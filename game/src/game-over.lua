local gameWidth, gameHeight = 540, 270

function GameOverUpdate()
	if love.keyboard.isDown('return') then
		map:resetMap()
	end
end

function GameoverDraw()
    love.graphics.setFont (love.graphics.newFont (50))
	local font = love.graphics.getFont ()
    local text = love.graphics.newText(font)

    text:add( {{1,1,1}, "Game Over"}, 0, 0)

	love.graphics.draw(text, 120, 50)
   ----------------------
    love.graphics.setFont (love.graphics.newFont (25))
    local scoreText = love.graphics.newText(font)

    scoreText:add( {{1,1,1}, "Score: " .. map.score }, 0, 0)    


    love.graphics.draw(scoreText, 170, 125) 
	---------------
	love.graphics.setFont (love.graphics.newFont (25))
	local font2 = love.graphics.getFont ()
	local text2 = love.graphics.newText(font2)

    text2:add( {{1,1,1}, "Enter to Replay"}, 0, 0)
	love.graphics.draw(text2, 170, 200)
end


return {
	GameOverUpdate = GameOverUpdate,
	GameOverDraw = GameoverDraw
}
