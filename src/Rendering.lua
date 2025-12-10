CurrentScreen = "MainMenu"

ShowHexCodes = ShowHexCodes or false

local Notification = {
    message = nil,
    timer = 0
}

function RenderNotification()
    if Notification.message and Notification.timer > 0 then
        print("RenderNotification: Displaying notification - " .. Notification.message) -- Debug log
        local screenWidth, screenHeight = love.graphics.getDimensions()
        local font = GetFont(12) -- Match the font size of the selection HUD
        love.graphics.setFont(font)
        love.graphics.setColor(1, 1, 1, 0.8) -- Match the semi-transparent white color
        local textWidth = font:getWidth(Notification.message)
        local textHeight = font:getHeight()
        local x = screenWidth - textWidth - 10 -- Align to the right with padding
        local y = screenHeight - textHeight - 10 -- Align to the bottom with padding
        love.graphics.print(Notification.message, x, y)
    end
end

function love.update(dt)
    if CurrentScreen == "MainMenu" then
        MainMenuUpdate()
    elseif CurrentScreen == "Grid" then
        UpdateGrid(Grid)
        UpdatePlacePoint()
        Overlay:update()
        UpdateCellBarButtons()
        if InSmallMenu then UpdateSmallMenu() end
    end

    -- Update notification timer
    if Notification.timer > 0 then
        Notification.timer = Notification.timer - dt
        if Notification.timer <= 0 then
            Notification.message = nil
        end
    end
end

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

    RenderNotification()
end