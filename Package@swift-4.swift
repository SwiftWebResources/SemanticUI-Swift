// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "jQuery",
  products: [
    .library(name: "jQuery", targets: ["jQuery"])
  ],
  dependencies: [],
  targets: [ .target(name: "jQuery") ]
)
