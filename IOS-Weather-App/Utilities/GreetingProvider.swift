import Foundation

enum GreetingProvider {
    static func greeting(
        for hour: Int
    ) -> String {
        switch hour {
        case 5..<12:
            return "Good Morning"

        case 12..<18:
            return "Good Afternoon"

        default:
            return "Good Evening"
        }
    }
}