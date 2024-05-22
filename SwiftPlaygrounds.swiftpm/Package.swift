// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "SwiftPlaygrounds",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "SwiftPlaygrounds",
            targets: ["AppModule"],
            bundleIdentifier: "com.muhiro12.SwiftPlaygrounds",
            teamIdentifier: "66PKF55HK5",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.mint),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .photoLibrary(purposeString: "Photo Library")
            ]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", "4.0.0"..<"5.0.0")
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            dependencies: [
                .product(name: "KeychainAccess", package: "keychainaccess")
            ],
            path: "."
        )
    ]
)