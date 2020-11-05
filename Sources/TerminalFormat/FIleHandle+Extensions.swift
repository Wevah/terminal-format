//
//  FileHandle+Extensions.swift
//  
//
//  Created by Nate Weaver on 2020-10-23.
//

import Foundation

extension FileHandle {

	/// Returns whether `self` is connected to a terminal.
	var isTTY: Bool {
		return isatty(self.fileDescriptor) != 0
	}
	
}
