import BankDesignSystem
import SwiftUI

struct TransactionsListView: View {
    @Environment(TransactionStore.self) private var store
    @State private var searchText = ""
    @State private var debouncedSearchText = ""

    private var filteredTransactions: [Transaction] {
        guard !debouncedSearchText.isEmpty else { return store.transactions }
        return store.transactions.filter {
            $0.recipientName.localizedCaseInsensitiveContains(debouncedSearchText)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            listHeader

            TransactionListContent(transactions: filteredTransactions)
        }
        .dsScreenBackground()
        .toolbar(.hidden, for: .navigationBar)
        .task(id: searchText) {
            try? await Task.sleep(for: .milliseconds(200))
            debouncedSearchText = searchText
        }
    }

    private var listHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Transactions")
                .font(DSTypography.title1())
                .foregroundStyle(DSColors.dark)

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(DSColors.labelSecondary)

                TextField("Search transactions", text: $searchText)
                    .font(DSTypography.title4())
                    .foregroundStyle(DSColors.dark)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(DSColors.white)
            .clipShape(RoundedRectangle(cornerRadius: DSRadius.button))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, DSSpacing.screenHorizontal)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(DSColors.grey)
    }
}

private struct TransactionListContent: View {
    let transactions: [Transaction]

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        List(transactions) { transaction in
            NavigationLink(value: transaction.id) {
                DSTransactionRow(
                    merchantInitial: merchantInitial(for: transaction),
                    recipientName: transaction.recipientName,
                    subtitle: subtitle(for: transaction),
                    formattedAmount: transaction.amount.formatted,
                    isCredit: transaction.amount.isCredit
                )
            }
            .listRowSeparator(.hidden)
            .listRowBackground(DSColors.white)
            .listRowInsets(EdgeInsets(top: 0, leading: DSSpacing.screenHorizontal, bottom: 0, trailing: DSSpacing.screenHorizontal))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(transaction.recipientName), \(transaction.amount.formatted)")
            .accessibilityHint("View transaction details")
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    private func subtitle(for transaction: Transaction) -> String {
        "\(Self.dateFormatter.string(from: transaction.date)) · \(transaction.status.displayTitle)"
    }

    private func merchantInitial(for transaction: Transaction) -> String {
        guard let first = transaction.recipientName.first else { return "?" }
        return String(first).uppercased()
    }
}

#Preview {
    NavigationStack {
        TransactionsListView()
    }
    .environment(PreviewTransactionStore.make())
}
