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
            -- Call SaveSelectionScreenshot when F2 is pressed
            if key == "f2" and SaveSelectionScreenshot then
                print("F2 pressed: Attempting to save screenshot") -- Debug log
                SaveSelectionScreenshot()
            end
            HandleRotation(scancode)
            if SmallMenuToggle then SmallMenuToggle(key) end
        end
    end
end