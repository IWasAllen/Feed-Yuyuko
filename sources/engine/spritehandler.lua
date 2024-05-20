local Spritesheet, m_objset = {}, {}
Spritesheet.__index = Spritesheet

----------------------------------------------------------------
function Spritesheet:new(image_filename, frame_width, frame_height)

    local class = {}
    class.image = love.graphics.newImage(image_filename)
    class.quads = {}
    class.speed = 0.0
    class.time  = 0.0

    class.column_row = 1
    class.column_x   = 1
    class.column_y   = 1

    -- Slice each columns per each rows
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
    return class

end


----------------------------------------------------------------
Spritesheet.__call = function(self)

    -- Linear interpolation to get the current quad index
    local index = math.floor(self.column_x + (self.column_y - self.column_x) * self.time)
    
    -- Shortcut for retrieving the image and quad for love.graphics.draw()
    return self.image, self.quads[self.column_row][index]

end


----------------------------------------------------------------
function Spritesheet:play(start_column, end_column, duration)

    self.time = 0

    -- Adding +1 for intended result occuring in lerp
    self.column_x = start_column + (start_column > end_column and 1 or 0)
    self.column_y = end_column   + (start_column < end_column and 1 or 0)

    if duration then
        self.speed = 1 / duration
    end

    -- Add in the set to update it overtime
    m_objset[tostring(self)] = self

end


----------------------------------------------------------------
function Spritesheet:row(row)

    self.column_row = row

end


----------------------------------------------------------------
function Spritesheet:stop()

    self.speed = 0
    self.time = 0

    -- Set initial frame
    local lowest = math.min(self.column_x, self.column_y)
    self.column_x = lowest
    self.column_y = lowest

    -- Remove in the set
    m_objset[tostring(self)] = nil

end


----------------------------------------------------------------
function Spritesheet.update(deltaTime)

    for i, v in pairs(m_objset) do
        v.time = (v.time + deltaTime * v.speed) % 1
    end

end


return Spritesheet