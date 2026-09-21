import SwiftUI

struct Hero: View {
    let temperature: String
    let condition: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "#1C99FF"))

            Text(temperature)
                .font(.system(size: 128, weight: .heavy))
                .foregroundStyle(Color(hex: "#FFFEFA"))
        }
        .frame(width: 350, height: 350)
        .padding()
    }
}