import Foundation
import Observation

@Observable
@MainActor
final class WeatherViewModel {
    private let weatherService = OpenMeteoService()

    var weather: WeatherViewData?
    var isLoading = false
    var errorMessage: String?

    var searchText = ""
    var searchResults: [LocationSearchResult] = []
    var isSearching = false

    func loadWeather(
        for location: LocationSearchResult
    ) async {
        isLoading = true
        errorMessage = nil

        do {
            weather = try await weatherService.fetchWeather(
                for: location
            )
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    func loadGlasgowWeather() async {
        let glasgow = LocationSearchResult(
            id: 2648579,
            name: "Glasgow",
            latitude: 55.8642,
            longitude: -4.2518,
            country: "United Kingdom",
            admin1: "Scotland",
            timezone: "Europe/London"
        )

        await loadWeather(for: glasgow)
    }

    func searchLocations() async {
        let query = searchText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )

        guard query.count >= 2 else {
            searchResults = []
            return
        }

        isSearching = true

        do {
            searchResults = try await weatherService.searchLocations(
                named: query
            )
        } catch {
            searchResults = []
        }

        isSearching = false
    }

    func selectLocation(
        _ location: LocationSearchResult
    ) async {
        searchText = location.name
        searchResults = []

        await loadWeather(for: location)
    }

    func clearSearch() {
        searchText = ""
        searchResults = []
    }
}