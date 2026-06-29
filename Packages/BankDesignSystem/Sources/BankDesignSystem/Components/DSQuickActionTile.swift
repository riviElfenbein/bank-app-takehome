import SwiftUI

public struct DSQuickActionTile: View {
    private let title: String
    private let systemName: String
    private let action: () -> Void

    public init(
        _ title: String,
        systemName: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.systemName = systemName
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: systemName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(DSColors.white)
                    .frame(width: DSSpacing.iconLarge, height: DSSpacing.iconLarge)
                    .background(DSColors.primary)
                    .clipShape(Circle())

                Text(title)
                    .font(DSTypography.caption())
                    .foregroundStyle(DSColors.labelSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 108)
            .background(DSColors.white)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.button))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    HStack(spacing: 12) {
        DSQuickActionTile("Search", systemName: "magnifyingglass") {}
        DSQuickActionTile("Add", systemName: "plus") {}
        DSQuickActionTile("Filter", systemName: "line.3.horizontal.decrease") {}
    }
    .padding()
    .background(DSColors.grey)
}
