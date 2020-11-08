//
//  Custom.swift
//  
//
//  Created by Nate Weaver on 2020-10-28.
//

import Foundation
import ArgumentParser
import TerminalFormat

struct Custom: ParsableCommand {

	static var configuration = CommandConfiguration(abstract: "Customize output.")

	@Flag var bold: Bool = false
	@Flag var italic: Bool = false
	@Flag var faint: Bool = false
	@Option(transform: { URL(string: $0) }) var url: URL? = nil
	@Option(transform: { TerminalAttribute.custom($0) }) var custom: [TerminalAttribute]
	@Option(
		transform: { (string) -> TerminalAttribute.UnderlineStyle? in
			switch string {
				case "single":
					return .single
				case "double":
					return .double
				case "curly":
					return .curly
				case "dashed":
					return .dashed
				case "dotted":
					return .dotted
				default:
					return nil
			}
		})
	var underline: TerminalAttribute.UnderlineStyle?

	@Argument var text: [String] = []

	func run() {
		var attributes = [TerminalAttribute]()

		if bold {
			attributes.append(.bold)
		}

		if faint {
			attributes.append(.faint)
		}

		if italic {
			attributes.append(.italic)
		}

		if let underline = underline {
			attributes.append(.underline(underline))
		}

		attributes.append(contentsOf: custom)

		let formatted = "\(text.joined(separator: " "), attributes: attributes.count != 0 ? attributes : nil)"

		if let url = url {
			let hyperlink = TerminalHyperlink(url: url, string: formatted)

			print(hyperlink)
		} else {
			print(formatted)
		}
	}

}
