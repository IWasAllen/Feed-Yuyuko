local _oldassert = assert

local function assert(condition, message)

    _oldassert(condition, "[State Machine] " .. message)

end

local function default()
    
end


----------------------------------------------------------------
local StateMachine = {}
StateMachine.__index = StateMachine


----------------------------------------------------------------
function StateMachine:new()

    local class = {}
    class.states = {}
    class.active = "idle"

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function StateMachine:create(name, enterCallback, updateCallback)

    assert(self.states[name] == nil, "duplicate states name of " .. name)

    self.states[name] = {}
    self.states[name][1] = enterCallback or default
    self.states[name][2] = updateCallback or default

end


----------------------------------------------------------------
function StateMachine:change(name)

    self.active = name
    self.states[self.active][1]()

end


----------------------------------------------------------------
function StateMachine:update(deltaTime)

    self.states[self.active][2](deltaTime)

end


return StateMachine
