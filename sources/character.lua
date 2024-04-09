local Character = {}

local Animation = require("sources/animation")

local Dialogue = require("sources/dialogue")


----------------------------------------------------------------
function Character:new(character_directory)

    local class = {}
    class.directory = character_directory .. '/'
    class.resources = {}

    setmetatable(class, self)
    self.__index = self

    return class

end


----------------------------------------------------------------
function Character:init()

    -- Load Textures
    self.resources.texture_base = love.graphics.newImage(self.directory .. "textures/base.png")
    self.resources.texture_face = love.graphics.newImage(self.directory .. "textures/faces/1.png")

    -- Initialize Face Animations
    self.resources.animation = Animation:new(self.resources.texture_face, 1024, 1024)
    self.resources.animation:add("idle", 1, 1, 1)
    self.resources.animation:add("speaking", 1, 1, 2)
    self.resources.animation:add("eating", 1, 3, 5)
    self.resources.animation:play("idle")

    -- Initialize Dialogue
    self.resources.dialogue = Dialogue:new(self.directory .. "dialogue/font.ttf", self.directory .. "dialogue/voice.wav")
    self.resources.dialogue.font:setFilter("nearest", "nearest")

end


----------------------------------------------------------------
function Character:speak(text, speed, textcolor)

    self.resources.animation:play("speaking", 0.32, 2)

    self.resources.dialogue:play(text, speed, textcolor)

end


----------------------------------------------------------------
function Character:update(deltaTime)

    self.resources.animation:update(deltaTime)

    self.resources.dialogue:update(deltaTime)

end


----------------------------------------------------------------
function Character:draw()

    -- Drawing the character
    love.graphics.push()
        love.graphics.scale(0.25, 0.25) -- Fit to screen
        love.graphics.translate(-640, 0) -- Set origin to the center; (1280 / 2 = 640)

        love.graphics.draw(self.resources.texture_base)
        love.graphics.draw(self.resources.texture_face, self.resources.animation(), 78, 280)
    love.graphics.pop()

    -- Drawing the text dialogue
    love.graphics.setColor(0, 0, 0)
        self.resources.dialogue:draw()
    love.graphics.setColor(1, 1, 1)

end


----------------------------------------------------------------
function Character:setFace(state)

    -- Delete previous face texture
    self.resources.texture_face:release()

    -- Load the new face image in the character/faces/x.png whereas 'x' is the parameter 'state'
    self.resources.texture_face = love.graphics.newImage(self.directory .. "textures/faces/" .. state .. ".png")

end


return Character