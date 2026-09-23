import SwiftUI

struct ContentView: View {
    @State private var viewModel = WeatherViewModel()
    @State private var showingSearch = false
    @State private var showingNameSetup = false

    @AppStorage("userFirstName") private var userFirstName = ""
    @AppStorage("hasCompletedNameSetup")
    private var hasCompletedNameSetup = false

    var body: some View {
        GeometryReader { screenGeometry in
            ZStack {
                Color(hex: "#3D3D3D")
                    .ignoresSafeArea()

                if viewModel.isLoading && viewModel.weather == nil {
                    loadingView

                } else if let weather = viewModel.weather {
                    weatherContent(weather)
                        .frame(
                            width: screenGeometry.size.width,
                            height: screenGeometry.size.height
                        )
                        .ignoresSafeArea(
                            .keyboard,
                            edges: .bottom
                        )

                } else if let errorMessage = viewModel.errorMessage {
                    errorView(errorMessage)

                } else {
                    loadingView
                }

                if showingSearch {
                    searchBackdrop

                    WeatherSearchOverlay(
                        viewModel: viewModel,
                        onDismiss: {
                            closeSearch()
                        }
                    )
                    .transition(
                        .opacity.combined(
                            with: .scale(scale: 0.96)
                        )
                    )
                    .zIndex(10)
                }

                if showingNameSetup {
                    NameSetupView(
                        onContinue: { name in
                            saveNameAndDismissSetup(name)
                        },
                        onSkip: {
                            saveNameAndDismissSetup("")
                        }
                    )
                    .transition(
                        .opacity.combined(
                            with: .scale(scale: 0.96)
                        )
                    )
                    .zIndex(20)
                }
            }
            .frame(
                width: screenGeometry.size.width,
                height: screenGeometry.size.height
            )
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .animation(
            .easeInOut(duration: 0.22),
            value: showingSearch
        )
        .animation(
            .easeInOut(duration: 0.22),
            value: showingNameSetup
        )
        .task {
            showingNameSetup = !hasCompletedNameSetup

            await viewModel.loadSavedOrDefaultLocation()
        }
    }

    @ViewBuilder
    private func weatherContent(
        _ weather: WeatherViewData
    ) -> some View {
        ZStack {
            VStack(alignment: .leading) {
                GreetingHeader(
                    cityName: weather.cityName,
                    condition: weather.condition,
                    greeting: greetingText,
                    onSearchTapped: {
                        withAnimation(
                            .easeInOut(duration: 0.22)
                        ) {
                            showingSearch = true
                        }
                    },
                    onRefreshTapped: {
                        Task {
                            await viewModel.loadSavedOrDefaultLocation()
                        }
                    },
                    onHelpTapped: {}
                )
                .ignoresSafeArea(.container, edges: .top)
                .offset(y: 5)

                Hero(
                    temperature: weather.temperature,
                    condition: weather.condition,
                    weatherCode: weather.weatherCode
                )
                .offset(y: -25)

                Spacer()
            }

            WeatherBottomSheet(
                cityName: weather.cityName,
                sunrise: weather.sunrise,
                sunset: weather.sunset,
                feelsLike: weather.feelsLike,
                humidity: weather.humidity,
                uvIndex: weather.uvIndex,
                windSpeed: weather.windSpeed,
                windDirection: weather.windDirection,
                condition: weather.condition,
                weatherCode: weather.weatherCode,
                hourlyForecastItems: weather.hourlyForecast
            )

            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .padding(16)
                    .background(
                        Color.black.opacity(0.35),
                        in: Capsule()
                    )
            }
        }
    }

    private var searchBackdrop: some View {
        Color.black
            .opacity(0.18)
            .background(.ultraThinMaterial)
            .ignoresSafeArea()
            .transition(.opacity)
            .zIndex(9)
            .onTapGesture {
                closeSearch()
            }
    }

    private var loadingView: some View {
        ProgressView("Loading weather...")
            .tint(.white)
            .foregroundStyle(.white)
    }

    private func errorView(
        _ errorMessage: String
    ) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 34))
                .foregroundStyle(.yellow)

            Text("Weather unavailable")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.white)

            Text(errorMessage)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)

            Button("Try again") {
                Task {
                    await viewModel.loadSavedOrDefaultLocation()
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(28)
        .multilineTextAlignment(.center)
    }

    private var greeting: String {
        let hour = Calendar.current.component(
            .hour,
            from: Date()
        )

        switch hour {
        case 5..<12:
            return "Good Morning"

        case 12..<18:
            return "Good Afternoon"

        default:
            return "Good Evening"
        }
    }

    private var greetingText: String {
        let cleanedName = userFirstName.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard !cleanedName.isEmpty else {
            return greeting
        }

        return "\(greeting), \(cleanedName)"
    }

    private func closeSearch() {
        withAnimation(
            .easeInOut(duration: 0.22)
        ) {
            showingSearch = false
            viewModel.clearSearch()
        }
    }

    private func saveNameAndDismissSetup(
        _ name: String
    ) {
        userFirstName = name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        withAnimation(
            .easeInOut(duration: 0.22)
        ) {
            hasCompletedNameSetup = true
            showingNameSetup = false
        }
    }
}