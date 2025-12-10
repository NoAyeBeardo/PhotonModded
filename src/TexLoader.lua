Tex = {}
TexSize = {}

local function RecursiveTextureScan(fldr,orig)
    orig = orig or fldr
    for i,v in ipairs(love.filesystem.getDirectoryItems(fldr)) do
        local fullpath = fldr .. "/" .. v
        if love.filesystem.getInfo(fullpath,"directory") then
            RecursiveTextureScan(fullpath,orig)
        else
            local tx = love.graphics.newImage(fullpath)
            -- we dont want the orig folder in the textures because yes
            if fullpath:sub(1,#orig+1) == orig .. "/" then
                fullpath = fullpath:sub(#orig+2)
            end
            if fullpath:sub(#fullpath-3) == ".png" then
                fullpath = fullpath:sub(1,#fullpath-4)
            end
            Tex[fullpath] = tx
            TexSize[fullpath] = {w = tx:getWidth(), h = tx:getHeight(), w2 = tx:getWidth()/2, h2 = tx:getHeight()/2, diagsize = math.sqrt(tx:getWidth()^2 + tx:getHeight()^2)}
        end
    end
end

RecursiveTextureScan("textures")