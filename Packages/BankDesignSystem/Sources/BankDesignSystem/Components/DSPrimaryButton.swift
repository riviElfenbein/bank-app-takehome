import SwiftUI

public struct DSPrimaryButton: View {
    private let title: String
    private let isEnabled: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isEnabled = isEnabled
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(DSTypography.button())
                .foregroundStyle(DSColors.white)
                .frame(maxWidth: .infinity)
                .frame(height: DSSpacing.buttonHeight)
                .background(isEnabled ? DSColors.primary : DSColors.primary.opacity(0.4))
                .clipShape(RoundedRectangle(cornerRadius: DSRadius.button))
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        DSPrimaryButton("To Main") {}
        DSPrimaryButton("Disabled", isEnabled: false) {}
    }
    .padding()
}
