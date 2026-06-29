import Foundation

enum TransactionLoadConfiguration {
    static let totalCount = 10_000
    static let batchSize = 500
    static let previewCount = 50
    static let simulatedBatchDelay: Duration = .milliseconds(50)
}
