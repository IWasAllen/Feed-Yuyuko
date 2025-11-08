----------------------------------------------------------------
-- Easing functions below are based from easings.net
----------------------------------------------------------------
local function sineIn(time)
    return 1 - math.cos((time * math.pi) / 2)
end


----------------------------------------------------------------
local function sineOut(time)
    return math.sin((time * math.pi) / 2)
end


----------------------------------------------------------------
local function sineInOut(time)
    return -(math.cos(time * math.pi) - 1) / 2
end


----------------------------------------------------------------
local function quadIn(time)
    return time * time
end


----------------------------------------------------------------
local function quadOut(time)
    return 1 - (1 - time) * (1 - time)
end


----------------------------------------------------------------
local function quadInOut(time)
    if time < 0.5 then
        return 2 * time * time
    else
        return 1 - math.pow(-2 * time + 2, 2) / 2
    end
end


----------------------------------------------------------------
local function cubicIn(time)
    return time * time * time
end


----------------------------------------------------------------
local function cubicOut(time)
    return 1 - math.pow(1 - time, 5)
end


----------------------------------------------------------------
local function cubicInOut(time)
    if time < 0.5 then
        return 16 * math.pow(time, 5)
    else
        return 1 - math.pow(-2 * time + 2, 5) / 2
    end
end


----------------------------------------------------------------
local function quartIn(time)
    return math.pow(time, 4)
end


----------------------------------------------------------------
local function quartOut(time)
    return 1 - math.pow(1 - time, 4)
end


----------------------------------------------------------------
local function quartInOut(time)
    if time < 0.5 then
        return 8 * math.pow(time, 4)
    else
        return 1 - math.pow(-2 * time + 2, 4) / 2
    end
end


----------------------------------------------------------------
local function backIn(time)
    return 2.70158 * math.pow(time, 3) - 1.70158 * time * time
end


----------------------------------------------------------------
local function backOut(time)
    return 2.70158 * math.pow(time - 1, 3) + 1.70158 * math.pow(time - 1, 2) + 1
end


----------------------------------------------------------------
local function backInOut(time)
    if time < 0.5 then
        return (math.pow(time * 2, 2) * ((4.59491 + 1) * 2 * time - 4.59491)) / 2
    else
        return (math.pow(time * 2 - 2, 2) * ((4.59491 + 1) * (time * 2 - 2) + 4.59491) + 2) / 2
    end
end


----------------------------------------------------------------
local function bounceIn(time)
    return 1 - bounceOut(1 - time)
end


----------------------------------------------------------------
local function bounceOut(time)
    local n1 = 7.56250
    local d1 = 2.75000

    if time < 1 / d1 then
        return n1 * time * time
    elseif time < 2 / d1 then
        time = time - 1.5 / d1
        return n1 * time * time + 0.75
    elseif time < 2.5 / d1 then
        time = time - 2.25 / d1
        return n1 * time * time + 0.9375
    else
        time = time - 2.625 / d1
        return n1 * time * time + 0.984375
    end
end


----------------------------------------------------------------
local function bounceInOut(time)
    if time < 0.5 then
        return (1 - bounceOut(1 - time * 2)) / 2
    else
        return (1 + bounceOut(time * 2 - 1)) / 2
    end
end


----------------------------------------------------------------
local function circularIn(time)
    return 1 - math.sqrt(1 - time * time)
end


----------------------------------------------------------------
local function circularOut(time)
    return math.sqrt(1 - math.pow(time - 1, 2))
end


----------------------------------------------------------------
local function circularInOut(time)
    if time < 0.5 then
        return (1 - math.sqrt(1 - math.pow(time * 2, 2))) / 2
    else
        return (math.sqrt(1 - math.pow(time * -2 + 2, 2)) + 1) / 2
    end
end


----------------------------------------------------------------
local EnumStyles = {
    linear        = function(x) return x end;

    sineIn        = sineIn;
    sineOut       = sineOut;
    sineInOut     = sineInOut;

    quadIn        = quadIn;
    quadOut       = quadOut;
    quadInOut     = quadInOut;

    cubicIn       = cubicIn;
    cubicOut      = cubicOut;
    cubicInOut    = cubicInOut;

    quartIn       = quartIn;
    quartOut      = quartOut;
    quartInOut    = quartInOut;

    backIn        = backIn;
    backOut       = backOut;
    backInOut     = backInOut;

    bounceIn      = bounceIn;
    bounceOut     = bounceOut;
    bounceInOut   = bounceInOut;

    circularIn    = circularIn;
    circularOut   = circularOut;
    circularInOut = circularInOut;
}


----------------------------------------------------------------
-- Helper Functions
----------------------------------------------------------------
local function deep_copy(object, filter)

    if type(object) ~= "table" then
        return object
    end

    local result = {}

    for i, v in pairs(filter) do
        assert(object[i], string.format("attempt to tween unknown subject field or index at '%s'", i));
        result[i] = deep_copy(object[i])
    end

    return result

end

----------------------------------------------------------------
local function recursive_lerp(object, start, target, time)

    if type(object) ~= "table" then
        return start + (target - start) * time -- lerp function
    end

    for i, v in pairs(target) do
        object[i] = recursive_lerp(object[i], start[i], v, time)
    end

end


----------------------------------------------------------------
-- Class
----------------------------------------------------------------
local TweenHandler, m_objset = {}, {}
TweenHandler.__index = TweenHandler


----------------------------------------------------------------
function TweenHandler:new(obj_reference)

    local class = {}

    class.goal    = {}
    class.initial = {}
    class.subject = obj_reference

    class.speed = 1.0
    class.style = EnumStyles.linear
    class.time  = 0.0

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function TweenHandler:play(goal, style, duration)

    self.goal    = goal
    self.initial = deep_copy(self.subject, goal)

    self.speed   = 1 / duration
    self.style   = EnumStyles[style]
    self.time    = 0

    -- Add in the set to update it overtime
    m_objset[self] = true

end


----------------------------------------------------------------
function TweenHandler:set(time)

    self.time = time

    recursive_lerp(self.subject, self.initial, self.goal, self.style(time))

end


----------------------------------------------------------------
function TweenHandler.update(deltaTime)

    for obj in pairs(m_objset) do
        local time = obj.time + deltaTime * obj.speed

        -- Tween Expiration
        if time >= 1 then
            time = 1
            m_objset[obj] = nil
        end

        obj:set(time)
    end

end


return TweenHandler
