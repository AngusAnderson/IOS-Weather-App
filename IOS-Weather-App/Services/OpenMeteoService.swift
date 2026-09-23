import Foundation

enum WeatherServiceError: LocalizedError {
    case invalidURL
    case invalidResponse
    case unavailable
    case decodingFailed
    case locationNotFound

    var errorDescription: String? {
        switch self {
            case .invalidURL:
                return "The weather request could not be created."

            case .invalidResponse:
                return "Weather data is temporarily unavailable."

            case .unavailable:
                return "Check your internet connection and try again."

            case .decodingFailed:
                return "Weather data could not be read. Please try again."

            case .locationNotFound:
                return "No matching location was found."
        }
    }
}

struct OpenMeteoService {
    private let session: URLSession

    init(session: URLSession = OpenMeteoService.makeSession()) {
        self.session = session
    }

    private static func makeSession() -> URLSession {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 30
        configuration.waitsForConnectivity = true

        return URLSession(configuration: configuration)
    }

    func searchLocations(
        named searchText: String
    ) async throws -> [LocationSearchResult] {
        var components = URLComponents(
            string: "https://geocoding-api.open-meteo.com/v1/search"
        )

        components?.queryItems = [
            URLQueryItem(name: "name", value: searchText),
            URLQueryItem(name: "count", value: "8"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]

        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode else {
                throw WeatherServiceError.invalidResponse
            }

            do {
                let decodedResponse = try JSONDecoder().decode(
                    GeocodingResponse.self,
                    from: data
                )

                return decodedResponse.results ?? []
            } catch is DecodingError {
                throw WeatherServiceError.decodingFailed
            }
        } catch let error as WeatherServiceError {
            throw error
        } catch {
            throw WeatherServiceError.unavailable
        }
    }

    func fetchWeather(
        for location: LocationSearchResult
    ) async throws -> WeatherViewData {
        var components = URLComponents(
            string: "https://api.open-meteo.com/v1/forecast"
        )

        components?.queryItems = [
            URLQueryItem(
                name: "latitude",
                value: String(location.latitude)
            ),
            URLQueryItem(
                name: "longitude",
                value: String(location.longitude)
            ),
            URLQueryItem(
                name: "current",
                value: """
                temperature_2m,relative_humidity_2m,apparent_temperature,\
                weather_code,wind_speed_10m,wind_direction_10m
                """
            ),
            URLQueryItem(
                name: "hourly",
                value: "temperature_2m,weather_code"
            ),
            URLQueryItem(
                name: "daily",
                value: "sunrise,sunset,uv_index_max"
            ),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "forecast_days", value: "2")
        ]

        guard let url = components?.url else {
            throw WeatherServiceError.invalidURL
        }

        do {
            let (data, response) = try await session.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse,
                200..<300 ~= httpResponse.statusCode else {
                throw WeatherServiceError.invalidResponse
            }

            do {
                let forecast = try JSONDecoder().decode(
                    OpenMeteoForecastResponse.self,
                    from: data
                )

                return mapForecast(
                    forecast,
                    cityName: location.name
                )
            } catch is DecodingError {
                throw WeatherServiceError.decodingFailed
            }
        } catch let error as WeatherServiceError {
            throw error
        } catch {
            throw WeatherServiceError.unavailable
        }
    }

    private func mapForecast(
        _ forecast: OpenMeteoForecastResponse,
        cityName: String
    ) -> WeatherViewData {
        let current = forecast.current

        return WeatherViewData(
            cityName: cityName,
            temperature: "\(Int(current.temperature2m.rounded()))°",
            condition: weatherDescription(
                for: current.weatherCode
            ),
            weatherCode: current.weatherCode,
            sunrise: formattedTime(
                from: forecast.daily.sunrise.first
            ),
            sunset: formattedTime(
                from: forecast.daily.sunset.first
            ),
            feelsLike: "\(Int(current.apparentTemperature.rounded()))°",
            humidity: "\(current.relativeHumidity2m)%",
            uvIndex: formattedUVIndex(
                forecast.daily.uvIndexMax.first
            ),
            windSpeed: "\(Int(current.windSpeed10m.rounded())) km/h",
            windDirection: WindDirection.from(
                degrees: current.windDirection10m
            ),
            hourlyForecast: HourlyForecastBuilder.makeForecast(
                from: forecast.hourly,
                currentTime: current.time
            )
        )
    }

    private func makeHourlyForecast(
        from hourly: HourlyWeather,
        currentTime: String
    ) -> [HourlyForecastItem] {
        let safeCount = min(
            hourly.time.count,
            hourly.temperature2m.count,
            hourly.weatherCode.count
        )

        guard safeCount > 0 else {
            return []
        }

        let currentHour = String(currentTime.prefix(13))

        let currentIndex = hourly.time.prefix(safeCount).firstIndex {
            String($0.prefix(13)) >= currentHour
        } ?? 0

        let startIndex = min(
            currentIndex + 1,
            safeCount
        )

        let endIndex = min(
            startIndex + 6,
            safeCount
        )

        guard startIndex < endIndex else {
            return []
        }

        return (startIndex..<endIndex).map { index in
            HourlyForecastItem(
                time: formattedHour(
                    from: hourly.time[index]
                ),
                temperature: formattedTemperature(
                    hourly.temperature2m[index]
                ),
                weatherCode: hourly.weatherCode[index]
            )
        }
    }

    private func formattedTemperature(
        _ temperature: Double
    ) -> String {
        "\(Int(temperature.rounded()))°"
    }

    private func formattedTime(
        from apiTime: String?
    ) -> String {
        guard let apiTime else {
            return "--"
        }

        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

        guard let date = inputFormatter.date(
            from: apiTime
        ) else {
            return "--"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale.current
        outputFormatter.dateFormat = "h:mm a"

        return outputFormatter.string(from: date)
    }

    private func formattedHour(
        from apiTime: String
    ) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

        guard let date = inputFormatter.date(
            from: apiTime
        ) else {
            return "--"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.locale = Locale.current
        outputFormatter.dateFormat = "ha"

        return outputFormatter.string(from: date)
            .lowercased()
    }

    private func formattedUVIndex(
        _ value: Double?
    ) -> String {
        guard let value else {
            return "--"
        }

        return String(Int(value.rounded()))
    }

    private func weatherDescription(
        for code: Int
    ) -> String {
        switch code {
        case 0:
            return "Clear sky"

        case 1, 2, 3:
            return "Cloudy"

        case 45, 48:
            return "Foggy"

        case 51, 53, 55, 56, 57:
            return "Drizzle"

        case 61, 63, 65, 66, 67, 80, 81, 82:
            return "Raining"

        case 71, 73, 75, 77, 85, 86:
            return "Snowing"

        case 95, 96, 99:
            return "Thunderstorm"

        default:
            return "Unknown"
        }
    }
}