
symbols = {}
symbols.list = {}
symbolsList = {}
symbols.display = {}

symbols.correct = 0

symbols.completed = false
symbols.amountDone = 0

function symbols.load()

	symbolButtons = love.graphics.newImage("images/symbolButtons.png")
	symbolSheet = love.graphics.newImage("images/symbols.png")

	buttonClick = love.audio.newSource("sounds/buttonClick.wav", static)

	unselectedButton = love.graphics.newQuad(0, 0, 50, 50, symbolButtons:getDimensions())
	selectedButton = love.graphics.newQuad(50, 0, 50, 50, symbolButtons:getDimensions())

	local gridX = 1
	local gridY = 1
	local buttons = 0
	local buttonAmount = 10

	repeat
		table.insert(symbols,
					{buttonNum = buttons,
					img = love.graphics.newQuad((gridX - 1) * 50, (gridY - 1) * 50, 50, 50, symbolSheet:getDimensions()),
					gridX = gridX,
					gridY = gridY,
					timer = 0,
					selected = false})

		table.insert(symbolsList,
					{symbolNum = buttons,
					img = love.graphics.newQuad((gridX - 1) * 50, (gridY - 1) * 50, 50, 50, symbolSheet:getDimensions()),
					gridX = gridX,
					gridY = gridY})

		gridX = gridX + 1

		if gridX > 5 then
			gridX = 1
			gridY = gridY + 1
		end

		buttons = buttons + 1
	until buttons == buttonAmount

		local displayButtons = 6
		local buttonsCreated = 0
		gridX = 1
		gridY = 1

	repeat
		table.insert(symbols.display,
					{displayNum = buttonsCreated,
					img = nil,
					gridX = gridX,
					gridY = gridY})

		gridX = gridX + 1
		if gridX > 3 then
			gridX = 1
			gridY = gridY + 1
		end
		buttonsCreated = buttonsCreated + 1
	until buttonsCreated == displayButtons
end

function symbols.update(dt)
	for i, v in ipairs(symbols) do
		if v.selected == true then
			v.timer = v.timer + 1
		end

		if v.timer >= 10 then
			v.selected = false
			v.timer = 0
		end
	end

	if symbols.correct == 6 then
		if symbolsCompleted == false then
			symbols.amountDone = symbols.amountDone + 1
		end
		symbols.completed = true
	end
end

function symbols.mousepressed(x, y, button)

	local match = false

	for i, v in ipairs(symbols) do
		if x >= (v.gridX + 6) * 50 and
		x <= (v.gridX + 6) * 50 + 50 and
		y >= v.gridY * 50 and
		y <= v.gridY * 50 + 50 then
			v.selected = true

			local pitch = math.floor(math.random() * 3 + 1)

			if pitch == 1 then
				buttonClick:setPitch(1)
			elseif pitch == 2 then
				buttonClick:setPitch(.9)
			else
				buttonClick:setPitch(1.1)
			end
				buttonClick:play()
			nileGlyph.randomTiles()
			nileGlyph.playPyramids()

			for i, b in ipairs(symbols.list) do
				if v.img == b.img and
				b.symbolNum == symbols.correct then

					for i, n in ipairs(symbols.display) do
						if n.displayNum == symbols.correct then
							n.img = v.img
						end
					end

					symbols.correct = symbols.correct + 1
					match  = true
					break
				end
			end
		end
	end

	if match == false then
		symbols.correct = 0
		for i, v in ipairs(symbols.display) do
			v.img = nil
		end
		symbols.resetDisplay()
	end
end

function symbols.displayList()

	local symbolsAmount = 6
	local symbolsCreated = 0

	repeat
		table.insert(symbols.list,
					{symbolNum = symbolsCreated,
					img = math.floor(math.random() * 10)})
		symbolsCreated = symbolsCreated + 1
	until symbolsCreated == symbolsAmount

	for i, v in ipairs(symbols) do
		for i, b in ipairs(symbols.list) do
			if v.buttonNum == b.img then
				b.img = v.img
			end
		end
	end
end

function symbols.resetDisplay()
	if symbols.completed == false then
		for i, v in ipairs(symbols.list) do
			v.img = math.floor(math.random() * 10)
		end

		for i, v in ipairs(symbols) do
			for i, b in ipairs(symbols.list) do
				if v.buttonNum == b.img then
					b.img = v.img
				end
			end
		end
	end
end

function symbols.draw()
	for i, v in ipairs(symbols) do
		if v.selected == false then
			love.graphics.draw(symbolButtons, unselectedButton, (v.gridX + 6) * 50, v.gridY * 50)
		else
			love.graphics.draw(symbolButtons, selectedButton, (v.gridX + 6) * 50, v.gridY * 50)
		end

		love.graphics.draw(symbolSheet, 7 * 50, 50)
	end

	if nileGlyph.completed == true then
		for i, v in ipairs(symbols.list) do
			love.graphics.draw(bricks, 10 * 50, (v.symbolNum + 11) * 50)
			love.graphics.draw(symbolSheet, v.img, 10 * 50, (v.symbolNum + 11) * 50)
		end
	end

	for i, v in ipairs(symbols.display) do

		love.graphics.draw(symbolButtons, unselectedButton, (v.gridX + 7) * 50, (v.gridY + 3) * 50)

		if v.img ~= nil then
			love.graphics.draw(symbolSheet, v.img, (v.gridX + 7) * 50, (v.gridY + 3) * 50)
		end
	end
end