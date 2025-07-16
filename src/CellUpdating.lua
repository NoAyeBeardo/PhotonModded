
Paused = false

-- Bitwise compatibility for LuaJIT and Lua 5.1
if not bit32 then
    local ok, bit = pcall(require, "bit")
    if ok and bit then
        bit32 = {}
        bit32.band = bit.band
        bit32.bor = bit.bor
        bit32.bxor = bit.bxor
        bit32.bnot = bit.bnot
    else
        error("bit32 and bit libraries are missing. Please install LuaBitOp or use Lua 5.2+.")
    end
end

local updatedelay = 0.05
local updatetimer = 0

PositionsToUpdate = {}

function PauseDetect(key)
    if key == "space" then Paused = not Paused if Paused then Overlay.components[3].tx = "play" else Overlay.components[3].tx = "pause" end end
    if key == "f" then DoTick() end

end

function HandleCellUpdates(dt)
    local delaytouse = updatedelay
    if not Paused then
        if love.keyboard.isDown(",") then delaytouse = delaytouse / 2 end
        if (love.keyboard.isDown(".") or (love.mouse.isDown(1) and Overlay.components[4]:pointonbutton(love.mouse.getX(),love.mouse.getY()))) then delaytouse = delaytouse / 4 end
        if love.keyboard.isDown("/") then delaytouse = delaytouse / 6 end

        if love.keyboard.isDown("z") then delaytouse = delaytouse * 2 end
        if love.keyboard.isDown("x") then delaytouse = delaytouse * 4 end
        if love.keyboard.isDown("c") then delaytouse = delaytouse * 6 end
        updatetimer = updatetimer + dt
    end
    while updatetimer >= delaytouse do
        updatetimer = updatetimer - delaytouse
        DoTick()
    end
end

function BaseGate(tile,x,y,check)
    local ron = ((tile.activity or {})[1] == true)
    local lon = ((tile.activity or {})[3] == true)

    local rclr = (tile.activityclr or {})[1]
    local lclr = (tile.activityclr or {})[3]
    
    local path = CalculatePath(x,y,tile.rot)
    local returned = check(lon,ron, lclr,rclr)
    if returned then
        if type(returned) == "table" then
            EmitLaser(path,returned)
        else
            EmitLaser(path,{255,0,0})
        end
    end
end

function ThreeInBaseGate(tile,x,y,check)
    local ron = ((tile.activity or {})[1] == true)
    local lon = ((tile.activity or {})[3] == true)
    local bon = ((tile.activity or {})[0] == true)

    local rclr = (tile.activityclr or {})[1]
    local lclr = (tile.activityclr or {})[3]
    local bclr = (tile.activityclr or {})[0]
    
    local path = CalculatePath(x,y,tile.rot)
    local returned = check(lon,ron,bon, lclr,rclr,bclr)
    if returned then
        if type(returned) == "table" then
            EmitLaser(path,returned)
        else
            EmitLaser(path,{255,0,0})
        end
    end
end

UpdateFuncs = {}

UpdateFuncs["emitter"] = function(cell,x,y)
    local path = CalculatePath(x,y,cell.rot)
    EmitLaser(path,cell.clr)
end

UpdateFuncs["andgate"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon, lclr,rclr,bclr)
        if lon and ron then
            if bon then
                return bclr
            else
                return true
            end
        end
    end)
end

UpdateFuncs["orgate"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon, lclr,rclr,bclr)
        if lon or ron then
            if bon then
                return bclr
            else
                return true
            end
        end
    end)
end

UpdateFuncs["xorgate"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon, lclr,rclr,bclr)
        if (lon and (not ron)) or ((not lon) and ron) then
            if bon then
                return bclr
            else
                return true
            end
        end
    end)
end

UpdateFuncs["nandgate"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon, lclr,rclr,bclr)
        if not (lon and ron) then
            if bon then
                return bclr
            else
                return true
            end
        end
    end)
end

UpdateFuncs["norgate"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon, lclr,rclr,bclr)
        if not (lon or ron) then
            if bon then
                return bclr
            else
                return true
            end
        end
    end)
end

UpdateFuncs["xnorgate"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon, lclr,rclr,bclr)
        if (lon and ron) or ((not lon) and (not ron)) then
            if bon then
                return bclr
            else
                return true
            end
        end
    end)
end

UpdateFuncs["notgate"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y, function(lon,ron,bon, lclr,rclr,bclr)
        if not bon then
            if ron or lon then
                local nclr = {0,0,0}
                if ron then
                    nclr[1] = nclr[1] + rclr[1]
                    nclr[2] = nclr[2] + rclr[2]
                    nclr[3] = nclr[3] + rclr[3]
                end
                if lon then
                    nclr[1] = nclr[1] + lclr[1]
                    nclr[2] = nclr[2] + lclr[2]
                    nclr[3] = nclr[3] + lclr[3]
                end
                if nclr[1] > 255 then nclr[1] = 255 end
                if nclr[2] > 255 then nclr[2] = 255 end
                if nclr[3] > 255 then nclr[3] = 255 end
                return nclr
            else
                return true
            end
        end
    end)
end

UpdateFuncs["delayer"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y, function (lon,ron,bon, lclr,rclr,bclr)
        if bon then
            if lon or ron then
                local nclr = {0,0,0}
                if ron then
                    nclr[1] = nclr[1] + rclr[1]
                    nclr[2] = nclr[2] + rclr[2]
                    nclr[3] = nclr[3] + rclr[3]
                end
                if lon then
                    nclr[1] = nclr[1] + lclr[1]
                    nclr[2] = nclr[2] + lclr[2]
                    nclr[3] = nclr[3] + lclr[3]
                end
                if nclr[1] > 255 then nclr[1] = 255 end
                if nclr[2] > 255 then nclr[2] = 255 end
                if nclr[3] > 255 then nclr[3] = 255 end
                return nclr
            else
                return bclr
            end
        end
    end)
end

UpdateFuncs["colorcomparator"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y,function (lon,ron,bon, lclr,rclr,bclr)
        if (ron and lon and lclr[1] == rclr[1] and lclr[2] == rclr[2] and lclr[3] == rclr[3]) then
            if bon then
                return bclr
            else
                return true
            end
        end
    end)
end

UpdateFuncs["colorcomparatorlesser"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y,function (lon,ron,bon, lclr,rclr,bclr)
        if ron and lon then
            local hexclr1 = lclr[3] + lclr[2]*256 + lclr[1]*65536
            local hexclr2 = rclr[3] + rclr[2]*256 + rclr[1]*65536
            if hexclr1 < hexclr2 then
                if bon then
                    return bclr
                else
                    return true
                end
            end
        end
    end)
end

UpdateFuncs["colorcomparatorgreater"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y,function (lon,ron,bon, lclr,rclr,bclr)
        if ron and lon then
            local hexclr1 = lclr[3] + lclr[2]*256 + lclr[1]*65536
            local hexclr2 = rclr[3] + rclr[2]*256 + rclr[1]*65536
            if hexclr1 > hexclr2 then
                if bon then
                    return bclr
                else
                    return true
                end
            end
        end
    end)
end

UpdateFuncs["colormixer"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y,function (lon,ron,bon, lclr,rclr,bclr)
        local nclr = {0,0,0}
        if lon then
            nclr[1] = nclr[1] + (lclr or {0,0,0})[1]
            nclr[2] = nclr[2] + (lclr or {0,0,0})[2]
            nclr[3] = nclr[3] + (lclr or {0,0,0})[3]
        end
        if ron then
            nclr[1] = nclr[1] + (rclr or {0,0,0})[1]
            nclr[2] = nclr[2] + (rclr or {0,0,0})[2]
            nclr[3] = nclr[3] + (rclr or {0,0,0})[3]
        end
        if bon then
            nclr[1] = nclr[1] + (bclr or {0,0,0})[1]
            nclr[2] = nclr[2] + (bclr or {0,0,0})[2]
            nclr[3] = nclr[3] + (bclr or {0,0,0})[3]
        end
        if lon or ron or bon then
            if nclr[1] > 255 then nclr[1] = 255 end
            if nclr[2] > 255 then nclr[2] = 255 end
            if nclr[3] > 255 then nclr[3] = 255 end
            return nclr
        else
            return false
        end
    end)
end

UpdateFuncs["colormixeravrg"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y,function (lon,ron,bon, lclr,rclr,bclr)
        local nclr = {0,0,0}
        if lon then
            nclr[1] = nclr[1] + (lclr or {0,0,0})[1]
            nclr[2] = nclr[2] + (lclr or {0,0,0})[2]
            nclr[3] = nclr[3] + (lclr or {0,0,0})[3]
        end
        if ron then
            nclr[1] = nclr[1] + (rclr or {0,0,0})[1]
            nclr[2] = nclr[2] + (rclr or {0,0,0})[2]
            nclr[3] = nclr[3] + (rclr or {0,0,0})[3]
        end
        if bon then
            nclr[1] = nclr[1] + (bclr or {0,0,0})[1]
            nclr[2] = nclr[2] + (bclr or {0,0,0})[2]
            nclr[3] = nclr[3] + (bclr or {0,0,0})[3]
        end
        if lon or ron or bon then
            local count = 0
            if lon then count = count + 1 end
            if ron then count = count + 1 end
            if bon then count = count + 1 end
            nclr[1] = nclr[1] / count
            nclr[2] = nclr[2] / count
            nclr[3] = nclr[3] / count
            return nclr
        else
            return false
        end
    end)
end

UpdateFuncs["colourfloor"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y, function (lon,ron,bon, lclr,rclr,bclr)
        if bon then
            local clr = {bclr[1],bclr[2],bclr[3]}
            clr[1] = math.floor(clr[1])
            clr[2] = math.floor(clr[2])
            clr[3] = math.floor(clr[3])
            return clr
        else
            return false
        end
    end)
end


UpdateFuncs["colourshiftleft"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y, function (lon,ron,bon, lclr,rclr,bclr)
        if bon then
            local clr = {bclr[1],bclr[2],bclr[3]}
            -- Shift left: R->G, G->B, B->R
            local shifted = {clr[2], clr[3], clr[1]}
            return shifted
        else
            return false
        end
    end)
end

UpdateFuncs["colourshiftright"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y, function (lon,ron,bon, lclr,rclr,bclr)
        if bon then
            local clr = {bclr[1],bclr[2],bclr[3]}
            -- Shift right: R<-B, G<-R, B<-G
            local shifted = {clr[3], clr[1], clr[2]}
            return shifted
        else
            return false
        end
    end)
end

UpdateFuncs["colormixersub"] = function (cell,x,y) -- subtractive color mixing is hardest here since screens use light which is additive
    ThreeInBaseGate(cell,x,y,function (lon,ron,bon, lclr,rclr,bclr) -- also lasers are light so it doesn't even make sense that this exists
        -- gonna "recycle" some old code for this because i am stupid af + this shit makes no sense to me
        if ron or lon or bon then
            local ncolor = {255,255,255}
            local colors = {}
            if lclr and lon then colors[#colors+1] = lclr end
            if rclr and ron then colors[#colors+1] = rclr end
            if bclr and bon then colors[#colors+1] = bclr end
            if #colors == 1 then
                ncolor = {colors[1][1],colors[1][2],colors[1][3]}
            elseif #colors == 2 then
                ncolor = {colors[1][1],colors[1][2],colors[1][3]}
                for i = 1,3 do
                    ncolor[i] = (ncolor[i] * colors[2][i])/255
                end
            elseif #colors == 3 then
                ncolor = {colors[1][1],colors[1][2],colors[1][3]}
                for i = 1,3 do
                    ncolor[i] = (ncolor[i] * colors[2][i] * colors[3][i])/65025
                end
            end
            return ncolor
        else
            return false
        end
    end)
end

local function color_bitwise_op(l, r, op)
    local res = {}
    for i = 1,3 do
        local a = math.floor(l[i] or 0)
        local b = math.floor(r[i] or 0)
        if op == "and" then
            res[i] = bit32.band(a, b)
        elseif op == "or" then
            res[i] = bit32.bor(a, b)
        elseif op == "xor" then
            res[i] = bit32.bxor(a, b)
        elseif op == "nand" then
            res[i] = bit32.band(bit32.bnot(bit32.band(a, b)), 0xFF)
        elseif op == "nor" then
            res[i] = bit32.band(bit32.bnot(bit32.bor(a, b)), 0xFF)
        elseif op == "xnor" then
            res[i] = bit32.band(bit32.bnot(bit32.bxor(a, b)), 0xFF)
        end
    end
    return res
end

-- Colour Binary Adder (per channel, 8-bit, floored)
local function color_binary_add(l, r)
    local res = {}
    for i = 1,3 do
        local a = math.floor(l[i] or 0)
        local b = math.floor(r[i] or 0)
        res[i] = bit32.band(a + b, 0xFF)
    end
    return res
end

-- Colour Binary Subtractor (per channel, 8-bit, floored, wraps like 8-bit unsigned)
local function color_binary_sub(l, r)
    local res = {}
    for i = 1,3 do
        local a = math.floor(l[i] or 0)
        local b = math.floor(r[i] or 0)
        res[i] = bit32.band(a - b, 0xFF)
    end
    return res
end
-- Colour Binary Adder Cell
UpdateFuncs["colouradd"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon,lclr,rclr,bclr)
        if lon and ron then
            return color_binary_add(lclr or {0,0,0}, rclr or {0,0,0})
        end
        return false
    end)
end

-- Colour Binary Subtractor Cell
UpdateFuncs["coloursub"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon,lclr,rclr,bclr)
        if lon and ron then
            return color_binary_sub(lclr or {0,0,0}, rclr or {0,0,0})
        end
        return false
    end)
end

UpdateFuncs["colourand"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon,lclr,rclr,bclr)
        if lon and ron then
            return color_bitwise_op(lclr or {0,0,0}, rclr or {0,0,0}, "and")
        end
        return false
    end)
end

UpdateFuncs["colouror"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon,lclr,rclr,bclr)
        if lon and ron then
            return color_bitwise_op(lclr or {0,0,0}, rclr or {0,0,0}, "or")
        end
        return false
    end)
end

UpdateFuncs["colourxor"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon,lclr,rclr,bclr)
        if lon and ron then
            return color_bitwise_op(lclr or {0,0,0}, rclr or {0,0,0}, "xor")
        end
        return false
    end)
end

UpdateFuncs["colournand"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon,lclr,rclr,bclr)
        if lon and ron then
            return color_bitwise_op(lclr or {0,0,0}, rclr or {0,0,0}, "nand")
        end
        return false
    end)
end

UpdateFuncs["colournor"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon,lclr,rclr,bclr)
        if lon and ron then
            return color_bitwise_op(lclr or {0,0,0}, rclr or {0,0,0}, "nor")
        end
        return false
    end)
end

UpdateFuncs["colourxnor"] = function(cell,x,y)
    ThreeInBaseGate(cell,x,y,function(lon,ron,bon,lclr,rclr,bclr)
        if lon and ron then
            return color_bitwise_op(lclr or {0,0,0}, rclr or {0,0,0}, "xnor")
        end
        return false
    end)
end

UpdateFuncs["pixel"] = function (cell,x,y)
    local ron = ((cell.activity or {})[1] == true)
    local lon = ((cell.activity or {})[3] == true)
    local bon = ((cell.activity or {})[0] == true)
    local fon = ((cell.activity or {})[2] == true)

    local rclr = (cell.activityclr or {})[1]
    local lclr = (cell.activityclr or {})[3]
    local bclr = (cell.activityclr or {})[0]
    local fclr = (cell.activityclr or {})[2]

    local rendercolor = {0,0,0}
    if ron then
        for i = 1,3 do
            rendercolor[i] = rendercolor[i] + rclr[i]
        end
    end
    if lon then
        for i = 1,3 do
            rendercolor[i] = rendercolor[i] + lclr[i]
        end
    end
    if bon then
        for i = 1,3 do
            rendercolor[i] = rendercolor[i] + bclr[i]
        end
    end
    if fon then
        for i = 1,3 do
            rendercolor[i] = rendercolor[i] + fclr[i]
        end
    end

    cell.rclr = rendercolor
end

UpdateFuncs["amplifier"] = function (cell,x,y)
    local bon = ((cell.activity or {})[0] == true)

    local bclr = (cell.activityclr or {})[0]

    local rendercolor = {0,0,0}
    if bon then
        for i = 1,3 do
            rendercolor[i] = rendercolor[i] + bclr[i]
        end
    end
    cell.rclr = rendercolor
end

UpdateFuncs["colorbrightener"] = function (cell,x,y) -- for older codes from testers
    ThreeInBaseGate(cell,x,y, function (lon,ron,bon, lclr,rclr,bclr)
        if bon then
            local nclr = {bclr[1],bclr[2],bclr[3]}
            nclr[1] = nclr[1] + 5
            nclr[2] = nclr[2] + 5
            nclr[3] = nclr[3] + 5
            if nclr[1] > 255 then nclr[1] = 255 end
            if nclr[2] > 255 then nclr[2] = 255 end
            if nclr[3] > 255 then nclr[3] = 255 end
            return nclr
        else
            return false
        end
    end)
end

UpdateFuncs["colordebrightener"] = function (cell,x,y) -- for older codes from testers
    ThreeInBaseGate(cell,x,y, function (lon,ron,bon, lclr,rclr,bclr)
        if bon then
            local nclr = {bclr[1],bclr[2],bclr[3]}
            nclr[1] = nclr[1] - 5
            nclr[2] = nclr[2] - 5
            nclr[3] = nclr[3] - 5
            if nclr[1] < 0 then nclr[1] = 0 end
            if nclr[2] < 0 then nclr[2] = 0 end
            if nclr[3] < 0 then nclr[3] = 0 end
            return nclr
        else
            return false
        end
    end)
end

UpdateFuncs["colorgrayscale"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y, function (lon,ron,bon, lclr,rclr,bclr)
        if bon then
            local clr = {bclr[1],bclr[2],bclr[3]}
            local gray = (clr[1]*0.299 + clr[2]*0.587 + clr[3]*0.114)
            clr = {gray,gray,gray}
            return clr
        else
            return false
        end
    end)
end

UpdateFuncs["colorinverter"] = function (cell,x,y)
    ThreeInBaseGate(cell,x,y, function (lon,ron,bon, lclr,rclr,bclr)
        if bon then
            local clr = {bclr[1],bclr[2],bclr[3]}
            clr = {255-clr[1],255-clr[2],255-clr[3]}
            return clr
        else
            return false
        end
    end)
end

function DoTick()
    SetupNextTick()

    for k,v in pairs(PositionsToUpdate) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        local cell = GetCell(pos[1],pos[2])
        if UpdateFuncs[cell.id] then
            UpdateFuncs[cell.id](cell,pos[1],pos[2])
        end
    end
end