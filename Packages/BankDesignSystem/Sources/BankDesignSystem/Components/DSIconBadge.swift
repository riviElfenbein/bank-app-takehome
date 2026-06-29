import SwiftUI

public enum DSIconBadgeStyle {
    case info
    case visa
    case chevron
    case merchant(initial: String)
}

public struct DSIconBadge: View {
    private let systemName: String
    private let style: DSIconBadgeStyle

    public init(systemName: String, style: DSIconBadgeStyle) {
        self.systemName = systemName
        self.style = style
    }

    public init(merchantInitial: String) {
        self.systemName = ""
        self.style = .merchant(initial: merchantInitial)
    }

    public var body: some View {
        Group {
            switch style {
            case .info:
                Image(systemName: systemName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(DSColors.white)
                    .frame(width: DSSpacing.iconLarge, height: DSSpacing.iconLarge)
                    .background(DSColors.primary)
                    .clipShape(Circle())
            case .visa:
                Text("VISA")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(DSColors.dark)
                    .frame(width: 32, height: 20)
                    .background(DSColors.grey)
                    .clipShape(RoundedRectangle(cornerRadius: DSRadius.visaBadge))
            case .chevron:
                Image(systemName: systemName)
                    .font(.system(size: DSSpacing.iconSmall, weight: .semibold))
                    .foregroundStyle(DSColors.labelSecondary)
            case .merchant(let initial):
                Text(initial)
                    .font(DSTypography.caption().weight(.semibold))
                    .foregroundStyle(DSColors.white)
                    .frame(width: DSSpacing.iconLarge, height: DSSpacing.iconLarge)
                    .background(DSColors.primary)
                    .clipShape(Circle())
            }
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        DSIconBadge(systemName: "info.circle.fill", style: .info)
        DSIconBadge(systemName: "creditcard", style: .visa)
        DSIconBadge(merchantInitial: "U")
    }
}
