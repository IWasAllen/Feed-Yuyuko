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

    class.looped = false

    -- Iterate each columns
    for i = 0, class.image:getHeight() - frame_height, frame_height do
        local row = i / frame_height + 1
        class.quads[row] = {}

        -- Slice each rows of the columns into quads
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
function Spritesheet:once(start_column, end_column, duration)
    
    self:play(start_column, end_column, duration)
    
    self.looped = false

end


----------------------------------------------------------------
function Spritesheet:play(start_column, end_column, duration)

    self.looped = true
    self.time = 0

    -- Adding +1 to see all frames when using lerp. 0.9999 so it dont index array out of bounds, n + 1
    self.column_x = start_column + (start_column > end_column and 0.9999 or 0)
    self.column_y = end_column   + (start_column < end_column and 0.9999 or 0)

    if duration then
        self.speed = 1 / duration
    end

    -- Add in the set to update it overtime
    m_objset[self] = true

end


----------------------------------------------------------------
function Spritesheet:row(row)

    self.column_row = row

end


----------------------------------------------------------------
function Spritesheet:stop()

    self.column_x = 1
    self.speed    = 0
    self.time     = 0

    -- Remove itself from updating
    m_objset[self] = nil

end


----------------------------------------------------------------
function Spritesheet:draw()

    -- Linear interpolation to get the current quad index
    local index = math.floor(self.column_x + (self.column_y - self.column_x) * self.time)

    love.graphics.draw(self.image, self.quads[self.column_row][index])

end


----------------------------------------------------------------
function Spritesheet.update(deltaTime)

    for obj in pairs(m_objset) do
        if obj.looped then
            obj.time = (obj.time + deltaTime * obj.speed) % 1
        else
            obj.time = math.min(1, obj.time + deltaTime * obj.speed)
        end
    end

end


return Spritesheet
