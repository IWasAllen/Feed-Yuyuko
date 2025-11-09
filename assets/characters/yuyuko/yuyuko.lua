-- Yuyuko has 4 character states:
--   - Idle
--   - Speaking
--   - Chewing
--   - Puking

local dir = "assets/characters/yuyuko/"
local AbstractCharacter = require("sources/character/abstract")
local Language = require(dir .. "dialogue/english")


----------------------------------------------------------------
-- Private
----------------------------------------------------------------
local m_chew_duration = 0.00
local m_chew_time     = 0.00

local m_puke_duration = 0.00
local m_puke_time     = 0.00

local m_particle_puke
local m_particle_tears

local m_sound_burp
local m_sound_chew
local m_sound_puke

local m_sounds_chew = {}

local m_bytes = {
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
    -- Load Super Class
    --------------------------------
    local settings = {
        eyes          = {76, 276};
        mouth         = {430, 830};
        left_eyebrow  = {276, 476};
        right_eyebrow = {680, 470};

        scale = 0.25;
    }

    AbstractCharacter.load(self, dir, settings)


    --------------------------------
    -- Load Resources
    --------------------------------

    -- Chewing Sounds
    for i, v in pairs(love.filesystem.getDirectoryItems(dir .. "audio/chew")) do

        -- load the sound file
        local sound = love.audio.newSource(dir .. "audio/chew/" .. v, "static")
        sound:setLooping(true)

        -- store in table
        local filename = string.match(v, "(.+)%.") -- exclude file extension
        m_sounds_chew[filename] = sound

    end

    m_sound_burp = love.audio.newSource(dir .. "audio/burp.wav", "static")
    m_sound_puke = love.audio.newSource(dir .. "audio/puke.wav", "static")

    -- Particles
    m_particle_puke = love.graphics.newParticleSystem(love.graphics.newImage(dir .. "textures/puke.png"))
    m_particle_puke:setColors(0.35, 0.5, 0.35, 0.6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)
    m_particle_puke:setEmissionRate(16)
    m_particle_puke:setLinearAcceleration(-400, 1024, 128, 64)
    m_particle_puke:setParticleLifetime(1)
    m_particle_puke:setRotation(-90, 90)
    m_particle_puke:setSizes(1, 2)
    m_particle_puke:setSpin(0, 10)
    m_particle_puke:stop()

    m_particle_tears = love.graphics.newParticleSystem(love.graphics.newImage(dir .. "textures/tears.png"))
    m_particle_tears:setColors(1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0)
    m_particle_tears:setEmissionRate(2)
    m_particle_tears:setLinearAcceleration(0, 300, 0, 400)
    m_particle_tears:setParticleLifetime(0.50, 1.25)
    m_particle_tears:setSizes(0.75, 1, 1.15, 0.75)
    m_particle_tears:setSpin(-1, 2)
    m_particle_tears:stop()


    -- State Machines
    self.state:create("chewing", {

        --------------------------------
        enter = function()
    
            m_chew_time = 0

            self.base.resources.sprite_mouth:play(3, 5, 0.35)
            self.base:wobble(3.75, 0.25, 0.125)

        end;

        --------------------------------
        update = function(deltaTime)
    
            m_chew_time = m_chew_time + deltaTime

            if m_chew_time >= m_chew_duration then
                self.base:blink()

                -- this will also leave this state
                m_sound_burp:play()
                self:speak("Yum!")
            end

        end;

        --------------------------------
        leave = function()

            m_sound_chew:stop()

        end;

    })

    self.state:create("vomiting", {

        --------------------------------
        enter = function()

            m_puke_time = 0

            self.base:blink(m_puke_duration)            
            self.base:emotion("disgust")
            self.base.resources.sprite_mouth:play(2, 2, 1)
            self.base:wobble(1.50, 3.00, 0.75)

            m_particle_puke:start()
            m_particle_puke:emit(4)

        end;

        --------------------------------
        update = function(deltaTime)

            m_puke_time = m_puke_time + deltaTime

            if m_puke_time >= m_puke_duration then
                self.state:change("idle")
            end

        end;

        --------------------------------
        leave = function()

            m_particle_puke:stop()

        end;

    })


    --------------------------------
    -- Load Data
    --------------------------------
    self.dialogue:setMusicalScale("whole")

end


----------------------------------------------------------------
function Yuyuko:chew(duration, material)
    
    -- rename this method to :eat(filename)
    
    m_chew_duration = duration
    self.state:change("chewing")

    m_sound_chew = m_sounds_chew[material]
    m_sound_chew:play()

end


----------------------------------------------------------------
function Yuyuko:cry(enabled)

    if enabled then
        m_particle_tears:start()
        m_particle_tears:emit(1)
    else
        m_particle_tears:stop()
    end

end


----------------------------------------------------------------
function Yuyuko:puke(duration)

    m_puke_duration = duration or 1
    self.state:change("vomiting")

    m_sound_puke:stop()
    m_sound_puke:play()
    
    -- system for puking the files out of the stomach

end


----------------------------------------------------------------
function Yuyuko:update(deltaTime)

    AbstractCharacter.update(Yuyuko, deltaTime)

    -- Particles Emitter
    m_particle_puke:update(deltaTime)
    m_particle_tears:update(deltaTime)

end


----------------------------------------------------------------
function Yuyuko:draw()

    -- Draw Character
    AbstractCharacter.draw(Yuyuko)

    -- Draw Particles
    love.graphics.push()

        -- Puke
        love.graphics.push()
            love.graphics.translate(138, 252)
            love.graphics.draw(m_particle_puke)
        love.graphics.pop()

        -- Left Tears
        love.graphics.push()
            love.graphics.translate(100, 212)
            love.graphics.draw(m_particle_tears)

            love.graphics.scale(0.5, 0.75)
            love.graphics.draw(m_particle_tears)
        love.graphics.pop()

        -- Right Tears
        love.graphics.push()
            love.graphics.translate(192, 220)
            love.graphics.draw(m_particle_tears)

            love.graphics.scale(0.5, 0.75)
            love.graphics.draw(m_particle_tears)
        love.graphics.pop()

    love.graphics.pop()

end


return Yuyuko
