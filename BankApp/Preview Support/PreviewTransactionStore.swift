@MainActor
enum PreviewTransactionStore {
    static func make() -> TransactionStore {
        TransactionStore(transactions: MockTransactionProvider.makeTransactions())
    }
}
