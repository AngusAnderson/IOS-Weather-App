import Foundation

enum WindDirection {
    static func from(
        degrees: Int
    ) -> String {
        let directions = [
            "N", "NE", "E", "SE",
            "S", "SW", "W", "NW"
        ]

        let normalisedDegrees = (degrees % 360 + 360) % 360

        let index = Int(
            (Double(normalisedDegrees) + 22.5) / 45
        ) % directions.count

        return directions[index]
    }
}