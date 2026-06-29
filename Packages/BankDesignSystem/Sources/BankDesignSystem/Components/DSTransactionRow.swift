import SwiftUI

public struct DSTransactionRow: View {
    private let recipientName: String
    private let subtitle: String
    private let formattedAmount: String
    private let isCredit: Bool

    public init(
        recipientName: String,
        subtitle: String,
        formattedAmount: String,
        isCredit: Bool = false
    ) {
        self.recipientName = recipientName
        self.subtitle = subtitle
        self.formattedAmount = formattedAmount
        self.isCredit = isCredit
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(recipientName)
                    .font(DSTypography.title3())
                    .foregroundStyle(DSColors.dark)
                    .lineLimit(1)

                Text(subtitle)
                    .font(DSTypography.caption())
                    .foregroundStyle(DSColors.labelSecondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            DSAmountLabel(
                formattedAmount: formattedAmount,
                style: .row,
                isCredit: isCredit
            )
        }
        .padding(.vertical, 12)
        .contentShape(Rectangle())
    }
}

#Preview {
    List {
        DSTransactionRow(
            recipientName: "Alexander Dmitrievich V.",
            subtitle: "Sep 12, 2022 · Completed",
            formattedAmount: "100$"
        )
        DSTransactionRow(
            recipientName: "Salary Deposit",
            subtitle: "Sep 1, 2022 · Completed",
            formattedAmount: "+4,250$",
            isCredit: true
        )
    }
    .listStyle(.plain)
}
