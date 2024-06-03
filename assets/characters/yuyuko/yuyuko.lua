local dir = "assets/characters/yuyuko/"

local Language = loadfile(dir .. "dialogue/english")

local AbstractCharacter = require("sources/character/abstract")


----------------------------------------------------------------
-- Private
----------------------------------------------------------------
local m_particle_puke = love.graphics.newParticleSystem
local m_particle_tears = love.graphics.newParticleSystem

local m_sound_burp
local m_chewing_sounds = {}


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
function Yuyuko:load()

    print("Yuyuko load() called!")

    -- Load abstract character resources
    local resources_locations = {
        eyes          = {76, 276};
        mouth         = {430, 830};
        left_eyebrow  = {276, 476};
        right_eyebrow = {680, 470};
    }

    AbstractCharacter.load(self, dir, resources_locations)

    -- Load chewing sounds
    for i, v in pairs(love.filesystem.getDirectoryItems(dir .. "audio/chew")) do

        -- load the sound file
        local sound = love.audio.newSource(dir .. "audio/chew/" .. v, "static")
        sound:setLooping(true)

        -- store in resources
        local filename = string.match(v, "(.+)%.") -- ignore file extension
        m_chewing_sounds["sound_chew_" .. filename] = sound

    end

    -- load other food related sound
    m_sound_burp = love.audio.newSource(dir .. "audio/burp.wav", "static")

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
        Yuyuko:chew(10.0, "slime")
    end

    if scancode == "space" then

    end

end

return Yuyuko
