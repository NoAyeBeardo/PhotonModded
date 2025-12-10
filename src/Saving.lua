local gon = require('lib.GON')

function SaveKey(key)
    if key == "m" then
        love.system.setClipboardText(SavePhot2())
    elseif key == "k" then
        love.system.setClipboardText(SavePhot2(true))
    end
end

function SavePhot2(nolaser) -- very very very simple saving format
    local code = "Phot2;"
    code = code .. tostring(Grid.width)
    code = code .. ";" .. tostring(Grid.height)
    code = code .. ";"

    -- local savedpostoupd = {}

    local cells = {}

    for x = 1,Grid.width do
        for y = 1,Grid.height do
            local cell = GetNextCell(x,y)
            if cell.id ~= "empty" then
                cells[tostring(x) .. " " .. tostring(y)] = cell
            end
        end
    end

    -- local compressedgonPositionsToUpdate = love.data.encode("string","base64",love.data.compress("string","zlib",gon.encode(savedpostoupd),9))
    -- code = code .. compressedgonPositionsToUpdate .. ";"

    local goncells = gon.encode(cells) -- use Goose Object Notation (by me) to handle turning it into a string
    local compressedgoncells = love.data.encode("string","base64",love.data.compress("string","zlib",goncells,9))

    code = code .. compressedgoncells

    code = code .. ";"

    if nolaser then
        code = code .. love.data.encode("string","base64",love.data.compress("string","zlib",gon.encode({}),9)) .. ";"
    else
        code = code .. love.data.encode("string","base64",love.data.compress("string","zlib",gon.encode(Grid.lasercells),9)) .. ";"
    end


    return code
end

function LoadPhot2(code)
    local parts = Split(code,";")
    Grid = MakeGrid(tonumber(parts[2]),tonumber(parts[3]))
    -- local savedPositionsToUpdate = gon.decode(love.data.decompress("string","zlib",love.data.decode("string","base64",parts[4])))

    local cells = gon.decode(love.data.decompress("string","zlib",love.data.decode("string","base64",parts[4])))

    PositionsToUpdate = {}
    ButtonsToCheck = {}
    DigitalButtonsToCheck = {}

    if type(cells) ~= "table" then cells = {} end

    for k,v in pairs(cells) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        SetNextCell(pos[1],pos[2],v)
        SetCell(pos[1],pos[2],v)
        if UpdateFuncs[v.id] then
            PositionsToUpdate[tostring(pos[1]) .. " " .. tostring(pos[2])] = true
        end
        if v.id == "buttonback" then
            ButtonsToCheck[tostring(pos[1]) .. " " .. tostring(pos[2])] = true
        end
        if v.id == "digitalbuttonback" then
            DigitalButtonsToCheck[tostring(pos[1]) .. " " .. tostring(pos[2])] = true
        end
    end

    Grid.lasercells = gon.decode(love.data.decompress("string","zlib",love.data.decode("string","base64",parts[5])))
    Paused = true
    Overlay.components[3].tx = "play"

    SetupBackgrounds()
end

function LoadPhot1(code)
    local strs = Split(code,";")
    table.remove(strs,1)
    Grid = MakeGrid(EncodeNum.decode(strs[1]),EncodeNum.decode(strs[2]))
    local cellcode = love.data.decompress("string","zlib",love.data.decode("string","base64",strs[3]))
    local cc = Split(cellcode,"%)")
    local currentcell = 0
    local cells = {}
    PositionsToUpdate = {}
    for k,v in ipairs(cc) do
      local ccc = Split(v,";")
      if ccc[2] and ccc[1] then
        for i = 1,EncodeNum.decode(ccc[3]) do
            local data = {}
            if ccc[1] == "tile" then ccc[1] = "empty" end
            if ccc[1] == "colorconverterred" then ccc[1] = "converter" data.clr = {255,0,0} end
            if ccc[1] == "colorconvertergreen" then ccc[1] = "converter" data.clr = {0,255,0} end
            if ccc[1] == "colorconverterblue" then ccc[1] = "converter" data.clr = {0,0,255} end
            if ccc[1] == "emitter" then data.clr = {255,0,0} end
            if ccc[1] == "greenemitter" then ccc[1] = "emitter" data.clr = {0,255,0} end
            if ccc[1] == "blueemitter" then ccc[1] = "emitter" data.clr = {0,0,255} end
            if ccc[1] == "colorsplitter" then ccc[1] = "splitdouble" end
            data.id = ccc[1]
            data.rot = EncodeNum.decode(ccc[2])
            cells[#cells+1] = data
        end
      end
    end
    for y = 1,Grid.height do
      for x = 1,Grid.width do
        currentcell = currentcell + 1
        SetCell(x,y,cells[currentcell])
        SetNextCell(x,y,cells[currentcell])
        if UpdateFuncs[cells[currentcell].id] then
            PositionsToUpdate[tostring(x) .. " " .. tostring(y)] = true
        end
      end
    end
    Paused = true
    Overlay.components[3].tx = "play"

    SetupBackgrounds()
end