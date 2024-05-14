local dir = "assets/characters/yuyuko/"

local Brain = require("sources/brain"):new()

local Character = require("sources/character")

local Dialogue = loadfile(dir .. "dialogue/english")


----------------------------------------------------------------
-- Private
----------------------------------------------------------------
local m_texture_puke = love.graphics.newImage(dir .. "textures/puke.png")
local m_texture_tears = love.graphics.newImage(dir .. "textures/tears.png")

local m_particle_puke = love.graphics.newParticleSystem
local m_particle_tears = love.graphics.newParticleSystem

local m_wobble_progress = 0.0


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

-- Todo on wobble animation has progress. 1 = wobbled down, 0 = normal.
-- so that when speaking, tween progress back adn foruhtt 0 to 1

----------------------------------------------------------------
function Yuyuko:init()

    print("Yuyuko init() called!")

    Character.init(self, {76, 276}, {430, 830}, {276, 476}, {680, 470})

    self.resources.dialogue:tone("minor")


end


----------------------------------------------------------------
function Yuyuko:draw()

    Character.draw(Yuyuko)

end


----------------------------------------------------------------
local debounce1 = false
local debounce2 = false

function Yuyuko:update(deltaTime)

   Character.update(self, deltaTime)

    -- Wobbling Animation States
    if Yuyuko.state == "idle" then
        m_wobble_progress = m_wobble_progress + deltaTime
    end
    
    
    -- Debugging keyboard press
    if love.keyboard.isDown("w") then
        if not debounce1 then
            debounce1 = true

            Brain:push(1)
            Yuyuko:emotion("disgust")
        end
    else
        debounce1 = false
    end

    if love.keyboard.isDown("d") then
        if not debounce2 then
            debounce2 = true

            Brain:push(0)
            Yuyuko:emotion("happy")

        end
    else
        debounce2 = false
    end
 
end


return Yuyuko
