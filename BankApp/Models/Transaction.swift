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
}
