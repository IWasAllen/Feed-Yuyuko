local Spritesheet, m_objset = {}, {}
Spritesheet.__index = Spritesheet


----------------------------------------------------------------
function Spritesheet:new(image_filename, frame_width, frame_height)

    local class = {}

    class.image = love.graphics.newImage(image_filename)
    class.quads = {}

    class.looped = false
    class.speed  = 0.0
    class.time   = 0.0

    class.column_index = 1
    class.column_x     = 1
    class.column_y     = 1

    -- Iterate each columns
    for i = 0, class.image:getHeight() - frame_height, frame_height do
        local column = i / frame_height + 1
        class.quads[column] = {}
        print(column)

        -- Slice each rows of the columns into quads
        for j = 0, class.image:getWidth() - frame_width, frame_width do
            table.insert(class.quads[column], love.graphics.newQuad(
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
function Spritesheet:play(start_column, end_column, duration, isLooped)

    self.looped = isLooped ~= false
    self.time = 0

    -- Adding (+1) to see all frames when using lerp (0.9999 so it doesn't index array out of bounds; [n + 1 -> n + 0.9999])
    self.column_x = start_column + (start_column > end_column and 0.9999 or 0)
    self.column_y = end_column + (start_column < end_column and 0.9999 or 0)

    if duration then
        self.speed = 1 / duration
    end

    -- Add in the set to update it overtime
    m_objset[self] = true

end


----------------------------------------------------------------
function Spritesheet:column(index)

    self.column_index = index

end


----------------------------------------------------------------
function Spritesheet:stop()

    self.column_x = 1    
    self.time     = 0

    -- Remove itself from updating
    m_objset[self] = nil

end


----------------------------------------------------------------
function Spritesheet:draw()

    -- Calculate the row index by time using linear interpolation
    local row = math.floor(self.column_x + (self.column_y - self.column_x) * self.time)

    love.graphics.draw(self.image, self.quads[self.column_index][row])

end


----------------------------------------------------------------
function Spritesheet.update(deltaTime)

    for obj in pairs(m_objset) do
        print(obj.time)

        if obj.looped then
            obj.time = (obj.time + deltaTime * obj.speed) % 1
        else
            obj.time = obj.time + deltaTime * obj.speed

            -- Remove
            if obj.time > 1 then
                obj.time = 1
                m_objset[obj] = nil
            end
        end
    end

end


return Spritesheet
