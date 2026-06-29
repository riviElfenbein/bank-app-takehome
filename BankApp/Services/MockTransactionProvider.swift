import Foundation

enum MockTransactionProvider {
    private static let merchantNames = [
        "Netflix", "Amazon", "Uber", "Spotify", "Apple Store",
        "Whole Foods Market", "Shell Gas Station", "Starbucks",
        "Target", "Walmart", "Costco", "CVS Pharmacy",
        "Delta Airlines", "Airbnb", "Booking.com", "PayPal Transfer",
        "Salary Deposit", "Freelance Client", "City Utilities", "Rent Payment"
    ]

    static func makeTransactions(referenceDate: Date = .now) -> [Transaction] {
        let exemplar = makeExemplarTransaction()
        let bulk = generateBulk(count: 120, referenceDate: referenceDate)
        return ([exemplar] + bulk).sorted { $0.date > $1.date }
    }

    private static func makeExemplarTransaction() -> Transaction {
        let salaryCard = PaymentCard(label: "Salary card", brand: .visa, last4: "3040")

        var exemplarComponents = DateComponents()
        exemplarComponents.year = 2022
        exemplarComponents.month = 9
        exemplarComponents.day = 12
        exemplarComponents.hour = 16
        exemplarComponents.minute = 0
        let exemplarDate = Calendar.current.date(from: exemplarComponents) ?? .now

        return Transaction(
            id: UUID(uuidString: "A1000001-0000-4000-8000-000000000001")!,
            recipientName: "Alexander Dmitrievich V.",
            recipientPhone: "+995 559 72 88",
            beneficiaryCardLast4: "0981",
            amount: Money(amount: -.dollars(100)),
            commission: Money(amount: 0),
            operationNumber: "2669708927",
            date: exemplarDate,
            status: .completed,
            withdrawalAccount: salaryCard
        )
    }

    private static func generateBulk(count: Int, referenceDate: Date) -> [Transaction] {
        let calendar = Calendar.current
        let salaryCard = PaymentCard(label: "Salary card", brand: .visa, last4: "3040")

        return (1...count).map { index in
            let isCredit = index % 10 == 0
            let amountValue: Decimal = if isCredit {
                .dollars(Double.random(in: 200...5000).rounded(toPlaces: 2))
            } else {
                -.dollars(Double.random(in: 5...500).rounded(toPlaces: 2))
            }

            let daysAgo = index % 365
            let hour = (index * 3) % 24
            let minute = (index * 7) % 60
            let base = calendar.date(byAdding: .day, value: -daysAgo, to: referenceDate) ?? referenceDate
            let date = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: base) ?? base

            let merchant = merchantNames[index % merchantNames.count]
            let suffix = index > merchantNames.count ? " #\(index)" : ""
            let cardLast4 = String(format: "%04d", (index * 137) % 10000)
            let commission: Decimal = index % 15 == 0 ? .dollars(1.50) : 0

            return Transaction(
                id: stableID(index: index),
                recipientName: merchant + suffix,
                recipientPhone: "+1 555 \(String(format: "%03d", index % 1000)) \(String(format: "%02d", (index * 11) % 100)) \(String(format: "%02d", (index * 13) % 100))",
                beneficiaryCardLast4: cardLast4,
                amount: Money(amount: amountValue),
                commission: Money(amount: commission),
                operationNumber: "2669709\(String(format: "%03d", index + 100))",
                date: date,
                status: .completed,
                withdrawalAccount: salaryCard
            )
        }
    }

    private static func stableID(index: Int) -> UUID {
        UUID(uuidString: String(format: "B1000001-0000-4000-8000-%012X", index))!
    }
}

private extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
