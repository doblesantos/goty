
local class = require 'lib/middleclass'
local Tile = class('Tile', Entity)

function Tile:initialize(world, x, y, width, height, quad, type, tilemap)
  Entity.initialize(self, world, x, y, width, height)
  self.quad = quad
  self.type = type or 'ground'
  self.indestructible = true
  self.tileset = tilemap
end

function Tile:update(dt)
end

function Tile:draw()   love.graphics.draw(self.tileset, self.quad, self.x, self.y)
end

function Tile:destroy()
  Entity.destroy(self)
end

return Tile;
