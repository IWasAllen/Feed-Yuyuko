local Character = {}

local Spritesheet = require("sources/utils/spritesheet")

local Dialogue = require("sources/dialogue")


----------------------------------------------------------------
function Character:new(character_directory)

    local class = {}
    class.directory = character_directory .. '/'
    class.resources = {locations = {}}

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
    
    -- Initialize text dialogue
    self.resources.dialogue = Dialogue:new(self.directory .. "dialogue/font.ttf", self.directory .. "dialogue/voice.wav")
    self.resources.dialogue.font:setFilter("nearest", "nearest")

    -- Caches
    self.origin = { -self.resources.image_base:getWidth() / 2, -self.resources.image_base:getHeight() / 2 }

end


----------------------------------------------------------------
function Character:face(TODO)



end


----------------------------------------------------------------
function Character:speak(text, speed)

    self.resources.dialogue:play(text, speed or 16)
    self.resources.sprite_mouth:play(2, 1, 0.35)

end


----------------------------------------------------------------
function Character:update(deltaTime)

    -- Dialogue
    self.resources.dialogue:update(deltaTime)

    -- Sprites
    self.resources.sprite_eyes:update(deltaTime)
    self.resources.sprite_mouth:update(deltaTime)

    do -- Blinking
    
    end

    do -- Speak
        if self.resources.dialogue:done() then
            self.resources.sprite_mouth:stop()
        end
    end

end


----------------------------------------------------------------
function Character:draw()

    -- Drawing the character
    love.graphics.push()
        love.graphics.scale(0.25, 0.25)
        love.graphics.translate(unpack(self.origin))
        love.graphics.draw(self.resources.image_base)

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
            love.graphics.translate(unpack(self.resources.locations.left_eyebrow))
            love.graphics.draw(self.resources.image_eyebrow)
        love.graphics.pop()

        love.graphics.push()
            love.graphics.translate(unpack(self.resources.locations.right_eyebrow))
            love.graphics.scale(-1, 1)
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