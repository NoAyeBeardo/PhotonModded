ShowHexCodes = false

Backgrounds = love.graphics.newSpriteBatch(Tex["empty"],nil,"static")

CellSize = 16
local hpi = math.pi/2

function ScreenToGrid(x,y)
    x = math.floor((x-Cam.rx)/Cam.rzoom/CellSize+0.5)
    y = math.floor((y-Cam.ry)/Cam.rzoom/CellSize+0.5)
    return x,y
end

function GridToScreen(x,y)
    x = x*CellSize*Cam.rzoom+Cam.rx
    y = y*CellSize*Cam.rzoom+Cam.ry
    return x,y
end

function SetupBackgrounds()
    Backgrounds:clear()
    for x = 1,Grid.width do
        for y = 1,Grid.height do
            Backgrounds:add((x-1)*CellSize,(y-1)*CellSize)
        end
    end
end

function DrawCell(cell,x,y,size)
    if cell.id == "laser" or cell.id == "halflaser" or cell.id == "laser_bounce" then
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(cell.clr[1]/255*r,cell.clr[2]/255*g,cell.clr[3]/255*b,a)
    end
    love.graphics.draw(Tex[cell.id],x,y,cell.rot*hpi,size,size,TexSize[cell.id].w2,TexSize[cell.id].h2)
    if cell.id == "emitter" then
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(cell.clr[1]/255*r,cell.clr[2]/255*g,cell.clr[3]/255*b,a)
        love.graphics.draw(Tex["emitterarrow"],x,y,cell.rot*hpi,size,size,TexSize[cell.id].w2,TexSize[cell.id].h2)
    elseif cell.id == "converter" then
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor(cell.clr[1]/255*r,cell.clr[2]/255*g,cell.clr[3]/255*b,a)
        love.graphics.draw(Tex["converterarrow"],x,y,cell.rot*hpi,size,size,TexSize[cell.id].w2,TexSize[cell.id].h2)
    elseif cell.id == "pixel" or cell.id == "amplifier" then
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor((cell.rclr or {0,0,0})[1]/255*r,(cell.rclr or {0,0,0})[2]/255*g,(cell.rclr or {0,0,0})[3]/255*b,a)
        love.graphics.draw(Tex["pixelclr"],x,y,cell.rot*hpi,size,size,TexSize[cell.id].w2,TexSize[cell.id].h2)
    elseif cell.id == "fullpixel" then
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor((cell.rclr or {0,0,0})[1]/255*r,(cell.rclr or {0,0,0})[2]/255*g,(cell.rclr or {0,0,0})[3]/255*b,a)
        love.graphics.draw(Tex["fullpixelclr"],x,y,cell.rot*hpi,size,size,TexSize[cell.id].w2,TexSize[cell.id].h2)
    elseif cell.id == "buttonback" then
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor((cell.clr or {255,0,0})[1]/255*r,(cell.clr or {255,0,0})[2]/255*g,(cell.clr or {255,0,0})[3]/255*b,a)
        if cell.pressed then
            love.graphics.draw(Tex["buttonpressed"],x,y,cell.rot*hpi,size,size,TexSize[cell.id].w2,TexSize[cell.id].h2)
        else
            love.graphics.draw(Tex["button"],x,y,cell.rot*hpi,size,size,TexSize[cell.id].w2,TexSize[cell.id].h2)
        end
    elseif cell.id == "digitalbuttonback" then
        local r,g,b,a = love.graphics.getColor()
        love.graphics.setColor((cell.clr or {255,0,0})[1]/255*r,(cell.clr or {255,0,0})[2]/255*g,(cell.clr or {255,0,0})[3]/255*b,a)
        if cell.pressed then
            love.graphics.draw(Tex["digitalbuttonpressed"],x,y,cell.rot*hpi,size,size,TexSize[cell.id].w2,TexSize[cell.id].h2)
        else
            love.graphics.draw(Tex["digitalbutton"],x,y,cell.rot*hpi,size,size,TexSize[cell.id].w2,TexSize[cell.id].h2)
        end

        -- render the key
        love.graphics.setColor(1*r,1*g,1*b)
        local font = GetFont(math.max(size*5,1))
        love.graphics.setFont(font)
        local key = cell.key or "g"
        local w = font:getWidth(key)
        local txtsize = math.min(1,(10*size)/w)
        local rx,ry = x,y
        local changenum = 0
        if cell.pressed then
            changenum = (size*1.5)
        else
            changenum = (size*2.5)
        end
        if cell.rot == 0 then
            ry = ry - changenum
        elseif cell.rot == 1 then
            rx = rx + changenum
        elseif cell.rot == 2 then
            ry = ry + changenum
        elseif cell.rot == 3 then
            rx = rx - changenum
        end
         love.graphics.print(key,rx,ry,cell.rot*hpi,txtsize,txtsize,w/2,font:getHeight()/2)
    end
end

function RenderGrid(gr)
    --local empties = love.graphics.newSpriteBatch(Tex["empty"])

    local sw,sh = love.graphics.getDimensions()

    local sx,sy = ScreenToGrid(0,0)
    local ex,ey = ScreenToGrid(sw,sh)

    if sx < 1 then sx = 1 end
    if sy < 1 then sy = 1 end
    if ex < 1 then ex = 1 end
    if ey < 1 then ey = 1 end

    if sx > gr.width then sx = gr.width end
    if sy > gr.height then sy = gr.height end
    if ex > gr.width then ex = gr.width end
    if ey > gr.height then ey = gr.height end
    
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(Backgrounds,Cam.rx+(CellSize/2*Cam.rzoom),Cam.ry+(CellSize/2*Cam.rzoom),0,Cam.rzoom,Cam.rzoom)

    for x = sx,ex do
        for y = sy,ey do
            local rx,ry = GridToScreen(x,y)
            --empties:add(rx,ry,0,Cam.rzoom,Cam.rzoom,TexSize["empty"].w2,TexSize["empty"].h2)

            local c = GetCell(x,y)

            if c.id ~= "empty" then
                love.graphics.setColor(0,0,0,0.25)
                DrawCell(c,rx+Cam.rzoom,ry+Cam.rzoom,Cam.rzoom)
            end

            if GetLaserCell(x,y) ~= nil then
                for i,v in ipairs(GetLaserCell(x,y)) do
                    love.graphics.setColor(1,1,1)
                    DrawCell(v,rx,ry,Cam.rzoom)
                end
            end

            if c.id ~= "empty" then
                love.graphics.setColor(1,1,1,1)
                DrawCell(c,rx,ry,Cam.rzoom)
                -- Show hex code if enabled and cell is emitter or pixel
                if ShowHexCodes and (c.id == "emitter" or c.id == "pixel") then
                    local clr = c.clr or c.rclr or {0,0,0}
                    local hex = string.format("#%02x%02x%02x", clr[1] or 0, clr[2] or 0, clr[3] or 0)
                    local font = GetFont(10)
                    love.graphics.setFont(font)
                    love.graphics.setColor(1,1,1,1)
                    -- Position text directly above the top-left pixel of the cell
                    local textHeight = font:getHeight()
                    local cellScreenX = rx - (CellSize * Cam.rzoom) / 2
                    local cellScreenY = ry - (CellSize * Cam.rzoom) / 2
                    love.graphics.print(hex, cellScreenX, cellScreenY - textHeight - 2)
                end
            end
        end
    end
    love.graphics.setColor(1,1,1,1)
end

-- HUD for selection info
function DrawSelectionHUD()
    local sel = SelectionHUD
    if not sel or not sel.active then
        -- Draw HUD status boolean in top right
        local sw, sh = love.graphics.getDimensions()
        local font = GetFont(14)
        love.graphics.setFont(font)
        local statusText = "HUD: false"
        love.graphics.setColor(1,1,1,1)
        local statusWidth = font:getWidth(statusText)
        local margin = 12
        love.graphics.print(statusText, sw - statusWidth - margin, margin)
        return
    end
    -- HUD is active
    local sw, sh = love.graphics.getDimensions()
    local font = GetFont(14)
    love.graphics.setFont(font)
    local statusText = "HUD: true"
    love.graphics.setColor(1,1,1,1)
    local statusWidth = font:getWidth(statusText)
    local margin = 12
    love.graphics.print(statusText, sw - statusWidth - margin, margin)
    -- Compose HUD lines
    local lines = {string.format("Selection: %dx%d", sel.width, sel.height)}
    if sel.area > 0 then
        table.insert(lines, string.format("Area: %d", sel.area))
    end
    if sel.totalCells > 0 then
        table.insert(lines, string.format("Total Cells: %d", sel.totalCells))
    end
    if sel.density > 0 then
        table.insert(lines, string.format("Density: %.2f" , sel.density) .. "%")
    end
    for id, count in pairs(sel.cellCounts) do
        if count > 0 then
            table.insert(lines, string.format("%s: %d", id, count))
        end
    end
    local hudWidth = 0
    for _, line in ipairs(lines) do
        local w = font:getWidth(line)
        if w > hudWidth then hudWidth = w end
    end
    local hudHeight = #lines * font:getHeight()
    local hudX = sw - hudWidth - margin
    local hudY = margin + font:getHeight() + 6
    love.graphics.setColor(0,0,0,0.7)
    love.graphics.rectangle("fill", hudX - 6, hudY - 6, hudWidth + 12, hudHeight + 12, 8, 8)
    love.graphics.setColor(1,1,1,1)
    for i, line in ipairs(lines) do
        love.graphics.print(line, hudX, hudY + (i-1)*font:getHeight())
    end
end