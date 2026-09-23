import Foundation
import Observation

@Observable
@MainActor
final class WeatherViewModel {
    private let weatherService = OpenMeteoService()
    private let lastLocationKey = "lastSelectedWeatherLocation"

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

        guard query.count >= 2, query.count <= 100 else {
            searchResults = []
            isSearching = false
            return
        }

        isSearching = true

        do {
            let locations = try await weatherService.searchLocations(
                named: query
            )

            guard !Task.isCancelled else {
                return
            }

            searchResults = locations
        } catch is CancellationError {
            return
        } catch {
            guard !Task.isCancelled else {
                return
            }

            searchResults = []
        }

        isSearching = false
    }

    func selectLocation(
        _ location: LocationSearchResult
    ) async {
        searchText = location.name
        searchResults = []

        saveLocation(location)

        await loadWeather(for: location)
    }

    func clearSearch() {
        searchText = ""
        searchResults = []
    }

    func loadSavedOrDefaultLocation() async {
        if let savedLocation = loadSavedLocation() {
            await loadWeather(for: savedLocation)
        } else {
            await loadGlasgowWeather()
        }
    }

    private func saveLocation(
        _ location: LocationSearchResult
    ) {
        guard let data = try? JSONEncoder().encode(location) else {
            assertionFailure(
                "Failed to encode selected weather location."
            )
            return
        }

        UserDefaults.standard.set(
            data,
            forKey: lastLocationKey
        )
    }

    private func loadSavedLocation() -> LocationSearchResult? {
        guard let data = UserDefaults.standard.data(
            forKey: lastLocationKey
        ) else {
            return nil
        }

        guard let location = try? JSONDecoder().decode(
            LocationSearchResult.self,
            from: data
        ) else {
            UserDefaults.standard.removeObject(
                forKey: lastLocationKey
            )

            assertionFailure(
                "Failed to decode saved weather location."
            )

            return nil
        }

        return location
    }
}