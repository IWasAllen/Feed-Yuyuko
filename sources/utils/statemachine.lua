local _oldassert = assert

local function assert(condition, message)

    _oldassert(condition, "[State Machine] " .. message)

end


----------------------------------------------------------------
local StateMachine = {}
StateMachine.__index = StateMachine


----------------------------------------------------------------
function StateMachine:new()

    local class = {}
    class.active = nil
    class.states = {}

    -- initialize default state
    class.states.idle.enter = function() print("idled") end
    class.states.idle.update = function() print("idle updates!") end

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function StateMachine:create(name, callback)

    assert(self.states[name] ~= nil, "duplicate states name of " .. name)

    self.states[name] = callback

end


----------------------------------------------------------------
function StateMachine:change(name)

    self.states.active = self.states[name]
    self.states.active.enter()

end


----------------------------------------------------------------
function StateMachine:update(deltaTime)

    self.states.active.update(deltaTime)

end


return StateMachine