import Foundation

struct Transaction: Identifiable, Hashable, Sendable {
    typealias ID = UUID

    var id: ID
    var recipientName: String
    var recipientPhone: String
    var beneficiaryCardLast4: String
    var amount: Money
    var commission: Money
    var operationNumber: String
    var date: Date
    var status: TransactionStatus
    var withdrawalAccount: PaymentCard

    var summaryLine: String {
        "\(amount.formatted) → \(recipientName)"
    }

    var heroAmountText: String {
        amount.formatted.replacingOccurrences(of: "-", with: "")
    }

    var commissionDisplayText: String {
        if commission.amount == 0 {
            return "No commission"
        }
        return "Commission: \(commission.formatted)"
    }

    var completedDisplayText: String {
        let dateText = Self.completedDisplayFormatter.string(from: date)
        return "\(status.displayTitle), \(dateText)"
    }

    private static let completedDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "d MMMM HH:mm"
        return formatter
    }()

    static let detailDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}
