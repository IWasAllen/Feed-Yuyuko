function love.conf(t)

    t.author = "IWasAllen"
    t.title = "Feed Yuyuko"
    t.version = "11.5"

    t.window.width     = 852
    t.window.height    = 480
    t.window.minwidth  = 852
    t.window.minheight = 480
    t.window.resizable = true
    t.window.highdpi   = true
    
    t.modules.data     = false
    t.modules.joystick = false
    t.modules.keyboard = true
    t.modules.math     = true
    t.modules.mouse    = false
    t.modules.physics  = false
    t.modules.thread   = false
    t.modules.touch    = false
    t.modules.video    = false

    t.console = true

end
