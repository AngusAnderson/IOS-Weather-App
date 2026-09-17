import SwiftUI

struct GreetingHeader: View {
    let cityName: String
    let condition: String
    let greeting: String
    let onSearchTapped: () -> Void
    let onHelpTapped: () -> Void
    let onRefreshTapped: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(greeting), Angus")
                    .font(.title2)
                    .accessibilityIdentifier("greetingHeader.greetingText")
                
                Text("\(cityName) • \(condition)")
                    .font(.headline)
                    .accessibilityIdentifier("greetingHeader.LocationConditionText")
            }

            Spacer()

            VStack(spacing: 12) {
                Button(action: onSearchTapped) {
                    Image(systemName: "magnifyingglass")
                }
                .accessibilityLabel("Search for a city")
                .accessibilityIdentifier("greetingHeader.searchButton")

                Button(action: onRefreshTapped) {
                    Image(systemName: "arrow.clockwise")
                }
                .accessibilityLabel("Refresh weather")
                .accessibilityIdentifier("greetingHeader.refreshButton")

                Button(action: onHelpTapped) {
                    Image(systemName: "questionmark")
                }
                .accessibilityLabel("Weather colour key")
                .accessibilityIdentifier("greetingHeader.helpButton")
            }
        }
        .padding()
    }
}