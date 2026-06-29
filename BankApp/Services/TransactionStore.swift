import Foundation
import Observation

@Observable
final class TransactionStore {
    private(set) var transactions: [Transaction]

    init(transactions: [Transaction] = MockTransactionProvider.makeTransactions()) {
        self.transactions = transactions.sorted { $0.date > $1.date }
    }

    func transaction(id: Transaction.ID) -> Transaction? {
        transactions.first { $0.id == id }
    }

    func updateRecipientName(id: Transaction.ID, name: String) {
        guard let index = transactions.firstIndex(where: { $0.id == id }) else { return }
        transactions[index].recipientName = name
    }
}
