import Foundation

enum TransactionFormatters {
    static func listDate(_ date: Date) -> String {
        listDateFormatter.string(from: date)
    }

    static func listSubtitle(date: Date, status: TransactionStatus) -> String {
        "\(listDate(date)) · \(statusTitle(status))"
    }

    static func merchantInitial(from recipientName: String) -> String {
        guard let first = recipientName.first else { return "?" }
        return String(first).uppercased()
    }

    static func detailDate(_ date: Date) -> String {
        detailDateFormatter.string(from: date)
    }

    static func parseDetailDate(_ string: String) -> Date? {
        detailDateFormatter.date(from: string)
    }

    static func heroAmount(_ money: Money) -> String {
        money.formatted.replacingOccurrences(of: "-", with: "")
    }

    static func commissionText(_ commission: Money) -> String {
        if commission.amount == 0 {
            return "No commission"
        }
        return "Commission: \(commission.formatted)"
    }

    static func completedText(date: Date, status: TransactionStatus) -> String {
        let dateText = completedDisplayFormatter.string(from: date)
        return "\(statusTitle(status)), \(dateText)"
    }

    static func beneficiaryCardDisplay(last4: String) -> String {
        "· \(last4)"
    }

    static func parseBeneficiaryCardLast4(_ display: String) -> String {
        display.replacingOccurrences(of: "·", with: "").trimmingCharacters(in: .whitespaces)
    }

    static func statusTitle(_ status: TransactionStatus) -> String {
        switch status {
        case .completed:
            return "Completed"
        case .pending:
            return "Pending"
        case .failed:
            return "Failed"
        }
    }

    private static let listDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    private static let detailDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    private static let completedDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB")
        formatter.dateFormat = "d MMMM HH:mm"
        return formatter
    }()
}
