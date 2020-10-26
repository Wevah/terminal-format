//
//  CommandLine+Extensions.swift
//  
//
//  Created by Nate Weaver on 2020-10-26.
//

import Foundation

extension CommandLine {

	var supportsTrueColor: Bool {
		guard let colorterm = ProcessInfo.processInfo.environment["COLORTERM"] else { return false }
		return colorterm == "truecolor" || colorterm == "24bit"
	}

}
