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
            targets: ["KExtensions"]),
        .library(
            name: "Array",
            targets: ["Array"]),
        .library(
            name: "Color",
            targets: ["Color"]),
        .library(
            name: "Date",
            targets: ["Date"]),
        .library(
            name: "Double",
            targets: ["Double"]),
        .library(
            name: "Font",
            targets: ["Font"]),
        .library(
            name: "Image",
            targets: ["Image"]),
        .library(
            name: "Label",
            targets: ["Label"]),
        .library(
            name: "Location",
            targets: ["Location"]),
        .library(
            name: "String",
            targets: ["String"]),
        .library(
            name: "TableView",
            targets: ["TableView"]),
        .library(
            name: "TextField",
            targets: ["TextField"]),
        .library(
            name: "UIView",
            targets: ["UIView"]),
        .library(
            name: "UIViewController",
            targets: ["UIViewController"]),
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
            name: "Array",
            dependencies: []),
    .target(
        name: "Color",
        dependencies: []),
    .target(
        name: "Date",
        dependencies: []),
    .target(
        name: "Double",
        dependencies: []),
    .target(
        name: "Font",
        dependencies: []),
    .target(
        name: "Image",
        dependencies: []),
    .target(
        name: "Label",
        dependencies: ["NSAttributedStringBuilder", "String"]),
    .target(
        name: "Location",
        dependencies: []),
    .target(
        name: "String",
        dependencies: ["NSAttributedStringBuilder", "Font"]),
    .target(
        name: "TableView",
        dependencies: ["SnapKit"]),
    .target(
        name: "TextField",
        dependencies: ["SnapKit", "String", "Font"]),
    .target(
        name: "UIView",
        dependencies: ["SnapKit"]),
    .target(
        name: "UIViewController",
        dependencies: []),
        .testTarget(
            name: "KExtensionsTests",
            dependencies: ["KExtensions"]),
    ]
)
