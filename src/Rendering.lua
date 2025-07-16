CurrentScreen = "MainMenu"

ShowHexCodes = ShowHexCodes or false

function love.draw()
    if CurrentScreen == "MainMenu" then
        MainMenuRender()
    elseif CurrentScreen == "Grid" then
        RenderGrid(Grid)
        RenderPlacePoint()
        Overlay:draw()
        DrawCellBarButtons()
        if InSmallMenu then RenderSmallMenu() end
        -- Draw selection HUD and boolean indicator in the top right
        DrawSelectionHUD(Selection)
    end

    love.graphics.setColor(1,1,1)
    love.graphics.setFont(GetFont(10))
    -- Show FPS, TPS, MSPT, and time till next autosave
    local fps = 1 / Delta
    local tps = TPS or 0
    local mspt = MSPT or 0
    local timeToAutosave = ""
    if autosaveInterval and autosaveTimer then
        timeToAutosave = string.format("  Next autosave: %.1fs", math.max(0, (autosaveInterval - autosaveTimer)))
    end
    love.graphics.print(
        string.format("FPS: %.1f  TPS: %.1f  MSPT: %.2f%s", fps, tps, mspt, timeToAutosave),
        0, 0
    )
end