import Testing
@testable import IOS_Weather_App

struct GreetingProviderTests {
    @Test("Morning begins at 5am")
    func morningBeginsAtFiveAM() {
        #expect(
            GreetingProvider.greeting(for: 5)
                == "Good Morning"
        )
    }

    @Test("Morning ends before midday")
    func morningEndsBeforeMidday() {
        #expect(
            GreetingProvider.greeting(for: 11)
                == "Good Morning"
        )
    }

    @Test("Afternoon begins at midday")
    func afternoonBeginsAtMidday() {
        #expect(
            GreetingProvider.greeting(for: 12)
                == "Good Afternoon"
        )
    }

    @Test("Afternoon ends before 6pm")
    func afternoonEndsBeforeSixPM() {
        #expect(
            GreetingProvider.greeting(for: 17)
                == "Good Afternoon"
        )
    }

    @Test("Evening covers night and early morning")
    func eveningCoversNightAndEarlyMorning() {
        #expect(
            GreetingProvider.greeting(for: 18)
                == "Good Evening"
        )

        #expect(
            GreetingProvider.greeting(for: 0)
                == "Good Evening"
        )

        #expect(
            GreetingProvider.greeting(for: 4)
                == "Good Evening"
        )
    }
}