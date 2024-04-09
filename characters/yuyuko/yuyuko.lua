local Brain = require("sources/brain"):new()

local Character = require("sources/character")

local Dialogue = require("characters/yuyuko/dialogue/english")


----------------------------------------------------------------
-- Private
----------------------------------------------------------------
local m_texture_puke = love.graphics.newImage("characters/yuyuko/textures/tears.png")
local m_texture_tears = love.graphics.newImage("characters/yuyuko/textures/puke.png")

local m_particle_puke = love.graphics.newParticleSystem
local m_particle_tears = love.graphics.newParticleSystem


----------------------------------------------------------------
local MAJOR_SCALE_PITCH = {1.00, 1.12, 1.25, 1.33, 1.49, 1.68, 1.88, 2.00}
local MINOR_SCALE_PITCH = {1.00, 1.12, 1.18, 1.33, 1.49, 1.58, 1.88, 2.00}
local WHOLE_SCALE_PITCH = {1.00, 1.12, 1.25, 1.41, 1.58, 1.78, 2.00}
local BLUES_SCALE_PITCH = {1.00, 1.18, 1.33, 1.41, 1.49, 1.78, 2.00}
local KLEZMER_SCALE_PTICH = {1.00, 1.05, 1.25, 1.33, 1.49, 1.58, 1.78, 2.00}


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
local Yuyuko = Character:new("characters/yuyuko")


----------------------------------------------------------------
function Yuyuko:init()

    Character.init(self)

    self.resources.dialogue:setPitches(MINOR_SCALE_PITCH)
    --------


end


----------------------------------------------------------------
function Yuyuko:draw()
    
    Character.draw(Yuyuko)

end


----------------------------------------------------------------
local debounce1 = false
local debounce2 = false

function Yuyuko:update(deltaTime)
   
   Character.update(Yuyuko, deltaTime)
   
    if love.keyboard.isDown("w") then
        if debounce1 then
            return
        end

        debounce1 = true
        
        Brain:push(1)
        local classified = Brain:analyze(1)
        print("1")
        
    else
        debounce1 = false
    end

    if love.keyboard.isDown("e") then
        if debounce2 then
            return
        end

        debounce2 = true
        
        Brain:push(0)
        local classified = Brain:analyze(1)
        print("0")
        
    else
        debounce2 = false
    end
    
    
    

end


return Yuyuko
