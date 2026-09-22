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

    @State private var sheetOffset: CGFloat = 0
    @State private var dragStartOffset: CGFloat = 0
    @State private var sheetHeight: CGFloat = 0
    @State private var isDragging: Bool = false

    private let sheetCornerRadius: CGFloat = 32
    private let secondaryTextOpacity: Double = 0.66
    private let collapsedVisibleHeight: CGFloat = 94
    private let fastSwipeThreshold: CGFloat = 120

    var body: some View {
        GeometryReader { screenGeometry in
            let expandedOffset: CGFloat = 0
            let collapsedOffset = max(
                0,
                sheetHeight - collapsedVisibleHeight
            )

            VStack(spacing: 0) {
                dragIndicator

                sheetContent
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .fixedSize(horizontal: false, vertical: true)
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
                .stroke(
                    Color.white.opacity(0.08),
                    lineWidth: 1
                )
            }
            .shadow(
                color: .black.opacity(0.35),
                radius: 16,
                y: 6
            )
            .padding(.horizontal, 12)
            .background {
                GeometryReader { sheetGeometry in
                    Color.clear
                        .onAppear {
                            let measuredHeight = sheetGeometry.size.height

                            sheetHeight = measuredHeight

                            sheetOffset = max(
                                0,
                                measuredHeight - collapsedVisibleHeight
                            )
                        }
                        .onChange(of: sheetGeometry.size.height) {
                            _, newHeight in

                            sheetHeight = newHeight

                            let maximumOffset = max(
                                0,
                                newHeight - collapsedVisibleHeight
                            )

                            sheetOffset = min(
                                max(sheetOffset, expandedOffset),
                                maximumOffset
                            )
                        }
                }
            }
            .offset(
                y: screenGeometry.size.height
                    - sheetHeight
                    + sheetOffset
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        if !isDragging {
                            isDragging = true
                            dragStartOffset = sheetOffset
                        }

                        let proposedOffset = dragStartOffset
                            + value.translation.height

                        sheetOffset = min(
                            max(proposedOffset, expandedOffset),
                            collapsedOffset
                        )
                    }
                    .onEnded { value in
                        isDragging = false

                        let velocityEffect = value.predictedEndTranslation.height
                            - value.translation.height

                        let targetOffset: CGFloat

                        if velocityEffect < -fastSwipeThreshold {
                            targetOffset = expandedOffset
                        } else if velocityEffect > fastSwipeThreshold {
                            targetOffset = collapsedOffset
                        } else {
                            targetOffset = sheetOffset
                        }

                        withAnimation(
                            .interactiveSpring(
                                response: 0.35,
                                dampingFraction: 0.86
                            )
                        ) {
                            sheetOffset = targetOffset
                        }

                        dragStartOffset = targetOffset
                    }
            )
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var dragIndicator: some View {
        Capsule()
            .fill(Color.white.opacity(0.95))
            .frame(width: 110, height: 4)
            .padding(.top, 16)
            .padding(.bottom, 20)
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
                .fill(
                    isBlue
                        ? Color(hex: "#1C99FF")
                        : Color.gray.opacity(0.75)
                )
                .frame(width: 25, height: 25)
        }
        .frame(maxWidth: .infinity)
    }
}