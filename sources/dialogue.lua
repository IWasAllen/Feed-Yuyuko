local Dialogue = {}


----------------------------------------------------------------
local function getNoisedIndex(maxIndex, time, seed)

    local noise = love.math.noise(time / 4, seed)

    local index = noise * maxIndex + 1

    -- Adding variety for complex but catchy sounding
    local variety = love.math.noise(noise * 64 , seed * 2) * 2 - 1

    index = index + variety

    --print(string.format("%.2f, (%+.2f): %s", index, variety, string.rep('#', index)))

    return math.floor(math.max(1, math.min(maxIndex, index)))

end


----------------------------------------------------------------
function Dialogue:new(font_filename, sound_filename)

    local class = {}
    class.font = love.graphics.newFont(font_filename, 48)
    class.sound = love.audio.newSource(sound_filename, "static")
    class.text = love.graphics.newText(class.font)
    class.pitches = {1.0, 1.5, 2.0}

    class.content = ""
    class.progress = 1.0
    class.speed = 1.0
    class.previous_index = 0 -- used to play sfx when the text is updated

    setmetatable(class, self)
    self.__index = self

    return class

end


----------------------------------------------------------------
function Dialogue:play(text, speed, textcolor)

    self.content = text
    self.progress = 1.0
    self.previous_index = 0
    self.speed = speed or self.speed
    self.textcolor = textcolor or self.textcolor

end


----------------------------------------------------------------
function Dialogue:update(deltaTime)

   if self.progress >= #self.content then
        return
    end

    self.progress = self.progress + deltaTime * self.speed

    local index = math.floor(self.progress)
    self.text:set(self.content:sub(1, self.progress))

    -- Playing sound when the text updates
    if index ~= self.previous_index and self.content:sub(index, index) ~= ' ' then
        self.previous_index = index

        -- Play random pitch
        local pitch = self.pitches[getNoisedIndex(#self.pitches, index, #self.content)]
        self.sound:setPitch(pitch)

        self.sound:play()
    end

end


----------------------------------------------------------------
function Dialogue:draw()

    love.graphics.push()
        love.graphics.translate(-self.text:getWidth() / 2, -self.text:getHeight() / 2 - 32) -- centering text

        love.graphics.draw(self.text)
    love.graphics.pop()

end


----------------------------------------------------------------
function Dialogue:setPitches(pitches)

    self.pitches = pitches

end


return Dialogue