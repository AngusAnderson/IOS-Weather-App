import SwiftUI

struct NameSetupView: View {
    let onContinue: (String) -> Void
    let onSkip: () -> Void

    @State private var name = ""
    @FocusState private var nameFieldFocused: Bool

    var body: some View {
        ZStack {
            Color(hex: "#2B2B2B")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Spacer()

                Text("Welcome")
                    .font(.system(size: 34, weight: .semibold))
                    .foregroundStyle(.white)

                Text("What should we call you?")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(
                        Color.white.opacity(0.70)
                    )

                TextField("First name", text: $name)
                    .font(.system(size: 19))
                    .foregroundStyle(.white)
                    .tint(Color(hex: "#1C99FF"))
                    .focused($nameFieldFocused)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .submitLabel(.done)
                    .onSubmit {
                        submitName()
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 54)
                    .background(
                        Color.white.opacity(0.10),
                        in: RoundedRectangle(
                            cornerRadius: 12,
                            style: .continuous
                        )
                    )
                    .overlay {
                        RoundedRectangle(
                            cornerRadius: 12,
                            style: .continuous
                        )
                        .stroke(
                            nameFieldFocused
                                ? Color(hex: "#1C99FF")
                                : Color.white.opacity(0.12),
                            lineWidth: 1
                        )
                    }

                Button {
                    submitName()
                } label: {
                    Text("Continue")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(hex: "#1C99FF"))
                .disabled(cleanedName.isEmpty)

                Button("Skip for now") {
                    onSkip()
                }
                .buttonStyle(.plain)
                .font(.system(size: 16))
                .foregroundStyle(Color.white.opacity(0.65))
                .frame(maxWidth: .infinity)

                Spacer()
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 44)
        }
    }

    private var cleanedName: String {
        name.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
    }

    private func submitName() {
        guard !cleanedName.isEmpty else {
            return
        }

        onContinue(cleanedName)
    }
}