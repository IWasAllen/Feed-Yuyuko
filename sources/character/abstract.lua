local Statemachine = require("sources/utils/statemachine")

local Base     = require("sources/character/base")
local Dialogue = require("sources/character/dialogue")
local Memory   = require("sources/character/memory")


----------------------------------------------------------------
-- Class
----------------------------------------------------------------
local AbstractCharacter = {}
AbstractCharacter.__index = AbstractCharacter


----------------------------------------------------------------
function AbstractCharacter:new()

    local class = {}
    class.base     = Base:new()
    class.dialogue = Dialogue:new()
    class.state    = Statemachine:new()
    class.memory   = Memory:new()

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function AbstractCharacter:load(resources_directory, base_settings)

    -- Character Body
    self.base:load(resources_directory, base_settings)

    -- Character Dialogue
    self.dialogue:load(resources_directory .. "dialogue/font.ttf", resources_directory .. "dialogue/voice.wav", "nearest")

    -- Character States
    self.state:create("idle", {

        enter = function()
            self.base.resources.sprite_mouth:stop()

            -- Reset wobbling effect to default
            self.base:wobble(0.50, 0.25, 1.50)

            print("[DEBUG] Character state changed to idle!")
        end;

    }, true)

    self.state:create("speaking", {

        enter = function()
            self.base.resources.sprite_mouth:play(2, 1, 0.5)
            self.base:wobble(2.0, 0.5, 0.5)
        end;

        update = function(deltaTime)
            if self.dialogue:done() then
                self.state:change("idle")
            end
        end;

        leave = function()
            self.dialogue:stop()
        end

    })

end


----------------------------------------------------------------
function AbstractCharacter:idle()

    self.state:change("idle")

end


----------------------------------------------------------------
function AbstractCharacter:speak(text)

    self.state:change("speaking")

    self.dialogue:play(text, 36)

end


----------------------------------------------------------------
function AbstractCharacter:update(deltaTime)

    self.state:update(deltaTime)

    self.base:update(deltaTime)

    self.dialogue:update(deltaTime)

end


----------------------------------------------------------------
function AbstractCharacter:draw()

    -- Drawing body
    self.base:draw(AbstractCharacter)

    -- Drawing text dialogue
    love.graphics.push()
        love.graphics.translate(self.base.cache.half_width * self.base.settings.scale, -48)
        self.dialogue:draw()
    love.graphics.pop()

end


return AbstractCharacter
