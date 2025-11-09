----------------------------------------------------------------
-- Private
----------------------------------------------------------------
local function default()

    return

end


----------------------------------------------------------------
-- Class
----------------------------------------------------------------
local StateMachine = {}
StateMachine.__index = StateMachine


----------------------------------------------------------------
function StateMachine:new()

    local class = {}
    class.states = {}
    class.active = nil

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function StateMachine:create(name, callbacks)

    assert(not self.states[name], string.format("attempt to create duplicate state called '%s'.", name))

    -- Initialize empty callbacks
    callbacks.enter  = callbacks.enter  or default
    callbacks.leave  = callbacks.leave  or default
    callbacks.update = callbacks.update or default

    -- Set id state
    self.states[name] = callbacks

    -- Set initial state
    if not self.active then
        self.active = callbacks
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
