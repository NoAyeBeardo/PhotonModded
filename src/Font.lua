local FontCache = {}

function GetFont(size)
    if not FontCache[size] then
        FontCache[size] = love.graphics.newFont("Nunito-Bold.ttf",size)
    end
    return FontCache[size]
end