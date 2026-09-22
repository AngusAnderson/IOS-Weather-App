import SwiftUI

struct ContentView: View {
    // @State private var viewModel = WeatherViewModel()
    // @State private var showingSearch = false
    // @State private var showingHelp = false
    @State private var lastAction = ""

    var body: some View {
        ZStack {
            Color(hex: "#3D3D3D")
                .ignoresSafeArea()

            VStack(alignment: .leading) {
                GreetingHeader(
                    cityName: "Glasgow",
                    condition: "Raining",
                    greeting: "Good Evening",
                    onSearchTapped: {
                        lastAction = "search tapped"
                    },
                    onRefreshTapped: {
                        lastAction = "refresh tapped"
                    },
                    onHelpTapped: {
                        lastAction = "help tapped"
                    }
                    
                )
                .offset(y: -60)
                .ignoresSafeArea(.container, edges: .top)

                Hero(
                    temperature: "14°",
                    condition: "Raining"
                )
                .offset(y: -100)

                Text(lastAction)
                    .accessibilityIdentifier(actionIdentifier)
                    .padding()
            }

            WeatherBottomSheet(
                cityName: "Glasgow",
                sunrise: "06:18 am",
                sunset: "08:39 pm",
                feelsLike: "12°",
                humidity: "88%",
                uvIndex: "2",
                windSpeed: "7 m/s",
                windDirection: "SW",
                condition: "Raining"
            )
            
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