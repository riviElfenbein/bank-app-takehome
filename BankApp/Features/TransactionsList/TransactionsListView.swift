import BankDesignSystem
import SwiftUI

struct TransactionsListView: View {
    @Bindable var model: TransactionsListModel

    var body: some View {
        VStack(spacing: 0) {
            listHeader

            if model.isLoading {
                loadingIndicator
            }

            TransactionListContent(rows: model.rowsForDisplay)
        }
        .dsScreenBackground()
        .toolbar(.hidden, for: .navigationBar)
        .task(id: model.searchText) {
            await model.applyDebouncedSearch()
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

                TextField("Search transactions", text: $model.searchText)
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

    private var loadingIndicator: some View {
        VStack(spacing: 8) {
            ProgressView(value: Double(model.loadProgress), total: Double(model.loadTotal))
                .tint(DSColors.dark)

            if let label = model.loadProgressLabel {
                Text(label)
                    .font(DSTypography.caption())
                    .foregroundStyle(DSColors.labelSecondary)
            }
        }
        .padding(.horizontal, DSSpacing.screenHorizontal)
        .padding(.bottom, 8)
    }
}

private struct TransactionListContent: View {
    let rows: [TransactionRowState]

    var body: some View {
        List(rows) { row in
            NavigationLink(value: row.id) {
                DSTransactionRow(
                    merchantInitial: row.merchantInitial,
                    recipientName: row.recipientName,
                    subtitle: row.subtitle,
                    formattedAmount: row.formattedAmount,
                    isCredit: row.isCredit
                )
            }
            .listRowSeparator(.hidden)
            .listRowBackground(DSColors.white)
            .listRowInsets(EdgeInsets(top: 0, leading: DSSpacing.screenHorizontal, bottom: 0, trailing: DSSpacing.screenHorizontal))
            .accessibilityElement(children: .combine)
            .accessibilityLabel("\(row.recipientName), \(row.formattedAmount)")
            .accessibilityHint("View transaction details")
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    NavigationStack {
        TransactionsListView(
            model: TransactionsListModel(repository: PreviewTransactionStore.make())
        )
    }
}
