//
//  TerminalControlSequence.swift
//  
//
//  Created by Nate Weaver on 2020-11-05.
//

import Foundation

public struct TerminalControlSequence {

	fileprivate let string: String

	fileprivate init(_ string: String) {
		self.string = string
	}

	/// The escape character (`ESC`, `0x1b`).
	public static let escape = Self("\u{001B}")

	/// The bell character (`BEL`, `0x07`).
	public static let bell = Self("\u{0007}")

	/// Control Sequence Introducer, `ESC` + `[`.
	public static let csi = Self("\(escape)[")

	/// Operating System Command, `ESC` + `]`.
	public static let osc = Self("\(escape)]")

}

// An explicit appendInterpolation function is defined here instead of
// conforming to TerminalPrintable so the type can be inferred in interpolations like "\(.escape)".

public extension DefaultStringInterpolation {

	mutating func appendInterpolation(_ controlSequence: TerminalControlSequence) {
		self.appendLiteral(controlSequence.string)
	}

}
