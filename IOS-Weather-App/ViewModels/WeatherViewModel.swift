import Foundation
import Observation

@Observable
@MainActor
final class WeatherViewModel {
    private let weatherService = OpenMeteoService()
    private let lastLocationKey = "lastSelectedWeatherLocation"
    private let networkMonitor = NetworkMonitor.shared

    var weather: WeatherViewData?
    var isLoading = false
    var errorMessage: String?
    var lastUpdated: Date?
    var lastUpdatedOnError: Date?

    var searchText = ""
    var searchResults: [LocationSearchResult] = []
    var isSearching = false

    init() {
        loadCachedWeather()
    }

    func loadSavedOrDefaultLocation() async {
        isLoading = true
        errorMessage = nil

        if !networkMonitor.isReachable() {
            let cached = WeatherCache.load()
            if let cached {
                weather = cached
                lastUpdated = WeatherCache.loadTimestamp()
                lastUpdatedOnError = lastUpdated
            } else {
                weather = nil
                lastUpdated = nil
                lastUpdatedOnError = nil
                errorMessage = "No internet connection"
            }
            isLoading = false
            return
        }

        if let savedLocation = loadSavedLocation() {
            await loadWeather(for: savedLocation)
        } else {
            await loadGlasgowWeather()
        }
    }

    func loadWeather(
        for location: LocationSearchResult
    ) async {
        if !networkMonitor.isReachable() {
            let cached = WeatherCache.load()
            if let cached {
                weather = cached
                lastUpdated = WeatherCache.loadTimestamp()
                lastUpdatedOnError = lastUpdated
            } else {
                weather = nil
                lastUpdated = nil
                lastUpdatedOnError = nil
                errorMessage = "No internet connection"
            }
            isLoading = false
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let fetched = try await weatherService.fetchWeather(
                for: location
            )
            weather = fetched
            lastUpdated = Date()
            lastUpdatedOnError = nil
            WeatherCache.save(fetched)
        } catch {
            errorMessage = error.localizedDescription

            let cached = WeatherCache.load()
            if let cached {
                weather = cached
                lastUpdated = WeatherCache.loadTimestamp()
                lastUpdatedOnError = lastUpdated
            } else {
                weather = nil
                lastUpdated = nil
                lastUpdatedOnError = nil
            }
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

    private func loadCachedWeather() {
        weather = WeatherCache.load()
        lastUpdated = WeatherCache.loadTimestamp()
    }
}