import BankDesignSystem
import SwiftUI

struct AppRootView: View {
    @State private var store = TransactionStore()

    var body: some View {
        NavigationStack {
            TransactionsListView()
                .navigationDestination(for: Transaction.ID.self) { id in
                    TransactionDetailView(transactionID: id)
                }
        }
        .environment(store)
        .dsKeyboardDoneToolbar()
    }
}

#Preview {
    AppRootView()
}
