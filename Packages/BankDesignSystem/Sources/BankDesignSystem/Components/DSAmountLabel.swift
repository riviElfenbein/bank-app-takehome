import SwiftUI

public enum DSAmountStyle {
    case hero
    case row
    case field
}

public struct DSAmountLabel: View {
    private let formattedAmount: String
    private let style: DSAmountStyle
    private let isCredit: Bool

    public init(
        formattedAmount: String,
        style: DSAmountStyle,
        isCredit: Bool = false
    ) {
        self.formattedAmount = formattedAmount
        self.style = style
        self.isCredit = isCredit
    }

    public var body: some View {
        Text(formattedAmount)
            .font(font)
            .foregroundStyle(color)
    }

    private var font: Font {
        switch style {
        case .hero:
            return DSTypography.title1()
        case .row, .field:
            return DSTypography.title3()
        }
    }

    private var color: Color {
        isCredit ? DSColors.success : DSColors.dark
    }
}

#Preview {
    VStack(alignment: .leading, spacing: 12) {
        DSAmountLabel(formattedAmount: "100$", style: .hero)
        DSAmountLabel(formattedAmount: "100$", style: .row)
        DSAmountLabel(formattedAmount: "+4,250$", style: .row, isCredit: true)
    }
}
