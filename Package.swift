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
            targets: ["ArrayExtension",
                      "ColorExtension",
                      "CodableExtension",
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
                      "UIViewControllerExtension",
                      "UIImageViewExtension"]),
        .library(
            name: "ArrayExtension",
            targets: ["ArrayExtension"]), // CodableExtension
        .library(
            name: "CodableExtension",
            targets: ["CodableExtension"]),
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
        .library(name: "UIImageViewExtension",
                 targets: ["UIImageViewExtension"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/ethanhuang13/NSAttributedStringBuilder", from: "0.3.0"),
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.0.0"),
        .package(url: "https://github.com/kean/Nuke", from: "9.0.0"),
        .package(url: "https://github.com/darjeelingsteve/Ampersand", from: "1.1.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ArrayExtension",
            dependencies: []),
        .target(
            name: "ColorExtension",
            dependencies: []),
        .target(
            name: "CodableExtension",
            dependencies: []),
        .target(
            name: "DateExtension",
            dependencies: []),
        .target(
            name: "DoubleExtension",
            dependencies: []),
        .target(
            name: "FontExtension",
            dependencies: ["Ampersand"]),
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
            dependencies: ["StringExtension"]),
        .target(
            name: "UIImageViewExtension",
            dependencies: ["Nuke"])
    ]
)
