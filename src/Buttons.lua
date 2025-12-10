ButtonsToCheck = {}
DigitalButtonsToCheck = {}

function CheckButtons()
    for k,v in pairs(ButtonsToCheck) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        GetCell(pos[1],pos[2]).pressed = false
    end

    for k,v in pairs(DigitalButtonsToCheck) do
        local pos = Split(k," ")
        pos[1] = tonumber(pos[1])
        pos[2] = tonumber(pos[2])
        local c = GetCell(pos[1],pos[2])
        if love.keyboard.isDown((c.key or "g")) then
            c.pressed = true
        else
            c.pressed = false
        end
    end


    if love.mouse.isDown(1) then
        local mx,my = love.mouse.getPosition()
        local gx,gy = ScreenToGrid(mx,my)
        for x = -math.floor(PlaceSize),math.ceil(PlaceSize) do
            for y = -math.floor(PlaceSize),math.ceil(PlaceSize) do
                if ButtonsToCheck[tostring(gx+x) .. " " .. tostring(gy+y)] then
                    GetCell(gx+x,gy+y).pressed = true
                end
            end
        end
    end
end