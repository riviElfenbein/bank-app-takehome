import SwiftUI

public struct DSStatusHeader: View {
    private let statusTitle: String
    private let summary: String

    public init(statusTitle: String, summary: String) {
        self.statusTitle = statusTitle
        self.summary = summary
    }

    public var body: some View {
        VStack(spacing: 8) {
            Text(statusTitle)
                .font(DSTypography.title2())
                .foregroundStyle(DSColors.dark)

            Text(summary)
                .font(DSTypography.caption())
                .foregroundStyle(DSColors.labelSecondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .padding(.bottom, DSSpacing.sectionSpacing)
    }
}

#Preview {
    DSStatusHeader(
        statusTitle: "Completed",
        summary: "100$ → Aleksander Dmitrievich V."
    )
    .background(DSColors.grey)
}
