require "puzzle/slidingPuzzle"
require "puzzle/liquidPuzzle"
require "puzzle/nileGlyph"
require "puzzle/symbols"
require "puzzle/colorMovement"
require "completedPuzzles"
require "loadGame"
require "endGame"

function love.load()

	--Randomization
	math.randomseed(os.time())

	--Load the background image
	background = love.graphics.newImage("images/background.png")

	--Load functions
	slidingPuzzle.load()
	liquidPuzzle.load()
	nileGlyph.load()
	symbols.load()
	colorMovement.load()
	completedPuzzles.load()
	loadGame.load()
	endGame.load()
end

function love.update(dt)

	liquidPuzzle.update(dt)
	nileGlyph.update(dt)
	symbols.update(dt)
	colorMovement.update(dt)
	completedPuzzles.update(dt)
	loadGame.update(dt)
	endGame.update(dt)
end

function love.wheelmoved(x, y)

end

function love.mousepressed(x, y, button)
	slidingPuzzle.mousepressed(x, y, button)
	liquidPuzzle.mousepressed(x, y, button)
	nileGlyph.mousepressed(x, y, button)
	symbols.mousepressed(x, y, button)
	colorMovement.mousepressed(x, y, button)
end

function love.keypressed(button)

end

function love.draw()
	--Draw the background
	love.graphics.draw(background, 0, 0)

	--Draw function
	slidingPuzzle.draw()
	liquidPuzzle.draw()
	nileGlyph.draw()
	symbols.draw()
	colorMovement.draw()
	completedPuzzles.draw()
	loadGame.draw()
	endGame.draw()
end

--C:\Users\Ethan Nichols\AppData\Roaming\LOVE\Testing