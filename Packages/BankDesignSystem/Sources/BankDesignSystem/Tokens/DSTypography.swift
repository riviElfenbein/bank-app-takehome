import SwiftUI

public enum DSTypography {
    public static func title1() -> Font {
        .largeTitle.weight(.semibold)
    }

    public static func title2() -> Font {
        .title2.weight(.semibold)
    }

    public static func title3() -> Font {
        .callout.weight(.medium)
    }

    public static func title4() -> Font {
        .callout
    }

    public static func caption() -> Font {
        .caption
    }

    public static func button() -> Font {
        .callout.weight(.semibold)
    }
}
