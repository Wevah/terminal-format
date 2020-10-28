//
//  CommandLine+Extensions.swift
//  
//
//  Created by Nate Weaver on 2020-10-26.
//

import Foundation

public extension CLIFormat {

	/// Whether the terminal emulator supports 24-bit color, determined by the contents of the `COLORTERM`
	/// environment variable.
	static var supportsTrueColor: Bool {
		guard let colorterm = ProcessInfo.processInfo.environment["COLORTERM"] else { return false }
		return colorterm == "truecolor" || colorterm == "24bit"
	}

	/// Sets the terminal window title.
	static func setWindowTitle(_ title: String) {
		print("\(Self.osc)0;\(title)\(Self.bell)")
	}

}
