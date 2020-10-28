# CommandLineFormat
version 0.1.0

Simple terminal string formatting, with custom interpolation.

API is still in flux!

## Examples

Simple single-string formatting:

```swift
let format = CLIFormat(foregroundColor: .brightGreen, backgroundColor: .gray)
print("hello".ansiFormatted(format: format))
// Prints "hello" in bright green text with a gray background.
```

Explicit :

```swift
let green = CLIFormat.green
let redBackground = CLIFormat(backgroundColor: .red)
let blueBackgroundOnly = CLIFormat(backgroundColor: .blue, reset: true)
print("one \(green)two \(redBackground)three \(blueBackgroundOnly)four \(.reset) five")
// Prints "one" in the default colors, "two" in green,
// "three" in green with a red background,
// "four" in the default foreground color with a blue background,
// and finally "five" in the default colors.
```
