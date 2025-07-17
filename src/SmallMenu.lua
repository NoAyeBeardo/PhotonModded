
InSmallMenu = false
SmallMenuContainer = MakeUIContainer()

SmallMenuContainer:add(
    MakeButton("back",function() CurrentScreen = "MainMenu" InSmallMenu = false CanPlaceCells = false end, 0,150,64,64,"center"),
    MakeButton("savelevel",function() love.system.setClipboardText(SavePhot2()) CanPlaceCells = false end, -74,150,64,64,"center"),
    MakeButton("loadlevel",function()
        local code = love.system.getClipboardText()
        if code:sub(1,6) == "Phot2;" then
            LoadPhot2(code)
        elseif code:sub(1,6) == "Phot1;" then
            LoadPhot1(code)
        end
        CanPlaceCells = false
    end, 74,150,64,64,"center")
)

-- Project Save UI state
projectName = projectName or ""
showProjectBox = showProjectBox or false
autosaveTimer = autosaveTimer or 0
autosaveInterval = 60
projectFolder = projectFolder or nil

function DrawProjectBox()
    if not InSmallMenu then return end
    local sw, sh = love.graphics.getDimensions()
    -- Center the box at sw/2, 3/4 from the top
    local boxW, boxH = 400, 120
    local boxX = sw/2 - boxW/2
    local boxY = (sh * 3/4) - boxH/2
    -- Use menu background color
    love.graphics.setColor(0.2,0.2,0.2,0.9)
    love.graphics.rectangle("fill", boxX, boxY, boxW, boxH, 16, 16)
    -- Border
    love.graphics.setColor(0.4,0.4,0.4,1)
    love.graphics.rectangle("line", boxX, boxY, boxW, boxH, 16, 16)
    -- Title
    love.graphics.setColor(1,1,1,1)
    local font = GetFont(28)
    love.graphics.setFont(font)
    love.graphics.printf("Project Name:", boxX+20, boxY+10, boxW-40, "left")
    -- Textbox
    local tbY = boxY+45
    love.graphics.setColor(0.16,0.19,0.31,1)
    love.graphics.rectangle("fill", boxX+20, tbY, boxW-40, 36, 8, 8)
    love.graphics.setColor(0.28,0.33,0.43,1)
    love.graphics.rectangle("line", boxX+20, tbY, boxW-40, 36, 8, 8)
    love.graphics.setColor(1,1,1,1)
    local font2 = GetFont(24)
    love.graphics.setFont(font2)
    love.graphics.printf(projectName, boxX+30, tbY+6, boxW-60, "left")
    -- Enter and Clear buttons
    local btnW, btnH = 120, 36
    local btnX = boxX + boxW - btnW - 20
    local btnY = boxY + boxH - btnH - 10
    -- Clear button to the left of Enter
    local clrW, clrH = 80, 36
    local clrX = btnX - clrW - 10
    local clrY = btnY
    -- Draw Clear button
    love.graphics.setColor(0.16,0.19,0.31,1)
    love.graphics.rectangle("fill", clrX, clrY, clrW, clrH, 8, 8)
    love.graphics.setColor(0.28,0.33,0.43,1)
    love.graphics.rectangle("line", clrX, clrY, clrW, clrH, 8, 8)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(GetFont(22))
    love.graphics.printf("Clear", clrX, clrY+6, clrW, "center")
    -- Draw Enter button
    love.graphics.setColor(0.16,0.19,0.31,1)
    love.graphics.rectangle("fill", btnX, btnY, btnW, btnH, 8, 8)
    love.graphics.setColor(0.28,0.33,0.43,1)
    love.graphics.rectangle("line", btnX, btnY, btnW, btnH, 8, 8)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(GetFont(22))
    love.graphics.printf("Enter", btnX, btnY+6, btnW, "center")
end

local oldSmallMenuTextInput = love.textinput
function love.textinput(t)
    if InSmallMenu then
        projectName = projectName .. t
    elseif oldSmallMenuTextInput then
        oldSmallMenuTextInput(t)
    end
end

local oldSmallMenuKeyPressed = love.keypressed
function logProjectFolderAttempt(name)
    local dt = os.date("%Y-%m-%d %H:%M:%S")
    local msg = string.format("[%s] Attempt to create project folder: %s\n", dt, name)
    local old = love.filesystem.read("log.txt") or ""
    love.filesystem.write("log.txt", old .. msg)
end

function love.keypressed(key, scancode, rep)
    if InSmallMenu then
        if showProjectBox then
            -- Accept both key and scancode for robust backspace/enter/escape
            local k = key or scancode
            if k == "escape" or scancode == "escape" then
                showProjectBox = false
            elseif k == "backspace" or scancode == "backspace" then
                projectName = projectName:sub(1, -2)
            elseif k == "return" or k == "kpenter" or scancode == "return" or scancode == "kpenter" then
                if #projectName > 0 then
                    projectFolder = "projects/" .. projectName
                    logProjectFolderAttempt(projectName)
                    if not love.filesystem.getInfo("projects") then
                        love.filesystem.createDirectory("projects")
                    end
                    love.filesystem.createDirectory(projectFolder)
                    showProjectBox = false
                    SaveProjectNow()
                    autosaveTimer = 0
                end
            end
        else
            if (scancode or key) == "escape" then
                InSmallMenu = false
            end
            if oldSmallMenuKeyPressed then
                oldSmallMenuKeyPressed(key, scancode, rep)
            end
        end
    elseif oldSmallMenuKeyPressed then
        oldSmallMenuKeyPressed(key, scancode, rep)
    end
end

local oldSmallMenuMousePressed = love.mousepressed
function love.mousepressed(x, y, button)
    if InSmallMenu and button == 1 then
        local sw, sh = love.graphics.getDimensions()
        -- Center the box at sw/2, 3/4 from the top
        local boxW, boxH = 400, 120
        local boxX = sw/2 - boxW/2
        local boxY = (sh * 3/4) - boxH/2
        local btnW, btnH = 120, 36
        local btnX = boxX + boxW - btnW - 20
        local btnY = boxY + boxH - btnH - 10
        local clrW, clrH = 80, 36
        local clrX = btnX - clrW - 10
        local clrY = btnY
        -- Close Menu button (top right)
        local menuX, menuY, menuW, menuH = (sw/2)-300, (sh/2)-200, 600, 400
        local closeW, closeH = 120, 40
        local closeX = menuX + menuW - closeW - 20
        local closeY = menuY + 20

        -- If clicking the project box Enter button, handle as before
        if x >= btnX and x <= btnX+btnW and y >= btnY and y <= btnY+btnH then
            if #projectName > 0 then
                projectFolder = "projects/" .. projectName
                logProjectFolderAttempt(projectName)
                if not love.filesystem.getInfo("projects") then
                    love.filesystem.createDirectory("projects")
                end
                love.filesystem.createDirectory(projectFolder)
                showProjectBox = false
                SaveProjectNow()
                autosaveTimer = 0
            end
        -- If clicking the Clear button
        elseif x >= clrX and x <= clrX+clrW and y >= clrY and y <= clrY+clrH then
            projectName = ""
        -- If clicking the Close Menu button
        elseif x >= closeX and x <= closeX+closeW and y >= closeY and y <= closeY+closeH then
            InSmallMenu = false
        else
            -- Otherwise, let the SmallMenuContainer handle button clicks
            SmallMenuContainer:click()
        end
    elseif oldSmallMenuMousePressed then
        oldSmallMenuMousePressed(x, y, button)
    end
end

function SmallMenuToggle(key, scancode)
    local k = key or scancode
    if k == "escape" then
        InSmallMenu = not InSmallMenu
    end
end

function RenderSmallMenu()
    local sw,sh = love.graphics.getDimensions()
    local menuX, menuY, menuW, menuH = (sw/2)-300, (sh/2)-200, 600, 400
    love.graphics.setColor(0.2,0.2,0.2,0.5)
    love.graphics.rectangle("fill", menuX, menuY, menuW, menuH, 100, 100)
    local font = GetFont(50)
    love.graphics.setFont(font)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print("Menu", (sw/2), (sh/2)-200, 0, 1, 1, font:getWidth("Menu")/2)

    -- Close Menu button (top right)
    local closeW, closeH = 120, 40
    local closeX = menuX + menuW - closeW - 20
    local closeY = menuY + 20
    love.graphics.setColor(0.16,0.19,0.31,1)
    love.graphics.rectangle("fill", closeX, closeY, closeW, closeH, 12, 12)
    love.graphics.setColor(0.28,0.33,0.43,1)
    love.graphics.rectangle("line", closeX, closeY, closeW, closeH, 12, 12)
    love.graphics.setColor(1,1,1,1)
    love.graphics.setFont(GetFont(22))
    love.graphics.printf("Close", closeX, closeY+8, closeW, "center")

    font = GetFont(30)
    love.graphics.setFont(font)
    love.graphics.print("Credits:", (sw/2), (sh/2)-200+50, 0, 1, 1, font:getWidth("Credits:")/2)

    local cr = "Code by Blendi Goose\nTextures by k_lemon\nMod by NoAyeBeardo"
    love.graphics.print(cr, (sw/2), (sh/2)-100, 0, 1, 1, font:getWidth(cr)/2)

    SmallMenuContainer:draw()
    DrawProjectBox()
end
