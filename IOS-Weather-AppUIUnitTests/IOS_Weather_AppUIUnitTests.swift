import Testing
@testable import IOS_Weather_App

struct IOS_Weather_AppUIUnitTests {
    @Test
    func returnsGoodMorningBetweenFiveAndEleven() {
        #expect(
            GreetingProvider.greeting(for: 5) == "Good Morning"
        )

        #expect(
            GreetingProvider.greeting(for: 11) == "Good Morning"
        )
    }

    @Test
    func returnsGoodAfternoonBetweenTwelveAndSeventeen() {
        #expect(
            GreetingProvider.greeting(for: 12) == "Good Afternoon"
        )

        #expect(
            GreetingProvider.greeting(for: 17) == "Good Afternoon"
        )
    }

    @Test
    func returnsGoodEveningAtNightAndEarlyMorning() {
        #expect(
            GreetingProvider.greeting(for: 18) == "Good Evening"
        )

        #expect(
            GreetingProvider.greeting(for: 23) == "Good Evening"
        )

        #expect(
            GreetingProvider.greeting(for: 0) == "Good Evening"
        )

        #expect(
            GreetingProvider.greeting(for: 4) == "Good Evening"
        )
    }
}