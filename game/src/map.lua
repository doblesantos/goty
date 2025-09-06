local class = require 'lib/middleclass'
Bump = require "lib/bump";
Entity = require "src/entity";
Player = require "src/player";
Tile = require "src/tile";

local Map = class('Map')

function Map:initialize()
	self.tileset = love.graphics.newImage('assets/tilemap.png')
	TileW, TileH = 18,18
	TileTable = {
		{'p1A','p1B','p1B','p1B','p1B','p1B','p1B','p1B','p1B','p1C',' ',' ','p1A','p1B','p1C'},
	}

	self:resetMap();
end

function Map:resetMap()
    self.world = Bump.newWorld(18)
	
	self:buildTileMap();

	self.player = Player:new(self.world, 36, 226)
end

function Map:buildTileMap()
	local tilesetW, tilesetH = self.tileset:getWidth(), self.tileset:getHeight()
	Quads = {}

	local quadInfo = {
		{ 'p1S',   0,  0 },  --plaform Green short
		{ 'p1A',  18,  0 },  --plaform Green long  part A
		{ 'p1B',  36,  0 },  --plaform Green long part B
		{ 'p1C',  54,  0 },  --plaform Green long part C
		{ 'p2S',   0, 54 },  --plaform brown short
		{ 'p2A',  18, 54 },  --plaform brown long  part A
		{ 'p2B',  36, 54 },  --plaform brown long part B
		{ 'p2C',  54, 54 },  --plaform brown long part C
		{ 'p3S',   0, 90 },  --plaform white short
		{ 'p3A',  18, 90 },  --plaform white long  part A
		{ 'p3B',  36, 90 },  --plaform white long part B
		{ 'p3C',  54, 90 },   --plaform white long part C
		{ 'b1S', 126, 36 },  --block brown short
		{ 'b1A', 144, 36 },  --block brown long  part A
		{ 'b1B', 162, 36 },  --block brown long part B
		{ 'b1C', 180, 36 },  --block brown long part C
	}
	
    for _,info in ipairs(quadInfo) do
		Quads[info[1]] = love.graphics.newQuad(info[2], info[3], TileW, TileH, tilesetW, tilesetH)
	end

	---creating tile Objects
	for rowIndex = #TileTable, 1, -1 do
		local row = TileTable[rowIndex]
		for columnIndex = 1, #row, 1 do
		  local x,y = (columnIndex-1)*TileW, (15-rowIndex)*TileH
		  local quadID = row[columnIndex]
		  if(quadID ~= ' ') then
		     Tile:new(self.world, x, y, TileW, TileH, Quads[quadID], 'ground', self.tileset)
		  end
		end
	end
end

function Map:update(dt, l,t,w,h)
  l,t,w,h = l or 0, t or 0, w or self.width, h or self.height
  local visibleThings, len = self.world:queryRect(l,t,w,h)

  --table.sort(visibleThings, sortByUpdateOrder)

  for i=1, len do
    visibleThings[i]:update(dt)
  end
end

function Map:draw(drawDebug, l,t,w,h)
  --if drawDebug then bump_debug.draw(self.world, l,t,w,h) end

  local visibleThings, len = self.world:queryRect(l,t,w,h)

  --table.sort(visibleThings, sortByCreatedAt)

  for i=1, len do
    visibleThings[i]:draw(drawDebug)
  end
end

return Map;
