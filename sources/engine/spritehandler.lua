----------------------------------------------------------------
-- Class
----------------------------------------------------------------
local SpriteHandler, m_objset = {}, {}
SpriteHandler.__index = SpriteHandler


----------------------------------------------------------------
function SpriteHandler:new(filename, frame_width, frame_height)

    local class = {}

    class.image = love.graphics.newImage(filename)
    class.quads = {}

    class.looped = false
    class.speed  = 0.0
    class.time   = 0.0

    class.column_row = 1
    class.column_x   = 1
    class.column_y   = 1

    -- Iterate each rows
    for y = 0, class.image:getHeight() - frame_height, frame_height do
        local row = y / frame_height + 1
        class.quads[row] = {}

        -- Slice each columns into quads
        for x = 0, class.image:getWidth() - frame_width, frame_width do
            table.insert(class.quads[row], love.graphics.newQuad(
                x,
                y,
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
function SpriteHandler:play(start_column, end_column, duration, isLooped)

    self.looped = isLooped ~= false
    self.speed = 1 / duration
    self.time = 0

    -- Adding (+1) to see the final frame when using lerp (0.9999 is used to avoid array out of bounds)
    self.column_x = start_column + (start_column > end_column and 0.9999 or 0)
    self.column_y = end_column + (start_column < end_column and 0.9999 or 0)

    -- Add in the set to update it overtime
    m_objset[self] = true

end


----------------------------------------------------------------
function SpriteHandler:row(index)

    self.column_row = index

end


----------------------------------------------------------------
function SpriteHandler:stop()

    self.column_x = 1
    self.time = 0

    -- Remove itself from updating
    m_objset[self] = nil

end


----------------------------------------------------------------
function SpriteHandler.update(deltaTime)

    for obj in pairs(m_objset) do
        if obj.looped then
            obj.time = (obj.time + deltaTime * obj.speed) % 1
        else
            obj.time = obj.time + deltaTime * obj.speed

            -- Expiration
            if obj.time > 1 then
                obj.time = 1
                m_objset[obj] = nil
            end
        end
    end

end


----------------------------------------------------------------
function SpriteHandler:draw()

    -- Calculate the column index by time with lerp function
    local column = math.floor(self.column_x + (self.column_y - self.column_x) * self.time)

    love.graphics.draw(self.image, self.quads[self.column_row][column])

end


return SpriteHandler
