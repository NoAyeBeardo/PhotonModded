love.keyboard.setKeyRepeat(true)

function love.keypressed(key, scancode, rep)
    if CurrentScreen == "MainMenu" then return end
    if TypeInHex then
        HexColorType(key)
    elseif DetectInp then
        InputChange(key)
    else
        if not rep then
            PauseDetect(key)
            SaveKey(key)
            -- F3 toggles ShowHexCodes
            if key == "f3" then
                ShowHexCodes = not ShowHexCodes
            end
            HandleRotation(scancode)
            if SmallMenuToggle then SmallMenuToggle(key) end
        end
    end
end