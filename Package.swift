// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "ServiceDemo",
    dependencies: [
        .Package(
            url: "https://github.com/PerfectlySoft/Perfect-HTTPServer.git",
            majorVersion: 2, minor: 0
        )
    ]
)
