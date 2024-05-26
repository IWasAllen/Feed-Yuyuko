local Base = {}

local SpriteHandler = require("sources/engine/spritehandler")

local TweenHandler = require("sources/engine/tweenhandler")

local TextDialogue = require("sources/character/textdialogue")


----------------------------------------------------------------
function Base:new(character_directory)

    local class = {}
    class.directory = character_directory .. '/'
    class.resources = {locations = {}}
    class.misc = {}

    class.state = "idle"
    class.state_idlelock = false

    setmetatable(class, self)
    self.__index = self

    return class

end


----------------------------------------------------------------
function Base:init(resources_locations)

    self.resources.locations = resources_locations

    -- Visual resources
    self.resources.image_base    = love.graphics.newImage(self.directory .. "textures/base.png")
    self.resources.image_eyebrow = love.graphics.newImage(self.directory .. "textures/eyebrow.png")
    self.resources.sprite_eyes   = SpriteHandler:new(self.directory .. "textures/eyes.png", 1024, 1024)
    self.resources.sprite_mouth  = SpriteHandler:new(self.directory .. "textures/mouths.png", 256, 256)

    -- load chewing sounds
    for i, v in pairs(love.filesystem.getDirectoryItems(self.directory .. "audio/chew")) do

        -- load the sound file
        local sound = love.audio.newSource(self.directory .. "audio/chew/" .. v, "static")
        sound:setLooping(true)

        local filename = string.match(v, "(.+)%.") -- ignore file extension
        self.resources["sound_" .. filename] = sound

    end

    self.resources.sound_burp = love.audio.newSource(self.directory .. "audio/burp.wav", "static")

    -- Object Resources
    self.resources.textdialogue = TextDialogue:new(self.directory .. "dialogue/font.ttf", self.directory .. "dialogue/voice.wav")
    self.resources.textdialogue.font:setFilter("nearest", "nearest")

    self.resources.tween_eyebrows = TweenHandler:new({0, 0, 0, 0, 0, math.rad(14)})
    self.resources.tween_wobble = TweenHandler:new(self.misc)

    -- Miscellanous Resources
    self.misc.wobble_intensity = 0.25
    self.misc.wobble_frequency = 0.50
    self.misc.wobble_time = 0.00

end


----------------------------------------------------------------
function Base:chew(duration, material)

    

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

    -- Convert rotation variables from degrees to radians
    r1 = math.rad(r1)
    r2 = math.rad(r2)

    -- Play
    self.resources.sprite_mouth:row(row)
    self.resources.tween_eyebrows:play({x1, y1, r1, x2, y2, r2}, "backOut", 1.0)

end


----------------------------------------------------------------
function Base:speak(text, speed)

    self.resources.textdialogue:play(text, speed)

end


----------------------------------------------------------------
function Base:update(deltaTime)

    self.resources.textdialogue:update(deltaTime)

    -- Wobble
    self.misc.wobble_time = self.misc.wobble_time + deltaTime * self.misc.wobble_frequency

end


----------------------------------------------------------------
function Base:draw()

    local HALF_WIDTH = self.resources.image_base:getWidth() / 2
    local HALF_HEIGHT = self.resources.image_base:getHeight() / 2

     -- Wobbling Effect
    local cycleX = math.sin(self.misc.wobble_time * math.pi * 2) * self.misc.wobble_intensity
    local cycleY = -math.sin(self.misc.wobble_time * math.pi * 2) * self.misc.wobble_intensity

    -- Drawing the character
    love.graphics.push()

        love.graphics.scale(0.25, 0.25)
        love.graphics.translate(-HALF_WIDTH, -HALF_HEIGHT) -- center to origin

        do -- Full Character Wobbling
            -- Normalize scale to 0.95 ~ 1.00
            local scaleX = (cycleX + 19) / 20
            local scaleY = (cycleY + 19) / 20

            local FULL_HEIGHT = HALF_HEIGHT * 2
            love.graphics.translate(HALF_WIDTH + (-scaleX * HALF_WIDTH), FULL_HEIGHT + (-scaleY * FULL_HEIGHT))
            love.graphics.scale(scaleX, scaleY)
        end

        -- Drawing body
        love.graphics.push()
            love.graphics.draw(self.resources.image_base)
        love.graphics.pop()

        -- Drawing eyes
        love.graphics.push()
            love.graphics.translate(0, -cycleY * 8) -- parallax wobbling
            love.graphics.translate(unpack(self.resources.locations.eyes))
            love.graphics.draw(self.resources.sprite_eyes())
        love.graphics.pop()

        do -- Drawing eyebrows
            local tween_translations = self.resources.tween_eyebrows.subject

            -- Left eyebrow
            love.graphics.push()
                love.graphics.translate(0, -cycleY * 16) -- parallax wobbling
                love.graphics.translate(unpack(self.resources.locations.left_eyebrow))
                love.graphics.translate(tween_translations[1], tween_translations[2])
                love.graphics.rotate(tween_translations[3])
                love.graphics.draw(self.resources.image_eyebrow)
            love.graphics.pop()
    
            -- Right eyebrow
            love.graphics.push()
                love.graphics.translate(0, -cycleY * 16) -- parallax wobbling
                love.graphics.translate(unpack(self.resources.locations.right_eyebrow))
                love.graphics.translate(tween_translations[4], tween_translations[5])
                love.graphics.rotate(tween_translations[6])
                love.graphics.draw(self.resources.image_eyebrow)
            love.graphics.pop()
        end

        -- Drawing mouth
        love.graphics.push()
            love.graphics.translate(0, -cycleY * 4) -- parallax wobbling
            love.graphics.translate(unpack(self.resources.locations.mouth))
            love.graphics.draw(self.resources.sprite_mouth())
        love.graphics.pop()

    love.graphics.pop()

    -- Drawing the text dialogue
    love.graphics.push()
        love.graphics.translate(0, -196)
        self.resources.textdialogue:draw()
    love.graphics.pop()

end


return Base
