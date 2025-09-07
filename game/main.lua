require "lib/middleclass"
Push = require "lib/Push"
GameOver=require "src/game-over"
gameWidth, gameHeight = 540, 270

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
    if not map:isGameOver() then
	  map:update(dt,0,0,gameWidth,gameHeight)
	else 
	  GameOver.GameOverUpdate()
	end 

	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
end

function love.resize(w, h)
	Push:resize(w, h)
end

function love.draw(dt)
	Push:apply("start")
    
   
    if map:isGameOver() then
		love.graphics.clear(0.2,0.2,0.2,1);
		GameOver.GameOverDraw()
	else 
		love.graphics.clear(129/255,210/255,235/255,1);
		map:draw(dt, 0, 0, gameWidth, gameHeight);
	end
	
	Push:apply("end")
end
