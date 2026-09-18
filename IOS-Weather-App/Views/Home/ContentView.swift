import SwiftUI

struct ContentView: View {
    // @State private var viewModel = WeatherViewModel()
    // @State private var showingSearch = false
    // @State private var showingHelp = false
    @State private var lastAction = ""

    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                GreetingHeader(
                    cityName: "Glasgow",
                    condition: "Raining",
                    greeting: "Good Evening",
                    onSearchTapped: {
                        lastAction = "search tapped"
                    },
                    onHelpTapped: {
                        lastAction = "help tapped"
                    },
                    onRefreshTapped: {
                        lastAction = "refresh tapped"
                    }
                )

                Text(lastAction)
                    .accessibilityIdentifier(actionIdentifier)
                    .padding()
            }
        }
    }

    private var actionIdentifier: String {
        switch lastAction {
        case "search tapped":
            return "searchTappedMessage"
        case "help tapped":
            return "helpTappedMessage"
        case "refresh tapped":
            return "refreshTappedMessage"
        default:
            return "noActionMessage"
        }
    }
}