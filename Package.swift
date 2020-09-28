// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KExtensions",
    platforms: [.iOS("12.0")],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "KExtensions",
            targets: ["KExtensions",
                      "ArrayExtension",
                      "ColorExtension",
                      "DateExtension",
                      "DoubleExtension",
                      "FontExtension",
                      "ImageExtension",
                      "LabelExtension",
                      "LocationExtension",
                      "StringExtension",
                      "TableViewExtension",
                      "TextFieldExtension",
                      "UIViewExtension",
                      "UIViewControllerExtension"]),
        .library(
            name: "ArrayExtension",
            targets: ["ArrayExtension"]),
        .library(
            name: "ColorExtension",
            targets: ["ColorExtension"]),
        .library(
            name: "DateExtension",
            targets: ["DateExtension"]),
        .library(
            name: "DoubleExtension",
            targets: ["DoubleExtension"]),
        .library(
            name: "FontExtension",
            targets: ["FontExtension"]),
        .library(
            name: "ImageExtension",
            targets: ["ImageExtension"]),
        .library(
            name: "LabelExtension",
            targets: ["LabelExtension"]),
        .library(
            name: "LocationExtension",
            targets: ["LocationExtension"]),
        .library(
            name: "StringExtension",
            targets: ["StringExtension"]),
        .library(
            name: "TableViewExtension",
            targets: ["TableViewExtension"]),
        .library(
            name: "TextFieldExtension",
            targets: ["TextFieldExtension"]),
        .library(
            name: "UIViewExtension",
            targets: ["UIViewExtension"]),
        .library(
            name: "UIViewControllerExtension",
            targets: ["UIViewControllerExtension"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/ethanhuang13/NSAttributedStringBuilder", from: "0.3.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "KExtensions",
            dependencies: []),
        .target(
            name: "ArrayExtension",
            dependencies: []),
        .target(
            name: "ColorExtension",
            dependencies: []),
        .target(
            name: "DateExtension",
            dependencies: []),
        .target(
            name: "DoubleExtension",
            dependencies: []),
        .target(
            name: "FontExtension",
            dependencies: []),
        .target(
            name: "ImageExtension",
            dependencies: []),
        .target(
            name: "LabelExtension",
            dependencies: ["NSAttributedStringBuilder", "StringExtension"]),
        .target(
            name: "LocationExtension",
            dependencies: []),
        .target(
            name: "StringExtension",
            dependencies: ["NSAttributedStringBuilder", "FontExtension"]),
        .target(
            name: "TableViewExtension",
            dependencies: ["SnapKit"]),
        .target(
            name: "TextFieldExtension",
            dependencies: ["SnapKit", "StringExtension", "FontExtension"]),
        .target(
            name: "UIViewExtension",
            dependencies: ["SnapKit"]),
        .target(
            name: "UIViewControllerExtension",
            dependencies: []),
        .testTarget(
            name: "KExtensionsTests",
            dependencies: ["KExtensions"]),
    ]
)
