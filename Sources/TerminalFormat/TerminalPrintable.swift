//
//  File.swift
//  
//
//  Created by Nate Weaver on 2020-11-02.
//

import Foundation

public protocol TerminalPrintable {

	/// The terminal sequence used for interpolation.
	var escapeSequence: String { get }

}

public extension DefaultStringInterpolation {

	mutating func appendInterpolation<T: TerminalPrintable>(_ printable: T) {
		self.appendLiteral(printable.escapeSequence)
	}

	mutating func appendInterpolation<T: TerminalPrintable & CustomStringConvertible>(_ printable: T) {
		self.appendLiteral(printable.escapeSequence)
	}

	mutating func appendInterpolation<T: TerminalPrintable>(_ printable: T?) {
		guard let representable = printable else { return }
		self.appendInterpolation(representable.escapeSequence)
	}

	mutating func appendInterpolation<T: TerminalPrintable & CustomStringConvertible>(_ printable: T?) {
		guard let representable = printable else { return }
		self.appendInterpolation(representable.escapeSequence)
	}

}
