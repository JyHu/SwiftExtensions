// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(name: "SwiftExtensions")

package.platforms = [
    .iOS(.v11),
    .macOS(.v10_13),
    .watchOS(.v6),
    .tvOS(.v11),
    .macCatalyst(.v13)
]

package.targets.append(
    .target(
        name: "SwiftExtensions",
        dependencies: []
    )
)

package.targets.append(
    .testTarget(
        name: "SwiftExtensionsTests",
        dependencies: [
            "SwiftExtensions"
        ]
    )
)

package.products = package.targets.filter { !$0.isTest }
.map {
    Product.library(name: $0.name, targets: [$0.name])
}
