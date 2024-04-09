local Animation = {}


----------------------------------------------------------------
function Animation:new(image, frame_width, frame_height)

    local class = {}

    -- Dimension details
    class.image_reference = image
    class.frame_width = frame_width
    class.frame_height = frame_height

    -- Frame storage
    class.states = {}
    class.current_state = nil -- holds a reference

    -- Frame index calculation 
    class.index = 1
    class.speed = 1
    class.progress = 0

    setmetatable(class, self)
    self.__index = self

    return class

end


----------------------------------------------------------------
Animation.__call = function(self)
    
    -- Shortcut for retrieving the current quad from the spritesheets
    return self.current_state[self.index]

end


----------------------------------------------------------------
function Animation:add(name, row, start_column, end_column)

    self.states[name] = {}

    for x = start_column, end_column do
        table.insert(self.states[name], love.graphics.newQuad(
            self.frame_width * (x - 1),
            self.frame_height * (row - 1),
            self.frame_width,
            self.frame_height,
            self.image_reference
        ))
    end

end


----------------------------------------------------------------
function Animation:play(state, duration, startIndex)

    -- Set the current state reference
    self.current_state = self.states[state]

    -- Converts the duration to speed
    if duration then
        self.speed = 1 / duration
    end

    -- Calculates the progress position where at the provided index will play
    if startIndex then
        self.progress = (startIndex - 1) / #self.current_state
    end

end


----------------------------------------------------------------
function Animation:update(deltaTime)

    -- Progress animation frame
    self.progress = self.progress + deltaTime * self.speed

    if self.progress > 1.0 then
        self.progress = self.progress % 1
    end

    -- Calculate current frame index by the current progress
    self.index = math.floor(#self.current_state * self.progress) + 1

end


return Animation