import SwiftUI

struct Hero: View {
    let temperature: String
    let condition: String
    let weatherCode: Int

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    WeatherConditionStyle
                        .from(weatherCode: weatherCode)
                        .colour
                )

            Text(temperature)
                .font(.system(size: 128, weight: .heavy))
                .foregroundStyle(Color(hex: "#FFFEFA"))
        }
        .frame(width: 360, height: 360)
        .padding()
    }
}