----------------------------------------------------------------
-- Easing functions below are based from easings.net
----------------------------------------------------------------
local function sineIn(progress)
    return 1 - math.cos((progress * math.pi) / 2)
end


----------------------------------------------------------------
local function sineOut(progress)
    return math.sin((progress * math.pi) / 2)
end


----------------------------------------------------------------
local function sineInOut(progress)
    return -(math.cos(progress * math.pi) - 1) / 2
end


----------------------------------------------------------------
local function quadIn(progress)
    return progress * progress
end


----------------------------------------------------------------
local function quadOut(progress)
    return 1 - (1 - progress) * (1 - progress)
end


----------------------------------------------------------------
local function quadInOut(progress)
    if progress < 0.5 then
        return 2 * progress * progress
    else
        return 1 - math.pow(-2 * progress + 2, 2) / 2
    end
end


----------------------------------------------------------------
local function cubicIn(progress)
    return progress * progress * progress
end


----------------------------------------------------------------
local function cubicOut(progress)
    return 1 - math.pow(1 - progress, 5)
end


----------------------------------------------------------------
local function cubicInOut(progress)
    if progress < 0.5 then
        return 16 * math.pow(progress, 5)
    else
        return 1 - math.pow(-2 * progress + 2, 5) / 2
    end
end


----------------------------------------------------------------
local function quartIn(progress)
    return math.pow(progress, 4)
end


----------------------------------------------------------------
local function quartOut(progress)
    return 1 - math.pow(1 - progress, 4)
end


----------------------------------------------------------------
local function quartInOut(progress)
    if progress < 0.5 then
        return 8 * math.pow(progress, 4)
    else
        return 1 - math.pow(-2 * progress + 2, 4) / 2
    end
end


----------------------------------------------------------------
local function backIn(progress)
    return 2.70158 * math.pow(progress, 3) - 1.70158 * progress * progress
end


----------------------------------------------------------------
local function backOut(progress)
    return 2.70158 * math.pow(progress - 1, 3) + 1.70158 * math.pow(progress - 1, 2) + 1
end


----------------------------------------------------------------
local function backInOut(progress)
    if progress < 0.5 then
        return (math.pow(progress * 2, 2) * ((4.59491 + 1) * 2 * progress - 4.59491)) / 2
    else
        return (math.pow(progress * 2 - 2, 2) * ((4.59491 + 1) * (progress * 2 - 2) + 4.59491) + 2) / 2
    end
end


----------------------------------------------------------------
local function bounceIn(progress)
    return 1 - bounceOut(1 - progress)
end


----------------------------------------------------------------
local function bounceOut(progress)
    local n1 = 7.56250
    local d1 = 2.75000

    if progress < 1 / d1 then
        return n1 * progress * progress
    elseif progress < 2 / d1 then
        progress = progress - 1.5 / d1
        return n1 * progress * progress + 0.75
    elseif progress < 2.5 / d1 then
        progress = progress - 2.25 / d1
        return n1 * progress * progress + 0.9375
    else
        progress = progress - 2.625 / d1
        return n1 * progress * progress + 0.984375
    end
end


----------------------------------------------------------------
local function bounceInOut(progress)
    if progress < 0.5 then
        return (1 - bounceOut(1 - progress * 2)) / 2
    else
        return (1 + bounceOut(progress * 2 - 1)) / 2
    end
end


----------------------------------------------------------------
local function circularIn(progress)
    return 1 - math.sqrt(1 - progress * progress)
end


----------------------------------------------------------------
local function circularOut(progress)
    return math.sqrt(1 - math.pow(progress - 1, 2))
end


----------------------------------------------------------------
local function circularInOut(progress)
    if progress < 0.5 then
        return (1 - math.sqrt(1 - math.pow(progress * 2, 2))) / 2
    else
        return (math.sqrt(1 - math.pow(progress * -2 + 2, 2)) + 1) / 2
    end
end


----------------------------------------------------------------
local EnumStyles = {
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

    linear      = function(x) return x end;
}


----------------------------------------------------------------
-- Helper Functions
----------------------------------------------------------------
local _oldassert = assert

local function assert(condition, message)

    _oldassert(condition, "[TweenHandler] " .. message)

end


----------------------------------------------------------------
local function lerp(start, target, time, style)

    return start + (target - start) * EnumStyles[style](time)

end


----------------------------------------------------------------
local function deep_copy(subject, initial, goal)

    for i, v in pairs(goal) do
        assert(subject[i] ~= nil, string.format("attempt to tween unknown subject field at '%s'", i))
        assert(type(subject[i]) == type(v), string.format("attempt to tween different types at '%s'", i))

        if type(subject[i]) ~= "table" then
            initial[i] = subject[i]
        else
            initial[i] = {}
            recursive_copy(subject[i], initial[i], v)
        end
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
    class.initial = {}
    class.goal    = {}
    class.subject = obj_reference

    class.speed = 1.0
    class.style = "linear"
    class.time  = 0.0

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function TweenHandler:play(goal, style, duration)

    self.initial = {}
    self.goal    = goal
    self.speed   = 1 / duration
    self.style   = style
    self.time    = 0

print(goal, duration)
    -- Copy the required initials from the subject
    local function recursive_copy(subject, initial, goal)
        for i, v in pairs(goal) do
            assert(subject[i] ~= nil, string.format("attempt to tween unknown subject field at '%s'", i))
            assert(type(subject[i]) == type(v), string.format("attempt to tween different types at '%s'", i))

            if type(subject[i]) ~= "table" then
                initial[i] = subject[i]
            else
                initial[i] = {}
                recursive_copy(subject[i], initial[i], v)
            end
        end
    end

    recursive_copy(self.subject, self.initial, self.goal)
print(unpack(self.initial))
    -- Add in the set to update it overtime
    m_objset[self] = true

end


----------------------------------------------------------------
function TweenHandler:set(time)

    self.time = time

    local function recursive_lerp(subject, initial, goal)
        for i, v in pairs(goal) do
            if type(subject[i]) ~= "table" then
                subject[i] = lerp(initial[i], v, time, self.style)
            else
                recursive_lerp(subject[i], initial[i], v)
            end
        end
    end

    recursive_lerp(self.subject, self.initial, self.goal)

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
