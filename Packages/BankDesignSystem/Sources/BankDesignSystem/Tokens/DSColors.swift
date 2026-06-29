import SwiftUI

public enum DSColors {
    public static let white = Color(red: 1, green: 1, blue: 1)
    public static let grey = Color(red: 243 / 255, green: 246 / 255, blue: 250 / 255)
    public static let dark = Color(red: 40 / 255, green: 42 / 255, blue: 49 / 255)
    public static let primary = Color(red: 61 / 255, green: 112 / 255, blue: 1)
    public static let success = Color(red: 83 / 255, green: 176 / 255, blue: 82 / 255)

    public static let labelSecondary = dark.opacity(0.6)
    public static let separator = dark.opacity(0.06)
}
