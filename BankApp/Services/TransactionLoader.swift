import Foundation

struct TransactionBatch: Sendable {
    let transactions: [Transaction]
    let loadedCount: Int
    let totalCount: Int
}

protocol TransactionLoader: Sendable {
    func transactionStream(totalCount: Int) -> AsyncStream<TransactionBatch>
}

struct MockTransactionLoader: TransactionLoader {
    func transactionStream(totalCount: Int) -> AsyncStream<TransactionBatch> {
        MockTransactionProvider.transactionStream(
            totalCount: totalCount,
            batchSize: TransactionLoadConfiguration.batchSize,
            simulatedDelay: TransactionLoadConfiguration.simulatedBatchDelay
        )
    }
}
