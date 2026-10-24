// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "CRToast",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "CRToast", targets: ["CRToast"])
    ],
    targets: [
        .target(
            name: "CRToast",
            path: "CRToast",
            exclude: ["Info.plist"],
            publicHeadersPath: ".",
            cSettings: [
                // CRToast.h imports its siblings as <CRToast/...>; resolve that against the repo root.
                .headerSearchPath("..")
            ]
        )
    ]
)
