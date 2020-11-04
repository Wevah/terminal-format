//
//  CommandLine+Extensions.swift
//  
//
//  Created by Nate Weaver on 2020-10-26.
//

import Foundation

public extension CommandLine {

	/// Whether the terminal emulator supports 24-bit color, determined by the contents of the `COLORTERM`
	/// environment variable.
	///
	/// `true` if `COLORTERM` is either `"truecolor"` or `"24bit"`.
	static var supportsTrueColor: Bool {
		guard let colorterm = ProcessInfo.processInfo.environment["COLORTERM"] else { return false }
		return colorterm == "truecolor" || colorterm == "24bit"
	}

	/// Sets the terminal window title.
	/// 
	/// - Parameter title: The new title. Pass an empty string to reset.
	static func setWindowTitle(_ title: String) {
		print("\(CLIControlSequence.osc)0;\(title)\(CLIControlSequence.bell)")
	}

}
