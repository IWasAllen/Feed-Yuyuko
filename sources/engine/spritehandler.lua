local Spritesheet, m_spriteset = {}


----------------------------------------------------------------
function Spritesheet:new(image_filename, frame_width, frame_height)

    local class = {}
    class.image = love.graphics.newImage(image_filename)
    class.quads = {}
    class.current_row = 1

    class.column_start = 1
    class.column_end   = 1
    class.speed        = 0.0
    class.progress     = 0.0

    -- Slices each columns into quads for each rows
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

    -- Linear interpolation to get the current quad index
    local index = math.floor(self.column_start + (self.column_end - self.column_start) * self.progress)

    -- Shortcut for retrieving the image and quad for love.graphics.draw()
    return self.image, self.quads[self.current_row][index]

end


----------------------------------------------------------------
function Spritesheet:play(start_column, end_column, duration)

    self.progress = 0.001

    -- Adding +1 in a column for inteded result of lerp in .__call()
    self.column_start = start_column + (start_column > end_column and 1 or 0)
    self.column_end   = end_column   + (start_column < end_column and 1 or 0)

    if duration then
        self.speed = 1 / duration
    end

end


----------------------------------------------------------------
function Spritesheet:row(row)

    self.current_row = row

end


----------------------------------------------------------------
function Spritesheet:stop()

    -- Sets the current frame to the very first frame of the current row
    self.column_start = 1
    self.column_end   = 1

    self.progress     = 0.001
    self.speed        = 0.000

end


----------------------------------------------------------------
function Spritesheet:update(deltaTime)

    self.progress = (self.progress + deltaTime * self.speed) % 1

end


return Spritesheet