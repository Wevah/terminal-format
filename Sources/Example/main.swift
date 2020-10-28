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

	@Flag(name: .customLong("iterm-image"))
	var iTermImage: Bool = false

	@Flag
	var complex: Bool = false

	static let testImage = "R0lGODlhGAAYAPcAMf///wEBAQUCAAYCAQYFAwYGBQkGBAsIBQwJBg8IBQ8LBw8PDw8TBhALBxAMCBEKBREMCBERERINCBIPCxQOBxUIAhUJBBUUExUZDBYVFBcHABcRChcUERgQCxgRChgSDhgVEhkJBBkTEBkUERoIABoQCBoRCBoaFxoeEhsPCRsTCxsbFxwcGB0UCh0XER4TBx4UBx4VDCAdFiAgHSAkFyEXDSEYDyIZDSMXByMdFyMhICMjICQbEiQfGCQiISQtCCUZCiYaCiYdECYkEicdECcnJygeESgjGSgnJikcDikkGSobBiodCyoqKiozDyo0DysgEisgEyweCSwnDi0gES0hEi0nEi0sLC0tLS4iEy8jEy8kEy8qFTAkEzAwMDA8FTImFDIoGzIoHDItFzIvLzIxMTI+DjMmFDMtFTMxMTNADzQiEzQnEzUvKzUwGjYjEzYoFDYpFDYwFTYxLzY2NjZCEjcpFTcyLzc1MzdDEzksFjkzGDk2Njk3Ojk8ETlFHTlGFTlGHjorFjo0LDpHFjsmEzsnDTssFjs2Gjs2Gzs4NDs4NTtEGTwtFjw5OTxJGDxLGD0tFj04HD09PT1MGT5NGj5OGz8vFz8+Pj8/Pz9FFz9HGj9OGz9PG0BAP0BNHEBQHEErD0ExGEI9P0I9QEI/O0JOJ0JSHkQ4MkRERERNIkUyF0UzFkVAN0VEREVFRUVVIUZGRkZVIkc3G0dEREdXI0g2GUhQI0hYJEosFkpKSkpWL0tLSktbJ0w5HExGT01dKU5dKk5eKlBJUlBfLFBgLFFZLFFhLVI8HFMyF1NcMVNfOFROV1RTXFRkMFVPU1VUXFZlMlZmM1dfMldnM1hnNFhoNFlJSllpNVpqNltrN1xoQVxoQlxsOF1dXV1tOV5dXV5eXl5uOl9eXl9fX19vO2BgYGBwPGFxPWNjY2NzP2ReZ2V1QWZkZ2ZmaWdlaGdnZ2dnamd3Q35+gX9/ggAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACwAAAAAGAAYAEAI/wDVURtILVu2YwizscumjqFDhwPlqVCAQ8UDCDeaxbuSI0cfd9BcQFDQAkcDFZyo4ap3SUO9OFoKTPiwY8aHCQW0xAkg4M0LS4CoXRIl6hCjYs62LVu2a5vTbcIeqTIUStSlTuxO9ZKgQAETO1jojApHjhQdLHaYNFDQARg2UNRkcUGBYgkDNHLk7JGDSFIiOW4wSKFB+ByoctSO4XLmbKCwU86+UWsMq1evTpQ6dcJGCB0cPXqIVEkyDt6wVIoUuWK2zpyRJERAw+HELgZXBRyaZCpRKJcjR8kKmcDUBERXCjE4fetVj8qDehuC1ItQxBGfIhHqAdlQr54HAtIqff+TVY/HAgFZDp3pcaTVICU9wBzKMsACjxDd6oizFswaMWuy9CfLfwgpltgx1lgTTTZmYDNQY8IIA8spnQhTjjDUCHNML87ggouB4hmzySa3LDaQZcdkeKIsp/ihySbTbHbJLLNooYUyy8DTTjrmmJPOO+1wo8oWWtB4lUQKUCBBDRW0QQ8tWEQBBRm6zIOHAxVIQIECKCEJgwcViFDEHM+gkkYZ1zxzRxEjKAADDFxygo4VQ3SFRCmLpCBEGK/EIoYQKShSChIKQDDFGJyU00sgMShwABuseDHJL96A88skXqzCBgIHeGBKOXAx11I9XWhRzwU68OKJDxnUo0UXAdRq80YLnOSBzSn1CGJBPerJcMIKmXjBwgkyyBeABmskIAsl1DxiwAILkGCDFo3Y4gsyyPhiSyRZ2EACtAtUo4Y2nwhTCyy1nILuKeZSI9kp1mSIzbzsQPLFFz984YS++Tqx770AB+zEH08EBAA7"

	func complexExample() {
		print("""

			\(CLIFormat(faint: true, italic: true))// Complex example.
			// Should print "one" in the default colors, "two" in green,
			// "three" in bold green with a red background,
			// "four" in italics (if supported by the terminal)
			// with the default foreground color and a blue background,
			// and finally "five" in the default colors.\(.reset)

			""")
		let green = CLIFormat.green
		let redBackground = CLIFormat(backgroundColor: .red, bold: true)
		let blueBackgroundOnly = CLIFormat(backgroundColor: .blue, italic: true, reset: true)
		print("one \(green)two \(redBackground)three \(blueBackgroundOnly)four\(.reset) five\n")
	}

	func iTermImageExample() {
		print("iTerm image example:")
		let image = CLIImage(base64String: Self.testImage)
		print(image.escapeString(width: .pixels(100)))
	}

	func run() {
		if iTermImage {
			iTermImageExample()
		}

		if complex {
			complexExample()
		}
	}

}

Example.main()
