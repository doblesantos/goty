
local class = require 'lib/middleclass'
local Entity = require 'src/entity'

local Player = class('Player', Entity)
Player.static.updateOrder = 1

function Player:initialize(world, x,y)

  local width = 24
  local height = 24

  Entity.initialize(self, world, x, y, width, height);
  self.onGround = false
  self.isJumping = false
  self.jumpVelocity = 5
  self.brakeAccel = 50
  self.speed = 10
  self.tilemap = love.graphics.newImage('assets/tilemap-characters.png')

  self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.tilemap:getWidth(), self.tilemap:getHeight())
end

function Player:moveColliding(dt)
  self.onGround = false
  local world = self.world

  local future_x = self.x + self.vx
  local future_y = self.y + self.vy 

  local next_x, next_y, cols, len = world:move(self, future_x, future_y, self.filter)

  for i=1, len do
    local col = cols[i]
	if(col.other.type == 'ground') then
		self.onGround = true
	end

    self:changeVelocityByCollisionNormal(col.normal.x, col.normal.y, 0)
    -- self:checkIfOnGround(col.normal.y)
  end

  self.x, self.y = next_x, next_y
end

function Player:changeVelocityByGravity(dt)
	if self.onGround then
		self.vy = 0
		self.isJumping = false
	else
		self.vy = self.vy + GravityAccel * dt
	end
  
  print(self.vy)
end

function Player:changeVelocityByKeys(dt)

  local vx, vy = self.vx, self.vy

  if love.keyboard.isDown("a") then
    vx = vx - dt * (vx > 0 and self.brakeAccel or self.speed)
  elseif love.keyboard.isDown("d") then
    vx = vx + dt * (vx < 0 and self.brakeAccel or self.speed)
  else
    local brake = dt * (vx < 0 and self.brakeAccel or -self.brakeAccel)
    if math.abs(brake) > math.abs(vx) then
      vx = 0
    else
      vx = vx + brake
    end
  end

  if love.keyboard.isDown("w") and self.onGround then
	print("jump")
	vy = -self.jumpVelocity
    self.isJumping = true
  end

  self.vx, self.vy = vx, vy
end

function Player:update(dt)
  self:changeVelocityByKeys(dt)
  self:changeVelocityByGravity(dt)

  self:moveColliding(dt)
end

function Player:draw()
	love.graphics.draw(self.tilemap, self.quad, self.x, self.y)
end

return Player
