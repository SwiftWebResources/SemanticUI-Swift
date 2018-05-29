import PackageDescription

let package = Package(
  name: "SemanticUI",

  targets: [ Target(name: "SemanticUI") ],

  dependencies: [
  ],
	
  exclude: [
    "Makefile",
    "README.md"
  ]
)
