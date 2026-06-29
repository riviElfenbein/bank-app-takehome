import SwiftUI

public struct DSLabeledRow: View {
    private let label: String
    private let value: String
    private let trailingAccessory: AnyView?

    public init(
        label: String,
        value: String,
        @ViewBuilder trailingAccessory: () -> some View = { EmptyView() }
    ) {
        self.label = label
        self.value = value
        self.trailingAccessory = AnyView(trailingAccessory())
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(DSTypography.caption())
                .foregroundStyle(DSColors.labelSecondary)

            HStack {
                Text(value)
                    .font(DSTypography.title3())
                    .foregroundStyle(DSColors.dark)

                Spacer()

                trailingAccessory
            }
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
    VStack(spacing: 0) {
        DSLabeledRow(label: "Transfer amount", value: "100$")
        DSLabeledRow(label: "Withdrawal account", value: "Salary card") {
            HStack(spacing: 8) {
                Text("VISA")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(DSColors.dark)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(DSColors.grey)
                    .clipShape(RoundedRectangle(cornerRadius: DSRadius.visaBadge))
                Text("· 3040")
                    .font(DSTypography.caption())
                    .foregroundStyle(DSColors.labelSecondary)
            }
        }
    }
    .padding(.horizontal, DSSpacing.screenHorizontal)
}
