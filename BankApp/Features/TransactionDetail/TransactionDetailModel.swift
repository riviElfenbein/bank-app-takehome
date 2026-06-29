import Observation
import SwiftUI

@Observable
final class TransactionDetailModel {
    let transactionID: Transaction.ID

    private let store: TransactionStore

    init(store: TransactionStore, transactionID: Transaction.ID) {
        self.store = store
        self.transactionID = transactionID
    }

    var isAvailable: Bool {
        transaction != nil
    }

    var recipientName: String {
        transaction?.recipientName ?? ""
    }

    var heroAmountText: String {
        transaction?.heroAmountText ?? ""
    }

    var commissionText: String {
        transaction?.commissionDisplayText ?? ""
    }

    var completedText: String {
        transaction?.completedDisplayText ?? ""
    }

    var showsVisaBadge: Bool {
        transaction?.withdrawalAccount.brand == .visa
    }

    var withdrawalLabelBinding: Binding<String> {
        Binding(
            get: { self.transaction?.withdrawalAccount.label ?? "" },
            set: { newValue in
                self.store.updateTransaction(id: self.transactionID) { $0.withdrawalAccount.label = newValue }
            }
        )
    }

    var withdrawalLast4Binding: Binding<String> {
        Binding(
            get: { self.transaction?.withdrawalAccount.last4 ?? "" },
            set: { newValue in
                self.store.updateTransaction(id: self.transactionID) { $0.withdrawalAccount.last4 = newValue }
            }
        )
    }

    var recipientNameBinding: Binding<String> {
        stringBinding(keyPath: \.recipientName)
    }

    var recipientPhoneBinding: Binding<String> {
        stringBinding(keyPath: \.recipientPhone)
    }

    var beneficiaryCardBinding: Binding<String> {
        Binding(
            get: {
                guard let last4 = self.transaction?.beneficiaryCardLast4 else { return "" }
                return "· \(last4)"
            },
            set: { newValue in
                let digits = newValue.replacingOccurrences(of: "·", with: "").trimmingCharacters(in: .whitespaces)
                self.store.updateTransaction(id: self.transactionID) { $0.beneficiaryCardLast4 = digits }
            }
        )
    }

    var amountBinding: Binding<String> {
        moneyBinding(keyPath: \.amount)
    }

    var commissionBinding: Binding<String> {
        moneyBinding(keyPath: \.commission)
    }

    var operationNumberBinding: Binding<String> {
        stringBinding(keyPath: \.operationNumber)
    }

    var dateBinding: Binding<String> {
        Binding(
            get: {
                guard let date = self.transaction?.date else { return "" }
                return Transaction.detailDateFormatter.string(from: date)
            },
            set: { newValue in
                guard let date = Transaction.detailDateFormatter.date(from: newValue) else { return }
                self.store.updateTransaction(id: self.transactionID) { $0.date = date }
            }
        )
    }

    private var transaction: Transaction? {
        store.transaction(id: transactionID)
    }

    private func stringBinding(keyPath: WritableKeyPath<Transaction, String>) -> Binding<String> {
        Binding(
            get: { self.transaction?[keyPath: keyPath] ?? "" },
            set: { newValue in
                self.store.updateTransaction(id: self.transactionID) { $0[keyPath: keyPath] = newValue }
            }
        )
    }

    private func moneyBinding(keyPath: WritableKeyPath<Transaction, Money>) -> Binding<String> {
        Binding(
            get: { self.transaction?[keyPath: keyPath].formatted ?? "" },
            set: { newValue in
                guard let money = Money.parse(from: newValue) else { return }
                self.store.updateTransaction(id: self.transactionID) { $0[keyPath: keyPath] = money }
            }
        )
    }
}
