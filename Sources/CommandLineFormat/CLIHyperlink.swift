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
public struct CLIHyperlink: CustomStringConvertible {

	/// The URL linked to by the hyperlink.
	var url: URL
	/// The string content of the hyperlink.
	var string: String

	/// An optional identifier. Multiple links with the same ID are treated as the same link
	/// for the purpose of, e.g., hover effects.
	var id: String?

	public var description: String {
		let idstring = id != nil ? "id=\(id!)" : ""
		return "\(CLIFormat.escape)]8;\(idstring);\(url.absoluteString)\(CLIFormat.bell)\(self)\(CLIFormat.escape)]8;;\(CLIFormat.bell)"
	}
	
}