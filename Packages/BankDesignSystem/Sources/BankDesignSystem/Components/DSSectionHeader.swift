import SwiftUI

public struct DSSectionHeader: View {
    private let title: String
    private let showsDisclosure: Bool

    public init(title: String, showsDisclosure: Bool = true) {
        self.title = title
        self.showsDisclosure = showsDisclosure
    }

    public var body: some View {
        HStack(spacing: 12) {
            DSIconBadge(systemName: "info.circle.fill", style: .info)

            Text(title)
                .font(DSTypography.title4())
                .foregroundStyle(DSColors.dark)

            Spacer()

            if showsDisclosure {
                Image(systemName: "chevron.up")
                    .font(.system(size: DSSpacing.iconSmall, weight: .semibold))
                    .foregroundStyle(DSColors.labelSecondary)
            }
        }
        .frame(height: DSSpacing.iconLarge)
        .padding(.bottom, 8)
    }
}

#Preview {
    DSSectionHeader(title: "Operation details")
        .padding(.horizontal, DSSpacing.screenHorizontal)
}
