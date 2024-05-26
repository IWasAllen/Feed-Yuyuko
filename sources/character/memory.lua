local Memory = {}
Memory.__index = Memory


----------------------------------------------------------------
function Memory:new()

    local class = {}
    class.short_term = {} 
    class.long_term = {}

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function Memory:rate(byte)

    local result = 0

    for i = 1, 7 do
        if self.short_term[i] == byte then
            local bias = i / 4
            result = result + 1 * bias
        end
    end

    return result
 
end


-----------------------------------------------------   -----------
function Memory:push(byte)

    print("Pushed", byte)

    table.insert(self.short_term, byte)

    -- Humans can only remember up to 7 things in short term memory
    if #self.short_term > 7 then
        table.remove(self.short_term, 1)
    end

end


----------------------------------------------------------------
function Memory:pop()

    table.remove(self.short_term, #self.short_term)

end


----------------------------------------------------------------
function Memory:remember(byte)

    table.insert(self.long_term, byte)

end


return Memory
