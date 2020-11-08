//
//  example.swift
//  
//
//  Created by Nate Weaver on 2020-10-28.
//

import Foundation
import ArgumentParser

struct Example: ParsableCommand {

	static let configuration = CommandConfiguration(subcommands: [Complex.self, Hyperlink.self, Image.self, Custom.self], defaultSubcommand: Custom.self)

}

Example.main()
