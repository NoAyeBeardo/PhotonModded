function MakeButton(texture,onclick,x,y,w,h,align,trueheight)
    if trueheight == nil then trueheight = true end
    if onclick == nil then onclick = function() end end
    return {
        tx = texture,
        onclick = onclick,
        align = align,
        x = x,
        y = y,
        w = w,
        h = h,
        trueheight = trueheight,
        pointonbutton = function(self,px,py)
            local bw,bh = self.w,self.h

            if not trueheight then
                bw = bw * TexSize[self.tx].w
                bh = bh * TexSize[self.tx].h
            end

            bw = bw / 2
            bh = bh / 2

            local xx,yy = PositionToAlignedPosition(self.x,self.y,self.align)

            return px >= xx-bw and px <= xx+bw and py >= yy-bh and py <= yy+bh
        end,
        draw = function(self)
            local xx,yy = PositionToAlignedPosition(self.x,self.y,self.align)

            local imgw,imgh = TexSize[self.tx].w,TexSize[self.tx].h
            local renderw,renderh = self.w,self.h
            if trueheight then
                renderw = renderw/imgw
                renderh = renderh/imgh
            end

            if self:pointonbutton(love.mouse.getPosition()) then
                if love.mouse.isDown(1) then
                    love.graphics.setColor(.5,.5,.5,1)
                else
                    love.graphics.setColor(1,1,1,1)
                end
            else
                love.graphics.setColor(1,1,1,.5)
            end

            -- no transparency or whatever just yet
            love.graphics.draw(Tex[self.tx],xx,yy,0,renderw,renderh,TexSize[self.tx].w2,TexSize[self.tx].h2)
        end,
        click = function(self)
            if self:pointonbutton(love.mouse.getPosition()) then
                self.onclick()
            end
        end
    }
end