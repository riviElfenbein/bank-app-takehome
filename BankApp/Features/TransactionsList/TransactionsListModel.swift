import Foundation
import Observation

struct TransactionRowState: Identifiable, Hashable, Sendable {
    let id: Transaction.ID
    let merchantInitial: String
    let recipientName: String
    let subtitle: String
    let formattedAmount: String
    let isCredit: Bool
}

@MainActor
@Observable
final class TransactionsListModel {
    var searchText = ""

    private(set) var rows: [TransactionRowState] = []
    private(set) var isLoading = false
    private(set) var loadProgress = 0
    private(set) var loadTotal = TransactionLoadConfiguration.totalCount

    private let repository: TransactionStore
    private var debouncedSearchText = ""
    private var allRows: [TransactionRowState] = []
    private var rowIndexByID: [Transaction.ID: Int] = [:]
    private var lastSyncedRevision = 0
    private var hasStartedLoading = false

    init(repository: TransactionStore) {
        self.repository = repository
        if case .loaded = repository.loadState {
            hasStartedLoading = true
        }
        syncPreloadedRowsIfNeeded()
    }

    var loadProgressLabel: String? {
        guard isLoading else { return nil }
        return "Loading \(loadProgress) of \(loadTotal)"
    }

    var rowsForDisplay: [TransactionRowState] {
        syncWithStoreIfNeeded()
        return rows
    }

    func load(using loader: any TransactionLoader, totalCount: Int = TransactionLoadConfiguration.totalCount) async {
        guard !hasStartedLoading else { return }
        hasStartedLoading = true
        isLoading = true
        loadTotal = totalCount
        loadProgress = repository.transactions.count
        repository.beginLoading(totalCount: totalCount)

        do {
            for await batch in loader.transactionStream(totalCount: totalCount) {
                try Task.checkCancellation()

                repository.appendBatch(
                    batch.transactions,
                    loadedCount: batch.loadedCount,
                    totalCount: batch.totalCount
                )
                appendRows(for: batch.transactions)
                loadProgress = batch.loadedCount
                loadTotal = batch.totalCount
            }

            repository.markLoaded()
            isLoading = false
            loadProgress = loadTotal
        } catch is CancellationError {
            isLoading = false
        } catch {
            repository.markFailed(error.localizedDescription)
            isLoading = false
        }
    }

    func applyDebouncedSearch() async {
        let query = searchText
        try? await Task.sleep(for: .milliseconds(200))
        guard !Task.isCancelled, query == searchText else { return }
        debouncedSearchText = query
        applySearchFilter()
    }

    private func syncPreloadedRowsIfNeeded() {
        guard !repository.transactions.isEmpty, allRows.isEmpty else { return }

        allRows = repository.transactions.map(rowState(for:))
        rowIndexByID = Dictionary(uniqueKeysWithValues: allRows.enumerated().map { ($1.id, $0) })
        applySearchFilter()
        lastSyncedRevision = repository.dataRevision
        isLoading = false
        loadProgress = repository.transactions.count
        loadTotal = max(repository.transactions.count, loadTotal)
    }

    private func syncWithStoreIfNeeded() {
        guard repository.dataRevision != lastSyncedRevision else { return }
        defer { lastSyncedRevision = repository.dataRevision }

        guard let updatedID = repository.lastUpdatedTransactionID else { return }
        patchRow(for: updatedID)
    }

    private func appendRows(for transactions: [Transaction]) {
        for transaction in transactions {
            let row = rowState(for: transaction)
            rowIndexByID[row.id] = allRows.count
            allRows.append(row)
        }
        applySearchFilter()
        lastSyncedRevision = repository.dataRevision
    }

    private func patchRow(for id: Transaction.ID) {
        guard let transaction = repository.transaction(id: id) else { return }
        
        let updatedRow = rowState(for: transaction)
        let matchesSearch = debouncedSearchText.isEmpty
        || transaction.recipientName.localizedCaseInsensitiveContains(debouncedSearchText)
        
            
        if let cachedIndex = rowIndexByID[id] {
            allRows[cachedIndex] = updatedRow
        }

        guard matchesSearch else {
            applySearchFilter()
            return
        }

        if let visibleIndex = rows.firstIndex(where: { $0.id == id }) {
            rows[visibleIndex] = updatedRow
        } else {
            applySearchFilter()
        }
        
    }

    private func applySearchFilter() {
        guard !debouncedSearchText.isEmpty else {
            rows = allRows
            return
        }

        rows = allRows.filter {
            $0.recipientName.localizedCaseInsensitiveContains(debouncedSearchText)
        }
    }

    private func rowState(for transaction: Transaction) -> TransactionRowState {
        TransactionRowState(
            id: transaction.id,
            merchantInitial: TransactionFormatters.merchantInitial(from: transaction.recipientName),
            recipientName: transaction.recipientName,
            subtitle: TransactionFormatters.listSubtitle(date: transaction.date, status: transaction.status),
            formattedAmount: transaction.amount.formatted,
            isCredit: transaction.amount.isCredit
        )
    }
}
