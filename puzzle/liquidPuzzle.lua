
liquidPuzzle = {}

--Tables for all the variables for the liquid
liquidPuzzle.pots = {}
liquidPuzzle.holes = {}
liquidPuzzle.directors = {}
liquidPuzzle.liquidAnim = {}
liquidPuzzle.solution = {}

--The state of the lever, and the timer for the animation
liquidPuzzle.leverState = true
liquidPuzzle.leverTimer = 0

--Informs if the liquid puzzle has been completed
liquidPuzzle.completed = false

function liquidPuzzle.load()

	--Load sprite sheets
	potSheet = love.graphics.newImage("images/potSheet.png")
	liquidHole = love.graphics.newImage("images/liquidHole.png")
	liquidDirector = love.graphics.newImage("images/liquidDirector.png")
	liquidAnimation = love.graphics.newImage("images/liquidAnimation.png")
	leverAnimation = love.graphics.newImage("images/lever.png")
	colorDisplay = love.graphics.newImage("images/colorDisplay.png")

	--Load the pot images
	standingPot = love.graphics.newQuad(0, 0, 50, 50, potSheet:getDimensions())
	invertedPot = love.graphics.newQuad(50, 0, 50, 50, potSheet:getDimensions())

	--Load the liquid director images
	directionRight = love.graphics.newQuad(0, 0, 50, 50, liquidDirector:getDimensions())
	directionLeft = love.graphics.newQuad(50, 0, 50, 50, liquidDirector:getDimensions())
	directionNone = love.graphics.newQuad(100, 0, 50, 50, liquidDirector:getDimensions())

	--Load the liquid animations
	liquidOrigin = love.graphics.newQuad(0, 0, 50, 50, liquidAnimation:getDimensions())
	liquidTurnRight = love.graphics.newQuad(50, 0, 50, 50, liquidAnimation:getDimensions())
	liquidTurnLeft = love.graphics.newQuad(100, 0, 50, 50, liquidAnimation:getDimensions())
	liquidFallRight = love.graphics.newQuad(150, 0, 50, 50, liquidAnimation:getDimensions())
	liquidFallLeft = love.graphics.newQuad(200, 0, 50, 50, liquidAnimation:getDimensions())
	liquidFall = love.graphics.newQuad(250, 0, 50, 50, liquidAnimation:getDimensions())
	liquidInPot = love.graphics.newQuad(300, 0, 50, 50, liquidAnimation:getDimensions())

	--Load the lever animations
	leverUp = love.graphics.newQuad(0, 0, 50, 50, leverAnimation:getDimensions())
	leverDown = love.graphics.newQuad(50, 0, 50, 50, leverAnimation:getDimensions())

	--How many pots have been created, and how many should be created
	local potsCreated = 0
	local potAmount = 5

	repeat
		--Insert information into the pots table
		table.insert(liquidPuzzle.pots,
					{potNum = potsCreated + 1,
					gridX = potsCreated + 1,
					gridY = 1,
					sheet = potSheet,
					img = standingPot,
					r = 255,
					g = 255,
					b = 255})

		--Insert information into the holes table
		table.insert(liquidPuzzle.holes,
					{holeNum = potsCreated + 1,
					gridX = potsCreated + 1,
					gridY = 5,
					r = math.floor(math.random() * 255 + 1),
					g = math.floor(math.random() * 255 + 1),
					b = math.floor(math.random() * 255 + 1),})

		--Insert information into the solutions table
		table.insert(liquidPuzzle.solution,
					{solutionNum = potsCreated + 1,
					solution = false,
					r = 0,
					g = 0,
					b = 0,})

		--Create the next pot/hole/solution
		potsCreated = potsCreated + 1
	until potsCreated == potAmount

	--How many liquid directors have been created and need to be created
	local directorsCreated = 0
	local directorAmount = 6

	repeat
		--Insert information into the directors table
		table.insert(liquidPuzzle.directors,
					{directorNum = directorsCreated + 1,
					gridX = 0,
					gridY = 0,
					direction = math.floor(math.random() * 3 + 1)})

		--Create the next liquid director
		directorsCreated = directorsCreated + 1
	until directorsCreated == directorAmount

		--Create the liquid animation table
		table.insert(liquidPuzzle.liquidAnim,
					{falling = false,
					animTimer = 0,
					animation = 0,
					nextAnimation = 0,
					animations = 0,
					gridX = 0,
					gridY = 0,
					gridX1 = 0,
					gridX2 = 0,
					r = 0,
					g = 0,
					b = 0})

	--Randomize the directions the liquid directors are pointing
	--Create the solutions for the lisuid puzzle
	liquidPuzzle.directions()
	liquidPuzzle.answers()
end

function liquidPuzzle.directions()
	--Get information from the table
	for i, v in ipairs(liquidPuzzle.directors) do

		--Set the image of the liquid director to the random value
		if v.direction == 1 then
			v.direction = directionLeft
		elseif v.direction == 2 then
			v.direction = directionRight
		else
			v.direction = directionNone
		end

		--Set the location fo the liquid director
		if v.directorNum == 1 then
			v.gridX = 1
			v.gridY = 4
		elseif v.directorNum == 2 then
			v.gridX = 3
			v.gridY = 4
		elseif v.directorNum == 3 then
			v.gridX = 5
			v.gridY = 4
		elseif v.directorNum == 4 then
			v.gridX = 2
			v.gridY = 3
		elseif v.directorNum == 5 then
			v.gridX = 4
			v.gridY = 3
		elseif v.directorNum == 6 then
			v.gridX = 3
			v.gridY = 2
		end
	end
end

function liquidPuzzle.mousepressed(x, y, button)

	--Get the screen width and height
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	--Get information from the table
	for i, v in ipairs(liquidPuzzle.directors) do

		--Test if the mouse is clicking on a liquid director
		if x >= width - (v.gridX + 1) * 50 and
		x <= width - (v.gridX + 1) * 50 + 50 and
		y >= height - (v.gridY + 1) * 50 and
		y <= height - (v.gridY + 1) * 50 + 50 then

			--Cycle through the director types
			if v.direction == directionLeft then
				v.direction = directionRight
			elseif v.direction == directionRight then
				v.direction = directionNone
			else
				v.direction = directionLeft
			end
		end
	end

	--Get information from the table
	for i, v in ipairs(liquidPuzzle.holes) do

		--Test if the mouse is clicking on a hole
		if x >= width - (v.gridX + 1) * 50 and
		x <= width - (v.gridX + 1) * 50 + 50 and
		y >= height - (v.gridY + 1) * 50 and
		y <= height - (v.gridY + 1) * 50 + 50 then

			--Start the process for the liquid animation
			liquidPuzzle.liquid(v.holeNum)
		end
	end

	--Test if the mouse is clicking on a lever
	if x >= width - (6 + 1) * 50 and
	x <= width - (6 + 1) * 50 + 50 and
	y >= height - (1 + 1) * 50 and
	y <= height - (1 + 1) * 50 + 50 then

		--Change the state of the lever to start the animation
		if liquidPuzzle.leverState == true then
			liquidPuzzle.leverState = false
		end
	end
end

function liquidPuzzle.update(dt)

	--Update the liquid animation every tick
	liquidPuzzle.liquid(0)

	--Get information from the table
	for i, v in ipairs(liquidPuzzle.liquidAnim) do

		--Test if there is liquid that is falling
		--Start the animation timer
		if v.falling == true then
			v.animTimer = v.animTimer + 1
		end

		--Test if the animation timer is done
		--Reset the timer, and set the new image for the animation
		if v.animTimer >= 10 then
			v.animTimer = 0
			v.gridX = v.gridX1
			v.gridY = v.gridY1
			v.animation = v.nextAnimation

			v.gridX1 = 0
			v.gridY1 = 0
			v.nextAnimation = 0

			v.animations = v.animations + 1
		end
	end

	--Get information from the table
	for i, v in ipairs(liquidPuzzle.liquidAnim) do

		--Get the width of the window
		local width = love.graphics.getWidth()

		--Test if there is an animation image
		--Set that no liquid is falling
		--Reset the animation timer
		if v.animation == 0 and
		v.nextAnimation == 0 then
			v.falling = false
			v.animTimer = 0
			v.animations = 0
		end

		--Test if the liquid fell outside the window
		--Set that no liquid is falling
		--Reset the animation timer
		if v.animations >= 7 then
			v.falling = false
			v.animTimer = 0
			v.animations = 0
		end 
	end

	--Test if the lever was pulled
	if liquidPuzzle.leverState == false then

		--Start the animation sequence
		liquidPuzzle.leverTimer = liquidPuzzle.leverTimer + 1

		--Get infromation from the table
		--Change the image of the pots
		for i, v in ipairs(liquidPuzzle.pots) do
			v.img = invertedPot
		end

		--Test if the animation timer is done
		--Reset the timer, and change the lever state
		if liquidPuzzle.leverTimer >= 50 then
			liquidPuzzle.leverTimer = 0
			liquidPuzzle.leverState = true

			--Get information from the table
			for i, v in ipairs(liquidPuzzle.pots) do
				--Make all the pots standing again
				--Reset their color to the default
				v.img = standingPot
				v.r = 255
				v.g = 255
				v.b = 255
			end
		end
	end

	--Variable to see how many pots have the correct liquid
	local amountCorrect = 0

	--Get information from the tables
	for i, v in ipairs(liquidPuzzle.solution) do
		for i, b in ipairs(liquidPuzzle.pots) do

			--Test if the correct answer is equal to the pot's information
			--Add one to the amount of correct pots
			if v.solutionNum == b.potNum and
			b.r == v.r and
			b.g == v.g and
			b.b == v.b then
				amountCorrect = amountCorrect + 1
			end
		end
	end

	--Test if all 5 pots are correct
	--Set the liquid puzzle to be completed
	if amountCorrect >= 5 then
		liquidPuzzle.completed = true
	end
end

function liquidPuzzle.liquid(holeNum)

	--Test if a hole was clicked on, or if it's just updating
	if holeNum ~= 0 then

		--Get information from the tables
		for i, v in ipairs(liquidPuzzle.holes) do
			for i, b in ipairs(liquidPuzzle.liquidAnim) do

				--Test if the hole numbers match, and that no liquid is falling
				--Start the animation sequence
				if v.holeNum == holeNum and
				b.falling == false then
					b.gridX = v.gridX
					b.gridY = v.gridY
					b.animation = liquidOrigin
					b.falling = true
					b.r = v.r
					b.g = v.g
					b.b = v.b
				end
			end
		end
	end

	--Get information fromt the table
	for i, v in ipairs(liquidPuzzle.liquidAnim) do

		--Local variable that tests for a director in the liquid path
		local director = false

		--Get information from the table
		for i, b in ipairs(liquidPuzzle.directors) do

			--Get which animation frame the liquid is on
			if v.animation == liquidOrigin then

				--Check the grid below the animation for a director
				if v.gridX == b.gridX and
				v.gridY - 1 == b.gridY then
					director = true
				end

				--Get information about the grid below the animation
				if v.gridX == b.gridX and
				v.gridY - 1 == b.gridY then

					--Set the second animation's location
					v.gridX1 = b.gridX
					v.gridY1 = b.gridY

					--Test the direction of the director
					--Set the animation equal to the direction
					if b.direction == directionLeft then
						v.nextAnimation = liquidTurnLeft
					elseif b.direction == directionRight then
						v.nextAnimation = liquidTurnRight
					else
						v.nextAnimation = liquidFall
					end

				--Test if a director hasn't been found
				elseif director == false then
					--Set the new animations location
					--Set the animation to the dafult image
					v.gridX1 = v.gridX
					v.gridY1 = v.gridY - 1
					v.nextAnimation = liquidFall
				end

			--Test for the animation frame
			--Set the new animation location
			--Set the animation image
			elseif v.animation == liquidTurnLeft then
				v.gridX1 = v.gridX + 1
				v.gridY1 = v.gridY
				v.nextAnimation = liquidFallLeft

			elseif v.animation == liquidTurnRight then
				v.gridX1 = v.gridX - 1
				v.gridY1 = v.gridY
				v.nextAnimation = liquidFallRight
			
			elseif v.animation == liquidFall or 
			v.animation == liquidFallLeft or
			v.animation == liquidFallRight then

				--Check the grid below the animation for a director
				if v.gridX == b.gridX and
				v.gridY - 1 == b.gridY then
					director = true
				end

				--Get information about the grid below the animation
				if v.gridX == b.gridX and
				v.gridY - 1 == b.gridY then

					--Set the second animation's location
					v.gridX1 = b.gridX
					v.gridY1 = b.gridY

					--Test the direction of the director
					--Set the animation equal to the direction
					if b.direction == directionLeft then
						v.nextAnimation = liquidTurnLeft
					elseif b.direction == directionRight then
						v.nextAnimation = liquidTurnRight
					else
						v.nextAnimation = liquidFall
					end

				--Test if a director hasn't been found
				elseif director == false then
					--Set the new animations location
					--Set the animation to the dafult image
					v.gridX1 = v.gridX
					v.gridY1 = v.gridY - 1
					v.nextAnimation = liquidFall
				end
			end
		end

		--Get information from the table
		for i, b in ipairs(liquidPuzzle.pots) do

			--Test for a pot in the animation's location
			if v.gridX1 == b.gridX and
			v.gridY1 == b.gridY then

				--Set the new animation image
				v.nextAnimation = liquidInPot

				--Set the color of the pot
				--If there is already a color, mix the colors
				if b.r == 255 then
					b.r = v.r
					b.g = v.g
					b.b = v.b
				end
			end
		end
	end
end

function liquidPuzzle.answers()

	--Variable to set the actual solution
	local solution = 0

	--Get information from the table
	for i, v in ipairs(liquidPuzzle.holes) do

		--Variable to test if a solution has been created
		local createdSolution = false

		repeat

			--Test which hole number is getting a solution
			--Get a random solution for the hole
			if v.holeNum == 1 then
				solution = math.floor(math.random() * 3 + 1)
			elseif v.holeNum == 2 then
				solution = math.floor(math.random() * 4 + v.holeNum) - 1
			elseif v.holeNum == 3 then
				solution = math.floor(math.random() * 5 + v.holeNum) - 2
			elseif v.holeNum == 4 then
				solution = math.floor(math.random() * 4 + v.holeNum) - 2
			elseif v.holeNum == 5 then
				solution = math.floor(math.random() * 5 + v.holeNum) - 4
			end

			--Get information from the table
			for i, b in ipairs(liquidPuzzle.solution) do

				--Test if the solution hasn't been created yet
				if b.solutionNum == solution and
				b.solution == false and
				createdSolution == false then

					--Set the solution created to true
					--Set the information for the correct solution
					b.r = v.r
					b.g = v.g
					b.b = v.b
					b.solution = true
					createdSolution = true
				end
			end

		until createdSolution == true
	end

	--Color the bricks behind the sliding puzzle
	slidingPuzzle.colorBricks()
end

function liquidPuzzle.draw()

	--Get the width and height of the window
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()

	--Draw the pots with the colored liquid in them
	for i, v in ipairs(liquidPuzzle.pots) do
		love.graphics.draw(v.sheet, v.img, width - (v.gridX + 1) * 50, height - (v.gridY + 1) * 50)
		love.graphics.setColor(v.r, v.g, v.b)
		if v.r ~= 255 then
			love.graphics.draw(colorDisplay, width - (v.gridX + 1) * 50, height - (v.gridY + 1) * 50)
		end
		love.graphics.reset()		
	end

	--Draw the holes
	for i, v in ipairs(liquidPuzzle.holes) do
		love.graphics.draw(liquidHole, width - (v.gridX + 1) * 50, height - (v.gridY + 1) * 50)
	end

	--Draw the directors and which direction they point
	for i, v in ipairs(liquidPuzzle.directors) do
		if v.direction == directionLeft then
			love.graphics.draw(liquidDirector, directionLeft, width - (v.gridX + 1) * 50, height - (v.gridY + 1) * 50)
		elseif v.direction == directionRight then
			love.graphics.draw(liquidDirector, directionRight, width - (v.gridX + 1) * 50, height - (v.gridY + 1) * 50)
		else
			love.graphics.draw(liquidDirector, directionNone, width - (v.gridX + 1) * 50, height - (v.gridY + 1) * 50)
		end
	end

	--Draw the liquid animation when the sequence starts
	for i, v in ipairs(liquidPuzzle.liquidAnim) do
		if v.falling == true then
			love.graphics.setColor(v.r, v.g, v.b)
			love.graphics.draw(liquidAnimation, v.animation, width - (v.gridX + 1) * 50, height - (v.gridY + 1) * 50)
			love.graphics.draw(liquidAnimation, v.nextAnimation, width - (v.gridX1 + 1) * 50, height - (v.gridY1 + 1) * 50)
			love.graphics.reset()
		end
	end

	--Draw the lever, in the state that it is in
	if liquidPuzzle.leverState == true then
		love.graphics.draw(leverAnimation, leverUp, width - (6 + 1) * 50, height - (1 + 1) * 50)
	else
		love.graphics.draw(leverAnimation, leverDown, width - (6 + 1) * 50, height - (1 + 1) * 50)
	end
end