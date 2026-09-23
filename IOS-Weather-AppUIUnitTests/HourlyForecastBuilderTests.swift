import Testing
@testable import IOS_Weather_App

struct HourlyForecastBuilderTests {
    @Test("Current hour is excluded and the next six hours are returned")
    func currentHourIsExcludedAndNextSixHoursAreReturned() {
        let hourly = HourlyWeather(
            time: [
                "2026-09-23T22:00",
                "2026-09-23T23:00",
                "2026-09-24T00:00",
                "2026-09-24T01:00",
                "2026-09-24T02:00",
                "2026-09-24T03:00",
                "2026-09-24T04:00"
            ],
            temperature2m: [
                14, 13, 12, 11,
                10, 9, 8
            ],
            weatherCode: [
                61, 61, 3, 3,
                45, 45, 0
            ]
        )

        let result = HourlyForecastBuilder.makeForecast(
            from: hourly,
            currentTime: "2026-09-23T22:35"
        )

        #expect(result.count == 6)

        #expect(result[0].time == "11pm")
        #expect(result[0].temperature == "13°")
        #expect(result[0].weatherCode == 61)

        #expect(result[1].time == "12am")
        #expect(result[1].temperature == "12°")
        #expect(result[1].weatherCode == 3)

        #expect(result[5].time == "4am")
        #expect(result[5].temperature == "8°")
        #expect(result[5].weatherCode == 0)
    }

    @Test("Forecast crosses midnight correctly")
    func forecastCrossesMidnightCorrectly() {
        let hourly = HourlyWeather(
            time: [
                "2026-09-23T22:00",
                "2026-09-23T23:00",
                "2026-09-24T00:00",
                "2026-09-24T01:00",
                "2026-09-24T02:00",
                "2026-09-24T03:00",
                "2026-09-24T04:00",
                "2026-09-24T05:00"
            ],
            temperature2m: [
                14, 13, 12, 11,
                10, 9, 8, 7
            ],
            weatherCode: [
                61, 61, 3, 3,
                45, 45, 0, 0
            ]
        )

        let result = HourlyForecastBuilder.makeForecast(
            from: hourly,
            currentTime: "2026-09-23T23:15"
        )

        #expect(result.count == 6)

        #expect(result[0].time == "12am")
        #expect(result[0].temperature == "12°")

        #expect(result[1].time == "1am")
        #expect(result[1].temperature == "11°")

        #expect(result[5].time == "5am")
        #expect(result[5].temperature == "7°")
    }

    @Test("Forecast returns remaining data when fewer than six future hours exist")
    func forecastReturnsAvailableFutureHours() {
        let hourly = HourlyWeather(
            time: [
                "2026-09-23T20:00",
                "2026-09-23T21:00",
                "2026-09-23T22:00",
                "2026-09-23T23:00"
            ],
            temperature2m: [
                15, 14, 13, 12
            ],
            weatherCode: [
                3, 61, 61, 61
            ]
        )

        let result = HourlyForecastBuilder.makeForecast(
            from: hourly,
            currentTime: "2026-09-23T21:20"
        )

        #expect(result.count == 2)

        #expect(result[0].time == "10pm")
        #expect(result[0].temperature == "13°")

        #expect(result[1].time == "11pm")
        #expect(result[1].temperature == "12°")
    }

    @Test("Mismatched API arrays use their shared safe count")
    func mismatchedArraysUseSharedSafeCount() {
        let hourly = HourlyWeather(
            time: [
                "2026-09-23T10:00",
                "2026-09-23T11:00",
                "2026-09-23T12:00"
            ],
            temperature2m: [
                10, 11
            ],
            weatherCode: [
                0, 1, 2
            ]
        )

        let result = HourlyForecastBuilder.makeForecast(
            from: hourly,
            currentTime: "2026-09-23T09:00"
        )

        #expect(result.count == 1)
        #expect(result[0].time == "11am")
        #expect(result[0].temperature == "11°")
        #expect(result[0].weatherCode == 1)
    }

    @Test("Empty hourly data returns no forecast")
    func emptyHourlyDataReturnsNoForecast() {
        let hourly = HourlyWeather(
            time: [],
            temperature2m: [],
            weatherCode: []
        )

        let result = HourlyForecastBuilder.makeForecast(
            from: hourly,
            currentTime: "2026-09-23T10:00"
        )

        #expect(result.isEmpty)
    }

    @Test("A current hour after the final available hour returns no forecast")
    func currentHourAfterFinalAvailableHourReturnsNoForecast() {
        let hourly = HourlyWeather(
            time: [
                "2026-09-23T10:00",
                "2026-09-23T11:00"
            ],
            temperature2m: [
                10, 11
            ],
            weatherCode: [
                0, 1
            ]
        )

        let result = HourlyForecastBuilder.makeForecast(
            from: hourly,
            currentTime: "2026-09-23T12:15"
        )

        #expect(result.isEmpty)
    }
}