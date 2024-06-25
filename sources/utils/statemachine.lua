local StateMachine = {}
StateMachine.__index = StateMachine

local default = function() end


----------------------------------------------------------------
function StateMachine:new()

    local class = {}
    class.states = {}
    class.active = "idle"

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function StateMachine:create(name, callbacks)

    assert(self.states[name] == nil, "duplicate state named '" .. name .. "'")
    self.states[name] = callbacks

    -- Default empty callbacks
    callbacks["enter"]  = callbacks["enter"]  or default
    callbacks["leave"]  = callbacks["leave"]  or default
    callbacks["update"] = callbacks["update"] or default

end


----------------------------------------------------------------
function StateMachine:change(name)

    self.states[self.active]["leave"]()

    self.active = name

    self.states[self.active]["enter"]()

end


----------------------------------------------------------------
function StateMachine:update(deltaTime)

    self.states[self.active]["update"](deltaTime)
    
end


return StateMachine
