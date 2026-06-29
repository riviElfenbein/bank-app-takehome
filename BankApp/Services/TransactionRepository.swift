import Foundation

@MainActor
protocol TransactionRepository {
    var transactions: [Transaction] { get }
    func transaction(id: Transaction.ID) -> Transaction?
    func updateTransaction(id: Transaction.ID, _ mutate: (inout Transaction) -> Void)
}
