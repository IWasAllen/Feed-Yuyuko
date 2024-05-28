local SpriteHandler = require("sources/engine/spritehandler")

local TweenHandler = require("sources/engine/tweenhandler")

local Yuyuko = require("assets/characters/yuyuko/yuyuko")


----------------------------------------------------------------
function love.load()

    -- Splashscreen
    local splash_image = love.graphics.newImage("assets/textures/ui/startup.png")

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

        -- Centering Yuyuko at the bottom
        love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() - 160) 
        Yuyuko:draw()

    love.graphics.pop()

end


----------------------------------------------------------------
function love.update(dt)

    -- Engine Schedule
    SpriteHandler.update(dt)
    TweenHandler.update(dt)

    -- Game Interface Update
    Yuyuko:update(dt)

end
