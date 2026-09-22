import SwiftUI

struct SearchButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 25, weight: .light))
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
            .background(
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.75), lineWidth: 1)
                    )
            )
            .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
            .opacity(configuration.isPressed ? 0.75 : 1.0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}