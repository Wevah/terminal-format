//
//  TerminalImage.swift
//  
//
//  Created by Nate Weaver on 2020-10-27.
//

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

import TerminalFormat

/// An inline image.
///
/// For implementation details, see [Inline Images Protocol][proto] at the iTerm website.
///
/// [proto]: https://www.iterm2.com/documentation-images.html
public struct TerminalImage {

	private let base64: String

	/// Initializes a `TerminalImage` from image data.
	/// - Parameter data: The image data.
	public init(data: Data) {
		base64 = data.base64EncodedString()
	}

	/// Initializes a `TerminalImage` from an image URL.
	/// - Parameter url: The url to the image file.
	/// - Throws: An error in the Cocoa domain, if `url` cannot be read.
	public init(url: URL) throws {
		let data = try Data(contentsOf: url)
		self.init(data: data)
	}

	#if canImport(AppKit)
	/// Initializes a `TerminalImage` from an `NSImage`.
	/// - Parameter image: The source image.
	public init?(image: NSImage) {
		guard image.representations.count != 0 else { return nil }

		let rep = image.representations[0]
		let data: Data

		if let rep = rep as? NSPDFImageRep {
			data = rep.pdfRepresentation
		} else if let rep = rep as? NSBitmapImageRep {
			guard let pngData = rep.representation(using: .png, properties: [:]) else { return nil }
			data = pngData
		} else {
			guard let tiffData = image.tiffRepresentation else { return nil }
			data = tiffData
		}

		self.init(data: data)
	}
	#elseif canImport(UIKit)
	/// Initializes a `TerminalImage` from a `UIImage`.
	/// - Parameter image: The source image.
	/// - Returns: `nil` if the image couldn't be converted.
	public init?(image: UIImage) {
		guard let data = image.pngData() else { return nil }
		self.init(data: data)
	}
	#endif

	public init(base64String: String) {
		base64 = base64String
	}

	/// A TerminalImage dimension.
	public enum Dimension: CustomStringConvertible, ExpressibleByIntegerLiteral {

		/// Dimension measured in terminal cells.
		case cells(Int)

		/// Dimension measured in pixels.
		case pixels(Int)

		/// Dimension measured in percent of the terminal window bounds.
		case percent(Int)

		public var description: String {
			switch (self) {
				case let .cells(value):
					return String(value)
				case let .pixels(value):
					return "\(value)px"
				case let .percent(value):
					return "\(value)%"
			}
		}

		public init(integerLiteral: Int) {
			self = .cells(integerLiteral)
		}

	}

	/// The terminal-escaped string representation of this image, ready to be printed.
	///
	/// - Parameters:
	///   - name: An optional image name.
	///   - width: An optional width.
	///   - height: An optional height.
	///   - preserveAspectRatio: Whether to preserve the image's aspect ratio when resizing.
	///
	/// - Returns: A new string representing the image in iTerm protocol format.
	///
	/// - Note:  The protocol's `inline` attribute is always enabled.
	public func iTermEscaped(name: String? = nil, width: Dimension? = nil, height: Dimension? = nil, preserveAspectRatio: Bool = true) -> String {
		var options = ["inline": "1"]

		if let name = name {
			options["name"] = name
		}
		if let width = width {
			options["width"] = String(describing: width)
		}
		if let height = height {
			options["height"] = String(describing: height)
		}
		if !preserveAspectRatio {
			options["preserveAspectRatio"] = "0"
		}

		let optionsString = options.map { "\($0.key)=\($0.value)" }.joined(separator: ";")

		return "\(.osc)1337;File=\(optionsString):\(base64)\(.bell)"
	}

}

public extension DefaultStringInterpolation {

	mutating func appendInterpolation(_ image: TerminalImage, name: String? = nil, width: TerminalImage.Dimension? = nil, height: TerminalImage.Dimension? = nil, preserveAspectRatio: Bool = true) {
		self.appendLiteral(image.iTermEscaped(name: name, width: width, height: height, preserveAspectRatio: preserveAspectRatio))
	}

	mutating func appendInterpolation(_ image: TerminalImage) {
		self.appendInterpolation(image, height: 1)
	}

}
