function love.conf(t)

    t.author = "IWasAllen"
    t.title = "Feed Yuyuko"
    t.version = "11.5"

    t.window.width     = 852
    t.window.height    = 480
    t.window.minwidth  = 1
    t.window.minheight = 1
    t.window.resizable = true
    t.window.vsync     = 1
    
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
