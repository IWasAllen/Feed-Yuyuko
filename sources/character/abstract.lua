local Base     = require("sources/character/base")
local Dialogue = require("sources/character/dialogue")
local Memory   = require("sources/character/memory")

local Statemachine = require("sources/utils/statemachine")


----------------------------------------------------------------
-- Class
----------------------------------------------------------------
local AbstractCharacter = {}
AbstractCharacter.__index = AbstractCharacter


----------------------------------------------------------------
function AbstractCharacter:new()

    local class = {}
    class.base = Base:new()
    class.dialogue = Dialogue:new()
    class.state = Statemachine:new()
    class.memory = Memory:new()

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function AbstractCharacter:load(assetdir, resource_locations)

    -- Character Body
    self.base:load(assetdir, resource_locations)

    -- Character Dialogue
    self.dialogue:load(assetdir .. "dialogue/font.ttf", assetdir .. "dialogue/voice.wav", "nearest")

    -- Character States
    self.state:create("idle", {

        enter = function()
            -- Stop mouth animations
            self.base.resources.sprite_mouth:stop()

            -- Reset wobbling effect
            self.base:wobble(0.50, 0.25, 1.00)
            
            print("[DEBUG] Character state changed to idle!")
        end;

    })

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
            if not self.dialogue:done() then
                local cutoff = "~!"
                local content = string.sub(self.dialogue.content, 0, self.dialogue.index) .. cutoff
                self.dialogue.content = content
            end
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

    self.dialogue:play(text, 32)

end


----------------------------------------------------------------
function AbstractCharacter:update(deltaTime)

    self.state:update(deltaTime)

    self.base:update(deltaTime)

    self.dialogue:update(deltaTime)

end


----------------------------------------------------------------
function AbstractCharacter:draw()

    self.base:draw(AbstractCharacter)

    -- Drawing text dialogue
    love.graphics.push()
        love.graphics.translate(self.base.cache.half_width * self.base.settings.scale, -48)
        self.dialogue:draw()
    love.graphics.pop()

end


return AbstractCharacter
