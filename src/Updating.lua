local profile_file = "profile_updating.txt"
local function append_profile(name, duration)
    local f = io.open(profile_file, "a")
    if f then
        f:write(string.format("%s: %.6f\n", name, duration))
        f:close()
    end
end

-- Variables for TPS/MSPT display
local tps_tick_count = 0
local tps_accum_time = 0
local tps_last_log = love.timer.getTime()

TPS = 0
MSPT = 0


-- Project Save UI and Autosave (moved to SmallMenu.lua)
projectName = projectName or ""
showProjectBox = showProjectBox or false
autosaveTimer = autosaveTimer or 0
autosaveInterval = 60
projectFolder = projectFolder or nil

function SaveProjectNow()
    if not projectFolder then return end
    local dt = os.date("%Y-%m-%d_%H-%M-%S")
    local filename = string.format("%s/%s_%s.txt", projectFolder, projectName, dt)
    local saveData = SavePhot2 and SavePhot2() or "[NO SAVE FUNCTION]"
    love.filesystem.write(filename, saveData)

    -- Limit to 5 autosaves: delete oldest if more than 5
    local files = love.filesystem.getDirectoryItems(projectFolder)
    local autosaves = {}
    for _, fname in ipairs(files) do
        if fname:match("^" .. projectName .. "_.*%.txt$") then
            local info = love.filesystem.getInfo(projectFolder .. "/" .. fname)
            if info then
                table.insert(autosaves, {name=fname, modtime=info.modtime or 0})
            end
        end
    end
    table.sort(autosaves, function(a, b) return a.modtime < b.modtime end)
    while #autosaves > 5 do
        local toDelete = table.remove(autosaves, 1)
        love.filesystem.remove(projectFolder .. "/" .. toDelete.name)
    end
end

function love.update(dt)
    local start_time = love.timer.getTime()
    Delta = dt
    if CurrentScreen == "MainMenu" then 
        return 
    end
    CheckButtons()
    if love.mouse.isDown(1) then
        PlaceCell()
        if ClearCalculatePathCache then ClearCalculatePathCache() end
    end
    if love.mouse.isDown(2) then
        PlaceCell("empty")
        if ClearCalculatePathCache then ClearCalculatePathCache() end
    end

    -- If you have functions for destroy, paste, or cut, add:
    -- DestroyCell()
    -- if ClearCalculatePathCache then ClearCalculatePathCache() end
    -- PasteCells()
    -- if ClearCalculatePathCache then ClearCalculatePathCache() end
    -- CutCells()
    -- if ClearCalculatePathCache then ClearCalculatePathCache() end


    HandleCellUpdates(dt)
    CameraMovement(dt)
    RemoveTypeInHex()
    CameraInterpolate(dt)
    DragSelection()

    -- Autosave logic
    if not showProjectBox and projectFolder then
        autosaveTimer = autosaveTimer + dt
        if autosaveTimer >= autosaveInterval then
            SaveProjectNow()
            autosaveTimer = 0
        end
    end

    -- TPS and ms/tick calculation
    local now = love.timer.getTime()
    local tick_time = now - start_time
    tps_tick_count = tps_tick_count + 1
    tps_accum_time = tps_accum_time + tick_time
    if now - tps_last_log >= 1.0 then
        MSPT = (tps_accum_time / tps_tick_count) * 1000
        TPS = tps_tick_count / (now - tps_last_log)
        tps_tick_count = 0
        tps_accum_time = 0
        tps_last_log = now
    end
end

