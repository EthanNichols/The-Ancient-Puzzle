
nileGlyph = {}

nileGlyph.filledTiles = 0
nileGlyph.waterFill = false
nileGlyph.waterTimer = 0

nileGlyph.completed = false

function nileGlyph.load()

	dryRiver = love.graphics.newImage("images/dryRiver.png")
	waterAnimation = love.graphics.newImage("images/waterAnimation.png")
	pyramid = love.graphics.newImage("images/pyramid.png")

	dryOrigin = love.graphics.newQuad(0, 0, 50, 50, dryRiver:getDimensions())
	horizontalRiver = love.graphics.newQuad(50, 0, 50, 50, dryRiver:getDimensions())
	verticalRiver = love.graphics.newQuad(100, 0, 50, 50, dryRiver:getDimensions())
	leftUpRiver = love.graphics.newQuad(150, 0, 50, 50, dryRiver:getDimensions())
	leftDownRiver = love.graphics.newQuad(200, 0, 50, 50, dryRiver:getDimensions())
	rightDownRiver = love.graphics.newQuad(250, 0, 50, 50, dryRiver:getDimensions())
	rightUpRiver = love.graphics.newQuad(300, 0, 50, 50, dryRiver:getDimensions())

	waterOrigin = love.graphics.newQuad(0, 0, 50, 50, waterAnimation:getDimensions())
	horizontalWater = love.graphics.newQuad(50, 0, 50, 50, waterAnimation:getDimensions())
	verticalWater = love.graphics.newQuad(100, 0, 50, 50, waterAnimation:getDimensions())
	leftUpWater = love.graphics.newQuad(150, 0, 50, 50, waterAnimation:getDimensions())
	leftDownWater = love.graphics.newQuad(200, 0, 50, 50, waterAnimation:getDimensions())
	rightDownWater = love.graphics.newQuad(250, 0, 50, 50, waterAnimation:getDimensions())
	rightUpWater = love.graphics.newQuad(300, 0, 50, 50, waterAnimation:getDimensions())


	local gridX = 1
	local gridY = 1

	repeat

		if gridX == 10 and
		gridY == 2 then
			img = dryOrigin
			waterImg = waterOrigin
		else
			img = nil
			waterImg = nil
		end
		table.insert(nileGlyph,
					{img = img,
					waterImg = waterImg,
					water = false,
					gridX = gridX,
					gridY = gridY,
					up = false,
					down = false,
					left = false,
					right = false})

		gridX = gridX + 1

		if gridX > 11 and
		gridY <= 3 then
			gridX = 1
			gridY = gridY + 1
		elseif gridX > 8 and
		gridY > 3 then
			gridX = 1
			gridY = gridY + 1
		end

	until gridY == 11

	nileGlyph.randomTiles()
	nileGlyph.playPyramids()
end

function nileGlyph.randomTiles()

	for i, v in ipairs(nileGlyph) do

		local randomTile = math.floor(math.random() * 6 + 1)
		if randomTile == 1 then
			v.img = horizontalRiver
		elseif randomTile == 2 then
			v.img = verticalRiver
		elseif randomTile == 3 then
			v.img = leftUpRiver
		elseif randomTile == 4 then
			v.img = leftDownRiver
		elseif randomTile == 5 then
			v.img = rightDownRiver
		elseif randomTile == 6 then
			v.img = rightUpRiver
		end

		if v.gridX == 10 and
		v.gridY == 2 then
			v.img = dryOrigin
			v.waterImg = waterOrigin
		end
	end
end

function nileGlyph.playPyramids()

	local pyramids = 0

	repeat
		local x = math.floor(math.random() * 7 + 1)
		local y = math.floor(math.random() * 10 + 1)

		for i, v in ipairs(nileGlyph) do
			if v.gridX == x and
			v.gridY == y then
				if v.img == pyramid then
					pyramids = pyramids - 1
				end
				v.img = pyramid
			end
		end
		pyramids = pyramids + 1
	until pyramids == 5
end

function nileGlyph.update(dt)

	if nileGlyph.waterFill == true then
		nileGlyph.waterTimer = nileGlyph.waterTimer + 1

		if nileGlyph.waterTimer >= 2 then
			nileGlyph.waterTimer = 0
			nileGlyph.filledTiles = nileGlyph.filledTiles + 1
			nileGlyph.water()

			if nileGlyph.filledTiles >= 30 then
				nileGlyph.filledTiles = 0
				nileGlyph.waterFill = false
			end
		end
	end

	local pyramidsFilled = 0

	for i, v in ipairs(nileGlyph) do
		if v.img == pyramid and
		v.water == true then
			pyramidsFilled = pyramidsFilled + 1
		end
	end

	if pyramidsFilled == 5 then
		if nileGlyph.completed == false then
			symbols.displayList()
		end
		nileGlyph.completed = true
	else
		nileGlyph.completed = false
	end
end	

function nileGlyph.water()
	for i, v in ipairs(nileGlyph) do
		v.up = false
		v.down = false
		v.right = false
		v.left = false

		if v.img == dryOrigin or
		v.img == pyramid then
			v.up = true
			v.down = true
			v.right = true
			v.left = true

		elseif v.img == horizontalRiver then
			v.waterImg = horizontalWater
			v.left = true
			v.right = true

		elseif v.img == verticalRiver then
			v.waterImg = verticalWater
			v.up = true
			v.down = true

		elseif v.img == leftUpRiver then
			v.waterImg = leftUpWater
			v.left = true
			v.up = true

		elseif v.img == leftDownRiver then
			v.waterImg = leftDownWater
			v.left = true
			v.down = true

		elseif v.img == rightUpRiver then
			v.waterImg = rightUpWater
			v.right = true
			v.up = true

		elseif v.img == rightDownRiver then
			v.waterImg = rightDownWater
			v.right = true
			v.down = true
		end
	end

	for i, v in ipairs(nileGlyph) do
		for i, b in ipairs(nileGlyph) do

			if v.gridY == b.gridY and
			b.water == true then

				if v.left == true and
				b.right == true and
				v.gridX - 1 == b.gridX then
					v.water = true

				elseif v.right == true and
				b.left == true and
				v.gridX + 1 == b.gridX then
					v.water = true
				end
			end

			if v.gridX == b.gridX and
			b.water == true then

				if v.up == true and
				b.down == true and
				v.gridY - 1 == b.gridY then
					v.water = true

				elseif v.down == true and
				b.up == true and
				v.gridY + 1 == b.gridY then
					v.water = true
				end
			end
		end
	end
end

function nileGlyph.mousepressed(x, y, button)
	for i, v in ipairs(nileGlyph) do

		v.water = false

		if x >= v.gridX * 50 and
		x <= v.gridX * 50 + 50 and
		y >= (v.gridY + 6) * 50 and
		y <= (v.gridY + 6) * 50 + 50 then

			if v.img == dryOrigin then
				nileGlyph.waterFill = true
				v.water = true
			elseif v.img == horizontalRiver then
				v.img = verticalRiver
			elseif v.img == verticalRiver then
				v.img = horizontalRiver
			elseif v.img == leftUpRiver then
				v.img = rightUpRiver
			elseif v.img == rightUpRiver then
				v.img = rightDownRiver
			elseif v.img == rightDownRiver then
				v.img = leftDownRiver
			elseif v.img == leftDownRiver then
				v.img = leftUpRiver
			end
		end
	end
end

function nileGlyph.draw()
	for i, v in ipairs(nileGlyph) do
		if v.img ~= nil and
		v.img ~= pyramid then
			love.graphics.draw(dryRiver, v.img, v.gridX * 50, (v.gridY + 6) * 50)
		end

		if v.img == pyramid then
			if v.water == false then
				love.graphics.setColor(255, 255, 255)
			else
				love.graphics.setColor(150, 255, 150)
			end
				
			love.graphics.draw(v.img, v.gridX * 50, (v.gridY + 6) * 50)
			love.graphics.reset()
		end

		if v.water == true and
		v.img ~= pyramid then
			love.graphics.draw(waterAnimation, v.img, v.gridX * 50, (v.gridY + 6) * 50)
		end
	end
end