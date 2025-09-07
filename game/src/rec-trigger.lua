
local class = require 'lib/middleclass'
local RecTrigger = class('RecTrigger', Entity)

function RecTrigger:initialize(world, x, y, width, height, type)
  Entity.initialize(self, world, x, y, width, height)
  self.type = type or 'trigger'
  self.indestructible = true
end

function RecTrigger:update(dt)
end

function RecTrigger:draw()
	-- love.graphics.setColor(1, 0, 0, 1)
	-- love.graphics.rectangle( "fill", self.x, self.y, self.width, self.height )
	-- love.graphics.setColor(1, 1, 1, 1)
end

function RecTrigger:destroy()
  Entity.destroy(self)
end

return RecTrigger;
