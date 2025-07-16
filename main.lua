love.graphics.setDefaultFilter("nearest","nearest")

love.window.setVSync(0)

function table.copy(oldtable)
    local newtable = {}
    for k,v in pairs(oldtable) do
        if type(v) == "table" then v = table.copy(v) end
        newtable[k] = v
    end
    return newtable
end

function Split(inputstr, sep) sep=sep or '%s' local t={}  for field,s in string.gmatch(inputstr, "([^"..sep.."]*)("..sep.."?)") do table.insert(t,field)  if s=="" then return t end end end

require("src.errorscreen")
require("src.NumberEncoderPhot1")
require("src.Saving")
require("src.MainMenu")
require("src.Buttons")
require("src.KeyPressed")
require("src.Placing")
require("src.Camera")
require("src.TexLoader")
require("src.GridRenderer")
require("src.Font")
require("src.CellBar")
require("src.Clicks")
require("src.Rendering")
require("src.Physics")
require("src.CellUpdating")
require("src.Updating")
require("src.Scroll")
require("src.UI.UILoader")
require("src.Grid")
require("src.SmallMenu")


love.graphics.setBackgroundColor(.1137254902,.1254901961,.2078431373)

Overlay = MakeUIContainer()
Overlay:add(MakeButton("menu",function() InSmallMenu = not InSmallMenu CanPlaceCells = false end,42,42,64,64,"topleft"),
            MakeButton("selection", function ()
                if not IsPasting then
                    if Selection then
                        Selection = false
                        Overlay.components[2].tx = "selection"
                        StartSelectPos = nil
                        EndSelectPos = nil
                    else
                        Selection = true
                        Overlay.components[2].tx = "select_on"
                    end
                    CanPlaceCells = false
                end
            end, 42+64+10,42,64,64,"topleft"),
            MakeButton("pause", function ()
                if Paused then
                    Paused = false
                    Overlay.components[3].tx = "pause"
                else
                    Paused = true
                    Overlay.components[3].tx = "play"
                end
                CanPlaceCells = false
            end, 42,42+64+10,64,64,"topleft"),
            MakeButton("fastforward", function ()
                CanPlaceCells = false
            end, 42+64+10,42+64+10,64,64,"topleft"),
            MakeButton("copy", function ()
                CopySelection()
                CanPlaceCells = false
            end, 42+74+74,42,64,64,"topleft"),
            MakeButton("cut", function ()
                CutSelection()
                CanPlaceCells = false
            end, 42+74+74+74,42,64,64,"topleft"),
            MakeButton("paste", function ()
                PasteSelection()
                CanPlaceCells = false
            end, 42+74+74+74+74,42,64,64,"topleft"),
            MakeButton("fliphorizontal", function ()
                FlipSelectionHorizontally()
                CanPlaceCells = false
            end, 42+74+74+74+74+74,42,64,64,"topleft"),
            MakeButton("flipvertical", function ()
                FlipSelectionVertically()
                CanPlaceCells = false
            end, 42+74+74+74+74+74+74,42,64,64,"topleft")
        )

Grid = MakeGrid(100,100)

SetupBackgrounds()