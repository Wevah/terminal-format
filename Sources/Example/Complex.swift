//
//  Complex.swift
//  
//
//  Created by Nate Weaver on 2020-10-28.
//

import Foundation
import CommandLineFormat
import ArgumentParser

struct Complex: ParsableCommand {

	static let configuration = CommandConfiguration(abstract: "Display a complex example.")

	func run() {
		print("""

			\(CLIFormat(faint: true, italic: true))// Complex example.
			// Should print "one" in the default colors, "two" in green,
			// "three" in bold green with a red background,
			// "four" in italics (if supported by the terminal)
			// with the default foreground color and a blue background,
			// and finally "five" in the default colors.\(.reset)

			""")
		let green = CLIFormat.green
		let redBackground = CLIFormat(backgroundColor: .red, bold: true)
		let blueBackgroundOnly = CLIFormat(backgroundColor: .blue, italic: true, reset: true)
		print("one \(green)two \(redBackground)three \(blueBackgroundOnly)four\(.reset) five\n")
	}

}