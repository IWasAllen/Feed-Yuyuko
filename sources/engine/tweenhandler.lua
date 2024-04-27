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
    local n1 = 7.5625
    local d1 = 2.7500

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
local EnumStyles = {
    linear    = function(x) return x end,
    
    sineIn      = sineIn,
    sineOut     = sineOut,
    sineInOut   = sineInOut,

    quadIn      = quadIn,
    quadOut     = quadOut,
    quadInOut   = quadInOut,

    cubicIn     = cubicIn,
    cubicOut    = cubicOut,
    cubicInOut  = cubicInOut,

    quartIn     = quartIn,
    quartOut    = quartOut,
    quartInOut  = quartInOut,

    backIn      = backIn,
    backOut     = backOut,
    backInOut   = backInOut,

    bounceIn    = bounceIn,
    bounceOut   = bounceOut,
    bounceInOut = bounceInOut
}


----------------------------------------------------------------
-- Helper functions
----------------------------------------------------------------
local function memcpy(array1, array2)

    for i = 1, #array1 do
       array1[i] = array2[i] 
    end

end


----------------------------------------------------------------
-- Tween class
----------------------------------------------------------------
local TweenHandler, m_tweenset = {}, {}


----------------------------------------------------------------
function TweenHandler:new(callback, ...)

    local class = {}
    class.callback = callback
    class.progress = 0.0
    class.speed    = 1.0
    class.style    = "linear"

    -- Initializes tweening values
    class.values_start = {}
    class.values_end = {}

    for i = 1, debug.getinfo(callback).nparams do
        class.values_start[i] = ({...})[i] or 0
        class.values_end[i] = 0
        class[i] =  class.values_start[i]
    end

    setmetatable(class, self)
    self.__index = self

    return class

end

----------------------------------------------------------------
function TweenHandler:play(target_values, style, duration)

    -- Reset start values to current values
    for i = 1, #self.values_start do
        self.values_start[i] = self[i]
    end

    -- Resets progress
    self.progress = 0.0

    -- Resets the tween properties
    memcpy(self.values_end, target_values)

    self.speed = 1 / duration
    self.style = style

    -- Add in the set
    m_tweenset[tostring(self)] = self

end


----------------------------------------------------------------
function TweenHandler.update(deltaTime)

    for i, v in pairs(m_tweenset) do
        v.progress = v.progress + v.speed * deltaTime

        -- Interpolation
        for i = 1, debug.getinfo(v.callback).nparams do
            if v.progress < 1.0 then
                v[i] = v.values_start[i] + EnumStyles[v.style](v.progress) * (v.values_end[i] - v.values_start[i])
            else
                v[i] = v.values_end[i]
            end
        end
        
        v.callback(unpack(v))
        
        
        if v.progress >= 1.0 then
            v.progress = 1.0
            m_tweenset[tostring(v)] = nil
        end
    end

end


return TweenHandler
