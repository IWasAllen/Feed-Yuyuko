local Dialogue, Pitches = {}, {
    major   = {1.00, 1.12, 1.25, 1.33, 1.49, 1.68, 1.88, 2.00},
    minor   = {1.00, 1.12, 1.18, 1.33, 1.49, 1.58, 1.88, 2.00},
    whole   = {1.00, 1.12, 1.25, 1.41, 1.58, 1.78, 2.00},
    blues   = {1.00, 1.18, 1.33, 1.41, 1.49, 1.78, 2.00},
    klezmer = {1.00, 1.05, 1.25, 1.33, 1.49, 1.58, 1.78, 2.00}
}


----------------------------------------------------------------
local function getNoisedPitchIndex(pitches, time, seed)

    local noise = love.math.noise(time / 4, seed)

    local index = noise * #pitches

    -- Adding variety for complex and catchy sounding
    local variety = love.math.noise(noise * 64 , seed * 2) * 2 - 1

    --print(string.format("index %.2f, (%+.2f): %s", index, variety, string.rep('#', index + variety)))

    index = index + variety 

    return pitches[math.floor(math.max(1, math.min(#pitches, index)))]

end


----------------------------------------------------------------
function Dialogue:new(font_filename, sound_filename)

    local class   = {}
    class.font    = love.graphics.newFont(font_filename, 48 )
    class.pitches = Pitches["whole"]
    class.sound   = love.audio.newSource(sound_filename, "static")
    class.text    = love.graphics.newText(class.font)

    class.content = ""
    class.progress = 1.0
    class.speed = 1.0
    class.previous_index = 0 -- used to check when the text changes, for playing a sound

    setmetatable(class, self)
    self.__index = self

    return class

end


----------------------------------------------------------------
function Dialogue:done()

    return self.progress >= #self.content

end


----------------------------------------------------------------
function Dialogue:play(text, speed)

    self.content        = text
    self.previous_index = 0
    self.progress       = 1
    self.speed          = speed or self.speed

end


----------------------------------------------------------------
function Dialogue:tone(scale_name)

    self.pitches = Pitches[scale_name]

end


----------------------------------------------------------------
function Dialogue:update(deltaTime)

   if self.progress >= #self.content then
        return
    end

    self.progress = self.progress + deltaTime * self.speed

    -- Dialogue text updates
    local current_index = math.floor(self.progress)
    self.text:set(self.content:sub(1, current_index))

    -- Playing sound when the text updates
    if current_index ~= self.previous_index and self.content:sub(current_index, current_index) ~= ' ' then
        self.previous_index = current_index

        -- Play random pitch
        self.sound:setPitch(getNoisedPitchIndex(self.pitches, current_index, #self.content))
        self.sound:play()
    end

end


----------------------------------------------------------------
function Dialogue:draw()

    love.graphics.push()
        love.graphics.translate(-self.text:getWidth() / 2, -self.text:getHeight() / 2) -- centering text
        love.graphics.draw(self.text)
    love.graphics.pop()

end


return Dialogue