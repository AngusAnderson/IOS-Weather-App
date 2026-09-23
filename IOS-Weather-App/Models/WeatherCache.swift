import Foundation

enum WeatherCache {
    private static let cachedDataKey = "com.angusanderson.IOSWeatherApp.cachedWeather"
    private static let cacheTimestampKey = "com.angusanderson.IOSWeatherApp.cacheTimestamp"

    static func save(_ data: WeatherViewData) {
        guard let encoded = try? JSONEncoder().encode(data) else {
            return
        }
        UserDefaults.standard.set(encoded, forKey: cachedDataKey)
        UserDefaults.standard.set(
            Date().timeIntervalSince1970,
            forKey: cacheTimestampKey
        )
    }

    static func load() -> WeatherViewData? {
        guard let encoded = UserDefaults.standard.data(forKey: cachedDataKey),
              let data = try? JSONDecoder().decode(
                WeatherViewData.self,
                from: encoded
              )
        else {
            return nil
        }
        return data
    }

    static func loadTimestamp() -> Date? {
        guard let timestamp = UserDefaults.standard.object(
            forKey: cacheTimestampKey
        ) as? TimeInterval else {
            return nil
        }
        return Date(timeIntervalSince1970: timestamp)
    }
}