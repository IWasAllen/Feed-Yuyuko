local Kernels = {
    {-1.0, -1.0, -1.0, -1.0, -1.0}, -- stopped
    {-1.0, -1.0, -1.0, -1.0,  1.0}, -- opening
    { 1.0, -1.0, -1.0, -1.0, -1.0}, -- closing

    {-1.0, -1.0,  1.0,  1.0,  1.0}, -- starting repetition
    { 1.0,  1.0,  1.0, -1.0, -1.0}, -- stopping repetition

    { 1.0,  1.0,  1.0,  1.0,  1.0}, -- always occurence
    { 1.0, -1.0,  1.0, -1.0,  1.0}, -- frequent occurence
    {-1.0, -1.0,  1.0, -1.0, -1.0}, -- rare occurence
}

-- TODO: takes inputs of Short Term Memory, and Long Term Memory (CNN'ed) with filters like starting repetition, occurences.
-- Then genetic algorthm
----------------------------------------------------------------
local Brain = {}


----------------------------------------------------------------
function Brain:new()

    local class = {}
    class.memory = {short = {}, long = {}}
    class.emotion = {happy = 100, stress = 100}

    setmetatable(class, self)
    self.__index = self

    return class

end


-----------------------------------------------------   -----------
function Brain:push(byte)

    print("Pushed", byte)

    table.insert(self.memory.short, byte)

    -- Humans can only remember up to 7 things in short term memory
    if #self.memory.short > 7 then
        table.insert(self.memory.long, self.memory.short[1])
        table.remove(self.memory.short, 1)
    end

end


----------------------------------------------------------------
function Brain:pop()

    table.remove(self.memory.short, #self.memory.short)
    
end


----------------------------------------------------------------
function Brain:analyze(byte)



end


return Brain