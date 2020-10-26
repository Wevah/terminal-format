
import Foundation

public struct CLIFormat: Equatable, ExpressibleByArrayLiteral, CustomStringConvertible, CustomDebugStringConvertible {

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

	public enum BlinkStyle: String, Hashable, CustomDebugStringConvertible {

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
	}

	public enum UnderlineStyle: String, Hashable, CustomDebugStringConvertible {

		/// A single, standard underline.
		case single = "4"

		// not widely supported
		case double = "4:2"
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

	}

	public enum Element: Hashable {

		/// Foreground color.
		case color(Color)

		/// Background color.
		case backgroundColor(Color)

		/// Underline color. Not widely supported.
		case underlineColor(Color) // not widely supported

		case bold
		case faint
		case normalIntensity // also not bold or faint
		case italic

		case underline(UnderlineStyle)

		/// Blinking style.
		case blink(BlinkStyle)

		case reverseVideo(Bool)

		case conceal(Bool)

		/// Crossed-out style. Not widely supported.
		///
		/// - iTerm
		case crossOut(Bool)

		case overline // not widely supported

		case superscript // mintty
		case `subscript` // mintty

		/// Reset all styles.
		case reset

		case custom(String)

	}

	var elements: [Element]

	public init<S>(_ sequence: S) where S: Sequence, S.Element == Element {
		self.elements = sequence.uniquing()
	}

	public init(arrayLiteral elements: Element...) {
	  self.init(elements)
	}

	public var description: String {
		guard elements.count > 0 else { return "" }
		return "\u{001B}[\(elements.map { String(describing: $0) }.joined(separator: ";"))m"
	}

	public var debugDescription: String {
		guard elements.count > 0 else { return ".empty" }
		return "[\(elements.map { String(reflecting: $0) }.joined(separator: ", "))]"
	}

}

public extension CLIFormat {

	/// Convenience property for resetting all formatting.
	static let reset: CLIFormat = [.reset]

	/// Convenience property for an empty formatting object.
	///
	/// Can be used to decide whether to add formatting without needing to
	/// duplicate interpolated strings.
	//static let empty: CLIFormat = []

}

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
public extension CLIFormat.Element {

	static let black = Self.color(.black)
	/// A red foreground color.
	static let red = Self.color(.red)
	static let green = Self.color(.green)
	static let yellow = Self.color(.yellow)
	static let blue = Self.color(.blue)
	static let magenta = Self.color(.magenta)
	static let cyan = Self.color(.cyan)
	static let white = Self.color(.white)

	static let gray = Self.color(.gray) // "Bright Black"
	static let brightRed = Self.color(.brightRed)
	static let brightGreen = Self.color(.brightGreen)
	static let brightYellow = Self.color(.brightYellow)
	static let brightBlue = Self.color(.brightBlue)
	static let brightMagenta = Self.color(.brightMagenta)
	static let brightCyan = Self.color(.brightCyan)
	static let brightWhite = Self.color(.brightWhite)

	static func color(index: UInt8) -> CLIFormat.Element {
		return Self.color(CLIFormat.Color(bits8: index))
	}

	static func color(red: UInt8, green: UInt8, blue: UInt8) -> CLIFormat.Element {
		return Self.color(CLIFormat.Color(red: red, green: green, blue: blue))
	}

	static let defaultColor = Self.color(.default)

	static func backgroundColor(index: UInt8) -> CLIFormat.Element {
		return Self.backgroundColor(CLIFormat.Color(bits8: index))
	}

	static func backgroundColor(red: UInt8, green: UInt8, blue: UInt8) -> CLIFormat.Element {
		return Self.backgroundColor(CLIFormat.Color(red: red, green: green, blue: blue))
	}

	static let defaultBackgroundColor = Self.backgroundColor(.default)

	static func underlineColor(index: UInt8) -> CLIFormat.Element {
		return Self.underlineColor(CLIFormat.Color(bits8: index))
	}

	static func underlineColor(red: UInt8, green: UInt8, blue: UInt8) -> CLIFormat.Element {
		return Self.underlineColor(CLIFormat.Color(red: red, green: green, blue: blue))
	}

	static let defaultUnderlineColor = Self.underlineColor(.default)

	static let underline = Self.underline(.single)
	static let doubleUnderline = Self.underline(.double)
	static let curlyUnderline = Self.underline(.curly)

	/// Convenience property for regular blink.
	static let blink = Self.blink(.regular)

	/// Convenience property for rapid blink. Not widely supported.
	static let rapidBlink = Self.blink(.rapid)

}

extension CLIFormat.Element: CustomStringConvertible, CustomDebugStringConvertible {

	public var description: String {
		switch self {
			case let .color(color):
				return color.foregroundDescription
			case let .backgroundColor(color):
				return color.backgroundDescription
			case let .underlineColor(color):
				return color.underlineDescription

			case .reset:
				return "0"
			case .bold:
				return "1"
			case .faint:
				return "2"
			case .italic:
				return "3"
			case let .underline(type):
				return type.rawValue
			case let .blink(type):
				return type.rawValue
			case let .reverseVideo(value):
				return value ? "7" : "27"
			case let .conceal(value):
				return value ? "8" : "28"
			case let .crossOut(value):
				return value ? "9" : "29"
			case .normalIntensity:
				return "22"
			case .overline:
				return "53"
			case .superscript:
				return "73"
			case .subscript:
				return "74"
			case let .custom(value):
				return value
		}
	}

	public var debugDescription: String {
		switch self {
			case let .color(color):
				return "color: \(String(reflecting: color))"
			case let .backgroundColor(color):
				return "bg color: \(String(reflecting: color))"
			case let .underlineColor(color):
				return "underline color: \(String(reflecting: color))"

			case .reset:
				return "reset"
			case .bold:
				return "bold"
			case .faint:
				return "faint"
			case .italic:
				return "italic"
			case let .underline(type):
				return String(reflecting: type)
			case let .blink(type):
				return String(reflecting: type)
			case let .reverseVideo(value):
				return value ? "reverse video" : "no reverse video"
			case let .conceal(value):
				return value ? "conceal" : "no conceal"
			case let .crossOut(value):
				return value ? "cross out" : "no cross out"
			case .normalIntensity:
				return "normal intensity"
			case .overline:
				return "overline"
			case .superscript:
				return "superscript"
			case .subscript:
				return "subscript"
			case let .custom(value):
				return "custom: \(value)"
		}
	}

}

public extension DefaultStringInterpolation {

	/// Append a formatted string.
	/// - Parameters:
	///   - string: The string to format.
	///   - format: The formatting object. If `.empty`, no formatting will be applied.
	mutating func appendInterpolation<T>(_ value: T, format: CLIFormat?) where T: CustomStringConvertible {
		if let format = format {
			self.appendLiteral("\(format)\(value)\(CLIFormat.reset)")
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

extension CommandLine {

	var supportsTrueColor: Bool {
		guard let colorterm = ProcessInfo.processInfo.environment["COLORTERM"] else { return false }
		return colorterm == "truecolor" || colorterm == "24bit"
	}

}
