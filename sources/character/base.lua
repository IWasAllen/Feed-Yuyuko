local SpriteHandler = require("sources/engine/spritehandler")

local TweenHandler = require("sources/engine/tweenhandler")


----------------------------------------------------------------
local Base = {}
Base.__index = Base


----------------------------------------------------------------
function Base:new()

    local class = {}
    class.cache = {}
    class.resources = {}
    class.misc = {}

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function Base:load(assetdir, resources_locations)

    self.resources.locations = resources_locations

    -- Visual resources
    self.resources.image_base    = love.graphics.newImage(assetdir .. "textures/base.png")
    self.resources.image_eyebrow = love.graphics.newImage(assetdir .. "textures/eyebrow.png")

    self.resources.sprite_eyes   = SpriteHandler:new(assetdir .. "textures/eyes.png", 1024, 1024)
    self.resources.sprite_mouth  = SpriteHandler:new(assetdir .. "textures/mouths.png", 256, 256)

    -- Object Resources
    self.resources.tween_eyebrows = TweenHandler:new({0, 0, 0, 0, 0, math.rad(14)})
    self.resources.tween_wobble   = TweenHandler:new(self.misc)

    -- Miscellanous Resources
    self.misc.blink_duration = 5.00
    self.misc.blink_time = 0.00

    self.misc.wobble_frequency = 0.50
    self.misc.wobble_intensity = 0.25
    self.misc.wobble_time = 0.00

    -- Cache
    self.cache.width = self.resources.image_base:getWidth()
    self.cache.height = self.resources.image_base:getHeight()

    self.cache.half_width = self.cache.width / 2
    self.cache.half_height = self.cache.height / 2

end


----------------------------------------------------------------
function Base:blink(duration)

    self.misc.blink_duration = duration or 0.125
    self.misc.blink_time = 0

    self.resources.sprite_eyes:once(1, 3, 0.125)

end


----------------------------------------------------------------
function Base:emotion(state)

    local EnumEmotions = {
        happy   = {0, 0, 0, 0, 0, 14, 1};
        neutral = {12, -4, 6, -24, 24, 6, 2};
        sad     = {-24, 30, -8, 36, -2, 24, 3};
        angry   = {36, -16, 12, -48, 42, -2, 4};
        disgust = {-24, 48, -12, 48, 8, 32, 5};
    }

    local x1, y1, r1, x2, y2, r2, row = unpack(EnumEmotions[state])
    r1 = math.rad(r1)
    r2 = math.rad(r2)

    -- Play
    self.resources.sprite_mouth:row(row)
    self.resources.tween_eyebrows:play({x1, y1, r1, x2, y2, r2}, "backOut", 1.0)

end


----------------------------------------------------------------
function Base:wobble(frequency, intensity, transitionDuration)

    self.resources.tween_wobble:play({wobble_frequency = frequency, wobble_intensity = intensity}, "circularOut", transitionDuration)

end


----------------------------------------------------------------
function Base:update(deltaTime)

    -- Blinking
    self.misc.blink_time = self.misc.blink_time + deltaTime

    if self.misc.blink_time >= self.misc.blink_duration then

        -- Open eyes
        self.resources.sprite_eyes:once(3, 1, 0.2)

        -- Random blinking
        self.misc.blink_time = -math.random(1, 5) ^ 1.75 

        if self.misc.blink_duration == 0 then
            self:blink()
        else
            self.misc.blink_duration = 0
        end
    end

    -- Wobble
    self.misc.wobble_time = self.misc.wobble_time + self.misc.wobble_frequency * deltaTime

end


----------------------------------------------------------------
function Base:draw()

     -- Wobbling Effect
    local wobbleX = math.sin(self.misc.wobble_time * math.pi * 2) * self.misc.wobble_intensity
    local wobbleY = -math.sin(self.misc.wobble_time * math.pi * 2) * self.misc.wobble_intensity

    -- Drawing the base
    love.graphics.push()

        love.graphics.scale(0.25, 0.25)
        love.graphics.translate(-self.cache.half_width, -self.cache.half_height) -- center to origin

        do -- Full Base Wobbling

            -- Normalize scale to 0.95 ~ 1.00
            local scaleX = (wobbleX + 19) / 20
            local scaleY = (wobbleY + 19) / 20
            
            local posX = self.cache.half_width + (-scaleX * self.cache.half_width)
            local posY = self.cache.height + (-scaleY * self.cache.height)

            love.graphics.translate(posX, posY)
            love.graphics.scale(scaleX, scaleY)

        end

        -- Drawing Body
        love.graphics.push()
            love.graphics.draw(self.resources.image_base)
        love.graphics.pop()

        -- Drawing Eyes
        love.graphics.push()
            love.graphics.translate(0, -wobbleY * 8) -- parallax wobbling
            love.graphics.translate(unpack(self.resources.locations.eyes))
            love.graphics.draw(self.resources.sprite_eyes())
        love.graphics.pop()

        do -- Drawing Eyebrows
            local tween_translations = self.resources.tween_eyebrows.subject

            -- Left Eyebrow
            love.graphics.push()
                love.graphics.translate(0, -wobbleY * 16) -- parallax wobbling
                love.graphics.translate(unpack(self.resources.locations.left_eyebrow))
                love.graphics.translate(tween_translations[1], tween_translations[2])
                love.graphics.rotate(tween_translations[3])
                love.graphics.draw(self.resources.image_eyebrow)
            love.graphics.pop()

            -- Right Eyebrow
            love.graphics.push()
                love.graphics.translate(0, -wobbleY * 16) -- parallax wobbling
                love.graphics.translate(unpack(self.resources.locations.right_eyebrow))
                love.graphics.translate(tween_translations[4], tween_translations[5])
                love.graphics.rotate(tween_translations[6])
                love.graphics.draw(self.resources.image_eyebrow)
            love.graphics.pop()
        end

        -- Drawing Mouth
        love.graphics.push()
            love.graphics.translate(0, -wobbleY * 4) -- parallax wobbling
            love.graphics.translate(unpack(self.resources.locations.mouth))
            love.graphics.draw(self.resources.sprite_mouth())
        love.graphics.pop()

    love.graphics.pop()

end


return Base
