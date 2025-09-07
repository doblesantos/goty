local gameWidth, gameHeight = 540, 270

function GameOverUpdate()
	if love.keyboard.isDown('return') then
		map:resetMap()
	end
end

function GameoverDraw()
    love.graphics.setFont (love.graphics.newFont (50))
	font = love.graphics.getFont ()
    text = love.graphics.newText(font)
    height = font:getHeight( )

    text:add( {{1,1,1}, "Game Over"}, 0, 0)


	love.graphics.setFont (love.graphics.newFont (25))
	font2 = love.graphics.getFont ()
	text2 = love.graphics.newText(font2)

    text2:add( {{1,1,1}, "Enter to Replay"}, 0, 0)

	love.graphics.draw(text, 120, 50)
	love.graphics.draw(text2, 170, 200)
end


return {
	GameOverUpdate = GameOverUpdate,
	GameOverDraw = GameoverDraw
}
