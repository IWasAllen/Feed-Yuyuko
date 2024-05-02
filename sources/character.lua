local Character = {}

local Dialogue = require("sources/dialogue")

local Spritesheet = require("sources/utils/spritesheet")

local TweenHandler = require("sources/engine/tweenhandler")

local EnumEmotions = {
    happy   = {0, 0, 0, 0, 0, -14, 1};
    neutral = {12, -4, -6, -24, 24, -6, 2};
    sad     = {-24, 30, 8, 36, -2, -24, 3};
    angry   = {36, -16, -12, -48, 42, 2, 4};
    disgust = {-24, 30, 8, 36, -2, -24, 5};
}


----------------------------------------------------------------
function Character:new(character_directory)

    local class = {}
    class.directory = character_directory .. '/'
    class.resources = {locations = {}}

    class.state = "idle"
    class.state_idlelock = false

    setmetatable(class, self)
    self.__index = self

    return class

end


----------------------------------------------------------------
function Character:init(eyes_position, mouth_position, left_eyebrow_position, right_eyebrow_position)

    -- Set resource locations
    self.resources.locations.eyes          = eyes_position
    self.resources.locations.mouth         = mouth_position
    self.resources.locations.left_eyebrow  = left_eyebrow_position
    self.resources.locations.right_eyebrow = right_eyebrow_position

    -- Load resources
    self.resources.image_base              = love.graphics.newImage(self.directory .. "textures/base.png")
    self.resources.image_eyebrow           = love.graphics.newImage(self.directory .. "textures/eyebrow.png")
    self.resources.sprite_eyes             = Spritesheet:new(self.directory .. "textures/eyes.png", 1024, 1024)
    self.resources.sprite_mouth            = Spritesheet:new(self.directory .. "textures/mouths.png", 256, 256)
    
    -- Initialize tween class
    self.resources.tween_eyebrows = TweenHandler:new(function(x1, y1, r1, x2, y2, r2)

    end, 0, 0, 0, 0, 0, 0.2443)

    -- Initialize text dialogue
    self.resources.dialogue = Dialogue:new(self.directory .. "dialogue/font.ttf", self.directory .. "dialogue/voice.wav")
    self.resources.dialogue.font:setFilter("nearest", "nearest")

    -- Others
    self.blinkcooldown = 1.0

end


----------------------------------------------------------------
function Character:emotion(state)

    local x1, y1, r1, x2, y2, r2, row = unpack(EnumEmotions[state])

    -- Convert rotation variables from degrees to radians
    r1 = math.rad(r1)
    r2 = math.rad(r2)

    -- Play
    self.resources.sprite_mouth:row(row)
    self.resources.tween_eyebrows:play({x1, y1, -r1, x2, y2, -r2}, "backOut", 1.0)

end


----------------------------------------------------------------
function Character:speak(text, speed)

    self.state = "speaking"
    self.state_idlelock = true

    self.resources.dialogue:play(text, speed)
    self.resources.sprite_mouth:play(2, 1, 0.33)

end


----------------------------------------------------------------
function Character:update(deltaTime)

    -- Internal Resource Updates
    self.resources.dialogue:update(deltaTime)
    self.resources.sprite_eyes:update(deltaTime)
    self.resources.sprite_mouth:update(deltaTime)

    -- Character States
    if self.state == "speaking" and self.resources.dialogue:done() then
        self.state_idlelock = false
        self.resources.sprite_mouth:stop()
    end

    if not self.state_idlelock then
        self.state = "idle"
    end

end


----------------------------------------------------------------
function Character:draw()

    -- Drawing the character
    love.graphics.push()

        -- Translations
        love.graphics.scale(0.25, 0.25)
        love.graphics.translate(-self.resources.image_base:getWidth() / 2, -self.resources.image_base:getHeight() / 2) -- center origin
        
        -- Drawing body
        love.graphics.push()
            love.graphics.draw(self.resources.image_base)
        love.graphics.pop()

        -- Drawing eyes
        love.graphics.push()
            love.graphics.translate(unpack(self.resources.locations.eyes))
            love.graphics.draw(self.resources.sprite_eyes())
        love.graphics.pop()

        -- Drawing mouth
        love.graphics.push()
            love.graphics.translate(unpack(self.resources.locations.mouth))
            love.graphics.draw(self.resources.sprite_mouth())
        love.graphics.pop()
        
        -- Drawing eyebrows
        love.graphics.push()
    
            -- Left eyebrow
            love.graphics.translate(unpack(self.resources.locations.left_eyebrow))
            love.graphics.translate(self.resources.tween_eyebrows[1], self.resources.tween_eyebrows[2])
            love.graphics.rotate(self.resources.tween_eyebrows[3])
            love.graphics.draw(self.resources.image_eyebrow)
        love.graphics.pop()

        love.graphics.push()

            -- Right eyebrow
            love.graphics.translate(unpack(self.resources.locations.right_eyebrow))
            love.graphics.translate(self.resources.tween_eyebrows[4], self.resources.tween_eyebrows[5])
            love.graphics.rotate(self.resources.tween_eyebrows[6])
            love.graphics.draw(self.resources.image_eyebrow)
        love.graphics.pop()
    love.graphics.pop()

    -- Drawing the text dialogue
    love.graphics.push()
        love.graphics.translate(0, -196)

        love.graphics.setColor(0, 0, 0)
        self.resources.dialogue:draw()
        love.graphics.setColor(1, 1, 1)
    love.graphics.pop()

end


return Character