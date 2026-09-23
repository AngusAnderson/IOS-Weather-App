import Testing
@testable import IOS_Weather_App

struct WeatherConditionStyleTests {
    @Test("Clear weather code maps to clear")
    func clearWeatherCodeMapsToClear() {
        let style = WeatherConditionStyle.from(
            weatherCode: 0
        )

        #expect(style == .clear)
    }

    @Test("Cloud codes map to cloudy")
    func cloudWeatherCodesMapToCloudy() {
        let codes = [1, 2, 3]

        for code in codes {
            #expect(
                WeatherConditionStyle.from(
                    weatherCode: code
                ) == .cloudy
            )
        }
    }

    @Test("Fog codes map to fog")
    func fogWeatherCodesMapToFog() {
        let codes = [45, 48]

        for code in codes {
            #expect(
                WeatherConditionStyle.from(
                    weatherCode: code
                ) == .fog
            )
        }
    }

    @Test("Drizzle codes map to drizzle")
    func drizzleWeatherCodesMapToDrizzle() {
        let codes = [51, 53, 55]

        for code in codes {
            #expect(
                WeatherConditionStyle.from(
                    weatherCode: code
                ) == .drizzle
            )
        }
    }

    @Test("Rain and shower codes map to rain")
    func rainWeatherCodesMapToRain() {
        let codes = [61, 63, 65, 80, 81, 82]

        for code in codes {
            #expect(
                WeatherConditionStyle.from(
                    weatherCode: code
                ) == .rain
            )
        }
    }

    @Test("Freezing and snow codes map to snow or freezing")
    func snowAndFreezingCodesMapCorrectly() {
        let codes = [
            56, 57, 66, 67,
            71, 73, 75, 77,
            85, 86
        ]

        for code in codes {
            #expect(
                WeatherConditionStyle.from(
                    weatherCode: code
                ) == .snowOrFreezing
            )
        }
    }

    @Test("Thunderstorm codes map to thunderstorm")
    func thunderstormCodesMapCorrectly() {
        let codes = [95, 96, 99]

        for code in codes {
            #expect(
                WeatherConditionStyle.from(
                    weatherCode: code
                ) == .thunderstorm
            )
        }
    }

    @Test("Unknown codes use cloudy fallback")
    func unknownWeatherCodeUsesCloudyFallback() {
        let style = WeatherConditionStyle.from(
            weatherCode: -1
        )

        #expect(style == .cloudy)
    }
}