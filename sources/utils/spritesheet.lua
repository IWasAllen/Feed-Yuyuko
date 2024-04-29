local Spritesheet = {}


----------------------------------------------------------------
function Spritesheet:new(image_filename, frame_width, frame_height)

    local class = {}
    class.image = love.graphics.newImage(image_filename)
    class.quads = {}
    class.current_row = 1

    class.column_start = 1
    class.column_end = 1
    class.speed = 1.0
    class.progress = 0.0

    -- Slices each rows into quads
    for i = 0, class.image:getHeight() - frame_height, frame_height do
        local row = i / frame_height + 1
        class.quads[row] = {}

        for j = 0, class.image:getWidth() - frame_width, frame_width do
            table.insert(class.quads[row], love.graphics.newQuad(
                j,
                i,
                frame_width,
                frame_height,
                class.image
            ))
        end
    end

    setmetatable(class, self)
    self.__index = self

    return class

end


----------------------------------------------------------------
Spritesheet.__call = function(self)

    local column = math.floor(self.column_start + (self.column_end - self.column_start) * self.progress)

    -- Shortcut for retrieving the image and quad for love.graphics.draw()
    return self.image, self.quads[self.current_row][column]

end


----------------------------------------------------------------
function Spritesheet:play(start_column, end_column, duration)

    self.progress = 0.0

    if duration then
        self.speed = 1 / duration
    end

    -- Offseting extra column for the lerp in .__call() to substitute total frames when calculating the difference between.
    if start_column < end_column  then
        self.column_start = start_column 
        self.column_end   = end_column + 1
    else
        self.column_start = start_column + 1
        self.column_end   = end_column
    end

end


----------------------------------------------------------------
function Spritesheet:row(row)

    self.current_row = row

end


----------------------------------------------------------------
function Spritesheet:stop()

    self.column_end = self.column_start

end


----------------------------------------------------------------
function Spritesheet:update(deltaTime)

    self.progress = (self.progress + deltaTime * self.speed) % 1

end


return Spritesheet