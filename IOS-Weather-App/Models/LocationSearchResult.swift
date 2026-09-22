import Foundation

struct GeocodingResponse: Decodable {
    let results: [LocationSearchResult]?
}

struct LocationSearchResult: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
    let country: String?
    let admin1: String?
    let timezone: String?

    var displayName: String {
        let locationParts = [name, admin1, country]
            .compactMap { $0 }
            .filter { !$0.isEmpty }

        return locationParts.joined(separator: ", ")
    }
}