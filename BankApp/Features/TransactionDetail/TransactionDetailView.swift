import BankDesignSystem
import SwiftUI

struct TransactionDetailView: View {
    @Environment(TransactionStore.self) private var store

    let transactionID: Transaction.ID

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    var body: some View {
        Group {
            if let transaction = store.transaction(id: transactionID) {
                detailContent(for: transaction)
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

    @ViewBuilder
    private func detailContent(for transaction: Transaction) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                DSStatusHeader(
                    statusTitle: transaction.status.displayTitle,
                    summary: summary(for: transaction)
                )

                DSCardSurface {
                    VStack(spacing: 0) {
                        DSSectionHeader(title: "Operation details")

                        withdrawalAccountRow(for: transaction)
                        recipientNameField(for: transaction)

                        DSLabeledRow(
                            label: "Recipient's phone",
                            value: transaction.recipientPhone
                        )
                        DSLabeledRow(
                            label: "Beneficiary's card number",
                            value: "· \(transaction.beneficiaryCardLast4)"
                        )
                        DSLabeledRow(
                            label: "Transfer amount",
                            value: transaction.amount.formatted
                        )
                        DSLabeledRow(
                            label: "Commission",
                            value: transaction.commission.formatted
                        )
                        DSLabeledRow(
                            label: "Operation number",
                            value: transaction.operationNumber
                        )
                        DSLabeledRow(
                            label: "Date",
                            value: Self.dateFormatter.string(from: transaction.date)
                        )
                    }
                }
            }
        }
    }

    private func summary(for transaction: Transaction) -> String {
        let amountText = transaction.amount.formatted.replacingOccurrences(of: "-", with: "")
        return "\(amountText) → \(transaction.recipientName)"
    }

    private func withdrawalAccountRow(for transaction: Transaction) -> some View {
        DSLabeledRow(
            label: "Withdrawal account",
            value: transaction.withdrawalAccount.label
        ) {
            HStack(spacing: 8) {
                if transaction.withdrawalAccount.brand == .visa {
                    DSIconBadge(systemName: "creditcard", style: .visa)
                }
                Text("· \(transaction.withdrawalAccount.last4)")
                    .font(DSTypography.caption())
                    .foregroundStyle(DSColors.labelSecondary)
            }
        }
    }

    private func recipientNameField(for transaction: Transaction) -> some View {
        DSLabeledField(
            label: "Name of the recipient",
            text: recipientNameBinding(for: transaction.id)
        )
        .accessibilityLabel("Name of the recipient")
        .accessibilityHint("Editable transaction name")
    }

    private func recipientNameBinding(for id: Transaction.ID) -> Binding<String> {
        Binding(
            get: { store.transaction(id: id)?.recipientName ?? "" },
            set: { store.updateRecipientName(id: id, name: $0) }
        )
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
