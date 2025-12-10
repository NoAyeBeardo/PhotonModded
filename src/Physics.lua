local profile_file = "profile_calculatepath.txt"
local function append_profile(name, duration)
    local f = io.open(profile_file, "a")
    if f then
        f:write(string.format("%s: %.6f\n", name, duration))
        f:close()
    end
end

function NextCell(x,y,dir)
    if dir == 0 then
        x = x + 1
    elseif dir == 1 then
        y = y + 1
    elseif dir == 2 then
        x = x - 1
    elseif dir == 3 then
        y = y - 1
    end
    return x,y
end

local calculatepath_cache = {}

-- Simple cache key (as before, using comma separation)
local function make_cache_key(x, y, dir, clr)
    return tostring(x) .. "," .. tostring(y) .. "," .. tostring(dir) .. "," .. tostring(clr or "unset")
end

function ClearCalculatePathCache()
    calculatepath_cache = {}
end

function CalculatePath(x, y, dir, startclr)
    local clr = startclr or "unset"
    local cache_key = make_cache_key(x, y, dir, clr)
    local cached = calculatepath_cache[cache_key]
    if cached then
        -- Return a shallow copy (no deepcopy)
        return {
            render = {unpack(cached.render)},
            hits = {unpack(cached.hits)}
        }
    end

    local cx, cy = x, y
    local cdir = dir
    local renderpath = {}
    local mirroractives = {}
    local endposes = {}

    table.insert(renderpath, {cx, cy, (cdir + 2) % 4, clr, "halflaser"})
    while true do -- just break if you need to get out of the loop
        cx, cy = NextCell(cx, cy, cdir)
        if not OnGrid(cx, cy) then
            break
        end
        local ccell = GetCell(cx, cy)
        if ccell.id == "empty" then
            table.insert(renderpath, {cx, cy, cdir, clr, "laser"})
        elseif ccell.id == "wall" then
            break
        elseif ccell.id == "mirror" then -- crazy bouncing logic
            local rdir = cdir
            local side = (ccell.rot - cdir) % 4
            if side % 2 ~= 0 then
                rdir = (rdir - 1) % 4
            end
            if side % 2 == 0 then
                cdir = (cdir - 1) % 4
            else
                cdir = (cdir + 1) % 4
            end
            if ccell.mirroractive == nil then ccell.mirroractive = {} end
            table.insert(mirroractives, {cx, cy, cdir})
            table.insert(renderpath, {cx, cy, rdir, clr, "laser_bounce"})
        elseif ccell.id == "converter" then
            local side = (ccell.rot - cdir) % 4
            if side == 0 then
                clr = ccell.clr
            else
                break
            end
        elseif ccell.id == "amplifier" then -- separate because we want the laser to survive afterward
            local side = (ccell.rot - cdir) % 4
            table.insert(endposes, {cx, cy, side, cdir, clr})
            table.insert(renderpath, {cx, cy, cdir, clr, "halflaser"})
        elseif ccell.id == "splittriple" then
            local side = (ccell.rot - cdir) % 4
            if side == 0 then
                do
                    local path = CalculatePath(cx, cy, (ccell.rot - 1) % 4, clr)
                    for i, v in ipairs(path.render) do
                        table.insert(renderpath, v)
                    end
                    for i, v in ipairs(path.hits) do
                        table.insert(endposes, v)
                    end
                end
                do
                    local path = CalculatePath(cx, cy, (ccell.rot + 1) % 4, clr)
                    for i, v in ipairs(path.render) do
                        table.insert(renderpath, v)
                    end
                    for i, v in ipairs(path.hits) do
                        table.insert(endposes, v)
                    end
                end
            else
                break
            end
        elseif ccell.id == "splitdouble" then
            local side = (ccell.rot - cdir) % 4
            if side == 0 then
                do
                    local path = CalculatePath(cx, cy, (ccell.rot - 1) % 4, clr)
                    for i, v in ipairs(path.render) do
                        table.insert(renderpath, v)
                    end
                    for i, v in ipairs(path.hits) do
                        table.insert(endposes, v)
                    end
                end
                do
                    local path = CalculatePath(cx, cy, (ccell.rot + 1) % 4, clr)
                    for i, v in ipairs(path.render) do
                        table.insert(renderpath, v)
                    end
                    for i, v in ipairs(path.hits) do
                        table.insert(endposes, v)
                    end
                end
            end
            break
        elseif ccell.id == "splitleft" then
            local side = (ccell.rot - cdir) % 4
            if side == 0 then
                do
                    local path = CalculatePath(cx, cy, (ccell.rot - 1) % 4, clr)
                    for i, v in ipairs(path.render) do
                        table.insert(renderpath, v)
                    end
                    for i, v in ipairs(path.hits) do
                        table.insert(endposes, v)
                    end
                end
            else
                break
            end
        elseif ccell.id == "splitright" then
            local side = (ccell.rot - cdir) % 4
            if side == 0 then
                do
                    local path = CalculatePath(cx, cy, (ccell.rot + 1) % 4, clr)
                    for i, v in ipairs(path.render) do
                        table.insert(renderpath, v)
                    end
                    for i, v in ipairs(path.hits) do
                        table.insert(endposes, v)
                    end
                end
            else
                break
            end
        elseif ccell.id == "oneway" then
            local side = (ccell.rot - cdir) % 4
            if side ~= 0 then
                break
            end
        elseif (ccell.id == "tunnel" or ccell.id == "voidtunnel" or ccell.id == "blacktunnel") then
            local side = (ccell.rot - cdir) % 4
            if side == 0 then
                local ccx, ccy = cx, cy
                local depth = 1
                while depth > 0 do
                    ccx, ccy = NextCell(ccx, ccy, cdir)
                    if OnGrid(ccx, ccy) then
                        local cccell = GetCell(ccx, ccy)
                        if cccell.id == "tunnel" or cccell.id == "voidtunnel" or cccell.id == "blacktunnel" then
                            if cccell.rot == cdir then
                                depth = depth + 1
                            elseif ((cccell.rot + 2) % 4) == cdir then
                                depth = depth - 1
                            end
                        end
                    else
                        break
                    end
                end
                if depth <= 0 then
                    cx = ccx
                    cy = ccy
                else
                    break
                end
            else
                break
            end
        elseif ccell.id == "buttonback" or ccell.id == "digitalbuttonback" then
            if not ccell.pressed then
                break
            end
        else
            local side = (ccell.rot - cdir) % 4
            table.insert(endposes, {cx, cy, side, cdir, clr})
            table.insert(renderpath, {cx, cy, cdir, clr, "halflaser"})
            break
        end
    end
    if OnGrid(cx, cy) then
        table.insert(renderpath, {cx, cy, cdir, clr, "halflaser"})
    end

    local result = {render = renderpath, hits = endposes}
    calculatepath_cache[cache_key] = {
        render = {unpack(renderpath)},
        hits = {unpack(endposes)}
    }
    return result
end

function EmitLaser(path,clr)
    for i,v in ipairs(path.render) do
        local rclr = v[4]
        if v[4] == "unset" then
            rclr = clr
        end
        AddLaserCell(v[1],v[2],{rot = v[3], clr = rclr, id = v[5]})
    end
    for i,v in ipairs(path.hits) do
        local cx,cy,side,cdir,cclr = v[1],v[2],v[3],v[4],v[5]
        if cclr == "unset" then cclr = clr end
        local ccell = GetNextCell(cx, cy)
        if ccell.activity == nil then ccell.activity = {} end
        if ccell.activityclr == nil then ccell.activityclr = {} end
        ccell.activity[side] = true
        ccell.activityclr[side] = cclr
    end
end

-- Reminder: Call ClearCalculatePathCache() whenever the grid changes!
