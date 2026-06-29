// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "BankDesignSystem",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        .library(
            name: "BankDesignSystem",
            targets: ["BankDesignSystem"]
        )
    ],
    targets: [
        .target(
            name: "BankDesignSystem"
        )
    ]
)
