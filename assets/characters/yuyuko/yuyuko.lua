local dir = "assets/characters/yuyuko/"

local Language = loadfile(dir .. "dialogue/english")

local AbstractCharacter = require("sources/character/abstract")


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
local Yuyuko = AbstractCharacter:new()


----------------------------------------------------------------
function Yuyuko:init()

    print("Yuyuko init() called!")

    -- Initialize character resources
    local resources_locations = {
        eyes          = {76, 276};
        mouth         = {430, 830};
        left_eyebrow  = {276, 476};
        right_eyebrow = {680, 470};
    }

    AbstractCharacter.init(self, dir, resources_locations)

    -- Load property and states of saved data

end


----------------------------------------------------------------
-- Debug
----------------------------------------------------------------
function love.keypressed(key, scancode, isrepeat)

    if scancode == 'w' then
        Yuyuko:speak("314159 wow yes! hello hi world, what is happening?!")
     end

    if scancode == 'd' then

    end

    if scancode == "space" then
    end

end

return Yuyuko
