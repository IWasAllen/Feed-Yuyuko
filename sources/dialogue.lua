local Pitches = {
    major   = {1.00, 1.12, 1.25, 1.33, 1.49, 1.68, 1.88, 2.00},
    minor   = {1.00, 1.12, 1.18, 1.33, 1.49, 1.58, 1.88, 2.00},
    whole   = {1.00, 1.12, 1.25, 1.41, 1.58, 1.78, 2.00},
    blues   = {1.00, 1.18, 1.33, 1.41, 1.49, 1.78, 2.00},
    klezmer = {1.00, 1.05, 1.25, 1.33, 1.49, 1.58, 1.78, 2.00}
}

local function getNoisedPitch(pitches, time, seed)

    ------------------------
    local noise = love.math.noise(time / 16, seed)
    local index = noise * #pitches

    ------------------------
    -- Adding variety for complex and catchy sounding
    ------------------------
    local variety = love.math.noise(noise ^ 2 * 64 , seed * 2 ) * 2 - 1

    if time <= 1 then
        variety = -math.random(2, 4)
    end

    ------------------------
    local finalIndex = index + variety
    -- print(string.format("%.2f : (%+.2f) = %+.2f", noise, variety, finalIndex))

    return pitches[math.floor(math.max(1, math.min(#pitches, finalIndex)))]

end


----------------------------------------------------------------
local Dialogue = {}
Dialogue.__index = Dialogue


----------------------------------------------------------------
function Dialogue:new(font_filename, sound_filename)

    local class   = {}
    class.font    = love.graphics.newFont(font_filename, 48)
    class.pitches = Pitches["whole"]
    class.sound   = love.audio.newSource(sound_filename, "static")
    class.text    = love.graphics.newText(class.font)

    class.content = ""
    class.speed = 1.0
    class.time = 1.0

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function Dialogue:done()

    return self.time >= #self.content + 0.5

end


----------------------------------------------------------------
function Dialogue:play(text, charactersPerSecond)

    local _, wrappedText = self.font:getWrap(text, 640)
    wrappedText = table.concat(wrappedText, '\n'):gsub("% \n", '\n')

    self.content = wrappedText
    self.speed   = charactersPerSecond or self.speed
    self.time    = 1

end


----------------------------------------------------------------
function Dialogue:tone(scale_name)

    self.pitches = Pitches[scale_name]

end


----------------------------------------------------------------
function Dialogue:update(deltaTime)

   if self:done() then
        return
    end

    local previous_sub_index = math.floor(self.time - deltaTime)
    self.time = self.time + deltaTime * self.speed
    local sub_index = math.floor(self.time)

    -- Appending character to text
    self.text:set(self.content:sub(1, sub_index))

    -- Playing sound per character
    if previous_sub_index ~= sub_index and self.content:sub(sub_index, sub_index) ~= ' ' then
        
        -- Ignore space character
        if self.content:sub(sub_index, sub_index) ~= ' ' then
            self.sound:setPitch(getNoisedPitch(self.pitches, sub_index, #self.content))
            self.sound:play()
        end
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