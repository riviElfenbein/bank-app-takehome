import Foundation

enum CardBrand: String, Hashable, Sendable {
    case visa
    case mastercard
    case mir
}

struct PaymentCard: Hashable, Sendable {
    var label: String
    var brand: CardBrand
    var last4: String
}
