//
//  StringProtocol+Extensions.swift
//  
//
//  Created by Nate Weaver on 2020-10-27.
//

import Foundation

/// A terminal hyperlink.
///
/// Supported by iTerm and kitty.
public struct TerminalHyperlink: CustomDebugStringConvertible {

	public init(url: URL, string: String, id: String? = nil) {
		self.url = url
		self.string = string
		self.id = id
	}

	/// The URL linked to by the hyperlink.
	public var url: URL
	
	/// The string content of the hyperlink.
	public var string: String

	/// An optional identifier. Multiple links with the same ID are treated as the same link
	/// for the purpose of, e.g., hover effects.
	public var id: String?

	public var debugDescription: String {
		return "TerminalHyperlink: [url: \(url), string: \(string), id: \(id ?? "nil")]"
	}

	private var startSequence: String {
		let idstring = id != nil ? "id=\(id!)" : ""
		return "\(.osc)8;\(idstring);\(url.absoluteString)\(.bell)"
	}

	private var endSequence: String {
		return "\(.osc)8;;\(.bell)"
	}

}

extension TerminalHyperlink: TerminalPrintable {

	public var escapeSequence: String {
		return "\(startSequence)\(string)\(endSequence)"
	}

}

public extension DefaultStringInterpolation {

	mutating func appendInterpolation(_ string: String, link: TerminalHyperlink) {
		var copy = link
		copy.string = string
		appendInterpolation(copy)
	}

	mutating func appendInterpolation(_ string: String, url: URL, id: String? = nil) {
		let link = TerminalHyperlink(url: url, string: string, id: id)
		appendInterpolation(link)
	}

}
