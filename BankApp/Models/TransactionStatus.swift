import Foundation

enum TransactionStatus: String, Hashable, Sendable {
    case completed
    case pending
    case failed

    var displayTitle: String {
        switch self {
        case .completed:
            return "Completed"
        case .pending:
            return "Pending"
        case .failed:
            return "Failed"
        }
    }
}
