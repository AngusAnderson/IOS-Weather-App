import SwiftUI

struct WeatherBottomSheet: View {
    let cityName: String
    let sunrise: String
    let sunset: String
    let feelsLike: String
    let humidity: String
    let uvIndex: String
    let windSpeed: String
    let windDirection: String
    let condition: String

    @State private var isExpanded = false
    @GestureState private var dragTranslation: CGFloat = 0

    private let sheetCornerRadius: CGFloat = 32
    private let secondaryTextOpacity: Double = 0.66

    var body: some View {
        GeometryReader { geometry in
            let expandedHeight = geometry.size.height * 0.88
            let collapsedHeight = geometry.size.height * 0.40
            let sheetHeight = expandedHeight

            let restingOffset = isExpanded
                ? geometry.size.height - expandedHeight
                : geometry.size.height - collapsedHeight

            let currentOffset = max(
                geometry.size.height - expandedHeight,
                restingOffset + dragTranslation
            )

            VStack(spacing: 0) {
                dragIndicator

                sheetContent
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(
                width: geometry.size.width - 24,
                height: sheetHeight,
                alignment: .top
            )
            .background(Color(red: 0.13, green: 0.13, blue: 0.13))
            .clipShape(
                RoundedRectangle(
                    cornerRadius: sheetCornerRadius,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: sheetCornerRadius,
                    style: .continuous
                )
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
            }
            .shadow(
                color: .black.opacity(0.35),
                radius: 16,
                y: 6
            )
            .offset(
                x: 12,
                y: currentOffset
            )
            .animation(
                .interactiveSpring(
                    response: 0.35,
                    dampingFraction: 0.85
                ),
                value: isExpanded
            )
            .gesture(
                DragGesture()
                    .updating($dragTranslation) { value, state, _ in
                        state = value.translation.height
                    }
                    .onEnded { value in
                        let verticalMovement = value.translation.height

                        withAnimation(
                            .interactiveSpring(
                                response: 0.35,
                                dampingFraction: 0.85
                            )
                        ) {
                            if verticalMovement < -80 {
                                isExpanded = true
                            } else if verticalMovement > 80 {
                                isExpanded = false
                            }
                        }
                    }
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var dragIndicator: some View {
        Capsule()
            .fill(Color.white.opacity(0.95))
            .frame(width: 110, height: 4)
            .padding(.top, 8)
            .padding(.bottom, 38)
    }

    private var sheetContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            header

            weatherMetrics

            hourlyForecast
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 32)
    }

    private var header: some View {
        HStack {
            Text(cityName)
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(.white)

            Spacer()

            Circle()
                .fill(Color(hex: "#1C99FF"))
                .frame(width: 30, height: 30)
        }
        .padding(.bottom, 52)
    }

    private var weatherMetrics: some View {
        HStack(alignment: .top, spacing: 64) {
            VStack(alignment: .leading, spacing: 15) {
                weatherMetric(
                    title: "Sunrise",
                    value: sunrise
                )

                weatherMetric(
                    title: "Feels Like",
                    value: feelsLike
                )

                weatherMetric(
                    title: "UV Index",
                    value: uvIndex
                )
            }

            Spacer()

            VStack(alignment: .leading, spacing: 15) {
                weatherMetric(
                    title: "Sunset",
                    value: sunset
                )

                weatherMetric(
                    title: "Humidity",
                    value: humidity
                )

                weatherMetric(
                    title: "Wind",
                    value: "\(windSpeed) \(windDirection)"
                )
            }
        }
        .padding(.bottom, 20)
    }

    private func weatherMetric(
        title: String,
        value: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .light))
                .foregroundStyle(
                    Color.white.opacity(secondaryTextOpacity)
                )

            Text(value)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(.white)
        }
    }

    private var hourlyForecast: some View {
        HStack(spacing: 0) {
            hourlyWeather(time: "10pm", temperature: "14°", isBlue: true)
            hourlyWeather(time: "11pm", temperature: "13°", isBlue: true)
            hourlyWeather(time: "12am", temperature: "13°", isBlue: true)
            hourlyWeather(time: "01am", temperature: "11°", isBlue: false)
            hourlyWeather(time: "02am", temperature: "10°", isBlue: false)
            hourlyWeather(time: "03am", temperature: "09°", isBlue: false)
        }
    }

    private func hourlyWeather(
        time: String,
        temperature: String,
        isBlue: Bool
    ) -> some View {
        VStack(spacing: 16) {
            Text(time)
                .font(.system(size: 16, weight: .light))
                .foregroundStyle(
                    Color.white.opacity(secondaryTextOpacity)
                )

            Text(temperature)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(.white)

            Circle()
                .fill(isBlue ? Color.blue : Color.gray.opacity(0.75))
                .frame(width: 25, height: 25)
        }
        .frame(maxWidth: .infinity)
    }
}