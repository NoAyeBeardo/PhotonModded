function PositionToAlignedPosition(x,y,ali)
    local w,h = love.graphics.getDimensions()
    if ali == "topleft" then
        return x,y
    elseif ali == "topright" then
        return w-x,y
    elseif ali == "bottomleft" then
        return x,h-y
    elseif ali == "bottomright" then
        return w-x,h-y
    elseif ali == "left" then
        return x,(h*0.5)+y
    elseif ali == "right" then
        return w-x,(h*0.5)+y
    elseif ali == "top" then
        return (w*0.5)+x,y
    elseif ali == "bottom" then
        return (w*0.5)+x,h-y
    elseif ali == "center" then
        return (w*0.5)+x,(h*0.5)+y
    end
    return x,y
end