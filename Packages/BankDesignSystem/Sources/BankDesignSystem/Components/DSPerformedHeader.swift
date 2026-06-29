import SwiftUI

public struct DSPerformedHeader: View {
    private let recipientName: String
    private let formattedAmount: String
    private let isCredit: Bool
    private let commissionText: String
    private let completedText: String

    public init(
        recipientName: String,
        formattedAmount: String,
        isCredit: Bool = false,
        commissionText: String,
        completedText: String
    ) {
        self.recipientName = recipientName
        self.formattedAmount = formattedAmount
        self.isCredit = isCredit
        self.commissionText = commissionText
        self.completedText = completedText
    }

    public var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "checkmark")
                .font(.system(size: 32, weight: .semibold))
                .foregroundStyle(DSColors.white)
                .frame(width: 78, height: 78)
                .background(DSColors.success)
                .clipShape(Circle())
                .padding(.bottom, 8)

            Text(recipientName)
                .font(DSTypography.title2())
                .foregroundStyle(DSColors.dark)
                .multilineTextAlignment(.center)

            DSAmountLabel(
                formattedAmount: formattedAmount,
                style: .hero,
                isCredit: isCredit
            )

            Text(commissionText)
                .font(DSTypography.caption())
                .foregroundStyle(DSColors.labelSecondary)

            Text(completedText)
                .font(DSTypography.caption())
                .foregroundStyle(DSColors.labelSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
        .padding(.bottom, DSSpacing.sectionSpacing)
    }
}

#Preview {
    DSPerformedHeader(
        recipientName: "Aleksander Dmitrievich V.",
        formattedAmount: "100$",
        commissionText: "No commission",
        completedText: "Completed, 12 September 16:00"
    )
    .background(DSColors.grey)
}
