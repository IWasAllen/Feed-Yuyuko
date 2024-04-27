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
local EnumStyles = {
    linear    = function(x) return x end,
    sineIn    = sineIn,
    sineOut   = sineOut,
    sineInOut = sineInOut
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
local function lerp(start, target, style, progress)

    return start + EnumStyles[style](progress) * (target - start)

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
    end

    setmetatable(class, self)
    self.__index = self

    return class

end

----------------------------------------------------------------
function TweenHandler:play(target_values, style, duration)

    -- Reset start values to current values
    print(self.values_start[1])
    for i = 1, #self.values_start do
        self.values_start[i] = lerp(self.values_start[i], self.values_end[i], self.style, self.progress)
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
        
        local current_value = {}

        for i = 1, debug.getinfo(v.callback).nparams do
            if v.progress < 1.0 then
                current_value[i] = lerp(v.values_start[i], v.values_end[i], v.style, v.progress)
            else
                current_value[i] = v.values_end[i]
            end
        end
        
        v.callback(unpack(current_value))
        
        if v.progress >= 1.0 then
            v.progress = 1.0
            m_tweenset[tostring(v)] = nil
        end
    end

end


return TweenHandler
