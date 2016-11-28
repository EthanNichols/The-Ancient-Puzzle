
colorMovement = {}
colorMovement.background = {}
colorMovement.boxes = {}

arrow = {}
arrow[1] = 0
arrow[2] = 0
arrow[3] = 0
arrow[4] = 0

arrow[5] = 1
arrow[6] = -1
arrow[7] = -1
arrow[8] = 1

colorMovement.hover = "none"
colorMovement.moves = 0

colorMovement.completed = false

function colorMovement.load()

	wall = love.graphics.newImage("images/wall.png")
	box = love.graphics.newImage("images/box.png")
	arrowSheet = love.graphics.newImage("images/arrows.png")

	stoneMove1 = love.audio.newSource("sounds/stoneMove1.wav", static)
	stoneMove2 = love.audio.newSource("sounds/stoneMove2.wav", static)

	arrow[1] = love.graphics.newQuad(0, 0, 50, 50, arrowSheet:getDimensions())
	arrow[2] = love.graphics.newQuad(50, 0, 50, 50, arrowSheet:getDimensions())
	arrow[3] = love.graphics.newQuad(100, 0, 50, 50, arrowSheet:getDimensions())
	arrow[4] = love.graphics.newQuad(150, 0, 50, 50, arrowSheet:getDimensions())

	local gridX = 1
	local gridY = 1

	local brickAmount = 128
	local bricksCreated = 0

	repeat
		table.insert(colorMovement.background,
			{brickNum = bricksCreated,
			gridX = gridX,
			gridY = gridY,})

		gridX = gridX + 1
		if gridX > 16 then
			gridX = 1
			gridY = gridY + 1
		end
		bricksCreated = bricksCreated + 1
	until bricksCreated == brickAmount

	local boxes = math.floor(math.random() * 3 + 4)
	local boxesCreated = 0

	repeat
		table.insert(colorMovement.boxes,
					{boxNum = boxesCreated,
					gridX = math.floor(math.random() * 16 + 1),
					gridY = math.floor(math.random() * 8 + 1),
					up = 0,
					down = 0,
					left = 0,
					right = 0,
					r = math.floor(math.random() * 255 + 1),
					g = math.floor(math.random() * 255 + 1),
					b = math.floor(math.random() * 255 + 1)})

		boxesCreated = boxesCreated + 1
	until boxesCreated == boxes

	colorMovement.direction()
end

function colorMovement.update(dt)
	
	local x, y = love.mouse.getPosition()
	
	if x >= 14 * 50 and
	x <= 30 * 50 and
	y >= 50 and
	y <= 100 then
		colorMovement.hover = "up"
	elseif x >= 14 * 50 and
	x <= 30 * 50 and
	y >= 10 * 50 and
	y <= 11 * 50 then
		colorMovement.hover = "down"
	elseif x >= 13 * 50 and
	x <= 14 * 50 and
	y >= 100 and
	y <= 10 * 50 then
		colorMovement.hover = "left"
	elseif x >= 30 * 50 and
	x <= 31 * 50 and
	y >= 100 and
	y <= 10 * 50 then
		colorMovement.hover = "right"
	else
		colorMovement.hover = "none"
	end

	for i, v in ipairs(colorMovement.boxes) do
		if v.gridX <= 0 then
			v.gridX = 1
		elseif v.gridX >= 17 then
			v.gridX = 16
		elseif v.gridY <= 0 then
			v.gridY = 1
		elseif v.gridY >= 9 then
			v.gridY = 8
		end
	end

	for i, v in ipairs(colorMovement.boxes) do
		for i, b in ipairs(colorMovement.boxes) do
			if v.gridX == b.gridX and
			v.gridY == b.gridY and
			v.boxNum ~= b.boxNum then
				b.up = v.up
				b.right = v.right
				b.left = v.left
				b.down = v.down
			end
		end
	end

	local gridX = 0
	local gridY = 0
	local stacked = 0
	local boxAmount = 0

	for i, v in ipairs(colorMovement.boxes) do
		if v.boxNum == 1 then
			gridX = v.gridX
			gridY = v.gridY
		end

		boxAmount = v.boxNum

		if v.gridX == gridX and
		v.gridY == gridY then
			stacked = stacked + 1
		end
	end

	if colorMovement.moves > 50 then
		colorMovement.direction(true)
		colorMovement.moves = 0
	end

	if boxAmount == stacked then
		colorMovement.completed = true
	end
end

function colorMovement.mousepressed(x, y, button)

	local direction = "none"

	if x >= 14 * 50 and
	x <= 30 * 50 and
	y >= 50 and
	y <= 100 then
		direction = "up"
	elseif x >= 14 * 50 and
	x <= 30 * 50 and
	y >= 10 * 50 and
	y <= 11 * 50 then
		direction = "down"
	elseif x >= 13 * 50 and
	x <= 14 * 50 and
	y >= 50 and
	y <= 10 * 50 then
		direction = "left"
	elseif x >= 30 * 50 and
	x <= 31 * 50 and
	y >= 50 and
	y <= 10 * 50 then
		direction = "right"
	end

	if direction ~= "none" then
		colorMovement.moves = colorMovement.moves + 1

		if pitch == 1 then
			stoneMove1:setPitch(1)
			stoneMove2:setPitch(1)
		elseif pitch == 2 then
			stoneMove1:setPitch(.9)
			stoneMove2:setPitch(.9)
		elseif pitch == 3 then
			stoneMove1:setPitch(1.1)
			stoneMove2:setPitch(1.1)
		end

		if audio == 1 then
			stoneMove1:play()
		else
			stoneMove2:play()
		end
	end

	local audio = math.floor(math.random() * 2 + 1)
	local pitch = math.floor(math.random() * 3 + 1)

	local check = 0

	for i, v in ipairs(colorMovement.boxes) do
		if direction == "up" then
			check = v.up
		elseif direction == "right" then
			check = v.right
		elseif direction == "left" then
			check = v.left
		elseif direction == "down" then
			check = v.down
		end

		if check == 1 or
			check == 3 then
			v.gridX = v.gridX + arrow[check + 4]
		elseif check == 2 or
			check == 4 then
			v.gridY = v.gridY + arrow[check + 4]
		end
	end
end

function colorMovement.direction(reset)

	if reset == true then
		for i, v in ipairs(colorMovement.boxes) do
			gridX = math.floor(math.random() * 16 + 1)
			gridY = math.floor(math.random() * 8 + 1)
		end
	end

	for i, v in ipairs(colorMovement.boxes) do
		v.up = math.floor(math.random() * 4 + 1)

		repeat
			v.right = math.floor(math.random() * 4 + 1)
		until v.right ~= v.up

		repeat
			v.down = math.floor(math.random() * 4 + 1)
		until v.down ~= v.up and v.down ~= v.right

		repeat
			v.left = math.floor(math.random() * 4 + 1)
		until v.left ~= v.up and v.left ~= v.right and v.left ~= v.down
	end
end

function colorMovement.draw()
	love.graphics.draw(wall, 13 * 50, 50)

	for i, v in ipairs(colorMovement.background) do
		love.graphics.setColor(200, 200, 200)
		love.graphics.draw(bricks, (v.gridX + 13) * 50, (v.gridY + 1) * 50)
		love.graphics.reset()
	end

	for i, v in ipairs(colorMovement.boxes) do
		love.graphics.setColor(v.r, v.g, v.b)
		love.graphics.draw(box, (v.gridX + 13) * 50, (v.gridY + 1) * 50)
		love.graphics.reset()

		if v.r < 25 then
			v.r = v.r + 25
		elseif v.g < 25 then
			v.g = v.g + 25
		elseif v.b < 25 then
			v.b = v.b + 25
		end

		love.graphics.setColor(v.r, v.g, v.b)

		if colorMovement.hover == "up" then
			love.graphics.draw(arrowSheet, arrow[v.up], (v.gridX + 13) * 50, (v.gridY + 1) * 50)
		elseif colorMovement.hover == "right" then
			love.graphics.draw(arrowSheet, arrow[v.right], (v.gridX + 13) * 50, (v.gridY + 1) * 50)
		elseif colorMovement.hover == "down" then
			love.graphics.draw(arrowSheet, arrow[v.down], (v.gridX + 13) * 50, (v.gridY + 1) * 50)
		elseif colorMovement.hover == "left" then
			love.graphics.draw(arrowSheet, arrow[v.left], (v.gridX + 13) * 50, (v.gridY + 1) * 50)
		end
		love.graphics.reset()
	end
end