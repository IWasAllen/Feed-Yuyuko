local Yuyuko = {}
local Resolution = require("libs.resolution")
local Assets = require("libs.assets")

-- I apologize anyone for reading this code, I have to rush this project before August 11.
-- I started getting bored on this project so i don't really care if the code is messy.
-- just need to rush the graphics real quick by coding them how it would appear instead of organizing.

-- Private --
local hunger = 90
local isLose = false

local cooldown_save = 1    -- How long it takes for Yuyuko to save it's memory
local cooldown_check = 1   -- How long it takes for Yuyuko to check some datas

local drawables = {yuyuko = {}, dialogue = {}, icons = {}}
drawables.yuyuko.spritesheet = nil
drawables.yuyuko.sy = Resolution.getScaleY() / 2.15
drawables.yuyuko.sx = math.min(drawables.yuyuko.sy, Resolution.getScaleX() / 2.15)
drawables.yuyuko.x = Resolution.getCenterX(1280 * drawables.yuyuko.sx * 2.15 / Resolution.getScaleX(), 2.15)
drawables.yuyuko.y = Resolution.getBottomY(1280, 2.15)
drawables.yuyuko.r = 0
drawables.yuyuko.offsety = 0
drawables.yuyuko.quads_row = 1
drawables.yuyuko.quads = {}

drawables.icons = {
    file = love.graphics.newImage("assets/image/icon_file.png"),
    dll = love.graphics.newImage("assets/image/icon_dll.png"),
    folder = love.graphics.newImage("assets/image/icon_folder.png")
}

drawables.dialogue.color = 0
drawables.dialogue.text = ""
drawables.dialogue.x = 0
drawables.dialogue.y = Resolution.getCenterY(64,0.1)
drawables.dialogue.sy = math.min(1.5 * Resolution.getScaleX(), 1.5 * Resolution.getScaleY())
drawables.dialogue.sx = math.min(1.5 * Resolution.getScaleX(), 1.5 * Resolution.getScaleY())

local audios = {
    bgm = {
        background = love.audio.newSource("assets/audio/bgm/background.mp3", "stream"),
        final = love.audio.newSource("assets/audio/bgm/final.mp3", "stream")
    },
    chew = {
        paper = love.audio.newSource("assets/audio/chew/paper.wav", "static"),
        metal = love.audio.newSource("assets/audio/chew/metal.wav", "static"),
        slime = love.audio.newSource("assets/audio/chew/slime.wav", "static"),
        image = love.audio.newSource("assets/audio/chew/image.wav", "static"),
        hard = love.audio.newSource("assets/audio/chew/hard.wav", "static")
    },
    yuyuko = {
        burp = love.audio.newSource("assets/audio/yuyuko/burp.wav", "static"),
        confusion = love.audio.newSource("assets/audio/yuyuko/confusion.wav", "static"),
        disappoint = love.audio.newSource("assets/audio/yuyuko/disappoint.wav", "static"),
        voice = love.audio.newSource("assets/audio/yuyuko/voice.wav", "static")
    },
}

do -- Love Callbacks
    function Yuyuko.update(dt)
        hunger = hunger - dt / 1000 -- It takes 1000 seconds to lose 1 hunger level
	
        Yuyuko.animations.update(dt)
        Yuyuko.dialogue.update(dt)
        Yuyuko.stomach.update(dt)
        Yuyuko.lose.update(dt)

        if isLose then return end

        if cooldown_save <= 0 then cooldown_save = 1 Yuyuko.memory.save()
        else cooldown_save = cooldown_save - dt end

        if cooldown_check <= 0 then cooldown_check = 1 Yuyuko.stomach.digest() love.window.setTitle("Feed Yuyuko " .. math.floor(hunger / 0.01) * 0.01 .. "%")
        else cooldown_check = cooldown_check - dt end
    end

    function Yuyuko.draw()
        -- Draw Yuyuko --
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(
            drawables.yuyuko.spritesheet,
            drawables.yuyuko.quads[drawables.yuyuko.quads_row],
            drawables.yuyuko.x,
            drawables.yuyuko.y,
            drawables.yuyuko.r,
            drawables.yuyuko.sx,
            drawables.yuyuko.sy,
            1,
            drawables.yuyuko.offsety
        )

        -- Draw Dialogue --
        love.graphics.setColor(drawables.dialogue.color, drawables.dialogue.color, drawables.dialogue.color)
        love.graphics.print(drawables.dialogue.text, drawables.dialogue.x, drawables.dialogue.y, 0, drawables.dialogue.sx, drawables.dialogue.sy)

        -- Draw Particles --
        Yuyuko.animations.draw()

        -- Draw Lose --
        Yuyuko.lose.draw()
    end
end

Yuyuko.animations = {} do
    local animation_time = 0  -- The time position of the animation
    local animation_speed = 1 -- How fast the animation will play
    local animation_start = 1 -- Which row the sprite should start
    local animation_end = 1   -- How many rows the sprite will end

    local previous_hunger = 0 -- The previous hunger, used to check if the hunger changed instead of loop check
    local popup_y = 0 -- The popup animation when th game is loaded

    local particle_puke = love.graphics.newParticleSystem(love.graphics.newImage("assets/image/puke.png"))
    particle_puke:setParticleLifetime(1, 2)
    particle_puke:setLinearAcceleration(-64, 64, -512, 512)
    particle_puke:setRotation(0, 90)
    particle_puke:setSpeed(-128)

    local particle_puke_file = love.graphics.newParticleSystem(drawables.icons.file)
    particle_puke_file:setParticleLifetime(3)
    particle_puke_file:setLinearAcceleration(-64, 64, -512, 512)
    particle_puke_file:setRotation(0, 90)
    particle_puke_file:setSpeed(-256)

    local particle_tear = love.graphics.newParticleSystem(love.graphics.newImage("assets/image/tears.png"))
    particle_tear:setParticleLifetime(5)
    particle_tear:setLinearAcceleration(-256, 512, 256, 2560)
    particle_tear:setSpeed(2)

    local puke_cooldown = 0
    function Yuyuko.animations.puke()
        puke_cooldown = 1
        local chance = 10
        for i, v in pairs(love.filesystem.getDirectoryItems("yuyuko/stomach")) do
            chance = chance + 1
            if math.random(1, chance) > chance - 3 then
               os.rename("yuyuko/stomach/" .. v, love.filesystem.getUserDirectory() .. "Desktop/" .. v) 
            end
        end
    end

    function Yuyuko.animations.change(state)
        if state == "idle" then
            animation_time = 0
            animation_speed = 1
            animation_start = 1
            animation_end = 1
        elseif state == "speaking" then
            animation_time = 1
            animation_speed = 10
            animation_start = 1
            animation_end = 2
        elseif state == "eating" then
            animation_time = 2
            animation_speed = 10
            animation_start = 3
            animation_end = 3
        end
    end

    function Yuyuko.animations.update(dt)
        if animation_end > 1 then
            animation_time = animation_time + animation_speed * dt
            if animation_time > animation_end then animation_time = 0 end
        end

        if Yuyuko.dialogue.isDone() and Yuyuko.stomach.isDone() then Yuyuko.animations.change("idle") end
        drawables.yuyuko.quads_row = animation_start + math.floor(animation_time)

        if popup_y < 1 then
            popup_y = popup_y + dt / 1.5
            drawables.yuyuko.offsety = math.min(1 - math.pow(1 - popup_y, 4) * 1280, 0)
        end

        particle_puke:update(dt)
        particle_puke_file:update(dt)
        particle_tear:update(dt)

        if isLose then return end
        if hunger > 110 then
            if previous_hunger ~= 110 then
                previous_hunger = 110
                Yuyuko.animations.loadSpritesheet("nausea.png")
            end
        elseif hunger > 70 then
            if previous_hunger ~= 70 then
                previous_hunger = 70
                Yuyuko.animations.loadSpritesheet("happy.png")
            end
        elseif hunger > 50 then
            if previous_hunger ~= 50 then
                previous_hunger = 50
                Yuyuko.animations.loadSpritesheet("ok.png")
            end
        elseif hunger > 20 then
            if previous_hunger ~= 20 then
                previous_hunger = 20
                Yuyuko.animations.loadSpritesheet("angry.png")
            end
        elseif hunger > 0 then
            if previous_hunger ~= 1 then
                previous_hunger = 1
                Yuyuko.animations.loadSpritesheet("sad.png")
            end
            particle_tear:emit(1)
        else
            if previous_hunger ~= -1 then
                previous_hunger = -1
                Yuyuko.animations.loadSpritesheet("angry.png")
                Yuyuko.lose.start()
            end
        end

        if puke_cooldown > 0 then
            puke_cooldown = puke_cooldown - dt * 2
            particle_puke:emit(1)
            if math.random(1, 3) == 3 then particle_puke_file:emit(1) end
        end

        -- Wobble --
        drawables.yuyuko.y = Resolution.getBottomY(1280, 2.15) - math.sin(os.clock() * 4 / (math.max(0.7, hunger / 50))) * 16
        drawables.yuyuko.sy = Resolution.getScaleY() / 2.15 + math.sin(os.clock() * 4 / (math.max(0.7, hunger / 50))) / 80
    end

    function Yuyuko.animations.draw()
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(particle_puke, Resolution.getCenterX(32) * 0.95, Resolution.getCenterY(32) * 1.3 + drawables.yuyuko.y)
        love.graphics.draw(particle_puke_file, Resolution.getCenterX(32) * 0.95, Resolution.getCenterY(32) * 1.3 + drawables.yuyuko.y)
        love.graphics.draw(particle_tear, Resolution.getCenterX(4) / 1.15, Resolution.getCenterY(4) * 1.28 + drawables.yuyuko.y / 2 )
        love.graphics.draw(particle_tear, Resolution.getCenterX(4) * 1.05, Resolution.getCenterY(4) * 1.3 + drawables.yuyuko.y / 2 )
    end

    function Yuyuko.animations.loadSpritesheet(name) -- Load sprites rows by columns that are represented by the Y value drawables.yuyuko.spritesheet.
        drawables.yuyuko.spritesheet = nil collectgarbage("collect")-- Unloads the image
        drawables.yuyuko.spritesheet = love.graphics.newImage(Assets.load("yuyuko/face/" .. name))
        for x = 0, drawables.yuyuko.spritesheet:getWidth() - 1280, 1280 do
            table.insert(
                drawables.yuyuko.quads,
                love.graphics.newQuad(x, 0, 1280, 1280, drawables.yuyuko.spritesheet:getDimensions())
            )
        end
    end
end

Yuyuko.dialogue = {} do
    local dialogue_cooldown = 0
    local dialogue_speed = 1
    local dialogue_text = ""

    local previous_text = "" -- Used to check if text changed so that it can play the sound

    function Yuyuko.dialogue.start(text, speed)
        drawables.dialogue.text = ""
        dialogue_text = text
        dialogue_speed = 10 * (speed or 1)
        dialogue_cooldown = #dialogue_text

        drawables.dialogue.x = Resolution.getCenterX(love.graphics.getFont():getWidth(dialogue_text) * drawables.dialogue.sx / Resolution.getScaleX())
        Yuyuko.animations.change("speaking")
    end

    function Yuyuko.dialogue.update(dt)
        if dialogue_cooldown > 0 then
            dialogue_cooldown = math.max(0, dialogue_cooldown - dialogue_speed * dt)
            drawables.dialogue.text = dialogue_text:sub(1, math.min(-1, math.floor(-dialogue_cooldown)))

            if drawables.dialogue.text ~= previous_text then
                previous_text = drawables.dialogue.text
                audios.yuyuko.voice:play()
            end
        end
    end

    function Yuyuko.dialogue.isDone()
        return dialogue_cooldown <= 0
    end
end

Yuyuko.stomach = {} do
    local chewing_cooldown = 0 -- How long it takes for Yuyuko to chew the food
    local chewing_hunger = 0   -- The hunger that will be added after chewing
    local chewing_sound        -- The sound that will be played when eating and stopped when finished
    local chewing_music        -- The music that will be replaced by the dropped music file, and randomly wobbles

    local function chew(_cooldown, _sound, _hunger) -- Sets the chewing properties
        chewing_sound = nil collectgarbage("collect") -- Unload sound
        chewing_cooldown = _cooldown chewing_sound = _sound chewing_hunger = _hunger
        chewing_sound:setLooping(true) chewing_sound:play()
    end

    local dialogue_main = {
        {"Ooww.", "Tooo much...", "Yum."},
        {"Thank you~!", "Yummy.", "That was delicious!", "Tasty!", "I love that!", "Mmmmmmm.", "That was great!", "Very tasty.", "That was a perfect meal!"},
        {"That was really great.", "I will eat anything you give me.", "Mmmmmmm.", "I really love that food.", "Food Food Food!"},
        {"Aaaah.", "Oooww.", "Ughh.",  "Waaah!", "", "", ""},
    }

    local dialogue_custom = {
        important = {
            "That file seems to be important,\nbut tasty anyway.", "Whoops, was that file important?\nYum!", "Useful files do taste really delicious!"
        },
        disgusting = {
            "I don't like that file!", "Ew.", "Gross!", "Don't feed me that file again!", "Eh.", "Not that file!"
        }
    }

    local dialogue_sub = {
        {"I'm too full!", "I can't eat anymore!", "Please stop feeding me now!", "I'm gonna puke!", "Stop feeding me please!"},
        {"Could I have a little bit food?", "Could I also get another food?", "I still do not feel full.", "A little of food again please?"},
        {"I still feel hungry.", "I would like to have some big foods.", "Can I get some more food please?", "Can I get more food?", "My stomach still aching.", "It is not enough.", "I am in hunger."},
        {"I'm still hungry!", "I need more big food please!", "I am really hungry!", "I need more food!", "Please more food!", "I still want to eat more!", "I still don't feel full.", "I'm starving!", "My stomach hurts!"},
        {"I'm starving!", "Please I need more food!", "My stomach hurts so much!", "I need several gigantic food please!", "I request 100 MB of food!", "Please I need huge foods!", "I'm super uncomfortable!"},
        {"I'm starving help!", "Please keep feeding me!", "I'm so hungry that I could eat an elephant!", "I need gigantic foods now!", "It hurts.", "Please could you just feed me more food:1", "I'm sorry! Please I need more food.", "It really hurts."}
    }

    local selected_dialogue_custom = ""

    function Yuyuko.stomach.eat(path)
        if chewing_cooldown > 0 or isLose == true then return end

        local file = io.open(path, "a")
        if not file then print("Failed to eat the file at path: " .. path) return else file:write(" ") end

        local name = path:match("^.+/(.+)$") or path:match(("^.+\\(.+)$"))
        local extension = string.lower((path:match("^.+(%..+)$") or ""):sub(2))
        local size = file:seek("end") file:close()

        -- Eating System --
        if extension == "txt" or extension == "lnk" or extension == "md" or extension == "js" then
            chew(1.5, audios.chew.paper, size / 1200000)
        elseif extension == "png" or extension == "jpeg" or extension == "jpg" or extension == "bpm" or extension == "gif" or extension == "apng" or extension == "avif" or extension == "tiff" then
            chew(1, audios.chew.image, size / 1000000)
        elseif extension == "zip" or extension == "gz" or extension == "rar" or extension == "tgz" then
            chew(3, audios.chew.hard, size / 600000)
        elseif extension == "dll" or extension == "bin" or extension == "bat" or extension == "cmd" or extension == "msi" then
            chew(3, audios.chew.metal, size / 600000)
        elseif extension == "mp3" or extension == "wav" or extension == "ogg" then
            chewing_music = nil collectgarbage("collect") -- Unload
            chewing_music = love.audio.newSource(Assets.load(path), "stream")
            chewing_music:play()
            chew(chewing_music:getDuration("seconds"), audios.chew.slime, chewing_music:getDuration("seconds") / 15)
        else
            Yuyuko.dialogue.start("I don't think that file is edible.", 4)
            audios.yuyuko.disappoint:play() return
        end

        do
            local format_name = string.lower(name)
            if format_name:match("homework") or format_name:match("readme") or format_name:match("manual") or extension == "dll" or extension == "sys"then
                selected_dialogue_custom = "important"
            elseif format_name:match("virus") or format_name:match("poop") or format_name:match("trash") then
                selected_dialogue_custom = "disgusting"
            else
                selected_dialogue_custom = ""
            end
        end

        -- Swallowing System --
        while true do -- Add a discriminator if file name already exist in the stomach folder
            local file = io.open("yuyuko/stomach/" .. name)
            if file then name = " " .. name file:close() else break end
        end

        os.rename(path, "yuyuko/stomach/" .. name) -- Finally, move the file to the stomach
        Yuyuko.animations.change("eating")

        print("[" .. love.timer.getTime() .. "] Yuyuko ate the file " .. name)
    end

    function Yuyuko.stomach.digest()
        -- Loop through all files in the stomach folder
        for i, v in pairs(love.filesystem.getDirectoryItems("yuyuko/stomach")) do
            -- If the file's last modified date has reached 8 hours, then delete it
            if love.filesystem.getInfo("yuyuko/stomach/" .. v, "file").modtime + 28800 < os.time() then
                os.remove("yuyuko/stomach/" .. v) print("[" ..  os.clock() .. "] Digested: " .. v)
            end
        end
    end

    function Yuyuko.stomach.update(dt)
        if chewing_cooldown > 0 then chewing_cooldown = chewing_cooldown - dt
            if chewing_music then chewing_music:setPitch(1 + math.sin(os.clock() * 10) / 3) chewing_music:setVolume((0.1 + math.sin(os.clock() * math.random(100, 50)) - 0.5)) end
            if chewing_cooldown <= 0 then
                hunger = hunger + chewing_hunger chewing_hunger = 0
                chewing_sound:stop() 
                audios.yuyuko.burp:play()

                local current_main = ""
                local current_sub = ""

                if hunger >= 160 then
                    hunger = 130
                    current_main = "bleugh!"
                    audios.yuyuko.confusion:play()
                    Yuyuko.animations.puke()
                elseif hunger > 110 then
                    current_main = dialogue_main[1][math.random(1, #dialogue_main[1])]
                    current_sub = dialogue_sub[1][math.random(1, #dialogue_sub[1])]
                elseif hunger > 70 then
                    current_main = dialogue_main[2][math.random(1, #dialogue_main[2])]
                elseif hunger > 50 then
                    current_main = dialogue_main[2][math.random(1, #dialogue_main[2])]
                    current_sub = dialogue_sub[2][math.random(1, #dialogue_sub[2])]
                elseif hunger > 30 then
                    current_main = dialogue_main[3][math.random(1, #dialogue_main[3])]
                    current_sub = dialogue_sub[3][math.random(1, #dialogue_sub[3])]
                elseif hunger > 20 then
                    current_main = dialogue_main[4][math.random(1, #dialogue_main[4])]
                    current_sub = dialogue_sub[4][math.random(1, #dialogue_sub[4])]
                elseif hunger > 10 then
                    current_main = dialogue_main[4][math.random(1, #dialogue_main[4])]
                    current_sub = dialogue_sub[5][math.random(1, #dialogue_sub[5])]
                else
                    current_main = dialogue_main[4][math.random(1, #dialogue_main[4])]
                    current_sub = dialogue_sub[6][math.random(1, #dialogue_sub[6])]
                end

                if current_sub == "" then current_sub = current_main current_main = "" end

                if hunger > 30 and hunger <= 110 then
                    if selected_dialogue_custom ~= "" then current_main = dialogue_custom[selected_dialogue_custom][math.random(1, #dialogue_custom[selected_dialogue_custom])] current_sub = "" end
                end

                Yuyuko.dialogue.start(current_main .. "\n" .. current_sub, 2.5)
            end
        end
    end

    function Yuyuko.stomach.isDone()
        return chewing_cooldown <= 0
    end
end

Yuyuko.memory = {} do
    function Yuyuko.memory.save()
        local file = io.open("yuyuko/memory", "wb")
        if not file then error("Failed to save Yuyuko's memory!") end

        -- The compressed string must be wrapped in tostring() to prevent warning errors
        local content = tostring(love.data.compress("string", "deflate", "hunger=" .. hunger .. "\nepoch=" .. os.time()))

        file:write(content)
        file:close()

        print("[" .. love.timer.getTime() .. "] Yuyuko's memory has been saved!")
    end

    function Yuyuko.memory.load()
        local file = io.open("yuyuko/memory", "rb")
        if not file then print("Created new Yuyuko's memory file") Yuyuko.memory.save() return end

        for i in love.data.decompress("string", "deflate", file:read("*a")):gmatch("[^\r\n]+") do
            local key, value = i:match("(.+)=(.+)")

            if key == "hunger" then hunger = value
            elseif key == "epoch" then hunger = hunger - (os.time() - value) / 1000 -- Calculates Hunger Bar
            end
        end

        file:close()
        print("[" .. love.timer.getTime() .. "] Yuyuko's memory has been loaded!")
    end
end

Yuyuko.lose = {} do -- Lose
    local dialogue_stage = 0
    local next_time = 0

    local isBackgroundDim = false
    local backgroundColor = 1

    local showFiles = false
    local files_position_y = 0
    local files_transparent = 0

    local main_bgm_volumne = 0.05
 
    local popup_y = 1
    local isQuit = false -- enables if u can quit the game or not

    function Yuyuko.lose.update(dt)
        if not isLose then return end

        if main_bgm_volumne > 0 then
            main_bgm_volumne = math.max(main_bgm_volumne - dt / 50, 0)
            audios.bgm.background:setVolume(main_bgm_volumne)
        end

        if isBackgroundDim then
            backgroundColor = math.max(backgroundColor - 0.4 * dt, 0)
            love.graphics.setBackgroundColor(backgroundColor, backgroundColor, backgroundColor)
        else
            backgroundColor = math.min(backgroundColor + 0.3 * dt, 1)
            love.graphics.setBackgroundColor(backgroundColor, backgroundColor, backgroundColor)
        end

        if popup_y < 1 then
            popup_y = popup_y + dt / 1.5
            drawables.yuyuko.offsety = math.max(0 - math.pow(popup_y, 4) * 1280, -1280)
        end

        if showFiles then
            files_transparent = math.min(files_transparent + dt / 3, 1)
        else
            files_transparent = math.max(files_transparent - dt / 1.5, 0)
        end

        files_position_y = math.sin(os.clock() * 2) * 10

        if os.clock() < next_time then return end
        dialogue_stage = dialogue_stage + 1
        next_time = os.clock() + 4

        if dialogue_stage == 1 then
            Yuyuko.dialogue.start("You didn't feed me enough.", 2.6)
        elseif dialogue_stage == 2 then
            Yuyuko.dialogue.start("It's too late now.")
        elseif dialogue_stage == 3 then
            Yuyuko.dialogue.start("")
            Yuyuko.animations.loadSpritesheet("close.png")
            isBackgroundDim = true
            drawables.dialogue.color = 1
            popup_y = 0
            audios.bgm.final:setVolume(0.2)
            audios.bgm.final:play()
            next_time = next_time + 1 -- Add one second
        elseif dialogue_stage == 4 then
            Yuyuko.dialogue.start("These files looks really tasty.")
            showFiles = true
            next_time = next_time + 2 -- Add two second
        elseif dialogue_stage == 5 then
            Yuyuko.dialogue.start("It's unfortunate that I'm really hungry\nbecause you weren't feeding me.", 2)
            next_time = next_time + 2 -- Add two second
        elseif dialogue_stage == 6 then 
            Yuyuko.dialogue.start("I have gained full access to your system\nmemory now!", 1.5)
            showFiles = false
            next_time = next_time + 1 -- Add one second
        elseif dialogue_stage == 7 then
            audios.yuyuko.voice:setPitch(0.95)
            Yuyuko.dialogue.start("I'll eat everything!", 1)
            isBackgroundDim = false
            next_time = next_time - 0.6 -- Remove 0.6 second
        elseif dialogue_stage == 8 then
            audios.bgm.final:stop()
            os.remove("yuyuko/face/angry.png")
            os.remove("yuyuko/face/close.png")
            os.remove("yuyuko/face/nausea.png")
            os.remove("yuyuko/face/nausea.png")
            os.remove("yuyuko/face/ok.png")
            os.remove("yuyuko/face/sad.png")
            os.remove("yuyuko/face/scary.png")
            os.remove("yuyuko/face/template.pdn")
            os.remove("yuyuko/face/happy.png")

            os.remove("yuyuko/peaks/script.txt")
            os.remove("yuyuko/peaks/wip.png")
            os.remove("yuyuko/peaks/")

            os.remove("yuyuko/memory")

			-- Welp, you can't delete these files without getting permission error. I guess I'll find a way in next revamp
            os.remove("love.dll")
            os.remove("lua51.dll")
            os.remove("mpg123.dll")
            os.remove("OpenAL32.dll")
            os.remove("SDL2.dll")
            os.remove("game.exe")
            love.window.showMessageBox("Feed Yuyuko", "The game has crashed!\n\nYuyuko accidently ate her game files and data first before your system files.\nYour PC should be safe now.", "error")
            isQuit = false
            love.event.quit()
        end
    end

    function Yuyuko.lose.draw()
        if not isLose then return end
        love.graphics.setColor(1, 1, 1, files_transparent)
        love.graphics.draw(drawables.icons.dll, Resolution.getCenterX(32) * 0.2, Resolution.getCenterY(32) * 0.6 + files_position_y, 0, 6 * Resolution.getScaleX(), 6 * Resolution.getScaleY())
        love.graphics.draw(drawables.icons.dll, Resolution.getCenterX(32) * 0.85, Resolution.getCenterY(32) * 0.6 + files_position_y, 0, 6 * Resolution.getScaleX(), 6 * Resolution.getScaleY())
        love.graphics.draw(drawables.icons.folder, Resolution.getCenterX(32) * 1.645, Resolution.getCenterY(32) * 0.6 + files_position_y, 0, 6 * Resolution.getScaleX(), 6 * Resolution.getScaleY())

        love.graphics.setColor(1, 1, 1, files_transparent)
        love.graphics.print("system32.dll", drawables.dialogue.sx * 32, drawables.dialogue.sy * 260 + files_position_y, 0, drawables.dialogue.sx, drawables.dialogue.sy)
        love.graphics.print("kernel32.dll", drawables.dialogue.sx * 320, drawables.dialogue.sy * 260 + files_position_y, 0, drawables.dialogue.sx, drawables.dialogue.sy)
        love.graphics.print("Appdata", drawables.dialogue.sx * 675, drawables.dialogue.sy * 260 + files_position_y, 0, drawables.dialogue.sx, drawables.dialogue.sy)
    end

    function Yuyuko.lose.start()
        isLose = true
        isQuit = true
        next_time = os.clock() + 3
        Yuyuko.dialogue.start("")

        function love.quit()
            -- Prevents closing the game
            return isQuit
        end
    end
end

-- Load BGM --
if hunger > 0 then
    audios.bgm.background:play()
    audios.bgm.background:setLooping(true)
    audios.bgm.background:setVolume(0.05)
end

return Yuyuko