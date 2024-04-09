function love.conf(t)
    t.author = "IWasAllen"
    t.title = "Feed Yuyuko"
    t.version = "11.4"

    t.window.fullscreen = false
    t.window.resizable = false
    t.window.width = 852
    t.window.height = 480
    t.window.minwidth = 852
    t.window.minheight = 480
    t.window.vsync = 1

	if love.filesystem.isFused() then
        t.modules.data = false
        t.modules.joystick = false
        t.modules.keyboard = false
        t.modules.math = false
        t.modules.mouse = false
        t.modules.physics = false
        t.modules.thread = false
        t.modules.touch = false
        t.modules.video = false
	else
		t.console = true
	end

end