
loadGame = {}

loadGame[1] = "Adventurer, you have heard of an Ancient Technology hidden away"
loadGame[2] = "I understand why your curiosity has brought you to this ancient wall"
loadGame[3] = "I know that you want to see what was lost a long time ago"
loadGame[4] = "It is not going to be easy to see what you have been searching for"
loadGame[5] = "What puzzles will you solve?"
loadGame[6] = "What puzzles will you accidentally discover that have no answer"
loadGame[7] = "I am interested in watching you, and seeing if you can reach your goal"
loadGame[8] = "Let's see what you have, and what the Ancients have wanted to hide away"

loadGame.screen = 1
loadGame.timer = 0

function loadGame.load()
	loadGameFont = love.graphics.newFont(30)
end

function loadGame.update(dt)
	loadGame.timer = loadGame.timer + 1

	if loadGame.timer >= 1 then
		loadGame.screen = loadGame.screen + 1
		loadGame.timer = 0
	end
end

function loadGame.draw()

	if loadGame[loadGame.screen] ~= nil then

		love.graphics.setFont(loadGameFont)
		love.graphics.setColor(0, 0, 0)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

		love.graphics.setColor(255, 255, 255)
		love.graphics.print(loadGame[loadGame.screen], love.graphics.getWidth() / 2 - loadGameFont:getWidth(loadGame[loadGame.screen]) / 2, love.graphics.getHeight() / 2 - loadGameFont:getHeight() / 2)
		love.graphics.reset()
	end
end