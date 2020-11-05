//
//  Hyperlink.swift
//  
//
//  Created by Nate Weaver on 2020-11-02.
//

import Foundation
import TerminalFormat
import ArgumentParser

struct Hyperlink: ParsableCommand {

	func run() {
		print("""
			\([.faint, .italic])// All links should point to https://derailer.org/\([.reset])
			""")

		let link = TerminalHyperlink(url: URL(string: "https://derailer.org/")!, string: "Derailer")
		print("all-in-one: \(link)")

		print("wrapping: \("Derailer", link: link) <after link>")
		print("raw url: \("Derailer", url: URL(string: "https://derailer.org/")!) <after link>")
	}

}
