import Foundation
import Observation

enum LoadState: Equatable {
    case idle
    case loading(progress: Int, total: Int)
    case loaded
    case failed(String)
}

@MainActor
@Observable
final class TransactionStore {
    private(set) var transactions: [Transaction]
    private(set) var loadState: LoadState
    private(set) var dataRevision = 0
    private(set) var lastUpdatedTransactionID: Transaction.ID?

    private var indexByID: [Transaction.ID: Int]

    init(transactions: [Transaction] = [], loadState: LoadState = .idle) {
        self.transactions = transactions
        self.loadState = loadState
        self.indexByID = [:]
        rebuildIndex()
        if !transactions.isEmpty, loadState == .idle {
            self.loadState = .loaded
        }
    }

    func beginLoading(totalCount: Int) {
        loadState = .loading(progress: transactions.count, total: totalCount)
        bumpRevision()
    }

    func appendBatch(_ batch: [Transaction], loadedCount: Int, totalCount: Int) {
        guard !batch.isEmpty else { return }

        let startIndex = transactions.count
        transactions.append(contentsOf: batch)

        for (offset, transaction) in batch.enumerated() {
            indexByID[transaction.id] = startIndex + offset
        }

        loadState = .loading(progress: loadedCount, total: totalCount)
        bumpRevision()
    }

    func markLoaded() {
        loadState = .loaded
        bumpRevision()
    }

    func markFailed(_ message: String) {
        loadState = .failed(message)
        bumpRevision()
    }

    func transaction(id: Transaction.ID) -> Transaction? {
        guard let index = indexByID[id] else { return nil }
        return transactions[index]
    }

    func updateTransaction(id: Transaction.ID, _ mutate: (inout Transaction) -> Void) {
        guard let index = indexByID[id] else { return }
        mutate(&transactions[index])
        lastUpdatedTransactionID = id
        bumpRevision()
    }

    private func rebuildIndex() {
        indexByID = Dictionary(uniqueKeysWithValues: transactions.enumerated().map { ($1.id, $0) })
    }

    private func bumpRevision() {
        dataRevision &+= 1
    }
}

extension TransactionStore: TransactionRepository {}
