
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
  self.jumpVelocity = 3
  self.brakeAccel = 20
  self.speed = 10
  self.topXSpeed = 1;
  self.tilemap = love.graphics.newImage('assets/tilemap-characters.png')
  self.isDead = false
  self.quad = love.graphics.newQuad(0, 0, self.width, self.height, self.tilemap:getWidth(), self.tilemap:getHeight())

  self.jumpSFX = love.audio.newSource("assets/jump.wav", "static")
  self.stepSFX = love.audio.newSource("assets/step.wav", "static")
end

function Player:moveColliding(dt)
  self.onGround = false
  local world = self.world

  local future_x = self.x + self.vx
  local future_y = self.y + self.vy 

  local next_x, next_y, cols, len = world:move(self, future_x, future_y, self.filter)

  for i=1, len do
    local col = cols[i]

	if(col.other.type == 'mortalBox') then
		self.isDead = true
	end

	if(col.other.type == 'ground' and self.isJumping) then
		self.isJumping = false
		if CameraY < self.y and self.old_y ~= next_y then
	      map:moveCamera()
	      map:appendRandTileRow()
	      map:moveMortalBox()
	    end
	elseif(col.other.type == 'ground') then
		self.onGround = true
	    self.old_y = self.y
	end

    --self:changeVelocityByCollisionNormal(col.normal.x, col.normal.y, 0)
    -- self:checkIfOnGround(col.normal.y)
  end
  self.x, self.y = next_x, next_y
end

function Player:changeVelocityByGravity(dt)
	if self.onGround then
	elseif not self.onGround then
		self.vy = self.vy + GravityAccel * dt
	end
end

function Player:changeVelocityByKeys(dt)
  local vx, vy = self.vx, self.vy

  if love.keyboard.isDown("a") then
    vx = vx - dt * (vx > 0 and self.brakeAccel or self.speed)
	vx = vx < -self.topXSpeed and -self.topXSpeed or vx
	self.stepSFX:play()
  elseif love.keyboard.isDown("d") then
    vx = vx + dt * (vx < 0 and self.brakeAccel or self.speed)
	vx = vx > self.topXSpeed and self.topXSpeed or vx
	self.stepSFX:play()
  else
    local brake = dt * (vx < 0 and self.brakeAccel or -self.brakeAccel)
    if math.abs(brake) > math.abs(vx) then
      vx = 0
    else
      vx = vx + brake
    end
  end

  if love.keyboard.isDown("w") and self.onGround then
	vy = -self.jumpVelocity
    self.onGround  = false
	self.isJumping = true
	self.jumpSFX:play()
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
