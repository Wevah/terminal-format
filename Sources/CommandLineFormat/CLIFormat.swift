//
//  CommandLine.swift
//
//
//  Created by Nate Weaver on 2020-10-26.
//

import Foundation

/// An enum for standard ANSI terminal color/formatting codes.
///
/// Examples (assuming output is to an ANSI-compatible terminal):
///
/// String method:
/// ```
/// let attributes: [CLIAttribute] = [.brightGreen, .background(.gray)]
/// print("hello".ansiFormatted(attributes: attributes))
/// // Prints "hello" in bright green text with a gray background.
/// ```
///
/// Inline interpolation:
/// ```
/// print("This is \("red", attributes: [.red])")
/// // Prints "red" in red.
/// ```
///
/// Complex interpolation, verbose:
/// ```
///	let green = [CLIAttribute.green]
///	let redBackground: [CLIAttribute] = [.backgroundColor(.red)]
///	let blueBackgroundOnly: [CLIAttribute] = [.reset, .backgroundColor: .blue]
///	print("one \(green)two \(redBackground)three \(blueBackgroundOnly)four\(.reset) five")
///	// Prints "one" in the default colors, "two" in green,
///	// "three" in green with a red background,
///	// "four" in the default foreground color with a blue background,
///	// and finally "five" in the default colors.
/// ```
public enum CLIAttribute: Hashable {

	/// A terminal color.
	public struct Color: Hashable {

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

		private init(bits4 value: UInt8) {
			precondition((30...37).contains(value) || (90...97).contains(value))
			type = .bits4(value)
		}

		/// Initialize an ANSI 8-bit color.
		///
		/// - Parameter index: The index into the 8-bit color table.
		public init(bits8 index: UInt8) {
			type = .bits8(index)
		}

		/// Initialize a 24-bit color.
		///
		/// Not supported by Terminal.app, but supported by iTerm.
		///
		/// - Parameters:
		///   - red: The red component, from 0-255.
		///   - green: The green component, from 0-255.
		///   - blue: The blue component, from 0-255.
		public init(red: UInt8, green: UInt8, blue: UInt8) {
			type = .bits24(red: red, green: green, blue: blue)
		}

		/// Initialize a color to the default.
		private init() {
			type = .default
		}

		// Note that the following are generally user-customizable!

		/// The standard black color.
		public static let black = Self(bits4: 30)
		/// The standard red color.
		public static let red = Self(bits4: 31)
		/// The standard green color.
		public static let green = Self(bits4: 32)
		/// The standard yellow color.
		public static let yellow = Self(bits4: 33)
		/// The standard blue color.
		public static let blue = Self(bits4: 34)
		/// The standard magenta color.
		public static let magenta = Self(bits4: 35)
		/// The standard cyan color.
		public static let cyan = Self(bits4: 36)
		/// The standard white color.
		public static let white = Self(bits4: 37)

		/// The standard gray ("bright black") color
		public static let gray = Self(bits4: 90)
		/// The standard bright red color.
		public static let brightRed = Self(bits4: 91)
		/// The standard bright green color.
		public static let brightGreen = Self(bits4: 92)
		/// The standard bright yellow color.
		public static let brightYellow = Self(bits4: 93)
		/// The standard bright blue color.
		public static let brightBlue = Self(bits4: 94)
		/// The standard bright magenta color.
		public static let brightMagenta = Self(bits4: 95)
		/// The standard bright cyan color.
		public static let brightCyan = Self(bits4: 96)
		/// The standard bright white color.
		public static let brightWhite = Self(bits4: 97)

		/// The default text/background/underline color.
		public static let `default` = Color()

	}

	public enum BlinkStyle: String, CustomDebugStringConvertible, ExpressibleByBooleanLiteral {

		/// Regular blink frequency.
		case regular = "5"

		/// Rapid blink frequency.
		///
		/// Not widely supported.
		case rapid = "6"

		/// Disable blink.
		case off = "25"

		public var debugDescription: String {
			switch self {
				case .regular:
					return "blink"
				case .rapid:
					return "rapid blink"
				case .off:
					return "blink off"
			}
		}

		public init(booleanLiteral value: Bool) {
			self = value ? .regular : .off
		}

	}

	public enum UnderlineStyle: String, CustomDebugStringConvertible, ExpressibleByBooleanLiteral {

		/// A single, standard underline.
		case single = "4"

		/// A double underline.
		///
		/// Not widely supported.
		///
		/// - Note: The ECMA-48 standard specifies `21` for double underline, but that will cause
		/// iTerm to render no underline at all.
		///
		/// Will cause text to render in the wrong color in Terminal.app.
		case double = "4:2" // "21" / "4:2"

		/// Curly underline.
		///
		/// Supported by iTerm 3.4+ and kitty.
		///
		/// - Note: Will cause text to render in the wrong color in Terminal.app.
		case curly = "4:3" // iTerm 3.4+

		/// Dotted underline.
		///
		/// Not widely supported.
		case dotted = "4:4"

		/// Dashed underline.
		///
		/// Not widely supported.
		case dashed = "4:5"

		/// No underline.
		case off = "24"

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
				case .off:
					typeString = "off"
			}

			return "underline: \(typeString)"
		}

		public init(booleanLiteral value: Bool) {
			self = value ? .single : .off
		}

	}

	/// The foreground color.
	case foregroundColor(Color)

	/// The background color.
	case backgroundColor(Color)

	/// The underline color.
	///
	/// Not widely supported.
	case underlineColor(Color)

	/// Enable bold text.
	///
	/// To disable, use `normalIntensity`.
	case bold

	/// Enable faint text.
	///
	/// To disable, use `normalIntensity`.
	case faint

	/// Normal intensity; disable `bold` and `faint`.
	case normalIntensity

	/// Italic text.
	case italic(Bool)

	/// Text underline style.
	case underline(UnderlineStyle)

	/// Text blink style.
	case blink(BlinkStyle)

	/// Whether to reverse foreground and background colors.
	case reverseVideo(Bool)

	/// Whether to conceal text.
	case conceal(Bool)

	/// Cross out text.
	case crossOut(Bool)

	/// Overline text.
	///
	/// Not widely supported.
	case overline(Bool)

	/// Superscript.
	///
	/// mintty; not in standard.
	case superscript

	/// Subscript.
	///
	/// mintty; not in standard.
	case `subscript`

	/// Reset all formatting.
	case reset

	/// Custom attribute sequence.
	///
	/// Perhaps your terminal supports attributes not supplied here?
	///
	/// For example, for some imaginary CSI sequence whose code is `321`:
	///
	/// ```
	/// let customAttributes: [CLIAttribute] = [.custom("321")]
	/// ```
	case custom(String)

}

public struct CLIControlSequence {

	fileprivate let string: String

	fileprivate init(_ string: String) {
		self.string = string
	}

	/// The escape character (`ESC`, `0x1b`).
	public static let escape = Self("\u{001B}")

	/// The bell character (`BEL`, `0x07`).
	public static let bell = Self("\u{0007}")

	/// Control Sequence Introducer, `ESC` + `[`.
	public static let csi = Self("\(escape)[")

	/// Operating System Command, `ESC` + `]`.
	public static let osc = Self("\(escape)]")

}

public extension DefaultStringInterpolation {

	mutating func appendInterpolation(_ controlSequence: CLIControlSequence) {
		self.appendLiteral(controlSequence.string)
	}

}

// Convenience properties.
public extension CLIAttribute {

	/// Convenience for a black foreground color.
	static let black = Self.foregroundColor(.black)
	/// Convenience for the a red foreground color
	static let red = Self.foregroundColor(.red)
	/// Convenience for the a green foreground color
	static let green = Self.foregroundColor(.green)
	/// Convenience for the a yellow foreground color
	static let yellow = Self.foregroundColor(.yellow)
	/// Convenience for the a blue foreground color
	static let blue = Self.foregroundColor(.blue)
	/// Convenience for the a magenta foreground color
	static let magenta = Self.foregroundColor(.magenta)
	/// Convenience for the a cyan foreground color
	static let cyan = Self.foregroundColor(.cyan)
	/// Convenience for the a white foreground color
	static let white = Self.foregroundColor(.white)

	/// Convenience for the standard gray ("bright black") color
	static let gray = Self.foregroundColor(.gray)
	/// Convenience for the a bright red foreground color
	static let brightRed = Self.foregroundColor(.brightRed)
	/// Convenience for the a bright green foreground color
	static let brightGreen = Self.foregroundColor(.brightGreen)
	/// Convenience for the a bright yellow foreground color
	static let brightYellow = Self.foregroundColor(.brightYellow)
	/// Convenience for the a bright blue foreground color
	static let brightBlue = Self.foregroundColor(.brightBlue)
	/// Convenience for the a bright magenta foreground color
	static let brightMagenta = Self.foregroundColor(.brightMagenta)
	/// Convenience for the a bright cyan foreground color
	static let brightCyan = Self.foregroundColor(.brightCyan)
	/// Convenience for the a bright white foreground color
	static let brightWhite = Self.foregroundColor(.brightWhite)

	/// Convenience for the default foreground color.
	static let defaultForegroundColor = Self.foregroundColor(.default)

	/// Convenience for enabling italics.
	static let italic = Self.italic(true)

	/// Convenience for single underline.
	static let underline = Self.underline(.single)

	/// Convenience for regular blink.
	static let blink = Self.blink(.regular)

	static func color(_ color: Color) -> Self {
		return .foregroundColor(color)
	}

	static func background(_ color: Color) -> Self {
		return .backgroundColor(color)
	}
	
}

public extension CLIAttribute {

	var escapeCode: String {
		switch self {
			case .reset:
				return "0"

			case let .foregroundColor(color):
				return color.foregroundDescription
			case let .backgroundColor(color):
				return color.backgroundDescription
			case let .underlineColor(color):
				return color.underlineDescription
			case .bold:
				return "1"
			case .faint:
				return "2"
			case let .italic(value):
				return value ? "3" : "23"
			case let .underline(style):
				return style.rawValue
			case let .blink(style):
				return style.rawValue
			case let .reverseVideo(value):
				return value ? "7" : "27"
			case let .conceal(value):
				return value ? "8" : "28"
			case let .crossOut(value):
				return value ? "9" : "29"
			case .normalIntensity:
				return "22"
			case let .overline(value):
				return value ? "53" : "55"
			case .superscript:
				return "73"
			case .subscript:
				return "74"

			case let .custom(value):
				return value
		}
	}

}

extension CLIAttribute: CustomDebugStringConvertible {

	public var debugDescription: String {
		switch self {
			case .reset:
				return "reset"

			case let .foregroundColor(color):
				return "foreground color: \(String(reflecting: color))"
			case let .backgroundColor(color):
				return "background color: \(String(reflecting: color))"
			case let .underlineColor(color):
				return "underline color: \(String(reflecting: color))"
			case .bold:
				return "bold"
			case .faint:
				return "faint"
			case let .italic(value):
				return value ? "italic" : "italic off"
			case let .underline(style):
				return "underline: \(String(reflecting: style))"
			case let .blink(style):
				return "blink: \(String(reflecting: style))"
			case let .reverseVideo(value):
				return value ? "reversed video" : "reversed video off"
			case let .conceal(value):
				return value ? "conceal" : "conceal off"
			case let .crossOut(value):
				return value ? "cross out" : "cross out off"
			case .normalIntensity:
				return "normal intensity"
			case let .overline(value):
				return value ? "overline" : "overline off"
			case .superscript:
				return "superscript"
			case .subscript:
				return "subscript"

			case let .custom(value):
				return "custom: \(value)"
		}
	}

}

extension Array: TerminalPrintable where Element == CLIAttribute {

	public var escapeSequence: String {
		return "\(CLIControlSequence.csi)\(self.map { $0.escapeCode }.joined(separator: ";"))m"

	}
}

public typealias CLIColor = CLIAttribute.Color

private extension CLIColor {

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

extension CLIColor: CustomDebugStringConvertible {

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

///// Convenience properties.
public extension Array where Element == CLIAttribute {
//
	static let reset: [CLIAttribute] = [.reset]
//
//	static let black: Self = [.foregroundColor(.black)]
//	static let red: Self = [.foregroundColor(.red)]
//	static let green: Self = [.foregroundColor(.green)]
//	static let yellow: Self = [.foregroundColor(.yellow)]
//	static let blue: Self = [.foregroundColor(.blue)]
//	static let magenta: Self = [.foregroundColor(.magenta)]
//	static let cyan: Self = [.foregroundColor(.cyan)]
//	static let white: Self = [.foregroundColor(.white)]
//
//	static let gray: Self = [.foregroundColor(.gray)] // "Bright Black"
//	static let brightRed: Self = [.foregroundColor(.brightRed)]
//	static let brightGreen: Self = [.foregroundColor(.brightGreen)]
//	static let brightYellow: Self = [.foregroundColor(.brightYellow)]
//	static let brightBlue: Self = [.foregroundColor(.brightBlue)]
//	static let brightMagenta: Self = [.foregroundColor(.brightMagenta)]
//	static let brightCyan: Self = [.foregroundColor(.brightCyan)]
//	static let brightWhite: Self = [.foregroundColor(.brightWhite)]
//
//	static func foregroundColor(index: UInt8) -> [CLIAttribute] {
//		return [.foregroundColor(CLIColor(bits8: index))]
//	}
//
//	static func foregroundColor(red: UInt8, green: UInt8, blue: UInt8) -> [CLIAttribute] {
//		return [.foregroundColor(CLIColor(red: red, green: green, blue: blue))]
//	}
//
//	static let defaultForegroundColor: Self = [.foregroundColor(.default)]
//
//	static func backgroundColor(index: UInt8) -> [CLIAttribute] {
//		return [.backgroundColor(CLIColor(bits8: index))]
//	}
//
//	static func backgroundColor(red: UInt8, green: UInt8, blue: UInt8) -> [CLIAttribute] {
//		return [.backgroundColor(CLIColor(red: red, green: green, blue: blue))]
//	}
//
//	static let defaultBackgroundColor: Self = [.backgroundColor(.default)]
//
//	static func underlineColor(index: UInt8) -> [CLIAttribute] {
//		return [.underlineColor(CLIColor(bits8: index))]
//	}
//
//	static func underlineColor(red: UInt8, green: UInt8, blue: UInt8) -> [CLIAttribute] {
//		return [.underlineColor(CLIColor(red: red, green: green, blue: blue))]
//	}
//
//	static let defaultUnderlineColor: Self = [.underlineColor(.default)]
//
//	static let bold: Self = [.bold]
//	static let faint: Self = [.faint]
//	static let italic: Self = [.italic(true)]
//
//	static let underline: Self = [.underline(.single)]
//	static let doubleUnderline: Self = [.underline(.double)]
//	static let curlyUnderline: Self = [.underline(.curly)]
//
//	/// Convenience property for regular blink.
//	static let blink: Self = [.blink(.regular)]
//
//	/// Convenience property for rapid blink. Not widely supported.
//	static let rapidBlink: Self = [.blink(.rapid)]
//
}

public extension DefaultStringInterpolation {

	/// Append a formatted string.
	///
	/// - Parameters:
	///   - string: The string to format.
	///   - attributes: The attributes to apply. If `nil`, no attributes will be applied.
	mutating func appendInterpolation<T>(_ value: T, attributes: [CLIAttribute]?) {
		if let attributes = attributes, attributes.count != 0 {
			self.appendInterpolation(attributes)
			self.appendInterpolation(value)
			self.appendInterpolation([.reset])
		} else {
			self.appendInterpolation(value)
		}
	}

	/// Append formatting escapes.
	///
	/// - Parameters:
	///   - attributes: The attributes to apply.
	mutating func appendInterpolation(_ attributes: [CLIAttribute]) {
		guard attributes.count != 0 else { return }
		self.appendLiteral(attributes.escapeSequence)
	}

	/// Append formatting escapes.
	///
	/// - Parameters:
	///   - attributes: The attributes to apply. If `nil`, no attributes are set.
	mutating func appendInterpolation(_ attributes: [CLIAttribute]?) {
		guard let attributes = attributes else { return }
		self.appendInterpolation(attributes)
	}

}
//
//public extension StringProtocol {
//
//	/// Formats a string with ANSI escape codes and a reset at the end.
//	/// - Parameter format: The format to use.
//	/// - Returns: A new string with escape sequence described by `format` prepended,
//	/// and the `.reset` escape sequence appended.
//	func ansiFormatted(attributes: [CLIAttribute]) -> String {
//		return "\(self, attributes: attributes)"
//	}
//
//}
