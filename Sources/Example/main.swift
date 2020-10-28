//
//  example.swift
//  
//
//  Created by Nate Weaver on 2020-10-28.
//

import Foundation
import CommandLineImage
import CommandLineFormat
import ArgumentParser

struct Example: ParsableCommand {

	static let configuration = CommandConfiguration(subcommands: [Complex.self, Image.self, Custom.self])

}

Example.main()
