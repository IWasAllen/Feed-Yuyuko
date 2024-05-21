local dir = "assets/characters/yuyuko/"

local Brain = require("sources/brain"):new()

local Character = require("sources/character")

local Dialogue = loadfile(dir .. "dialogue/english")

local TweenHandler = require("sources/engine/tweenhandler")


----------------------------------------------------------------
-- Private
----------------------------------------------------------------
local m_texture_puke = love.graphics.newImage(dir .. "textures/puke.png")
local m_texture_tears = love.graphics.newImage(dir .. "textures/tears.png")

local m_particle_puke = love.graphics.newParticleSystem
local m_particle_tears = love.graphics.newParticleSystem


----------------------------------------------------------------
local Bytes = {
    ["idle"]             = 0,
    ["left_short"]       = 1,
    ["left_medium"]      = 2,
    ["left_long"]        = 3,

    ["eat_normal_file"]  = 10,
    ["eat_good_file"]    = 11, -- if repetitive, yuyuko overloads and plays blues scale
    ["eat_bad_file"]     = 12,
    ["eat_empty_file"]   = 13,
}


----------------------------------------------------------------
-- Public
----------------------------------------------------------------
local Yuyuko = Character:new(dir)


----------------------------------------------------------------
function Yuyuko:init()

    print("Yuyuko init() called!")

    local resources_locations = {
        eyes          = {76, 276};
        mouth         = {430, 830};
        left_eyebrow  = {276, 476};
        right_eyebrow = {680, 470};
    }

    Character.init(self, resources_locations)

    self.resources.dialogue:setScale("minor")

end


----------------------------------------------------------------
-- Debug
----------------------------------------------------------------
function love.keypressed(key, scancode, isrepeat)

    if scancode == 'w' then
        print("Pushed 1")
 
        Yuyuko:speak("The quick brown jumped over the lazy dog.", 14)
        Yuyuko:emotion("sad")
    end

    if scancode == 'd' then
        print("Pushed 0")
        Yuyuko:emotion("happy")
    end

end

return Yuyuko
