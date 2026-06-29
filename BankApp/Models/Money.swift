import Foundation

struct Money: Hashable, Sendable {
    var amount: Decimal
    var currencyCode: String

    init(amount: Decimal, currencyCode: String = "USD") {
        self.amount = amount
        self.currencyCode = currencyCode
    }

    var isCredit: Bool {
        amount > 0
    }

    var formatted: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = amount.isWholeNumber ? 0 : 2
        formatter.maximumFractionDigits = 2

        let number = amount as NSDecimalNumber
        let absolute = abs(number.decimalValue)
        let formattedNumber = formatter.string(from: absolute as NSDecimalNumber) ?? "\(absolute)"

        if amount > 0 {
            return "+\(formattedNumber)$"
        }
        if amount < 0 {
            return "-\(formattedNumber)$"
        }
        return "\(formattedNumber)$"
    }
}

private extension Decimal {
    var isWholeNumber: Bool {
        var rounded = self
        var original = self
        NSDecimalRound(&rounded, &original, 0, .plain)
        return rounded == original
    }
}

extension Decimal {
    static func dollars(_ value: Double) -> Decimal {
        Decimal(string: String(format: "%.2f", value)) ?? Decimal(value)
    }
}

extension Money {
    static func parse(from formatted: String) -> Money? {
        let trimmed = formatted.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return nil }

        let isNegative = trimmed.contains("-")
        let cleaned = trimmed
            .replacingOccurrences(of: "$", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: ",", with: "")

        guard let value = Decimal(string: cleaned) else { return nil }
        return Money(amount: isNegative ? -value : value)
    }
}
