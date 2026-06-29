@MainActor
enum PreviewTransactionStore {
    static func make(
        count: Int = TransactionLoadConfiguration.previewCount
    ) -> TransactionStore {
        TransactionStore(
            transactions: MockTransactionProvider.makeTransactions(totalCount: count),
            loadState: .loaded
        )
    }
}
