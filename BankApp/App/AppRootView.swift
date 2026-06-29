import BankDesignSystem
import SwiftUI

struct AppRootView: View {
    @State private var store: TransactionStore
    @State private var listModel: TransactionsListModel
    private let loader: any TransactionLoader

    init(
        store: TransactionStore = TransactionStore(),
        loader: any TransactionLoader = MockTransactionLoader()
    ) {
        _store = State(initialValue: store)
        _listModel = State(initialValue: TransactionsListModel(repository: store))
        self.loader = loader
    }

    var body: some View {
        NavigationStack {
            TransactionsListView(model: listModel)
                .navigationDestination(for: Transaction.ID.self) { id in
                    TransactionDetailView(
                        model: TransactionDetailModel(repository: store, transactionID: id)
                    )
                }
        }
        .dsKeyboardDoneToolbar()
        .task {
            await listModel.load(using: loader)
        }
    }
}

#Preview {
    AppRootView(store: PreviewTransactionStore.make())
}
