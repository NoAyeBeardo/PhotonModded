local HexClr = "7d7d7d"
local InpKey = "g"
TypeInHex = false
DetectInp = false

Bar = { -- all the data the cell bar needs to exist
    {
        name = "Emitters",
        icon = {id = "emitter", rot = 0, clr = {255,0,0}},
        cells = {
            {name = "White Emitter", cell = {id = "emitter", rot = 0, clr = {255,255,255}}},
            {name = "Black Emitter", cell = {id = "emitter", rot = 0, clr = {0,0,0}}},
            {name = "Cyan Emitter", cell = {id = "emitter", rot = 0, clr = {0,255,255}}},
            {name = "Yellow Emitter", cell = {id = "emitter", rot = 0, clr = {255,255,0}}},
            {name = "Magenta Emitter", cell = {id = "emitter", rot = 0, clr = {255,0,255}}},
            {name = "Blue Emitter", cell = {id = "emitter", rot = 0, clr = {0,0,255}}},
            {name = "Green Emitter", cell = {id = "emitter", rot = 0, clr = {0,255,0}}},
            {name = "Red Emitter", cell = {id = "emitter", rot = 0, clr = {255,0,0}}},
            {name = "Custom Emitter", cell = {id = "emitter", rot = 0, clr = {125,125,125}}},
        }
    },
    {
        name = "Converters",
        icon = {id = "converter", rot = 0, clr = {255,0,0}},
        cells = {
            {name = "White Converter", cell = {id = "converter", rot = 0, clr = {255,255,255}}},
            {name = "Black Converter", cell = {id = "converter", rot = 0, clr = {0,0,0}}},
            {name = "Cyan Converter", cell = {id = "converter", rot = 0, clr = {0,255,255}}},
            {name = "Yellow Converter", cell = {id = "converter", rot = 0, clr = {255,255,0}}},
            {name = "Magenta Converter", cell = {id = "converter", rot = 0, clr = {255,0,255}}},
            {name = "Blue Converter", cell = {id = "converter", rot = 0, clr = {0,0,255}}},
            {name = "Green Converter", cell = {id = "converter", rot = 0, clr = {0,255,0}}},
            {name = "Red Converter", cell = {id = "converter", rot = 0, clr = {255,0,0}}},
            {name = "Custom Converter", cell = {id = "converter", rot = 0, clr = {125,125,125}}},
        }
    },
    {
        name = "Laser Manipulation",
        icon = {id = "mirror", rot = 0},
        cells = {
            {name = "Wall", cell = {id = "wall", rot = 0}},
            {name = "Mirror", cell = {id = "mirror", rot = 0}},
            {name = "Double Splitter", cell = {id = "splitdouble", rot = 0}},
            {name = "Left Double Splitter", cell = {id = "splitleft", rot = 0}},
            {name = "Right Double Splitter", cell = {id = "splitright", rot = 0}},
            {name = "Triple Splitter", cell = {id = "splittriple", rot = 0}},
            {name = "One-Way", cell = {id = "oneway", rot = 0}},
            {name = "Tunnel", cell = {id = "tunnel", rot = 0}},
        }
    },
    {
        name = "Logic Gates",
        icon = {id = "andgate", rot = 0},
        cells = {
            {name = "AND Gate", cell = {id = "andgate", rot = 0}},
            {name = "OR Gate", cell = {id = "orgate", rot = 0}},
            {name = "XOR Gate", cell = {id = "xorgate", rot = 0}},
            {name = "NAND Gate", cell = {id = "nandgate", rot = 0}},
            {name = "NOR Gate", cell = {id = "norgate", rot = 0}},
            {name = "XNOR Gate", cell = {id = "xnorgate", rot = 0}},
            {name = "NOT Gate", cell = {id = "notgate", rot = 0}},
            {name = "Delayer", cell = {id = "delayer", rot = 0}}
        }
    },
    {
        name = "Colour Handling",
        icon = {id = "colormixer", rot = 0},
        cells = {
            {name = "Colour Comparator Equals", cell = {id = "colorcomparator", rot = 0}},
            {name = "Colour Comparator Lesser", cell = {id = "colorcomparatorlesser", rot = 0}},
            {name = "Colour Comparator Greater", cell = {id = "colorcomparatorgreater", rot = 0}},
            {name = "Additive Colour Mixer", cell = {id = "colormixer", rot = 0}},
            {name = "Subtractive Colour Mixer", cell = {id = "colormixersub", rot = 0}},
            {name = "Averaged Colour Mixer", cell = {id = "colormixeravrg", rot = 0}},
            {name = "Pixel", cell = {id = "pixel", rot = 0}},
            {name = "Amplifier", cell = {id = "amplifier", rot = 0}},
            {name = "Colour Grayscale", cell = {id = "colorgrayscale", rot = 0}},
            {name = "Colour Inverter", cell = {id = "colorinverter", rot = 0}},
            {name = "Colour Floor", cell = {id = "colourfloor", rot = 0}},
            {name = "Colour Shift Left", cell = {id = "colourshiftleft", rot = 0}},
            {name = "Colour Shift Right", cell = {id = "colourshiftright", rot = 0}},
        }
    },
    {
        name = "Colour Logic",
        icon = {id = "colourand", rot = 0},
        cells = {
            {name = "Colour AND", cell = {id = "colourand", rot = 0}},
            {name = "Colour OR", cell = {id = "colouror", rot = 0}},
            {name = "Colour XOR", cell = {id = "colourxor", rot = 0}},
            {name = "Colour NAND", cell = {id = "colournand", rot = 0}},
            {name = "Colour NOR", cell = {id = "colournor", rot = 0}},
            {name = "Colour XNOR", cell = {id = "colourxnor", rot = 0}},
            {name = "Colour Add", cell = {id = "colouradd", rot = 0}},
            {name = "Colour Subtract", cell = {id = "coloursub", rot = 0}}
        }
    },
    {
        name = "Input",
        icon = {id = "buttonback", rot = 0},
        cells = {
            {name = "Click Button", cell = {id = "buttonback", rot = 0}},
            {name = "Key Button", cell = {id = "digitalbuttonback", rot = 0}},
        }
    },
    {
        name = "Visual",
        icon = {id = "void", rot = 0},
        cells = {
            {name = "Void", cell = {id = "void", rot = 0}},
            {name = "Black Void", cell = {id = "blackvoid", rot = 0}},
            {name = "Void Tunnel", cell = {id = "voidtunnel", rot = 0}},
            {name = "Black Tunnel", cell = {id = "blacktunnel", rot = 0}},
            {name = "Full Pixel", cell = {id = "fullpixel", rot = 0}},
        }
    }
}

local currentopened = 0

function CheckCellBarCollide(px,py,num)
    local sh = love.graphics.getHeight()
    if py >= sh-72 and py <= sh-24 then
        if px >= num*64-24 and px <= num*64+24 then
            return true
        end
    end
    return false
end

function CheckCellBarSubCellCollide(px,py,num,subnum)
    if px >= num*64-16 and px <= num*64+16 then
        local subcell = love.graphics.getHeight()-48-(subnum*48)
        if py >= subcell-16 and py <= subcell+16 then
           return true 
        end
    end
    return false
end

function RemoveTypeInHex()
    if not (Selected == Bar[1].cells[9].cell or Selected == Bar[2].cells[9].cell or Selected == Bar[6].cells[1].cell or Selected == Bar[6].cells[2].cell) then
        TypeInHex = false
    end
    if not (Selected == Bar[6].cells[2].cell) then
        DetectInp = false
    end
end

function DrawCellBarButtons()
    local sw,sh = love.graphics.getDimensions()
    local hover = nil
    for i,v in ipairs(Bar) do
        love.graphics.setColor(1,1,1)
        local mx,my = love.mouse.getPosition()
        if CheckCellBarCollide(mx,my,i) then
            if love.mouse.isDown(1) then
                love.graphics.setColor(0.5,0.5,0.5,1)
            else
                love.graphics.setColor(1,1,1,1)
            end
            hover = v.name
        else
            love.graphics.setColor(1,1,1,0.5)
        end
        v.icon.rot = Selected.rot
        DrawCell(v.icon,i*64,love.graphics.getHeight()-48,3)
        if currentopened == i then
            for j,subcell in ipairs(v.cells) do
                if CheckCellBarSubCellCollide(mx,my,i,j) then
                    if love.mouse.isDown(1) then
                        love.graphics.setColor(0.5,0.5,0.5,1)
                    else
                        love.graphics.setColor(0.8,0.8,0.8,1)
                    end
                    hover = subcell.name
                else
                    love.graphics.setColor(1,1,1,0.5)
                end
                if subcell.cell.id == Selected.id and subcell.cell.clr == Selected.clr then
                    love.graphics.setColor(1,1,1,1)
                end
                subcell.cell.rot = Selected.rot
                DrawCell(subcell.cell,i*64,love.graphics.getHeight()-48-(j*48),2)
            end
        end

    end

    if Selected == Bar[1].cells[9].cell or Selected == Bar[2].cells[9].cell or Selected == Bar[7].cells[1].cell or Selected == Bar[7].cells[2].cell then
        love.graphics.setColor(0.1637254902,0.1954901961,0.3078431373,1)
        love.graphics.rectangle("fill",sw-310,10,300,150,30)

        love.graphics.setColor(1,1,1)
        local f = GetFont(48)
        love.graphics.setFont(f)
        local t = "Hex Color:"
        love.graphics.print(t,sw-160,45,0,1,1,f:getWidth(t)/2,f:getHeight()/2)

        love.graphics.setColor(0.2837254902,0.3254901961,0.4278431373,1)
        love.graphics.rectangle("fill",sw-280,80,240,60,20)

        love.graphics.setColor(1,1,1)
        local t2 = HexClr
        love.graphics.print(t2,sw-160,110,0,1,1,f:getWidth(t2)/2,f:getHeight()/2)
    end

    if Selected == Bar[7].cells[2].cell then
        love.graphics.setColor(0.1637254902,0.1954901961,0.3078431373,1)
        love.graphics.rectangle("fill",sw-310,180,300,150,30)

        love.graphics.setColor(1,1,1)
        local f = GetFont(48)
        love.graphics.setFont(f)
        local t = "Key:"
        love.graphics.print(t,sw-160,215,0,1,1,f:getWidth(t)/2,f:getHeight()/2)

        love.graphics.setColor(0.2837254902,0.3254901961,0.4278431373,1)
        love.graphics.rectangle("fill",sw-280,250,240,60,20)

        love.graphics.setColor(1,1,1)
        local t2 = InpKey
        local w = f:getWidth(t2)
        local size = math.min(1,220/w)
        love.graphics.print(t2,sw-160,280,0,size,size,f:getWidth(t2)/2,f:getHeight()/2)
    end

    if hover then
        local font = GetFont(24)
        local w = font:getWidth(hover)+10
        local h = font:getHeight()
        love.graphics.setFont(font)

        love.graphics.setColor(0.2,0.2,0.2,0.9)
        local mx,my = love.mouse.getPosition()
        love.graphics.rectangle("fill",mx,my-h,w,h,10,10)
        love.graphics.setColor(1,1,1)
        love.graphics.print(hover,mx+5,my-h,0)
    end
end

function CellBarClick(x,y,b)
    if b == 1 then
        for i,v in ipairs(Bar) do
            if CheckCellBarCollide(x,y,i) then
                if currentopened == i then
                    currentopened = 0
                    CanPlaceCells = false
                else
                    currentopened = i
                    CanPlaceCells = false
                end
            end
            if i == currentopened then
                for j,val in ipairs(v.cells) do
                    if CheckCellBarSubCellCollide(x,y,i,j) then
                        Selected = val.cell
                        CanPlaceCells = false
                    end
                end
            end
        end
    end

    if Selected == Bar[1].cells[9].cell or Selected == Bar[2].cells[9].cell or Selected == Bar[6].cells[1].cell or Selected == Bar[6].cells[2].cell then
        local sw,sh = love.graphics.getDimensions()
        if (x >= sw-280 and x <= (sw-280)+240) and (y >= 80 and y <= 80+60) then
            CanPlaceCells = false
            TypeInHex = true
            DetectInp = false
        else
            TypeInHex = false
        end
    else
        TypeInHex = false
    end

    if Selected == Bar[6].cells[2].cell then
        local sw,sh = love.graphics.getDimensions()
        if (x >= sw-280 and x <= (sw-280)+240) and (y >= 80+170 and y <= 80+60+170) then
            CanPlaceCells = false
            TypeInHex = false
            DetectInp = true
        else
            DetectInp = false
        end
    else
        DetectInp = false
    end
end

function InputChange(key)
    InpKey = key
    Bar[6].cells[2].cell.key = key
end

function HexColorType(key)
    if key == "0" or key == "1" or key == "2" or key == "3" or key == "4" or key == "5" or key == "6" or key == "7" or key == "8" or key == "9"
    or key == "a" or key == "b" or key == "c" or key == "d" or key == "e" or key == "f" then
        if string.len(HexClr) < 6 then
            if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
                key = string.upper(key)
            end
            HexClr = HexClr .. key
        end
    elseif key == "backspace" then
        if string.len(HexClr) > 0 then
            HexClr = HexClr:sub(1,-2)
        end
    end
    if #HexClr == 6 then
        local c1 = HexClr:sub(1,2)
        local c2 = HexClr:sub(3,4)
        local c3 = HexClr:sub(5,6)

        local nc1 = tonumber(c1,16)
        local nc2 = tonumber(c2,16)
        local nc3 = tonumber(c3,16)

        Bar[1].cells[9].cell.clr = {nc1,nc2,nc3}
        Bar[2].cells[9].cell.clr = {nc1,nc2,nc3}
        Bar[6].cells[1].cell.clr = {nc1,nc2,nc3}
        Bar[6].cells[2].cell.clr = {nc1,nc2,nc3}
    end
end

function HandleRotation(key)
    if key == "q" then
        if IsPasting then
            RotateSelectionCounterClockwise()
        else
            Selected.rot = (Selected.rot - 1)%4
        end
    elseif key == "e" then
        if IsPasting then
            RotateSelectionClockwise()
        else
            Selected.rot = (Selected.rot + 1)%4
        end
    end
end