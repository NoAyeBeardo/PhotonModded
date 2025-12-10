function MakeText(text,x,y,size,align)
    return {
        text = text,
        x = x,
        y = y,
        size = size,
        align = align,
        draw = function(self)
            local xx,yy = PositionToAlignedPosition(self.x,self.y,self.align)
            local font = GetFont(self.size)
            love.graphics.setFont(font)
            love.graphics.print(self.text,xx,yy,0,1,1,font:getWidth(self.text)/2,font:getHeight()/2)
        end
    }
end