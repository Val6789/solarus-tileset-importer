function love.load(arg)
	if #arg < 4 then
		print("Usage: love solarus-tileset-importer <your-tileset.png> <tile-width> <tile-height>")
		love.event.quit()
	end
	
	file = io.open(arg[2], "rb")
	tiles = love.graphics.newImage(love.filesystem.newFileData(file:read("*a"), ""))

	w, h = tiles:getWidth(), tiles:getHeight()
	tx, ty = tonumber(arg[3]), tonumber(arg[4])
	sx, sy = 0, 0
	
	love.window.setMode(w, h)
	
	-- Create the tiles table
	grid = {}
	for x = 0, w/tx do
		grid[x] = {}
		for y = 0, h/ty do
			-- Set all tiles as traversable by default
			grid[x][y] = "traversable"
		end
	end
end
 
function love.draw()
	love.graphics.draw(tiles, 0, 0)
	
	sx = math.floor(love.mouse.getX()/tx)
	sy = math.floor(love.mouse.getY()/ty)
	love.graphics.print(tostring(sx) .. ", " .. tostring(sy), 8, 8)
	love.graphics.rectangle("fill", sx*tx, sy*ty, tx, ty)
	
	for x = 0, w/tx do
		for y = 0, h/ty do
			if grid[x][y] == "wall" then
				love.graphics.rectangle("line", x*tx, y*ty, tx, ty)
			end
		end
	end
end

function love.mousereleased()
	if grid[sx][sy] == "traversable" then
		grid[sx][sy] = "wall"
	else
		grid[sx][sy] = "traversable"
	end
end

function love.keyreleased()
	print("background_color{ 0, 0, 0 }")
	
	i = 0
	for x = 0, w/tx do
		for y = 0, h/ty do
			i = i + 1
			
			print('tile_pattern{' .. 
				'id = "' .. i .. '",' ..
				'ground = "' .. grid[x][y] .. '",' ..
				'default_layer = 0,' ..
				'x = ' .. x*tx .. ',' ..
				'y = ' .. y*ty .. ',' ..
				'width = ' .. tx .. ',' ..
				'height = ' .. ty .. ',' ..
				'}')
		end
	end
end
