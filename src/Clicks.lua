function love.mousepressed(x,y,b)
    if CurrentScreen == "MainMenu" then
        MainMenuClick(x,y,b)
    elseif CurrentScreen == "Grid" then
        CellBarClick(x,y,b)
        Overlay:click()
        if InSmallMenu then SmallMenuContainer:click() end
        if b == 3 and CanPlaceCells then HandleCloneCell() end
    end
end

function love.mousereleased(x,y,b)
    if b == 1 then CanPlaceCells = true end
end