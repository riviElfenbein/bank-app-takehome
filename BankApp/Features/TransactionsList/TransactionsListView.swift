import BankDesignSystem
import SwiftUI

struct TransactionsListView: View {
    @Environment(TransactionStore.self) private var store

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        List(store.transactions) { transaction in
            NavigationLink(value: transaction.id) {
                DSTransactionRow(
                    recipientName: transaction.recipientName,
                    subtitle: subtitle(for: transaction),
                    formattedAmount: transaction.amount.formatted,
                    isCredit: transaction.amount.isCredit
                )
            }
            .listRowSeparatorTint(DSColors.separator)
            .listRowBackground(DSColors.grey)
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(transaction.recipientName), \(transaction.amount.formatted)")
            .accessibilityHint("View transaction details")
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .dsScreenBackground()
        .navigationTitle("Transactions")
    }

    private func subtitle(for transaction: Transaction) -> String {
        "\(Self.dateFormatter.string(from: transaction.date)) · \(transaction.status.displayTitle)"
    }
}

#Preview {
    NavigationStack {
        TransactionsListView()
    }
    .environment(PreviewTransactionStore.make())
}
