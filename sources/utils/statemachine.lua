local StateMachine = {}
StateMachine.__index = StateMachine

local default = function() end


----------------------------------------------------------------
function StateMachine:new()

    local class = {}
    class.states = {}
    class.active = {}

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function StateMachine:create(name, callbacks, isInitialState)

    assert(self.states[name] == nil, "duplicate state named '" .. name .. "'")

    -- Initialize empty callbacks
    callbacks.enter  = callbacks.enter  or default
    callbacks.leave  = callbacks.leave  or default
    callbacks.update = callbacks.update or default

    -- Set state
    self.states[name] = callbacks
    
    if isInitialState then
        self.active = self.states[name]
    end

end


----------------------------------------------------------------
function StateMachine:change(name)

    self.active.leave()
    self.active = self.states[name]
    self.active.enter()

end


----------------------------------------------------------------
function StateMachine:update(deltaTime)

    self.active.update(deltaTime)
    
end


return StateMachine
