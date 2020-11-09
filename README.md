# CommandLineFormat
version 0.1.0

Simple terminal string formatting, with custom interpolation.

API is still in flux!

## Examples

String method:
```swift
let attributes: [TerminalAttribute] = [.brightGreen, .background(.gray)]
print("hello".ansiFormatted(attributes: attributes))
// Prints "hello" in bright green text with a gray background.
```

Inline interpolation:

```swift
print("This is \("red", attributes: [.red])")
// Prints "red" in red.
```

Complex interpolation, verbose:

```swift
let green: [TerminalAttribute] = [.green]
let redBackground: [TerminalAttribute] = [.backgroundColor(.red)]
let blueBackgroundOnly: [TerminalAttribute] = [.reset, .backgroundColor(.blue)]
print("one \(green)two \(redBackground)three \(blueBackgroundOnly)four\(.reset) five")
// Prints "one" in the default colors, "two" in green,
// "three" in green with a red background,
// "four" in the default foreground color with a blue background,
// and finally "five" in the default colors.
```

Currently upports a few esoteric attributes, like squiggly underline (iTerm2/kitty).

Includes an optional target for displaying inline images in iTerm2 (whose API is even more in-flux than the main target's).

---

© 2020 Nate Weaver
