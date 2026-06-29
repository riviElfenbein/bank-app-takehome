import BankDesignSystem
import SwiftUI

struct TransactionDetailView: View {
    @Environment(TransactionStore.self) private var store

    let transactionID: Transaction.ID

    var body: some View {
        TransactionDetailScreen(store: store, transactionID: transactionID)
    }
}

private struct TransactionDetailScreen: View {
    @State private var model: TransactionDetailModel

    init(store: TransactionStore, transactionID: Transaction.ID) {
        _model = State(initialValue: TransactionDetailModel(store: store, transactionID: transactionID))
    }

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
                            text: model.withdrawalLabelBinding
                        )

                        HStack(spacing: 8) {
                            DSLabeledField(
                                label: "Card last four digits",
                                text: model.withdrawalLast4Binding
                            )

                            if model.showsVisaBadge {
                                DSIconBadge(systemName: "creditcard", style: .visa)
                                    .padding(.top, 20)
                            }
                        }

                        DSLabeledField(
                            label: "Name of the recipient",
                            text: model.recipientNameBinding
                        )

                        DSLabeledField(
                            label: "Recipient's phone",
                            text: model.recipientPhoneBinding
                        )

                        DSLabeledField(
                            label: "Beneficiary's card number",
                            text: model.beneficiaryCardBinding
                        )

                        DSLabeledField(
                            label: "Transfer amount",
                            text: model.amountBinding
                        )

                        DSLabeledField(
                            label: "Commission",
                            text: model.commissionBinding
                        )

                        DSLabeledField(
                            label: "Operation number",
                            text: model.operationNumberBinding
                        )

                        DSLabeledField(
                            label: "Date",
                            text: model.dateBinding
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
            transactionID: PreviewData.sampleTransactionID
        )
    }
    .environment(PreviewTransactionStore.make())
}
