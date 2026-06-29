import SwiftUI

#if canImport(UIKit)
import UIKit

public enum DSKeyboard {
    public static func dismiss() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil
        )
    }
}
#endif

extension View {
    public func dsKeyboardDoneToolbar() -> some View {
        toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done", action: DSKeyboard.dismiss)
            }
        }
    }
}
