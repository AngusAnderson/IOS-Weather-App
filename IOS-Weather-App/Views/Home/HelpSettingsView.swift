import SwiftUI

struct HelpSettingsView: View {
    let userFirstName: String
    let onChangeName: () -> Void
    let onResetName: () -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    colourLegendSection

                    Divider()
                        .overlay(Color.white.opacity(0.12))

                    nameSection
                }
                .padding(24)
            }
            .background(Color(hex: "#2B2B2B"))
            .navigationTitle("Help & Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(Color(hex: "#F5E4D0"))
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    private var colourLegendSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Weather colours")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)

            Text(
                "Colours provide a quick indication of the forecast condition."
            )
            .font(.subheadline)
            .foregroundStyle(Color.white.opacity(0.65))

            VStack(spacing: 12) {
                weatherLegendRow(
                    title: "Clear",
                    description: "Clear sky",
                    style: .clear
                )

                weatherLegendRow(
                    title: "Cloudy",
                    description: "Partly cloudy or overcast",
                    style: .cloudy
                )

                weatherLegendRow(
                    title: "Fog",
                    description: "Fog or low visibility",
                    style: .fog
                )

                weatherLegendRow(
                    title: "Drizzle",
                    description: "Light to dense drizzle",
                    style: .drizzle
                )

                weatherLegendRow(
                    title: "Rain",
                    description: "Rain or rain showers",
                    style: .rain
                )

                weatherLegendRow(
                    title: "Snow",
                    description: "Snow, snow showers, or freezing rain",
                    style: .snowOrFreezing
                )

                weatherLegendRow(
                    title: "Thunderstorm",
                    description: "Thunderstorm, including hail",
                    style: .thunderstorm
                )
            }
        }
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Profile")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.white)

            if userFirstName.isEmpty {
                Text("No name has been set.")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.65))
            } else {
                Text("Greeting name: \(userFirstName)")
                    .font(.subheadline)
                    .foregroundStyle(Color.white.opacity(0.65))
            }

            Button {
                onChangeName()
            } label: {
                Label(
                    "Change name",
                    systemImage: "pencil"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(Color(hex: "#1C99FF"))
            Text("""
                Made by Angus the Anderson
                API by Open-Meteo

                Nothing is stored on Servers, only on your phone
                """)
            .font(.system(size: 12))
            .foregroundStyle(Color.white.opacity(0.66))
        }
    }

    private func weatherLegendRow(
        title: String,
        description: String,
        style: WeatherConditionStyle
    ) -> some View {
        HStack(spacing: 14) {
            Circle()
                .fill(style.colour)
                .frame(width: 28, height: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white)

                Text(description)
                    .font(.system(size: 14))
                    .foregroundStyle(Color.white.opacity(0.60))
            }

            Spacer()
        }
        .padding(.vertical, 2)
    }
}