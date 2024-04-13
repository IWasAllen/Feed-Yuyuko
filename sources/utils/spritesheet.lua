local Spritesheet = {}


----------------------------------------------------------------
function Spritesheet:new(image_filename, frame_width, frame_height)

    local class = {}
    class.image = love.graphics.newImage(image_filename)
    class.quads = {}
    class.row = 1

    class.column_start = 1
    class.column_end = 1
    class.speed = 1.0
    class.progress = 0.0

    -- Slices rows into quads
    for i = 0, class.image:getHeight() - frame_height, frame_height do
        class.quads[i + 1] = {}

        for j = 0, class.image:getWidth() - frame_width, frame_width do
            table.insert(class.quads[i + 1], love.graphics.newQuad(
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

    -- Shortcut for retrieving the image and quad for love.graphics.draw()
    return self.image, self.quads[self.row][math.floor(self.progress) + self.column_start]

end


----------------------------------------------------------------
function Spritesheet:row(row)

    self.row = row

end


----------------------------------------------------------------
function Spritesheet:play(start_column, end_column, duration)

    local reversed = start_column > end_column 
    
    if not reversed then
        self.column_start = start_column
        self.column_end = end_column
    else
        self.column_start = end_column
        self.column_end = start_column
    end

    if duration then
        -- Total frames * frames per second
        self.speed = (self.column_end - self.column_start + 1) * (1 / duration)

        if reversed then
            self.speed = -math.abs(self.speed)
        end
    end
    
end


----------------------------------------------------------------
function Spritesheet:stop()

    self.column_end = self.column_start

end


----------------------------------------------------------------
function Spritesheet:update(deltaTime)

    self.progress = (self.progress + deltaTime * self.speed) 

    -- Snap the progress by the total frames
    % (self.column_end - self.column_start + 1)

end


return Spritesheet