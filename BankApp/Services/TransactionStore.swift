import Foundation
import Observation

@Observable
final class TransactionStore {
    private(set) var transactions: [Transaction]

    init(transactions: [Transaction] = MockTransactionProvider.transactions) {
        self.transactions = transactions
    }

    func transaction(id: Transaction.ID) -> Transaction? {
        transactions.first { $0.id == id }
    }

    func updateTransaction(id: Transaction.ID, _ mutate: (inout Transaction) -> Void) {
        guard let index = transactions.firstIndex(where: { $0.id == id }) else { return }
        mutate(&transactions[index])
    }
}
