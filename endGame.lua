
endGame = {}

endGame[1] = "You solved all the problems that you faced, I'm impressed"
endGame[2] = "Did you get what you came here for, are you satisfied?"
endGame[3] = "You seem confused? What's wrong?"
endGame[4] = "There's nothing in here? Well the Ancient Technology is here"
endGame[5] = "You've already seen it, but you were so blind"
endGame[6] = "You expected something glorious behind the door"
endGame[7] = "You're ignorant to youself, for being so blind"
endGame[8] = "Doing the puzzles again won't help you find the Ancient Technology"
endGame[9] = "That's becasuse that was what the Ancient Technology was"
endGame[10] = "The puzzles that weren't solved"
endGame[11] = "But now they're solved"
endGame[12] = "You should be ashamed of yourself"
endGame[13] = "I hope you're happy"
endGame[14] = ""
endGame[15] = "Thank you for playing\nCreated for Ludum Dare 36\n \nGame Dev. and Artist\nEthan Nichols"

endGame.start = false
endGame.screen = 0
endGame.timer = 0

function endGame.load()
	endGameFont = love.graphics.newFont(30)
end

function endGame.update(dt)
	if endGame.start == true then
		endGame.timer = endGame.timer + 1
	end

	print(endGame.timer)

	if endGame.timer >= 250 then
		endGame.screen = endGame.screen + 1
		endGame.timer = 0

		if endGame.screen >= 15 then
			endGame.screen = 15
		end
	end
end

function endGame.draw()

	if endGame[endGame.screen] ~= nil then

		love.graphics.setFont(endGameFont)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

		love.graphics.setColor(255, 255, 255)
		love.graphics.print(endGame[endGame.screen], love.graphics.getWidth() / 2 - endGameFont:getWidth(endGame[endGame.screen]) / 2, love.graphics.getHeight() / 2 - endGameFont:getHeight() / 2)
		love.graphics.reset()
	end
end