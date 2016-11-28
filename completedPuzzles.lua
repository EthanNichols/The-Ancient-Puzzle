
completedPuzzles = {}

completedPuzzles.doorX = 0
completedPuzzles.doorRotate = 0

function completedPuzzles.load()

	indicator = love.graphics.newImage("images/indicator.png")
	completed = love.graphics.newImage("images/completed.png")

	door = love.graphics.newImage("images/door.png")
	doorFrame = love.graphics.newImage("images/doorFrame.png")

	local indicators = 5
	local indicatorsCreated = 0

	local gridX = 1
	local gridY = 1

	local puzzleName = "sliding"

	repeat

		if indicatorsCreated == 1 then
			puzzleName = "liquid"
		elseif indicatorsCreated == 2 then
			puzzleName = "nileRiver"
		elseif indicatorsCreated == 3 then
			puzzleName = "symbols"
		elseif indicatorsCreated == 4 then
			puzzleName = "boxStack"
		end

		table.insert(completedPuzzles,
					{puzzleName = puzzleName,
					gridX = gridX,
					gridY = gridY,
					completed = false})

		gridY = gridY + 1
		indicatorsCreated = indicatorsCreated + 1
	until indicatorsCreated == indicators
end

function completedPuzzles.update(dt)
	for i, v in ipairs(completedPuzzles) do
		if colorMovement.completed == true and
		v.puzzleName == "boxStack" then
			v.completed = true
		elseif liquidPuzzle.completed == true and
		v.puzzleName == "liquid" then
			v.completed = true
		elseif nileGlyph.completed == true and
		v.puzzleName == "nileRiver" then
			v.completed = true
		elseif slidingPuzzle.completed == true and
		v.puzzleName == "sliding" then
			v.completed = true
		elseif symbols.completed == true and
		v.puzzleName == "symbols" then
			v.completed = true
		end
	end

	local amountCompleted = 0

	for i, v in ipairs(completedPuzzles) do
		if v.completed == true then
			amountCompleted = amountCompleted + 1
		end
	end

	if amountCompleted == 5 and
	completedPuzzles.doorX <= door:getWidth() + 10 then
		completedPuzzles.doorX = math.floor(completedPuzzles.doorX + 1.15)
		completedPuzzles.doorRotate = completedPuzzles.doorRotate + .01	
	end

	if completedPuzzles.doorX == math.floor(door:getWidth() + 10) then
		endGame.start = true
	end
end

function completedPuzzles.draw()
	for i, v in ipairs(completedPuzzles) do
		love.graphics.draw(indicator, (v.gridX + 20) * 50, (v.gridY + 11) * 50)
		
		if v.completed == true then
			love.graphics.draw(completed, (v.gridX + 20) * 50, (v.gridY + 11) * 50)
		end
	end

	love.graphics.push()
		love.graphics.translate(13 * 50, 12 * 50)
		love.graphics.draw(doorFrame, 0, 0)
		love.graphics.draw(door, completedPuzzles.doorX + door:getWidth() / 2, 0 + door:getHeight() / 2, completedPuzzles.doorRotate, 1, 1, door:getWidth() / 2, door:getHeight() / 2)
	love.graphics.pop()
end