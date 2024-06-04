local dir = "assets/characters/yuyuko/"

local Language = require(dir .. "dialogue/english")

local AbstractCharacter = require("sources/character/abstract")


----------------------------------------------------------------
-- Private
----------------------------------------------------------------
local m_particle_puke = love.graphics.newParticleSystem
local m_particle_tears = love.graphics.newParticleSystem

local m_sound_burp
local m_chewing_sounds = {}
local m_chewing_soundref = nil -- current playing chewing sound to be stopped
local m_chewing_timer = 0.00
local m_chewing_duration = 0.00


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

    --------------------------------
    -- Load super class
    --------------------------------
    local resources_locations = {
        eyes          = {76, 276};
        mouth         = {430, 830};
        left_eyebrow  = {276, 476};
        right_eyebrow = {680, 470};
    }

    AbstractCharacter.load(self, dir, resources_locations)


    --------------------------------
    -- Load resources
    --------------------------------
    -- Eating sounds
    for i, v in pairs(love.filesystem.getDirectoryItems(dir .. "audio/chew")) do

        -- load the sound file
        local sound = love.audio.newSource(dir .. "audio/chew/" .. v, "static")
        sound:setLooping(true)

        -- store in table
        local filename = string.match(v, "(.+)%.") -- exclude file extension
        m_chewing_sounds[filename] = sound

    end

    m_sound_burp = love.audio.newSource(dir .. "audio/burp.wav", "static")

    -- Chewing state
    self.state:create("chewing", {

        enter = function()
            self.base:wobble(0.25, 3.0, 0.25)
            self.base.resources.sprite_mouth:play(3, 5, 0.35)
            
            do -- inject dialogue text content
                local content = self.dialogue.content
                local index = self.dialogue.index

                -- run if dialogue text is currently playing
                if index >= #content then
                    return
                end

                -- append cutoff phrase at the end
                local cutoff = Language.getRandomValue(Language.interjections.cutoff)
                self.dialogue.text:set(content:sub(1, index) .. cutoff)
            end
        end;

        update = function(deltaTime)
            m_chewing_timer = m_chewing_timer + deltaTime

            if m_chewing_timer >= m_chewing_duration then
                self:speak("Yum!")
            end
        end;

        leave = function()
            m_sound_burp:play()
            m_chewing_soundref:stop()
        end

    })


    --------------------------------
    -- Load data
    --------------------------------

end


----------------------------------------------------------------
function Yuyuko:chew(duration, material)


    m_chewing_duration = duration
    m_chewing_timer = 0.00

    m_chewing_soundref = m_chewing_sounds[material]
    m_chewing_soundref:play()

end


----------------------------------------------------------------
-- Debug
----------------------------------------------------------------
function love.keypressed(key, scancode, isrepeat)

    if scancode == 'w' then
        Yuyuko:speak("314159 wow yes! hello hi world, what is happening?!")
     end

    if scancode == 'd' then
        Yuyuko:chew(0.5, "metal")
    end

    if scancode == "space" then

    end

end

return Yuyuko
