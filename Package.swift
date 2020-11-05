// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "TerminalFormat",
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "TerminalFormat",
			targets: ["TerminalFormat"]),
		.library(
			name: "TerminalImage",
			targets: ["TerminalImage"]),
		.executable(name: "example", targets: ["Example"])
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.0")
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "TerminalFormat",
			dependencies: []),
		.target(
			name: "TerminalImage",
			dependencies: ["TerminalFormat"]),
		.target(
			name: "Example",
			dependencies: ["TerminalImage", .product(name: "ArgumentParser", package: "swift-argument-parser")]),
		.testTarget(
			name: "TerminalFormatTests",
			dependencies: ["TerminalFormat"]),
	]
)
