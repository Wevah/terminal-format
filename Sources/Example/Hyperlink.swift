//
//  Hyperlink.swift
//  
//
//  Created by Nate Weaver on 2020-11-02.
//

import Foundation
import CommandLineFormat
import ArgumentParser

struct Hyperlink: ParsableCommand {

	func run() {
		print("""
			\([.faint, .italic])All links should point to https://derailer.org/\([.reset])
			""")

		let link = CLIHyperlink(url: URL(string: "https://derailer.org/")!, string: "Derailer")
		print("all-in-one: \(link)")

		print("wrapping: \("hello", link: link) after")
		print("raw url: \("hello", url: URL(string: "https://derailer.org/")!) after")
	}

}
