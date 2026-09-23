import Foundation

enum HourlyForecastBuilder {
    static func makeForecast(
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

        guard let currentIndex = hourly.time.prefix(safeCount).firstIndex(where: {
            String($0.prefix(13)) >= currentHour
        }) else {
            return []
        }

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

    private static func formattedHour(
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
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.dateFormat = "ha"

        return outputFormatter.string(from: date)
            .lowercased()
    }

    private static func formattedTemperature(
        _ temperature: Double
    ) -> String {
        "\(Int(temperature.rounded()))°"
    }
}