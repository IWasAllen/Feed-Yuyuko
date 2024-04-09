local Yuyuko = require("characters/yuyuko/yuyuko")


----------------------------------------------------------------
local original_resolution_x = 1280
local original_resolution_y = 720

local scale_resolution_x = love.graphics.getWidth() / original_resolution_x
local scale_resolution_y = love.graphics.getHeight() / original_resolution_y

-- add game.lua, which handles screen shaking, bgm, vignette, etc.

----------------------------------------------------------------
function love.load()

    -- Splashscreen
    love.graphics.clear()
        love.graphics.draw(
            love.graphics.newImage("assets/textures/ui/startup.png"),
            love.graphics.getWidth() / 2 - 426,
            love.graphics.getHeight() / 2 - 240
        )
    love.graphics.present();

    -- Initialization
    love.graphics.setBackgroundColor(255, 255, 255)

    love.graphics.setDefaultFilter("linear", "linear")

    Yuyuko:init()
Yuyuko:speak("What would it be to take that when it realize\nyou can't really have anything that may have been able\nto do so.", 16)

end


----------------------------------------------------------------
function love.draw()

    -- Drawing Yuyuko in the center
    love.graphics.push()
        love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() - 320)

        Yuyuko:draw()
    love.graphics.pop()

end


----------------------------------------------------------------
function love.update(dt)

    Yuyuko:update(dt)

end
