Cam = {
    x = 0, -- true values
    y = 0,
    zoom = 1,

    rx = 0, -- render values; the interpolated ones
    ry = 0,
    rzoom = 1,

    smoothness = 10, -- interpolatedness

    inlimit = 16, -- zoom limits
    outlimit = 0.25
}

function ZoomHandler(y)
    if love.keyboard.isDown("lctrl") then return end

    local scr = 2^y

    if scr > 1 and Cam.zoom >= Cam.inlimit then return end -- limits
    if scr < 1 and Cam.zoom <= Cam.outlimit then return end

    local mx,my = love.mouse.getPosition()

    Cam.zoom = Cam.zoom * scr
    Cam.x = Cam.x - mx
    Cam.y = Cam.y - my
    Cam.x = Cam.x * scr
    Cam.y = Cam.y * scr
    Cam.x = Cam.x + mx
    Cam.y = Cam.y + my
end

function CameraMovement(dt) -- WASD moving cam
    if not TypeInHex then
        if love.keyboard.isScancodeDown("a", "left") then
            Cam.x = Cam.x + 500*dt
        end
        if love.keyboard.isScancodeDown("s", "down") then
            Cam.y = Cam.y - 500*dt
        end
        if love.keyboard.isScancodeDown("w", "up") then
            Cam.y = Cam.y + 500*dt
        end
        if love.keyboard.isScancodeDown("d", "right") then
            Cam.x = Cam.x - 500*dt
        end
    end
end

function CameraInterpolate(dt) -- Interpolate the camera position; moves the render values towards the true values
    local t = Cam.smoothness * dt
    if t > 1 then t = 1 end
    Cam.rx = Cam.rx + (Cam.x - Cam.rx) * t
    Cam.ry = Cam.ry + (Cam.y - Cam.ry) * t
    Cam.rzoom = Cam.rzoom + (Cam.zoom - Cam.rzoom) * t
end