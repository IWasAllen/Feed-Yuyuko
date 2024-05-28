local Statemachine = require("sources/utils/statemachine")

local Base     = require("sources/character/base")
local Dialogue = require("sources/character/dialogue")
local Memory   = require("sources/character/memory")



----------------------------------------------------------------
-- Class
----------------------------------------------------------------
local AbstractCharacter = Base:new()
AbstractCharacter.__index = AbstractCharacter


----------------------------------------------------------------
function AbstractCharacter:new()

    local class = {}
    class.state = Statemachine:new()

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function AbstractCharacter:init(assetdir, resource_locations)

    Base.init(self, assetdir, resource_locations)

    -- Character Dialogue
    self.resources.dialogue = Dialogue:new(assetdir .. "dialogue/font.ttf", assetdir .. "dialogue/voice.wav")
    self.resources.dialogue.font:setFilter("nearest", "nearest")

    -- Character States
    do -- Idle
        self.state:create("idle", function()
            print("idle!")

            self.resources.sprite_mouth:stop()
            self:wobble(0.25, 0.50, 1.0)
        end)
    end

    do -- Speaking
        self.state:create("speaking", nil, function(deltaTime)
            self.resources.dialogue:update(deltaTime)

            if self.resources.dialogue:done() then
                self.state:change("idle")
            end
        end)
    end

end


----------------------------------------------------------------
function AbstractCharacter:speak(text)

    self.state:change("speaking")

    self.resources.dialogue:play(text, 32)
    self.resources.sprite_mouth:play(2, 1, 0.5)
    self:wobble(0.5, 2.0, 0.5)

end


----------------------------------------------------------------
function AbstractCharacter:update(deltaTime)

    self.state:update(deltaTime)

    Base.update(AbstractCharacter, deltaTime)

end


----------------------------------------------------------------
function AbstractCharacter:draw()
    
    Base.draw(AbstractCharacter)
    
    -- Drawing text dialogue
    love.graphics.push()
        love.graphics.translate(0, -196)
        self.resources.dialogue:draw()
    love.graphics.pop()

end

return AbstractCharacter
