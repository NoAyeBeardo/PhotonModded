function MakeUIContainer()
    return {
        components = {},
        draw = function(self)
            for i,v in ipairs(self.components) do
                v:draw()
            end
        end,
        click = function(self)
            for i,v in ipairs(self.components) do
                v:click()
            end
        end,
        add = function(self,...)
            for i,v in ipairs({...}) do
                table.insert(self.components,v)
            end
        end
    }
end