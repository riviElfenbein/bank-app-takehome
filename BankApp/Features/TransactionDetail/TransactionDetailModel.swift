import Observation

struct DetailDraftSnapshot: Equatable {
    var withdrawalLabel: String
    var withdrawalLast4: String
    var recipientName: String
    var recipientPhone: String
    var beneficiaryCard: String
    var amount: String
    var commission: String
    var operationNumber: String
    var date: String

    static let empty = DetailDraftSnapshot(
        withdrawalLabel: "",
        withdrawalLast4: "",
        recipientName: "",
        recipientPhone: "",
        beneficiaryCard: "",
        amount: "",
        commission: "",
        operationNumber: "",
        date: ""
    )

    init(from transaction: Transaction) {
        withdrawalLabel = transaction.withdrawalAccount.label
        withdrawalLast4 = transaction.withdrawalAccount.last4
        recipientName = transaction.recipientName
        recipientPhone = transaction.recipientPhone
        beneficiaryCard = TransactionFormatters.beneficiaryCardDisplay(last4: transaction.beneficiaryCardLast4)
        amount = transaction.amount.formatted
        commission = transaction.commission.formatted
        operationNumber = transaction.operationNumber
        date = TransactionFormatters.detailDate(transaction.date)
    }
}

@MainActor
@Observable
final class TransactionDetailModel {
    let transactionID: Transaction.ID

    var draftWithdrawalLabel = ""
    var draftWithdrawalLast4 = ""
    var draftRecipientName = ""
    var draftRecipientPhone = ""
    var draftBeneficiaryCard = ""
    var draftAmount = ""
    var draftCommission = ""
    var draftOperationNumber = ""
    var draftDate = ""

    private let repository: TransactionStore
    private let committedSnapshot: DetailDraftSnapshot

    init(repository: TransactionStore, transactionID: Transaction.ID) {
        self.repository = repository
        self.transactionID = transactionID

        if let transaction = repository.transaction(id: transactionID) {
            let snapshot = DetailDraftSnapshot(from: transaction)
            committedSnapshot = snapshot
            loadDraft(from: snapshot)
        } else {
            committedSnapshot = .empty
        }
    }

    var isAvailable: Bool {
        transaction != nil
    }

    var recipientName: String {
        draftRecipientName
    }

    var heroAmountText: String {
        if let money = Money.parse(from: draftAmount) {
            return TransactionFormatters.heroAmount(money)
        }
        return draftAmount.replacingOccurrences(of: "-", with: "")
    }

    var commissionText: String {
        if let money = Money.parse(from: draftCommission) {
            return TransactionFormatters.commissionText(money)
        }
        if draftCommission.isEmpty {
            return TransactionFormatters.commissionText(Money(amount: 0))
        }
        return draftCommission
    }

    var completedText: String {
        guard let transaction else { return "" }
        let date = TransactionFormatters.parseDetailDate(draftDate) ?? transaction.date
        return TransactionFormatters.completedText(date: date, status: transaction.status)
    }

    var showsVisaBadge: Bool {
        transaction?.withdrawalAccount.brand == .visa
    }

    func commit() {
        guard isAvailable else { return }
        guard hasUncommittedChanges else { return }

        repository.updateTransaction(id: transactionID) { transaction in
            transaction.withdrawalAccount.label = draftWithdrawalLabel
            transaction.withdrawalAccount.last4 = draftWithdrawalLast4
            transaction.recipientName = draftRecipientName
            transaction.recipientPhone = draftRecipientPhone
            transaction.beneficiaryCardLast4 = TransactionFormatters.parseBeneficiaryCardLast4(draftBeneficiaryCard)
            transaction.operationNumber = draftOperationNumber

            if let amount = Money.parse(from: draftAmount) {
                transaction.amount = amount
            }
            if let commission = Money.parse(from: draftCommission) {
                transaction.commission = commission
            }
            if let date = TransactionFormatters.parseDetailDate(draftDate) {
                transaction.date = date
            }
        }
    }

    private var transaction: Transaction? {
        repository.transaction(id: transactionID)
    }

    private var hasUncommittedChanges: Bool {
        draftSnapshot != committedSnapshot
    }

    private var draftSnapshot: DetailDraftSnapshot {
        DetailDraftSnapshot(
            withdrawalLabel: draftWithdrawalLabel,
            withdrawalLast4: draftWithdrawalLast4,
            recipientName: draftRecipientName,
            recipientPhone: draftRecipientPhone,
            beneficiaryCard: draftBeneficiaryCard,
            amount: draftAmount,
            commission: draftCommission,
            operationNumber: draftOperationNumber,
            date: draftDate
        )
    }

    private func loadDraft(from snapshot: DetailDraftSnapshot) {
        draftWithdrawalLabel = snapshot.withdrawalLabel
        draftWithdrawalLast4 = snapshot.withdrawalLast4
        draftRecipientName = snapshot.recipientName
        draftRecipientPhone = snapshot.recipientPhone
        draftBeneficiaryCard = snapshot.beneficiaryCard
        draftAmount = snapshot.amount
        draftCommission = snapshot.commission
        draftOperationNumber = snapshot.operationNumber
        draftDate = snapshot.date
    }
}

private extension DetailDraftSnapshot {
    init(
        withdrawalLabel: String,
        withdrawalLast4: String,
        recipientName: String,
        recipientPhone: String,
        beneficiaryCard: String,
        amount: String,
        commission: String,
        operationNumber: String,
        date: String
    ) {
        self.withdrawalLabel = withdrawalLabel
        self.withdrawalLast4 = withdrawalLast4
        self.recipientName = recipientName
        self.recipientPhone = recipientPhone
        self.beneficiaryCard = beneficiaryCard
        self.amount = amount
        self.commission = commission
        self.operationNumber = operationNumber
        self.date = date
    }
}
