//
//  Sequence+Extensions.swift
//  
//
//  Created by Nate Weaver on 2020-10-21.
//

// From ArgumentParser

extension Sequence where Element: Hashable {

	/// Returns an array with only the unique elements of this sequence, in the
	/// order of the first occurence of each unique element.
	///
	/// - Complexity: O(*n*) where *n* is the number of elements in `self`.
	func uniquing() -> [Element] {
		var seen = Set<Element>()
		return self.filter { seen.insert($0).inserted }
	}

}
