// swift-tools-version:4.0
import PackageDescription

let package = Package(
  name: "SemanticUI",
  products: [
    .library(name: "SemanticUI", targets: ["SemanticUI"])
  ],
  dependencies: [],
  targets: [ .target(name: "SemanticUI") ]
)
