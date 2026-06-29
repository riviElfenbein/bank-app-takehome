import SwiftUI

public struct DSCardSurface<Content: View>: View {
    private let content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .padding(.horizontal, DSSpacing.screenHorizontal)
            .padding(.top, DSSpacing.sectionSpacing)
            .padding(.bottom, DSSpacing.sectionSpacing)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(DSColors.white)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: DSRadius.card,
                    topTrailingRadius: DSRadius.card
                )
            )
    }
}

#Preview {
    ZStack(alignment: .top) {
        DSColors.grey.ignoresSafeArea()
        DSCardSurface {
            Text("Card content")
                .font(DSTypography.title4())
        }
    }
}
