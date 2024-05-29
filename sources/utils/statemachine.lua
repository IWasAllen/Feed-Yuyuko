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
function StateMachine:create(name, callbacks)

    assert(self.states[name] == nil, "duplicate states name of " .. name)

    self.states[name] = callbacks

    if not callbacks["enter"] then  
        callbacks["enter"] = default
    end

    if not callbacks["update"] then
        callbacks["update"] = default
    end

    if not callbacks["leave"] then
        callbacks["leave"] = default
    end

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
