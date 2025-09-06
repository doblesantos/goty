

-- pixels per second^2
local class = require 'lib/middleclass'
local Entity = class('Entity')
 GravityAccel  = 10 
function Entity:initialize(world, x, y, width, height)
    self.x = x
    self.y = y
	self.vx, self.vy = 0,0
    self.width = width
    self.height = height
	self.world = world
    self.world:add(self, x, y, width, height)
end

function Entity.update()
end

function Entity:draw()
   	love.graphics.setColor(1, 0, 0, 1)
	love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	love.graphics.setColor(1, 1, 1, 1)
end

function Entity:changeVelocityByGravity(dt)
end

function Entity:changeVelocityByCollisionNormal(nx, ny, bounciness)
  bounciness = bounciness or 0
  local vx, vy = self.vx, self.vy

  if (nx < 0 and vx > 0) or (nx > 0 and vx < 0) then
    vx = -vx * bounciness
  end

  if (ny < 0 and vy > 0) or (ny > 0 and vy < 0) then
    vy = -vy * bounciness
  end

  self.vx, self.vy = vx, vy
end

function Entity:destroy()
  self.world:remove(self)
end

return Entity;
