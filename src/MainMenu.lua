function MainMenuRender()
    local sw,sh = love.graphics.getDimensions()
    love.graphics.setColor(0.2,0.2,0.2)
    love.graphics.rectangle("fill",0,0,sw,sh)

    love.graphics.setColor(1,1,1)
    local font = GetFont(120)
    love.graphics.setFont(font)
    love.graphics.draw(Tex["logotext"],sw/2,170,0,0.5,0.5,TexSize["logotext"].w2,TexSize["logotext"].h2)
    
    love.graphics.setColor(0.7,0,0)
    love.graphics.setLineWidth(7)
    love.graphics.rectangle("line",sw/2-125,sh/2-25,250,100,20,20)
    love.graphics.setColor(1,0.2,0.2)
    love.graphics.rectangle("fill",sw/2-125,sh/2-25,250,100,20,20)

    love.graphics.setColor(0.7,0,0)
    love.graphics.setLineWidth(7)
    love.graphics.rectangle("line",sw/2-62.5,sh/2+100,125,50,20,20)
    love.graphics.setColor(1,0.2,0.2)
    love.graphics.rectangle("fill",sw/2-62.5,sh/2+100,125,50,20,20)

    love.graphics.setColor(1,1,1)

    font = GetFont(100)
    love.graphics.setFont(font)

    local ptext = "Play!"
    love.graphics.print(ptext,sw/2,sh/2+20,0,1,1,font:getWidth(ptext)/2,font:getHeight()/2)

    local qtext = "Quit"
    love.graphics.print(qtext,sw/2-5,sh/2+123,0,0.5,0.5,font:getWidth(qtext)/2,font:getHeight()/2)
end

function MainMenuClick(x,y,b)
    local sw,sh = love.graphics.getDimensions()
    if b == 1 then
        if x >= (sw/2-125) and x <= (sw/2-125)+250 then
            if y >= (sh/2-25) and y <= (sh/2-25)+100 then
                CurrentScreen = "Grid"
                CanPlaceCells = false
                Grid = MakeGrid(100,100)
                PositionsToUpdate = {}
                ButtonsToCheck = {}
                DigitalButtonsToCheck = {}
            end
        end
        if x >= (sw/2-62.5) and x <= (sw/2-62.5)+125 then
            if y >= (sh/2+100) and y <= (sh/2+100)+50 then
                love.event.quit()
            end
        end
    end
end