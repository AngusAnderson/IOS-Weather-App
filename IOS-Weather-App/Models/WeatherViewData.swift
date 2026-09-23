import Foundation

struct WeatherViewData: Codable {
    let cityName: String
    let temperature: String
    let condition: String
    let weatherCode: Int

    let sunrise: String
    let sunset: String
    let feelsLike: String
    let humidity: String
    let uvIndex: String
    let windSpeed: String
    let windDirection: String

    let hourlyForecast: [HourlyForecastItem]
}

struct HourlyForecastItem: Identifiable, Codable {
    let id = UUID()
    let time: String
    let temperature: String
    let weatherCode: Int
}