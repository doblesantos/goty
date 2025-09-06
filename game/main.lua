require "lib/middleclass"
Push = require "lib/Push"
local gameWidth, gameHeight = 540, 270

local windowWidth, windowHeight = love.window.getDesktopDimensions()
windowWidth, windowHeight = windowWidth*.5, windowHeight*.5


Map = require "src/map";


function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	Push:setupScreen(gameWidth, gameHeight, windowWidth, windowHeight, {
		fullscreen = false,
		resizable = true,
	  })

	map = Map:new()
end

function love.update(dt)
  map:update(dt,0,0,gameWidth,gameHeight)

  if love.keyboard.isDown("escape") then
	  love.event.quit()
  end
end

function love.resize(w, h)
	Push:resize(w, h)
end

function love.draw(dt)
	Push:apply("start")

	map:draw(dt,0,0,gameWidth,gameHeight);

	Push:apply("end")
end
