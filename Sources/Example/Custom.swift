//
//  Custom.swift
//  
//
//  Created by Nate Weaver on 2020-10-28.
//

import Foundation
import ArgumentParser
import CommandLineFormat

struct Custom: ParsableCommand {

	@Flag var bold: Bool = false
	@Flag var italic: Bool = false
	@Flag var faint: Bool = false
	@Option(transform: { URL(string: $0) }) var url: URL? = nil
	@Option(
		transform: { (string) -> CLIFormat.UnderlineStyle? in
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
	var underline: CLIFormat.UnderlineStyle?

	@Argument var text: [String] = []

	func run() {
		let format = CLIFormat(bold: bold, faint: faint, italic: italic, underline: underline)

		let formatted = text.joined(separator: " ").ansiFormatted(format: format)

		if let url = url {
			let hyperlink = CLIHyperlink(url: url, string: formatted)

			print(hyperlink)
		} else {
			print(formatted)
		}
	}

}
