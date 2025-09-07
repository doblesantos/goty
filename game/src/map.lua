local class = require 'lib/middleclass'
Bump = require "lib/bump";
Entity = require "src/entity";
Player = require "src/player";
Tile = require "src/tile";
RecTrigger = require "src/rec-trigger";

local Map = class('Map')

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


NewTopTiles = {
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  , ' ' , ' ' , ' ' ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  , ' ' , ' ' , ' ' ,' '  ,' '  ,' '  , ' ', ' ', 'b1A', 'b1B', 'b1C', ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  , ' ' , ' ' , ' ' ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  ,'b1A','b1B','b1C',' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
}

function Map:initialize()
	self.tileset = love.graphics.newImage('assets/tilemap.png')
    self.deaths = 0
	self:resetMap()
end

function Map:resetMap()
	self.score = 0
	
    TileW, TileH = 18,18
	BgTileW, BgTileH = 24,24
	TileTable = {
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  , ' ' ,' ', ' ' ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  , ' ' ,' ', ' ' ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  , ' ' ,'b1S', ' ' ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  , ' ' , ' ' , ' ' ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  , ' ' , ' ' , ' ' ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,'b1S', ' ' , ' ' , ' ' ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  , ' ' , ' ' , ' ' ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  , ' ' , ' ' , ' ' ,' '  ,' '  ,' '  , ' ', ' ', 'b1A', 'b1B', 'b1C', ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  , ' ' , ' ' , ' ' ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  ,'b1A','b1B','b1C',' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' , ' ' ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' ,'b1S',' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{' '  ,' '  ,' '  , ' ' ,' '  ,' '  ,' '  ,'b1S',' '  ,' '  ,' '  ,' '  ,' '  ,' '  ,' '  , ' ', ' ', ' '   , ' ' , ' '  , ' '  , ' '  , ' ' ,' '  , ' ' , ' ' , ' ' , ' ', ' ' , ' '  },
		{'p1A','p1B','p1B','p1B','p1B','p1B','p1B','p1B','p1B','p1C',' '  ,' '  ,'p1A','p1B','p1C', ' ', ' ', 'p1S' , ' ' , ' '  ,'p1A' , 'p1B','p1B','p1B','p1B','p1B','p1B','p1B','p1B','p1C'},
	}
    CameraX,CameraY = 0,0
    CamYstep = 15

	local tilesetW, tilesetH = self.tileset:getWidth(), self.tileset:getHeight()
	Quads = {}

    for _,info in ipairs(quadInfo) do
		Quads[info[1]] = love.graphics.newQuad(info[2], info[3], TileW, TileH, tilesetW, tilesetH)
	end

    self.world = Bump.newWorld(18)
	self:buildTileMap();
	MortalBoxY = 268
	self.mortalBox = RecTrigger:new(self.world, 0, MortalBoxY, gameWidth, 2, 'mortalBox')
    
	self.leftWorldLimit = RecTrigger:new(self.world, 0, 0 , 2, gameHeight, 'leftWorldLimit')
	self.rightWorldLimit = RecTrigger:new(self.world, gameWidth-2, 0, 2, gameHeight, 'rightWorldLimit')
    self.topWorldLimit = RecTrigger:new(self.world, 0, 0, gameWidth, 2, 'topWorldLimit')

	self.player = Player:new(self.world, 36, 226)
end

function Map:buildTileMap()
	local tilesetW, tilesetH = self.tileset:getWidth(), self.tileset:getHeight()
	Quads = {}
	BGTiles = {}

	
    for _,info in ipairs(quadInfo) do
		Quads[info[1]] = love.graphics.newQuad(info[2], info[3], TileW, TileH, tilesetW, tilesetH)
	end

	---creating tile Objects
	for rowIndex = #TileTable, 1, -1 do
		local row = TileTable[rowIndex]
		for columnIndex = 1, #row, 1 do
		  local x,y = (columnIndex-1)*TileW, (14-(#TileTable - rowIndex)) * TileH  
		  local quadID = row[columnIndex]
		  if(quadID ~= ' ') then
		     Tile:new(self.world, x, y, TileW, TileH, Quads[quadID], 'ground', self.tileset)
		  end
		end
	end
end

function Map:moveCamera()
	CameraY = CameraY + CamYstep
end

function Map:appendRandTileRow()
	    local newTileTableRow = NewTopTiles[math.random(1, #NewTopTiles)]
		local rowIndex = #TileTable + 1

		-- add to table
		table.insert(TileTable,1, newTileTableRow)
	
        -- add to world phisically
		for columnIndex = 1, #newTileTableRow, 1 do
		  local x,y = (columnIndex-1)*TileW, (-rowIndex) * TileH  
		  local quadID = newTileTableRow[columnIndex]
		  if(quadID ~= ' ') then
		     Tile:new(self.world, x, y, TileW, TileH, Quads[quadID], 'ground', self.tileset)
		  end
		end
end

function Map:moveMortalBox()
  self.mortalBox.y =  self.mortalBox.y - CamYstep
  self.world:update(self.mortalBox, self.mortalBox.x, self.mortalBox.y)


  self.leftWorldLimit.y = self.leftWorldLimit.y - CamYstep
  self.rightWorldLimit.y = self.rightWorldLimit.y -CamYstep
  self.topWorldLimit.y = self.topWorldLimit.y - CamYstep

  self.world:update(self.leftWorldLimit , 0, self.leftWorldLimit.y)
  self.world:update(self.rightWorldLimit, gameWidth-2, self.rightWorldLimit.y)
  self.world:update(self.topWorldLimit, 0, self.topWorldLimit.y)
end

function Map:isGameOver()
  return self.player.isDead
end

function Map:incrementScore()
  self.score = self.score + 1
end

function Map:incrementDeaths()
  self.deaths = self.deaths + 1
end

function Map:update(dt, l,t,w,h)
  l,t,w,h = l or 0, t or 0, w or self.width, h or self.height
  local visibleThings, len = self.world:queryRect(l, t-CameraY,w,h)

  self.mortalBox:update(dt)
  for i=1, len do
    visibleThings[i]:update(dt)
  end
end

function Map:draw(drawDebug, l,t,w,h)
  --if drawDebug then bump_debug.draw(self.world, l,t,w,h) end
    
  -- camera motion
	love.graphics.translate(0, CameraY)


   --- draw visible objects
  local visibleThings, len = self.world:queryRect(l, t-CameraY,w,h)

  --table.sort(visibleThings, sortByCreatedAt)

  for i=1, len do 
    visibleThings[i]:draw(drawDebug)
  end


  love.graphics.setFont (love.graphics.newFont (10))
  local font = love.graphics.getFont ()
  local scoreText = love.graphics.newText(font)

  scoreText:add( {{1,1,1}, "Score: " .. map.score }, 0, 0)    
  love.graphics.draw(scoreText, 450, t-CameraY) 
end


return Map;
