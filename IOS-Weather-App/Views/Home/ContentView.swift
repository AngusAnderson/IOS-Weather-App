import SwiftUI

struct ContentView: View {

    @state private var viewModel = WeatherViewModel()
    @state private var showingSearch = false
    @state private var showingHelp = false

    var body: some View {
        ZStack {
            AppColors.background.ignoreSafeArea()

            VStack(spacing: 0) {
                GreetingHeader(
                    cityName: viewModel.cityName,
                    condition: viewModel.condition,
                    greeting: viewModel.greeting,
                    onSearchTapped: {
                        showingSearch = true
                    },
                    onHelpTapped: {
                        showingHelp = true
                    },
                    onRefreshTapped: {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                )

                WeatherHeroView(
                    temperature: viewModel.temperatureText,
                    color: viewModel.weatherTheme.color,
                )
            }
        }
        .sheet(isPresented: $showingSearch) {
            SearchView()
        }
        .sheet(isPresented: $showingHelp) {
            WeatherKeyView()
        }
        .task {
            await viewModel.loadWeather()
        }
    }
}