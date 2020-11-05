//
//  KittyImage.swift
//  
//
//  Created by Nate Weaver on 2020-10-28.
//

import Foundation
import ArgumentParser
import TerminalImage

struct Image: ParsableCommand {

	static let configuration = CommandConfiguration(commandName: "image", abstract: "Display an example iTerm image.")

	static let testImage = "iVBORw0KGgoAAAANSUhEUgAAAQAAAADAAgMAAACWg1X1AAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAABAKADAAQAAAABAAAAwAAAAABFoyE3AAAACVBMVEUAAAAVX9r+/v5Msjb9AAABe0lEQVRo3u3aTY6DMAyG4W/TjU/XzdzP6/eUs0gCtIuqELAZjSMhVZX6CIXUPwlSjVuMn4lxCvCYAZ6nAM/j0/cooIACCijgGgCZI3PhMvD2pScA5kjWfmhOJGANQOYDYHyIAcCBbEDmwApAJOBMTuI0IEsGKiIVUEAB96oPDES/rCUa8Sm8nw68B1Z6gmdvVP6rwEiuwlFLsJtJjADG7eMC1/E5mAYMYSQBBhqTuCzlXnxdD1REKqCAAm5XH7h6ghlbAAZu3yaWOcBbQjXvzdbot3p4DwAYKT0P6CndeGnAAwFjU9ZYBtDLmrYRlAO8LuUtcOi/sBuoiFRAAQXcqz4QPawfPR6YBsxZWr0WTwkG1ktz+8rHgNH+e2s4E4D++KxvOkh7jwdOAZbFNPEU5gFbbz0WqIhUQAEF3AiAEdrVjwk8Fhjt3nuCjQN4SfEfNqMDAJbDmiQA/6a8ugBYHqNtSj0iAY0lvE6iBwMVkf45kP62cP4b0zXyxy8gPVgeNiGuiAAAAABJRU5ErkJggg=="

	func run() {
		print("Image example:")
		let image = TerminalImage(base64String: Self.testImage)
		print(image.iTermEscaped())
		print("")
		print("inline: \(image)")
	}

}
