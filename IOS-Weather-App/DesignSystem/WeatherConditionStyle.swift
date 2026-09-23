import SwiftUI

enum WeatherConditionStyle {
    case clear
    case cloudy
    case fog
    case drizzle
    case rain
    case snowOrFreezing
    case thunderstorm

    static func from(
        weatherCode: Int
    ) -> WeatherConditionStyle {
        switch weatherCode {
        case 0:
            return .clear

        case 1, 2, 3:
            return .cloudy

        case 45, 48:
            return .fog

        case 51, 53, 55:
            return .drizzle

        case 56, 57, 66, 67:
            return .snowOrFreezing

        case 61, 63, 65, 80, 81, 82:
            return .rain

        case 71, 73, 75, 77, 85, 86:
            return .snowOrFreezing

        case 95, 96, 99:
            return .thunderstorm

        default:
            return .cloudy
        }
    }

    var colour: Color {
        switch self {
        case .clear:
            return Color(hex: "#1C99FF")

        case .cloudy:
            return Color(hex: "#A8A8A8")

        case .fog:
            return Color(hex: "#8B9AA8")

        case .drizzle:
            return Color(hex: "#528BBE")

        case .rain:
            return Color(hex: "#2468C9")

        case .snowOrFreezing:
            return Color(hex: "#C7E5FF")

        case .thunderstorm:
            return Color(hex: "#8064D8")
        }
    }
}