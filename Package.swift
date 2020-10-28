// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "CommandLineFormat",
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "CommandLineFormat",
			targets: ["CommandLineFormat"]),
		.library(
			name: "CommandLineImage",
			targets: ["CommandLineImage"]),
		.executable(name: "example", targets: ["Example"])
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "CommandLineFormat",
			dependencies: []),
		.target(
			name: "CommandLineImage",
			dependencies: ["CommandLineFormat"]),
		.target(
			name: "Example",
			dependencies: ["CommandLineImage"]),
		.testTarget(
			name: "CommandLineFormatTests",
			dependencies: ["CommandLineFormat"]),
	]
)
