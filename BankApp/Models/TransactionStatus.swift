import Foundation

enum TransactionStatus: String, Hashable, Sendable {
    case completed
    case pending
    case failed
}
