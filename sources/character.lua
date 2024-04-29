local Character = {}

local Dialogue = require("sources/dialogue")

local Spritesheet = require("sources/utils/spritesheet")

local TweenHandler = require("sources/engine/tweenhandler")


----------------------------------------------------------------
function Character:new(character_directory)

    local class = {}
    class.directory = character_directory .. '/'
    class.resources = {locations = {}}
    class.state = "idle"
    class.state_locked = false

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
    
    end)

    -- Initialize text dialogue
    self.resources.dialogue = Dialogue:new(self.directory .. "dialogue/font.ttf", self.directory .. "dialogue/voice.wav")
    self.resources.dialogue.font:setFilter("nearest", "nearest")

    -- Others
    self.blinkcooldown = 1.0

    -- Caches
    self.origin = { -self.resources.image_base:getWidth() / 2, -self.resources.image_base:getHeight() / 2 }

end


----------------------------------------------------------------
function Character:face(state)

    self.resources.sprite_mouth:row(state)

end


----------------------------------------------------------------
function Character:speak(text, speed)

    self.resources.dialogue:play(text, speed)
    self.resources.sprite_mouth:play(2, 1, 0.5)

end


----------------------------------------------------------------
function Character:update(deltaTime)

    -- Internal Resource Updates
    self.resources.dialogue:update(deltaTime)
    self.resources.sprite_eyes:update(deltaTime)
    self.resources.sprite_mouth:update(deltaTime)

    -- Character States
    if self.state == "speaking" and self.resources.dialogue:done() then
        self.statelocked = false
        self.resources.sprite_mouth:stop()
    end

    if not self.statelocked then
        self.state = "idle"
    end

end


----------------------------------------------------------------
function Character:draw()

    -- Drawing the character
    love.graphics.push()

        -- Translations
        love.graphics.scale(0.25, 0.25)
        love.graphics.translate(unpack(self.origin))
        
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
            love.graphics.rotate(self.resources.tween_eyebrows[6])
            love.graphics.translate(self.resources.tween_eyebrows[4], self.resources.tween_eyebrows[5])
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