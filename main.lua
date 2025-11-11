local SpriteHandler = require("sources/engine/spritehandler")

local TweenHandler = require("sources/engine/tweenhandler")

local Yuyuko = require("assets/characters/yuyuko/yuyuko")

-- TODO:
-- dialogue
-- diet bar (in the future)

----------------------------------------------------------------
function love.load()

    ------------------------------
    -- Splashscreen
    ------------------------------
    local splash_image = love.graphics.newImage("assets/textures/ui/startup.png")

    love.graphics.draw(
        splash_image,
        love.graphics.getWidth() / 2 - splash_image:getWidth() / 2,
        love.graphics.getHeight() / 2 - splash_image:getHeight() / 2
    )
    love.graphics.present()


    ------------------------------
    -- Game
    ------------------------------
    love.graphics.setBackgroundColor(255, 255, 255)
    love.graphics.setDefaultFilter("linear", "linear")

    Yuyuko:load()

    -- Cleanup
    -- love.timer.sleep(0.25)
    splash_image:release()
    collectgarbage("collect")

end


----------------------------------------------------------------
function love.update(dt)

    -- Game Engine Schedule
    TweenHandler.update(dt)
    SpriteHandler.update(dt)

    -- Game Interface Update
    Yuyuko:update(dt)

end


----------------------------------------------------------------
function love.draw()

    -- Drawing Yuyuko
    love.graphics.push()

        -- Center Bottom
        love.graphics.translate(love.graphics.getWidth() / 2 - 160, love.graphics.getHeight() - 320)
        -- Magic number '160' = 1280 (Yuyuko's Width) * 0.25 (Yuyuko's Scale) / 2
        -- Magic number '320' = 1280 (Yuyuko's Height) * 0.25 (Yuyuko's Scale) / 4

        Yuyuko:draw()

    love.graphics.pop()

end






















----------------------------------------------------------------
-- Debug
----------------------------------------------------------------
local previousBytes = 0
local previousTime = 0

local previousAvgTime = 0
local avgTime = {}

function dbyte(restart)

    local newBytes = collectgarbage("count")

    if not restart then
        local difference = newBytes - previousBytes
        print(string.format("[DEBUG] %.1f Bytes (%.2fKB)", difference * 1024, difference))
    end

    previousBytes = newBytes

end

function dtime(restart)

    local newTime = love.timer.getTime()

    local difference = newTime - previousTime

    previousTime = newTime

    if not restart then
        print(string.format("[DEBUG] Time elapsed %.7fs", difference))
    end

end

function davg(restart)

    local newTime = love.timer.getTime()

    local difference = newTime - previousAvgTime

    previousAvgTime = newTime

    if restart then
        return
    end

    table.insert(avgTime, difference)
    
    if #avgTime > 30 then
        table.remove(avgTime, 1)
    end
    
    local sum = 0.00
    
    for i = 1, #avgTime do
        sum = sum + avgTime[i]
    end

    print(string.format("[DEBUG] Average time elapsed %.7fs", sum / #avgTime))

end

----------------------------------------------------------------
-- Yuyuko Debug
----------------------------------------------------------------
local toggle_cry = false

function love.keypressed(key, scancode, isrepeat)

    if scancode == 's' then
        Yuyuko:speak("The quick brown fox jumps over the lazy dog!")
     end

    if scancode == 'c' then
        Yuyuko:chew(1, "metal")
    end
    
    if scancode == "space" then
        Yuyuko.base:blink()
    end

    if scancode == "1" then
        Yuyuko:puke(1)
    end

    if scancode == "2" then
        toggle_cry = not toggle_cry
        
        Yuyuko:cry(toggle_cry)
    end

    if scancode == "5" then
        Yuyuko.base:emotion("sad")
    end

    if scancode == "6" then
        Yuyuko.base:emotion("angry")
    end

    if scancode == "7" then
        Yuyuko.base:emotion("happy")
    end

end

