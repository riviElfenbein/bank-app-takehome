import BankDesignSystem
import SwiftUI

struct TransactionsListView: View {
    @Environment(TransactionStore.self) private var store
    @State private var searchText = ""
    @State private var isSearchPresented = false

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    private var filteredTransactions: [Transaction] {
        guard !searchText.isEmpty else { return store.transactions }
        return store.transactions.filter {
            $0.recipientName.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        List {
            Section {
                HStack(spacing: 12) {
                    DSQuickActionTile("Search", systemName: "magnifyingglass") {
                        isSearchPresented = true
                    }
                    DSQuickActionTile("Add", systemName: "plus") {}
                    DSQuickActionTile("Filter", systemName: "line.3.horizontal.decrease") {}
                }
                .listRowInsets(EdgeInsets(top: 8, leading: DSSpacing.screenHorizontal, bottom: 8, trailing: DSSpacing.screenHorizontal))
                .listRowBackground(DSColors.grey)
                .listRowSeparator(.hidden)
            }

            ForEach(filteredTransactions) { transaction in
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
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .dsScreenBackground()
        .navigationTitle("Transactions")
        .searchable(text: $searchText, isPresented: $isSearchPresented, prompt: "Search transactions")
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
