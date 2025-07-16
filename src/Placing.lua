CanPlaceCells = true
PlaceSize = 0
BetterPlacing = true

Selection = false
Copied = {}
CopiedLasers = {}
HasBeenSelecting = false
StartSelectPos = nil
EndSelectPos = nil
IsPasting = false

Selected = {id = "empty", rot = 0}

-- Selection HUD tracking
SelectionHUD = {
    active = false,
    x1 = nil, y1 = nil, x2 = nil, y2 = nil,
    cellCounts = {},
    area = 0,
    totalCells = 0,
    density = 0,
    width = 0,
    height = 0
}

function HandleCloneCell()
    local mx,my = love.mouse.getPosition()
    local gx,gy = ScreenToGrid(mx,my)
    if OnGrid(gx,gy) then
        local gcell = GetCell(gx,gy)
        Selected = {}
        Selected.id = gcell.id
        Selected.rot = gcell.rot
        if gcell.clr then
            Selected.clr = table.copy(gcell.clr)
        end
        if gcell.key then
            Selected.key = gcell.key
        end
    end
end

function RenderPlacePoint()
    local mx,my = love.mouse.getPosition()
    local gx,gy = ScreenToGrid(mx,my)
    if Selection then
        if StartSelectPos and EndSelectPos then
            local startx,starty = StartSelectPos[1],StartSelectPos[2]
            
            local rx,ry = GridToScreen(EndSelectPos[1],EndSelectPos[2])
            
            local startrx,startry = GridToScreen(startx,starty)
            
            love.graphics.setColor(1,1,1,0.2)

            --whatever lets do it different
            if rx < startrx then
                local e = startrx
                startrx = rx
                rx = e
            end
            if ry < startry then
                local e = startry
                startry = ry
                ry = e
            end
            local w,h = rx-startrx+(Cam.rzoom*CellSize),ry-startry+(Cam.rzoom*CellSize)
            love.graphics.rectangle("fill",startrx-(Cam.rzoom*CellSize)/2,startry-(Cam.rzoom*CellSize)/2,w,h)
        end
    elseif IsPasting then
        for k,v in pairs(CopiedLasers) do
            local pos = Split(k," ")
            pos[1] = tonumber(pos[1])
            pos[2] = tonumber(pos[2])
            local sx,sy = GridToScreen(pos[1]+gx,pos[2]+gy)
            for l,w in pairs(v) do
                love.graphics.setColor(1,1,1,0.4)
                DrawCell(w,sx,sy,Cam.rzoom)
            end
        end
        for k,v in pairs(Copied) do
            local pos = Split(k," ")
            pos[1] = tonumber(pos[1])
            pos[2] = tonumber(pos[2])
            local sx,sy = GridToScreen(pos[1]+gx,pos[2]+gy)
            love.graphics.setColor(1,1,1,0.4)
            DrawCell(v,sx,sy,Cam.rzoom)
        end
    else
        for x = -math.floor(PlaceSize),math.ceil(PlaceSize) do 
            for y = -math.floor(PlaceSize),math.ceil(PlaceSize) do
                local sx,sy = GridToScreen(gx+x,gy+y)
                love.graphics.setColor(1,1,1,0.4)
                DrawCell(Selected,sx,sy,Cam.rzoom)
            end
        end
    end
end

function PasteSelection()
    IsPasting = true
    Selection = false
    StartSelectPos = nil
    EndSelectPos = nil
    Overlay.components[2].tx = "selection"
    if ClearCalculatePathCache then ClearCalculatePathCache() end
end

function FlipSelectionHorizontally()
    local w = 0
    local h = 0

    for k,v in pairs(Copied) do -- get the width/height
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        if pos[1] > w then w = pos[1] end
        if pos[2] > h then h = pos[2] end
    end
    for k,v in pairs(CopiedLasers) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        if pos[1] > w then w = pos[1] end
        if pos[2] > h then h = pos[2] end
    end

    local nCopied = {}
    local nCopiedLasers = {}

    for k,v in pairs(Copied) do -- get the width/height
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        if v.id == "mirror" then
            v.rot = (v.rot+1)%4
        end

        if v.id == "splitleft" then
            v.id = "splitright"
            if v.rot == 0 or v.rot == 2 then
                v.rot = (v.rot+2)%4
            end
        elseif v.id == "splitright" then
            v.id = "splitleft"
            if v.rot == 0 or v.rot == 2 then
                v.rot = (v.rot+2)%4
            end
        elseif v.id ~= "mirror" and v.rot == 0 or v.rot == 2 then
            v.rot = (v.rot+2)%4
        end
        nCopied[tostring(w-pos[1]) .. " " .. tostring(pos[2])] = v
    end

    for k,v in pairs(CopiedLasers) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        local nv = {}
        for l,x in ipairs(v) do
            if x.id == "laser_bounce" then
                if (x.rot == 0 or x.rot == 2) then
                    x.rot = (x.rot+1)%4
                else
                    x.rot = (x.rot-1)%4
                end
            elseif x.id == "halflaser" and x.rot == 0 or x.rot == 2 then
                x.rot = (x.rot+2)%4
            end
            nv[l] = x
        end
        nCopiedLasers[tostring(w-pos[1]) .. " " .. tostring(pos[2])] = nv
    end

    Copied = nCopied
    CopiedLasers = nCopiedLasers
end

function RotateSelectionClockwise()
    local w = 0
    local h = 0

    for k,v in pairs(Copied) do -- get the width/height
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        if pos[1] > w then w = pos[1] end
        if pos[2] > h then h = pos[2] end
    end
    for k,v in pairs(CopiedLasers) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        if pos[1] > w then w = pos[1] end
        if pos[2] > h then h = pos[2] end
    end

    local nCopied = {}
    local nCopiedLasers = {}

    for k,v in pairs(Copied) do -- get the width/height
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        v.rot = (v.rot+1)%4
        nCopied[tostring(h-pos[2]) .. " " .. tostring(pos[1])] = v
    end

    for k,v in pairs(CopiedLasers) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        local nv = {}
        for l,x in ipairs(v) do
            x.rot = (x.rot+1)%4
            nv[l] = x
        end
        nCopiedLasers[tostring(h-pos[2]) .. " " .. tostring(pos[1])] = nv
    end

    Copied = nCopied
    CopiedLasers = nCopiedLasers
end

function RotateSelectionCounterClockwise()
    local w = 0
    local h = 0

    for k,v in pairs(Copied) do -- get the width/height
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        if pos[1] > w then w = pos[1] end
        if pos[2] > h then h = pos[2] end
    end
    for k,v in pairs(CopiedLasers) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        if pos[1] > w then w = pos[1] end
        if pos[2] > h then h = pos[2] end
    end

    local nCopied = {}
    local nCopiedLasers = {}

    for k,v in pairs(Copied) do -- get the width/height
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        v.rot = (v.rot-1)%4
        nCopied[tostring(pos[2]) .. " " .. tostring(w-pos[1])] = v
    end

    for k,v in pairs(CopiedLasers) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        local nv = {}
        for l,x in ipairs(v) do
            x.rot = (x.rot-1)%4
            nv[l] = x
        end
        nCopiedLasers[tostring(pos[2]) .. " " .. tostring(w-pos[1])] = nv
    end

    Copied = nCopied
    CopiedLasers = nCopiedLasers
end

function FlipSelectionVertically()
    local w = 0
    local h = 0

    for k,v in pairs(Copied) do -- get the width/height
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        if pos[1] > w then w = pos[1] end
        if pos[2] > h then h = pos[2] end
    end
    for k,v in pairs(CopiedLasers) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        if pos[1] > w then w = pos[1] end
        if pos[2] > h then h = pos[2] end
    end

    local nCopied = {}
    local nCopiedLasers = {}

    for k,v in pairs(Copied) do -- get the width/height
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        if v.id == "mirror" then
            v.rot = (v.rot+1)%4
        end

        if v.id == "splitleft" then
            v.id = "splitright"
            if v.rot == 1 or v.rot == 3 then
                v.rot = (v.rot+2)%4
            end
        elseif v.id == "splitright" then
            v.id = "splitleft"
            if v.rot == 1 or v.rot == 3 then
                v.rot = (v.rot+2)%4
            end
        elseif v.id ~= "mirror" then
            if v.rot == 1 or v.rot == 3 then
                v.rot = (v.rot+2)%4
            end
        end
        nCopied[tostring(pos[1]) .. " " .. tostring(h-pos[2])] = v
    end

    for k,v in pairs(CopiedLasers) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        local nv = {}
        for l,x in ipairs(v) do
            if x.id == "laser_bounce" then
                if (x.rot == 1 or x.rot == 3) then
                    x.rot = (x.rot+1)%4
                else
                    x.rot = (x.rot-1)%4
                end
            elseif x.id == "halflaser" and x.rot == 1 or x.rot == 3 then
                x.rot = (x.rot+2)%4
            end
            nv[l] = x
        end
        nCopiedLasers[tostring(pos[1]) .. " " .. tostring(h-pos[2])] = nv
    end

    Copied = nCopied
    CopiedLasers = nCopiedLasers
end

function CopySelection()
    if StartSelectPos and EndSelectPos then
        local startx,starty = StartSelectPos[1],StartSelectPos[2]
                
        local endx,endy = EndSelectPos[1], EndSelectPos[2]
            
        love.graphics.setColor(1,1,1,0.2)

        --whatever lets do it different
        if endx < startx then
            local e = endx
            endx = startx
            startx = e
        end
        if endy < starty then
            local e = endy
            endy = starty
            starty = e
        end

        Copied = {}
        CopiedLasers = {}

        for x = startx,endx do
            for y = starty,endy do
                if OnGrid(x,y) then
                    local c = table.copy(GetNextCell(x,y))
                    local lc = GetLaserCell(x,y)
                    if c.id ~= "empty" then
                        Copied[tostring(x-startx) .. " " .. tostring(y-starty)] = c
                    end
                    if lc then
                        CopiedLasers[tostring(x-startx) .. " " .. tostring(y-starty)] = table.copy(lc)
                    end
                end
            end
        end

        StartSelectPos = nil
        EndSelectPos = nil
    end
end

function CutSelection()
    if StartSelectPos and EndSelectPos then
        local startx,starty = StartSelectPos[1],StartSelectPos[2]
                
        local endx,endy = EndSelectPos[1],EndSelectPos[2]
            
        love.graphics.setColor(1,1,1,0.2)

        --whatever lets do it different
        if endx < startx then
            local e = endx
            endx = startx
            startx = e
        end
        if endy < starty then
            local e = endy
            endy = starty
            starty = e
        end

        Copied = {}
        CopiedLasers = {}

        for x = startx,endx do
            for y = starty,endy do
                if OnGrid(x,y) then
                    local c = table.copy(GetNextCell(x,y))
                    local lc = GetLaserCell(x,y)
                    if c.id ~= "empty" then
                        Copied[tostring(x-startx) .. " " .. tostring(y-starty)] = c
                    end
                    if lc then
                        CopiedLasers[tostring(x-startx) .. " " .. tostring(y-starty)] = table.copy(lc)
                    end
                    SetCell(x,y,BlankCell())
                    SetNextCell(x,y,BlankCell())
                    if Grid.lasercells[x] and Grid.lasercells[x][y] then Grid.lasercells[x][y] = nil end
                end
            end
        end

        StartSelectPos = nil
        EndSelectPos = nil
        if ClearCalculatePathCache then ClearCalculatePathCache() end
    end
end

function UpdateSelectionHUD()
    -- Only update if selecting
    if StartSelectPos and EndSelectPos then
        local startx, starty = StartSelectPos[1], StartSelectPos[2]
        local endx, endy = EndSelectPos[1], EndSelectPos[2]
        local minx, maxx = math.min(startx, endx), math.max(startx, endx)
        local miny, maxy = math.min(starty, endy), math.max(starty, endy)
        SelectionHUD.x1, SelectionHUD.y1 = minx, miny
        SelectionHUD.x2, SelectionHUD.y2 = maxx, maxy
        SelectionHUD.width = maxx - minx + 1
        SelectionHUD.height = maxy - miny + 1
        SelectionHUD.cellCounts = {}
        for x = minx, maxx do
            for y = miny, maxy do
                if OnGrid(x, y) then
                    local c = GetCell(x, y)
                    if c and c.id then
                        SelectionHUD.cellCounts[c.id] = (SelectionHUD.cellCounts[c.id] or 0) + 1
                    end
                end
            end
        end
        SelectionHUD.area = SelectionHUD.width * SelectionHUD.height
        local emptyCount = SelectionHUD.cellCounts["empty"] or 0
        SelectionHUD.totalCells = SelectionHUD.area - emptyCount
        SelectionHUD.density = 100 * SelectionHUD.totalCells / SelectionHUD.area
        SelectionHUD.active = true
    else
        SelectionHUD.active = false
    end
end

function DragSelection()
    if not Selection then return end
    if not CanPlaceCells then return end
    local mx,my = love.mouse.getPosition()
    local gx,gy = ScreenToGrid(mx,my)
    if love.mouse.isDown(1) then
        if not HasBeenSelecting then
            HasBeenSelecting = true
            StartSelectPos = {gx,gy}
        else
            EndSelectPos = {gx,gy}
        end
    else
        HasBeenSelecting = false
    end
end

-- Patch DragSelection to update SelectionHUD, but only if DragSelection is defined
if DragSelection then
    if not _old_DragSelection then
        _old_DragSelection = DragSelection
        function DragSelection(...)
            _old_DragSelection(...)
            UpdateSelectionHUD()
        end
    end
end

function PlaceCell(overwriteid)
    if Selection then return end
    if not CanPlaceCells then return end

    local mx,my = love.mouse.getPosition()
    local gx,gy = ScreenToGrid(mx,my)
    if IsPasting then
        for k,v in pairs(Copied) do
            local pos = Split(k," ")
            pos[1] = tonumber(pos[1])
            pos[2] = tonumber(pos[2])
            SetCell(pos[1]+gx,pos[2]+gy,table.copy(v))
            SetNextCell(pos[1]+gx,pos[2]+gy,table.copy(v))
        end
        for k,v in pairs(CopiedLasers) do
            local pos = Split(k," ")
            pos[1] = tonumber(pos[1])
            pos[2] = tonumber(pos[2])
            for l,w in pairs(v) do
                AddLaserCell(pos[1]+gx,pos[2]+gy,table.copy(w))
            end
        end
        CanPlaceCells = false
        IsPasting = false
        return
    end
    for x = -math.floor(PlaceSize),math.ceil(PlaceSize) do
        for y = -math.floor(PlaceSize),math.ceil(PlaceSize) do

            if OnGrid(gx+x,gy+y) then

                if (overwriteid and overwriteid ~= "empty") or ((not overwriteid) and Selected.id ~= "empty") then
                    if GetCell(gx+x,gy+y).id == "buttonback" then
                        return
                    end
                end

                if overwriteid then
                    local sel = table.copy(Selected)
                    sel.id = overwriteid
                    SetCell(gx+x,gy+y,sel,Grid)
                    SetNextCell(gx+x,gy+y,sel,Grid)

                    if UpdateFuncs[overwriteid] then
                        PositionsToUpdate[tostring(gx+x) .. " " .. tostring(gy+y)] = true
                    else
                        PositionsToUpdate[tostring(gx+x) .. " " .. tostring(gy+y)] = nil
                    end

                    if overwriteid == "buttonback" then
                        ButtonsToCheck[tostring(gx+x) .. " " .. tostring(gy+y)] = true
                    else
                        ButtonsToCheck[tostring(gx+x) .. " " .. tostring(gy+y)] = nil
                    end

                    if overwriteid == "digitalbuttonback" then
                        DigitalButtonsToCheck[tostring(gx+x) .. " " .. tostring(gy+y)] = true
                    else
                        DigitalButtonsToCheck[tostring(gx+x) .. " " .. tostring(gy+y)] = nil
                    end
                else
                    SetCell(gx+x,gy+y,table.copy(Selected),Grid)
                    SetNextCell(gx+x,gy+y,table.copy(Selected),Grid)

                    if UpdateFuncs[Selected.id] then
                        PositionsToUpdate[tostring(gx+x) .. " " .. tostring(gy+y)] = true
                    else
                        PositionsToUpdate[tostring(gx+x) .. " " .. tostring(gy+y)] = nil
                    end

                    if Selected.id == "buttonback" then
                        ButtonsToCheck[tostring(gx+x) .. " " .. tostring(gy+y)] = true
                    else
                        ButtonsToCheck[tostring(gx+x) .. " " .. tostring(gy+y)] = nil
                    end

                    if Selected.id == "digitalbuttonback" then
                        DigitalButtonsToCheck[tostring(gx+x) .. " " .. tostring(gy+y)] = true
                    else
                        DigitalButtonsToCheck[tostring(gx+x) .. " " .. tostring(gy+y)] = nil
                    end
                end
            end
            
        end
    end


end

function HandlePlaceSize(y)
    if love.keyboard.isDown("lctrl") then
        PlaceSize = PlaceSize + y*0.5
        if PlaceSize < 0 then PlaceSize = 0 end
    end
end