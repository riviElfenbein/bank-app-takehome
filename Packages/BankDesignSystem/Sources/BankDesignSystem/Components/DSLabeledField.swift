import SwiftUI

public struct DSLabeledField: View {
    private let label: String
    @Binding private var text: String

    public init(label: String, text: Binding<String>) {
        self.label = label
        self._text = text
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(DSTypography.caption())
                .foregroundStyle(DSColors.labelSecondary)

            TextField("", text: $text)
                .font(DSTypography.title3())
                .foregroundStyle(DSColors.dark)
        }
        .frame(maxWidth: .infinity, minHeight: DSSpacing.rowHeight, alignment: .topLeading)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(DSColors.separator)
                .frame(height: 1)
        }
    }
}

#Preview {
    @Previewable @State var name = "Alexander Dmitrievich V."
    DSLabeledField(label: "Name of the recipient", text: $name)
        .padding(.horizontal, DSSpacing.screenHorizontal)
}
