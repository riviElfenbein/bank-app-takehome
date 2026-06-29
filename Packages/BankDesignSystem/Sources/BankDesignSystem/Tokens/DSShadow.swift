import SwiftUI

public struct ShadowStyle: Sendable {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
}

public enum DSShadow {
    public static let none = ShadowStyle(color: .clear, radius: 0, x: 0, y: 0)
}
