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

    private static let completedFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "d MMMM HH:mm"
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
                DSPerformedHeader(
                    recipientName: transaction.recipientName,
                    formattedAmount: heroAmount(for: transaction),
                    commissionText: commissionText(for: transaction),
                    completedText: completedText(for: transaction)
                )

                DSCardSurface {
                    VStack(spacing: 0) {
                        DSSectionHeader(title: "Operation details")

                        DSLabeledField(
                            label: "Withdrawal account",
                            text: withdrawalLabelBinding(for: transaction.id)
                        )

                        withdrawalLast4Field(for: transaction)

                        DSLabeledField(
                            label: "Name of the recipient",
                            text: stringBinding(for: transaction.id, keyPath: \.recipientName)
                        )

                        DSLabeledField(
                            label: "Recipient's phone",
                            text: stringBinding(for: transaction.id, keyPath: \.recipientPhone)
                        )

                        DSLabeledField(
                            label: "Beneficiary's card number",
                            text: beneficiaryCardBinding(for: transaction.id)
                        )

                        DSLabeledField(
                            label: "Transfer amount",
                            text: moneyBinding(for: transaction.id, keyPath: \.amount)
                        )

                        DSLabeledField(
                            label: "Commission",
                            text: moneyBinding(for: transaction.id, keyPath: \.commission)
                        )

                        DSLabeledField(
                            label: "Operation number",
                            text: stringBinding(for: transaction.id, keyPath: \.operationNumber)
                        )

                        DSLabeledField(
                            label: "Date",
                            text: dateBinding(for: transaction.id)
                        )
                    }
                }
            }
        }
    }

    private func heroAmount(for transaction: Transaction) -> String {
        transaction.amount.formatted.replacingOccurrences(of: "-", with: "")
    }

    private func commissionText(for transaction: Transaction) -> String {
        if transaction.commission.amount == 0 {
            return "No commission"
        }
        return "Commission: \(transaction.commission.formatted)"
    }

    private func completedText(for transaction: Transaction) -> String {
        let dateText = Self.completedFormatter.string(from: transaction.date)
        return "\(transaction.status.displayTitle), \(dateText)"
    }

    @ViewBuilder
    private func withdrawalLast4Field(for transaction: Transaction) -> some View {
        HStack(spacing: 8) {
            DSLabeledField(
                label: "Card last four digits",
                text: withdrawalLast4Binding(for: transaction.id)
            )

            if transaction.withdrawalAccount.brand == .visa {
                DSIconBadge(systemName: "creditcard", style: .visa)
                    .padding(.top, 20)
            }
        }
    }

    private func stringBinding(for id: Transaction.ID, keyPath: WritableKeyPath<Transaction, String>) -> Binding<String> {
        Binding(
            get: { store.transaction(id: id)?[keyPath: keyPath] ?? "" },
            set: { newValue in
                store.updateTransaction(id: id) { $0[keyPath: keyPath] = newValue }
            }
        )
    }

    private func moneyBinding(for id: Transaction.ID, keyPath: WritableKeyPath<Transaction, Money>) -> Binding<String> {
        Binding(
            get: { store.transaction(id: id)?[keyPath: keyPath].formatted ?? "" },
            set: { newValue in
                guard let money = Money.parse(from: newValue) else { return }
                store.updateTransaction(id: id) { $0[keyPath: keyPath] = money }
            }
        )
    }

    private func dateBinding(for id: Transaction.ID) -> Binding<String> {
        Binding(
            get: {
                guard let date = store.transaction(id: id)?.date else { return "" }
                return Self.dateFormatter.string(from: date)
            },
            set: { newValue in
                guard let date = Self.dateFormatter.date(from: newValue) else { return }
                store.updateTransaction(id: id) { $0.date = date }
            }
        )
    }

    private func beneficiaryCardBinding(for id: Transaction.ID) -> Binding<String> {
        Binding(
            get: {
                guard let last4 = store.transaction(id: id)?.beneficiaryCardLast4 else { return "" }
                return "· \(last4)"
            },
            set: { newValue in
                let digits = newValue.replacingOccurrences(of: "·", with: "").trimmingCharacters(in: .whitespaces)
                store.updateTransaction(id: id) { $0.beneficiaryCardLast4 = digits }
            }
        )
    }

    private func withdrawalLabelBinding(for id: Transaction.ID) -> Binding<String> {
        Binding(
            get: { store.transaction(id: id)?.withdrawalAccount.label ?? "" },
            set: { newValue in
                store.updateTransaction(id: id) { $0.withdrawalAccount.label = newValue }
            }
        )
    }

    private func withdrawalLast4Binding(for id: Transaction.ID) -> Binding<String> {
        Binding(
            get: { store.transaction(id: id)?.withdrawalAccount.last4 ?? "" },
            set: { newValue in
                store.updateTransaction(id: id) { $0.withdrawalAccount.last4 = newValue }
            }
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
