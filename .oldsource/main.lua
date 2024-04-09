local Yuyuko
local Resolution

function love.load()
    -- Startup --
    love.graphics.clear()
    love.graphics.draw(love.graphics.newImage("startup.png"), 0, 0, 0, love.graphics.getWidth() / 1280, love.graphics.getHeight() / 720)
    love.graphics.present()
    love.event.pump()

    -- Load --
    Resolution = require("libs.resolution")
    Resolution.setResolution(1280, 720)

    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setDefaultFilter("nearest", "nearest")

    Yuyuko = require("yuyuko")
    Yuyuko.memory.load()
    Yuyuko.stomach.digest()

    love.graphics.setFont(love.graphics.newFont("assets/fonts/rainyhearts.ttf", 48))

    collectgarbage("collect")
end

function love.update(dt)
    math.randomseed(os.time() + love.timer.getTime())
    Yuyuko.update(dt)
end

function love.draw()
    Yuyuko.draw()
end

function love.filedropped(file)
    Yuyuko.stomach.eat(file:getFilename())
end

function love.quit()
    Yuyuko.memory.save()
end