Grid = {
    width = 0,
    height = 0,
    cells = {}
}

function BlankCell()
    return {
        id = "empty",
        rot = 0,
    }
end

function OnGrid(x,y,gr)
    if x >= 1 and x <= (gr or Grid).width then
        if y >= 1 and y <= (gr or Grid).height then
            return true
        end
    end
    return false
end

function GetLaserCell(x,y,gr)
    if OnGrid(x,y) then
        if (gr or Grid).lasercells[x] and (gr or Grid).lasercells[x][y] then
            return (gr or Grid).lasercells[x][y]
        end
    end
end

function GetCell(x,y,gr)
    if OnGrid(x,y) then
        return (gr or Grid).cells[x][y]
    end
end

function GetNextCell(x,y,gr)
    if OnGrid(x,y) then
        return (gr or Grid).nextcells[x][y]
    end
end

function SetCell(x,y,c,gr)
    if OnGrid(x,y) then
        (gr or Grid).cells[x][y] = c
        if UpdateFuncs[c.id] then
            PositionsToUpdate[tostring(x) .. " " .. tostring(y)] = true
        else
            PositionsToUpdate[tostring(x) .. " " .. tostring(y)] = nil
        end
        if c.id == "buttonback" then
            ButtonsToCheck[tostring(x) .. " " .. tostring(y)] = true
        else
            ButtonsToCheck[tostring(x) .. " " .. tostring(y)] = nil
        end
        if c.id == "digitalbuttonback" then
            DigitalButtonsToCheck[tostring(x) .. " " .. tostring(y)] = true
        else
            DigitalButtonsToCheck[tostring(x) .. " " .. tostring(y)] = nil
        end
    end
end

function SetNextCell(x,y,c,gr)
    if OnGrid(x,y) then
        (gr or Grid).nextcells[x][y] = c
        if UpdateFuncs[c.id] then
            PositionsToUpdate[tostring(x) .. " " .. tostring(y)] = true
        else
            PositionsToUpdate[tostring(x) .. " " .. tostring(y)] = nil
        end
        if c.id == "buttonback" then
            ButtonsToCheck[tostring(x) .. " " .. tostring(y)] = true
        else
            ButtonsToCheck[tostring(x) .. " " .. tostring(y)] = nil
        end
        if c.id == "digitalbuttonback" then
            DigitalButtonsToCheck[tostring(x) .. " " .. tostring(y)] = true
        else
            DigitalButtonsToCheck[tostring(x) .. " " .. tostring(y)] = nil
        end
    end
end

function AddLaserCell(x,y,c,gr)
    if OnGrid(x,y) then
        if not (gr or Grid).lasercells[x] then (gr or Grid).lasercells[x] = {} end
        if not (gr or Grid).lasercells[x][y] then (gr or Grid).lasercells[x][y] = {} end
        table.insert((gr or Grid).lasercells[x][y],c)
    end
end

function SetupNextTick(gr)
    local grid = (gr or Grid)
    grid.lasercells = {}
    -- grid.nextcells = {}
    -- for x = 1,grid.width do
    --     grid.lasercells[x] = {}
    --     grid.nextcells[x] = {}
    --     for y = 1,grid.height do
    --         grid.lasercells[x][y] = {}
    --         grid.nextcells[x][y] = table.copy(grid.cells[x][y])
    --         grid.nextcells[x][y].activity = {}
    --     end
    -- end

    for k,v in pairs(PositionsToUpdate) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        grid.cells[pos[1]][pos[2]] = table.copy(grid.nextcells[pos[1]][pos[2]])
        grid.nextcells[pos[1]][pos[2]].activity = {}
        grid.nextcells[pos[1]][pos[2]].activityclr = {}
    end
end

function CopyGridCells(w,h,cells)
    local copy = {}
    for x = 1,w do
        copy[x] = {}
        for y = 1,h do
            copy[x][y] = table.copy(cells[x][y])
        end
    end
end

function MakeGrid(w,h)
    local gr = {width = w, height = h, cells = {}, lasercells = {}, nextcells = {}}
    for x = 1,w do
        gr.cells[x] = {}
        gr.nextcells[x] = {}
        gr.lasercells[x] = {}
        for y = 1,h do
            gr.cells[x][y] = BlankCell()
            gr.nextcells[x][y] = BlankCell()
            gr.lasercells[x][y] = {}
        end
    end
    return gr
end