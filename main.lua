local TweenHandler = require("sources/engine/tweenhandler")

local Yuyuko = require("assets/characters/yuyuko/yuyuko")


----------------------------------------------------------------
local original_resolution_x = 1280
local original_resolution_y = 720

local scale_resolution_x = love.graphics.getWidth() / original_resolution_x
local scale_resolution_y = love.graphics.getHeight() / original_resolution_y


----------------------------------------------------------------
function love.load()

    -- Splashscreen
    local splash_image = love.graphics.newImage("assets/textures/ui/startup.png")

    love.graphics.clear()
        love.graphics.draw(
            splash_image,
            love.graphics.getWidth() / 2 - splash_image:getWidth() / 2,
            love.graphics.getHeight() / 2 - splash_image:getHeight() / 2
        )
    love.graphics.present()
    splash_image:release()

    -- Initialize Graphics
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setDefaultFilter("linear", "linear")

    -- Initialize Game
    Yuyuko:init()

end


----------------------------------------------------------------
function love.draw()

    -- Drawing Yuyuko
    love.graphics.push()

        -- centering Yuyuko and anchoring at the bottom
        love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() - 160)

        Yuyuko:draw()
    love.graphics.pop()

end


----------------------------------------------------------------
function love.update(dt)

    TweenHandler.update(dt)
    
    Yuyuko:update(dt)

end
