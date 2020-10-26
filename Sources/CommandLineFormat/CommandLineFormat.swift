
import Foundation

/// A struct for easy standard ANSI terminal color/formatting codes.
///
/// Example:
///
/// ```
/// let format = CLIFormat(foregroundColor: .brightGreen, backgroundColor: .gray)
/// print("hello".ansiFormatted(format: format))
/// // Prints "hello" in bright green text with a gray background.
/// ```
///
public struct CLIFormat: Equatable {

	public init(foregroundColor: CLIFormat.Color? = nil, backgroundColor: CLIFormat.Color? = nil, underlineColor: CLIFormat.Color? = nil, bold: Bool = false, faint: Bool = false, normalIntensity: Bool = false, italic: Bool? = nil, underline: CLIFormat.UnderlineStyle? = nil, blink: CLIFormat.BlinkStyle? = nil, reverseVideo: Bool? = nil, conceal: Bool? = nil, crossOut: Bool? = nil, overline: Bool? = nil, superscript: Bool = false, subscript: Bool = false, reset: Bool = false) {
		self.foregroundColor = foregroundColor
		self.backgroundColor = backgroundColor
		self.underlineColor = underlineColor
		self.bold = bold
		self.faint = faint
		self.normalIntensity = normalIntensity
		self.italic = italic
		self.underline = underline
		self.blink = blink
		self.reverseVideo = reverseVideo
		self.conceal = conceal
		self.crossOut = crossOut
		self.overline = overline
		self.superscript = superscript
		self.subscript = `subscript`
		self.reset = reset
	}

	/// A terminal color.
	public struct Color: Hashable, CustomDebugStringConvertible {

		private enum ColorType: Hashable {
			/// One of the original 16 colors.
			///
			/// The exact values displayed are implementation-defined and can often be customized
			/// in the user's terminal application.
			case bits4(UInt8)

			/// 256-color table.
			///
			/// The first 16 entries map to the `.bits4` colors.

			case bits8(UInt8)

			/// 24-bit color, where red, green, and blue are from 0-255
			///
			/// Not supported by Terminal.app, but supported by iTerm.
			case bits24(red: UInt8, green: UInt8, blue: UInt8)

			case `default`
		}

		private let type: ColorType

		private init?(bits4 value: UInt8) {
			guard (30...37).contains(value) || (90...97).contains(value) else { return nil }
			type = .bits4(value)
		}

		public init(bits8 value: UInt8) {
			type = .bits8(value)
		}

		public init(red: UInt8, green: UInt8, blue: UInt8) {
			type = .bits24(red: red, green: green, blue: blue)
		}

		private init() {
			type = .default
		}

		public static let black = Self(bits4: 30)!
		public static let red = Self(bits4: 31)!
		public static let green = Self(bits4: 32)!
		public static let yellow = Self(bits4: 33)!
		public static let blue = Self(bits4: 34)!
		public static let magenta = Self(bits4: 35)!
		public static let cyan = Self(bits4: 36)!
		public static let white = Self(bits4: 37)!

		public static let gray = Self(bits4: 90)! // "Bright Black"
		public static let brightRed = Self(bits4: 91)!
		public static let brightGreen = Self(bits4: 92)!
		public static let brightYellow = Self(bits4: 93)!
		public static let brightBlue = Self(bits4: 94)!
		public static let brightMagenta = Self(bits4: 95)!
		public static let brightCyan = Self(bits4: 96)!
		public static let brightWhite = Self(bits4: 97)!

		public static let `default` = Color()

		public var debugDescription: String {
			switch type {
				case let .bits4(value):
					switch value {
						case 30...37:
							return ["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"][Int(value) - 30]
						case 90...97:
							return ["gray", "bright red", "bright green", "bright yellow", "bright blue", "bright magenta", "bright cyan", "bright white"][Int(value) - 90]
						default:
							return "invalid"
					}
				case let .bits8(value):
					return "8-bit color (index \(value))"
				case let .bits24(red: red, green: green, blue: blue):
					return "24-bit color (red: \(red), green: \(green), blue: \(blue))"
				case .default:
					return "default"
			}
		}

	}

	public enum BlinkStyle: String, Hashable, CustomDebugStringConvertible, ExpressibleByBooleanLiteral {

		case regular = "4"
		case rapid = "5" // not widely supported

		case none = "25"

		public var debugDescription: String {
			switch self {
				case .regular:
					return "blink"
				case .rapid:
					return "rapid blink"
				case .none:
					return "no blink"
			}
		}

		public init(booleanLiteral value: Bool) {
			self = value ? .regular : .none
		}

	}

	public enum UnderlineStyle: String, Hashable, CustomDebugStringConvertible, ExpressibleByBooleanLiteral {

		/// A single, standard underline.
		case single = "4"

		// not widely supported
		case double = "21" //"4:2"
		case curly = "4:3" // iTerm 3.4+
		case dotted = "4:4"
		case dashed = "4:5"

		case none = "24"

		public var debugDescription: String {
			let typeString: String

			switch self {
				case .single:
					typeString = "single"
				case .double:
					typeString = "double"
				case .curly:
					typeString = "curly"
				case .dotted:
					typeString = "dotted"
				case .dashed:
					typeString = "dashed"
				case .none:
					typeString = "no"
			}

			return "underline: \(typeString)"
		}

		public init(booleanLiteral value: Bool) {
			self = value ? .single : .none
		}

	}

	public var foregroundColor: Color?
	public var backgroundColor: Color?
	public var underlineColor: Color?

	public var bold: Bool = false
	public var faint: Bool = false
	public var normalIntensity: Bool = false // also not bold or faint
	public var italic: Bool?

	public var underline: UnderlineStyle?

	public var blink: BlinkStyle?

	public var reverseVideo: Bool?

	public var conceal: Bool?

	public var crossOut: Bool?

	public var overline: Bool?

	public var superscript: Bool = false
	public var `subscript`: Bool = false

	public var reset: Bool = false

}

public extension CLIFormat {

	/// Convenience property for resetting all formatting.
	static let reset: CLIFormat = CLIFormat(reset: true)
 //[.reset]

	/// Convenience property for an empty formatting object.
	///
	/// Can be used to decide whether to add formatting without needing to
	/// duplicate interpolated strings.
	//static let empty: CLIFormat = []

}

extension CLIFormat: CustomStringConvertible {

	public var description: String {
		var elements = [String]()

		// Make sure reset is always first.
		if reset {
			elements.append("0")
		}

		if let foregroundColor = foregroundColor {
			elements.append(foregroundColor.foregroundDescription)
		}

		if let backgroundColor = backgroundColor {
			elements.append(backgroundColor.backgroundDescription)
		}

		if let underlineColor = underlineColor {
			elements.append(underlineColor.underlineDescription)
		}

		if bold {
			elements.append("1")
		}

		if faint {
			elements.append("2")
		}

		if let italic = italic {
			elements.append(italic ? "3" : "23")
		}

		if let underline = underline {
			elements.append(underline.rawValue)
		}

		if let blink = blink {
			elements.append(blink.rawValue)
		}

		if let reverseVideo = reverseVideo {
			elements.append(reverseVideo ? "7" : "27")
		}

		if let conceal = conceal {
			elements.append(conceal ? "8" : "28")
		}

		if let crossOut = crossOut {
			elements.append(crossOut ? "9" : "29")
		}

		if normalIntensity {
			elements.append("22")
		}

		if let overline = overline {
			elements.append(overline ? "53" : "55")
		}

		if superscript {
			elements.append("73")
		}

		if `subscript` {
			elements.append("74")
		}

		return "\u{001B}[\(elements.joined(separator: ";"))m"
	}

	public var debugDescription: String {
		var elements = [String]()

		// Make sure reset is always first.
		if reset {
			elements.append("reset all")
		}

		if let foregroundColor = foregroundColor {
			elements.append("color: \(String(reflecting: foregroundColor))")
		}

		if let backgroundColor = backgroundColor {
			elements.append("color: \(String(reflecting: backgroundColor))")
		}

		if let underlineColor = underlineColor {
			elements.append("color: \(String(reflecting: underlineColor))")
		}

		if bold {
			elements.append("bold")
		}

		if faint {
			elements.append("faint")
		}

		if let italic = italic {
			elements.append(italic ? "italic" : "no italic")
		}

		if let underline = underline {
			elements.append(String(reflecting: underline))
		}

		if let blink = blink {
			elements.append(String(reflecting: blink))
		}

		if let reverseVideo = reverseVideo {
			elements.append(reverseVideo ? "reverse video" : "no reverse video")
		}

		if let conceal = conceal {
			elements.append(conceal ? "conceal" : "no conceal")
		}

		if let crossOut = crossOut {
			elements.append(crossOut ? "cross out" : "no cross out")
		}

		if normalIntensity {
			elements.append("normal intensity")
		}

		if let overline = overline {
			elements.append(overline ? "overline" : "no overline")
		}

		if superscript {
			elements.append("superscript")
		}

		if `subscript` {
			elements.append("subscript")
		}

		return "CLIFormat: [\(elements.joined(separator: ", "))]"
	}

}

public typealias CLIColor = CLIFormat.Color

private extension CLIFormat.Color {

	private func bits4ToBits8() -> UInt8 {
		guard case let .bits4(value) = type else { fatalError() }
		return value < 40 ? value - 30 : value - 82
	}

	var foregroundDescription: String {
		switch type {
			case let .bits4(value):
				return "\(value)"
			case let .bits8(value):
				return "38;5;\(value)"
			case let .bits24(red, green, blue):
				return "38;2;\(red);\(green);\(blue)"
			case .default:
				return "39"
		}
	}

	var backgroundDescription: String {
		switch type {
			case let .bits4(value):
				return "\(value + 10)"
			case let .bits8(value):
				return "48;5;\(value)"
			case let .bits24(red, green, blue):
				return "48;2;\(red);\(green);\(blue)"
			case .default:
				return "49"
		}
	}

	var underlineDescription: String {
		switch type {
			case .bits4:
				// Underline color can't actually be a 4-bit color;
				// convert to the 8-bit lookup key
				return "58;5;\(self.bits4ToBits8())"
			case let .bits8(value):
				return "58;5;\(value)"
			case let .bits24(red, green, blue):
				return "58;2;\(red);\(green);\(blue)"
			case .default:
				return "59"
		}
	}

}

/// Convenience properties.
public extension CLIFormat {

	static let black = Self(foregroundColor: .black)
	static let red = Self(foregroundColor: .red)
	static let green = Self(foregroundColor: .green)
	static let yellow = Self(foregroundColor: .yellow)
	static let blue = Self(foregroundColor: .blue)
	static let magenta = Self(foregroundColor: .magenta)
	static let cyan = Self(foregroundColor: .cyan)
	static let white = Self(foregroundColor: .white)

	static let gray = Self(foregroundColor: .gray) // "Bright Black"
	static let brightRed = Self(foregroundColor: .brightRed)
	static let brightGreen = Self(foregroundColor: .brightGreen)
	static let brightYellow = Self(foregroundColor: .brightYellow)
	static let brightBlue = Self(foregroundColor: .brightBlue)
	static let brightMagenta = Self(foregroundColor: .brightMagenta)
	static let brightCyan = Self(foregroundColor: .brightCyan)
	static let brightWhite = Self(foregroundColor: .brightWhite)

	static func foregroundColor(index: UInt8) -> CLIFormat {
		return Self(foregroundColor: Color(bits8: index))
	}

	static func foregroundColor(red: UInt8, green: UInt8, blue: UInt8) -> CLIFormat {
		return Self(foregroundColor: Color(red: red, green: green, blue: blue))
	}

	static let defaultForegroundColor = Self(foregroundColor: .default)

	static func backgroundColor(index: UInt8) -> CLIFormat {
		return Self(backgroundColor: Color(bits8: index))
	}

	static func backgroundColor(red: UInt8, green: UInt8, blue: UInt8) -> CLIFormat {
		return Self(backgroundColor: Color(red: red, green: green, blue: blue))
	}

	static let defaultBackgroundColor = Self(backgroundColor :.default)

	static func underlineColor(index: UInt8) -> CLIFormat {
		return Self(underlineColor: Color(bits8: index))
	}

	static func underlineColor(red: UInt8, green: UInt8, blue: UInt8) -> CLIFormat {
		return Self(underlineColor: Color(red: red, green: green, blue: blue))
	}

	static let defaultUnderlineColor = Self(underlineColor: .default)

	static let underline = Self(underline: .single)
	static let doubleUnderline = Self(underline:.double)
	static let curlyUnderline = Self(underline: .curly)

	/// Convenience property for regular blink.
	static let blink = Self(blink: true)

	/// Convenience property for rapid blink. Not widely supported.
	static let rapidBlink = Self(blink: .rapid)

}

public extension DefaultStringInterpolation {

	/// Append a formatted string.
	/// - Parameters:
	///   - string: The string to format.
	///   - format: The formatting object. If `nil`, no formatting will be applied.
	mutating func appendInterpolation<T>(_ value: T, format: CLIFormat?) where T: CustomStringConvertible {
		if let format = format {
			self.appendLiteral("\(format)\(value)\(.reset)")
		} else {
			self.appendInterpolation(value)
		}
	}

	/// Append formatting escapes.
	/// - Parameters:
	///   - format: The formatting object.
	mutating func appendInterpolation(_ format: CLIFormat?) {
		guard let format = format else { return }
		self.appendLiteral(String(describing: format))
	}

}

public extension StringProtocol {

	func ansiFormatted(format: CLIFormat) -> String {
		return "\(self, format: format)"
	}

}
