import SwiftUI

struct GreetingHeader: View {
    let cityName: String
    let condition: String
    let greeting: String
    let lastUpdated: Date?

    let onSearchTapped: () -> Void
    let onRefreshTapped: () -> Void
    let onHelpTapped: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(greeting)")
                    .font(Font.custom("RobotoMono-Regular", size: 22))
                    .tracking(20 * 0.04)
                    .accessibilityIdentifier("greetingHeader.greetingText")

                Text("\(cityName) • \(condition)")
                    .font(Font.custom("RobotoMono-Regular", size: 18))
                    .tracking(16 * 0.04)
                    .accessibilityIdentifier("greetingHeader.LocationConditionText")

                if let lastUpdated {
                    Text(lastUpdatedText(for: lastUpdated))
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.top, 2)
                }
            }
            .padding()

            Spacer()

            VStack(spacing: 14) {
                Button(action: onSearchTapped) {
                    Image(systemName: "magnifyingglass")
                }
                .accessibilityLabel("Search for a city")
                .accessibilityIdentifier("greetingHeader.searchButton")
                .buttonStyle(SearchButtonStyle())

                VStack(spacing: 0) {
                    Button(action: onRefreshTapped) {
                        Image(systemName: "arrow.clockwise")
                    }
                    .accessibilityLabel("Refresh weather")
                    .accessibilityIdentifier("greetingHeader.refreshButton")
                    .buttonStyle(ControlButtonStyle())

                    Button(action: onHelpTapped) {
                        Image(systemName: "questionmark")
                    }
                    .accessibilityLabel("Weather colour key")
                    .accessibilityIdentifier("greetingHeader.helpButton")
                    .buttonStyle(ControlButtonStyle())
                }
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.2))
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.75), lineWidth: 1)
                        )
                )
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }

    private func lastUpdatedText(for date: Date) -> String {
        let now = Date()
        let components = Calendar.current.dateComponents(
            [.minute, .hour],
            from: date,
            to: now
        )

        if let hours = components.hour, hours >= 1 {
            return "Offline: Updated \(hours)h ago"
        } else if let minutes = components.minute, minutes >= 1 {
            return "Offline: Updated \(minutes)m ago"
        } else {
            return "Offline: Updated just now"
        }
    }
}