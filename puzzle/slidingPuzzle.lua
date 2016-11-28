
slidingPuzzle = {}
slidingPuzzle.bricks = {}

slidingPuzzle.completed = false

function slidingPuzzle.load()

	--Load images
	slidingPuzzleImage = love.graphics.newImage("images/slidingPuzzle.png")
	bricks = love.graphics.newImage("images/bricks.png")

	--How many sliding pieces there are
	--The piece number that is being created
	local pieces = 25
	local pieceNum = 1

	--The image location on the sprite sheet X and Y
	local imgX = 0
	local imgY = 0

	--Create all 25 sliding pieces
	repeat
		
		--Put information into a talbe
		table.insert(slidingPuzzle,
					{imgNum = pieceNum,
					gridX = math.floor(math.random() * 5 + 1),
					gridY = math.floor(math.random() * 5 + 1),
					sheet = slidingPuzzleImage,
					img = love.graphics.newQuad(imgX * 50, imgY * 50, 50, 50, slidingPuzzleImage:getDimensions())})
		
		table.insert(slidingPuzzle.bricks,
					{brickNum = pieceNum,
					gridX = imgX + 1,
					gridY = imgY + 1,
					r= 255,
					g = 255,
					b = 255,})

		--Change the X position in the sprite sheet
		imgX = imgX + 1

		--Reset the X position and go to the next layer
		if imgX == 5 then
			imgX = 0
			imgY = imgY + 1
		end

		--Set the new number for the piece being created
		pieceNum = pieceNum + 1
	until pieceNum > 25

	--Randomize the puzzle pieces locations
	slidingPuzzle.randomize()
end

function slidingPuzzle.randomize()

	--Variable to know how many pieces are in one location
	--Test the X and Y location of the puzzle pieces
	local stackSize = 0
	local x = 1
	local y = 1

	--Make each sliding piece have it's own location
	repeat
		--Get information from the table
		for i, v in ipairs(slidingPuzzle) do

			--Test if there is a piece at the X and Y testing postion
			if v.gridX == x and
			v.gridY == y then

				--Test for how many peices are in the same location
				if stackSize >= 1 then

					--Move one of the pieces
					v.gridX = v.gridX + 1

					--Test if the piece goes off the side of the grid
					--Reset the X and go to the next Y layer
					if v.gridX > 5 then
						v.gridX = 1
						v.gridY = v.gridY + 1

						--Test if the piece goes off the bottome of the grid
						--Reset the X and Y to the default position
						--Restart the randomizing process
						if v.gridY > 5 then
							v.gridX = 1
							v.gridY = 1
							slidingPuzzle.randomize()
						end
					end
				end

				--Increase the stack size by one
				stackSize = stackSize + 1
			end
		end

		--Reset the stack size, go to the next X location
		stackSize = 0
		x = x + 1

		--If the X location is off the grid the go to the next layer
		if x > 5 then
			x = 1
			y = y + 1
		end

	--Repeat until all the spots are tested
	until y > 5
end

function slidingPuzzle.mousepressed(x, y, button)

	--Local variables to store the empty space location
	local emptySpaceX = 0
	local emptySpaceY = 0

	--Get information from the table
	for i, v in ipairs(slidingPuzzle) do
		--Test for the empty space
		if v.imgNum == 1 then
			--Set the location of the empty space
			emptySpaceX = v.gridX
			emptySpaceY = v.gridY
			break
		end
	end

	local movement = false

	--Get information from the table
	for i, v in ipairs(slidingPuzzle) do

		--Test where the mouse is clicking relative to the squares
		if x >= v.gridX * 50 and
		x <= v.gridX * 50 + 50 and
		y >= v.gridY * 50 and
		y <= v.gridY * 50 + 50 then

			--Test where the empty space is compared to the tile clicked
			--Move the tile to the empty space
			--Set the empty space to where the tile was
			if v.gridY == emptySpaceY then
				if v.gridX - 1 == emptySpaceX then
					v.gridX = v.gridX - 1
					emptySpaceX = emptySpaceX + 1
					movement = true
					break
				elseif v.gridX + 1 == emptySpaceX then
					v.gridX = v.gridX + 1
					emptySpaceX = emptySpaceX - 1
					movement = true
					break
				end
			elseif v.gridX == emptySpaceX then
				if v.gridY - 1 == emptySpaceY then
					v.gridY = v.gridY - 1
					emptySpaceY = emptySpaceY + 1
					movement = true
					break
				elseif v.gridY + 1 == emptySpaceY then
					v.gridY = v.gridY + 1
					emptySpaceY = emptySpaceY - 1
					movement = true
					break
				end
			end
		end
	end

	if movement == true then
		if pitch == 1 then
			stoneMove1:setPitch(1.6)
			stoneMove2:setPitch(1.6)
		elseif pitch == 2 then
			stoneMove1:setPitch(1.5)
			stoneMove2:setPitch(1.5)
		elseif pitch == 3 then
			stoneMove1:setPitch(1.7)
			stoneMove2:setPitch(1.7)
		end

		if audio == 1 then
			stoneMove1:play()
		else
			stoneMove2:play()
		end
	end

	--Get information from the table
	for i, v in ipairs(slidingPuzzle) do
		--Test for the empty tile space
		--Set the new location for the empty tile
		if v.imgNum == 1 then
			v.gridX = emptySpaceX
			v.gridY = emptySpaceY
			break
		end
	end

	--Check if the puzzle is completed
	slidingPuzzle.check()
end

function slidingPuzzle.check()

	--Set the completed variable to false by default
	local completed = false

	--Get information from the table
	for i, v in ipairs(slidingPuzzle) do

		--Test the img number compared to the location of the tile
		--If they aren't equal don't set the puzzle to completed
		if v.imgNum == v.gridX + (v.gridY - 1) * 5 then
			completed = true
		else
			completed = false
			break
		end
	end

	if completed == true then
		for i, v in ipairs(slidingPuzzle) do
			v.gridX = -100
			slidingPuzzle.completed = true
		end
	end
end

function slidingPuzzle.colorBricks()
	for i, v in ipairs(liquidPuzzle.solution) do

		local randomY = math.floor(math.random() * 5 + 1)

		for i, b in ipairs(slidingPuzzle.bricks) do

			if v.solutionNum == b.gridX and
			randomY == b.gridY then
				b.r = v.r
				b.g = v.g
				b.b = v.b
			end
		end
	end
end

function slidingPuzzle.draw()

	for i, v in ipairs(slidingPuzzle.bricks) do
		love.graphics.setColor(v.r, v.g, v.b)
		love.graphics.draw(bricks, v.gridX * 50, v.gridY * 50)
		love.graphics.reset()
	end
	--Get information from the table
	for i, v in ipairs(slidingPuzzle) do
		--Draw the tiles where they are in the grid
		love.graphics.draw(v.sheet, v.img, v.gridX * 50, v.gridY * 50)
	end
end