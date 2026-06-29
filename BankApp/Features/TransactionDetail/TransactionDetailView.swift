import BankDesignSystem
import SwiftUI

struct TransactionDetailView: View {
    @Bindable var model: TransactionDetailModel

    var body: some View {
        Group {
            if model.isAvailable {
                TransactionDetailContent(model: model)
                    .id(model.transactionID)
            } else {
                ContentUnavailableView(
                    "Transaction Not Found",
                    systemImage: "exclamationmark.triangle",
                    description: Text("This transaction is no longer available.")
                )
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .dsScreenBackground()
        .onDisappear {
            model.commit()
        }
    }
}

private struct TransactionDetailContent: View {
    @Bindable var model: TransactionDetailModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                DSPerformedHeader(
                    recipientName: model.recipientName,
                    formattedAmount: model.heroAmountText,
                    commissionText: model.commissionText,
                    completedText: model.completedText
                )

                DSCardSurface {
                    VStack(spacing: 0) {
                        DSSectionHeader(title: "Operation details")

                        DSLabeledField(
                            label: "Withdrawal account",
                            text: $model.draftWithdrawalLabel
                        )

                        HStack(spacing: 8) {
                            DSLabeledField(
                                label: "Card last four digits",
                                text: $model.draftWithdrawalLast4
                            )

                            if model.showsVisaBadge {
                                DSIconBadge(systemName: "creditcard", style: .visa)
                                    .padding(.top, 20)
                            }
                        }

                        DSLabeledField(
                            label: "Name of the recipient",
                            text: $model.draftRecipientName
                        )

                        DSLabeledField(
                            label: "Recipient's phone",
                            text: $model.draftRecipientPhone
                        )

                        DSLabeledField(
                            label: "Beneficiary's card number",
                            text: $model.draftBeneficiaryCard
                        )

                        DSLabeledField(
                            label: "Transfer amount",
                            text: $model.draftAmount
                        )

                        DSLabeledField(
                            label: "Commission",
                            text: $model.draftCommission
                        )

                        DSLabeledField(
                            label: "Operation number",
                            text: $model.draftOperationNumber
                        )

                        DSLabeledField(
                            label: "Date",
                            text: $model.draftDate
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TransactionDetailView(
            model: TransactionDetailModel(
                repository: PreviewTransactionStore.make(),
                transactionID: PreviewData.sampleTransactionID
            )
        )
    }
}
