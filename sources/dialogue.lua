local Pitches = {
    major   = {1.00, 1.12, 1.25, 1.33, 1.49, 1.68, 1.88, 2.00};
    minor   = {1.00, 1.12, 1.18, 1.33, 1.49, 1.58, 1.88, 2.00};
    whole   = {1.00, 1.12, 1.25, 1.41, 1.58, 1.78, 2.00};
    blues   = {1.00, 1.18, 1.33, 1.41, 1.49, 1.78, 2.00};
    klezmer = {1.00, 1.05, 1.25, 1.33, 1.49, 1.58, 1.78, 2.00};
}

local function getNoisedPitch(pitches, time, seed)

    local noise = love.math.noise(time / 4, seed)

    ------------------------
    -- Adding variety for complex and catchy sounding
    ------------------------
    local variety = love.math.noise(noise * 500, seed * (noise + 0.15)) * 6 - 3.5

    if time <= 2 then
        variety = math.random(-4, -2)
    end

    ------------------------
    local index = (noise * #pitches) + variety
    -- print(string.format("%.2f : (%+.2f) = %s", noise * #pitches, variety, string.rep('#', index))) -- debug

    return pitches[math.floor(math.max(1, math.min(#pitches, index)))]

end


----------------------------------------------------------------
local Dialogue = {}
Dialogue.__index = Dialogue


----------------------------------------------------------------
function Dialogue:new(font_filename, sound_filename)

    local class   = {}
    class.color   = {0, 0, 0, 1}
    class.font    = love.graphics.newFont(font_filename, 48)
    class.pitches = Pitches["whole"]
    class.sound   = love.audio.newSource(sound_filename, "static")
    class.text    = love.graphics.newText(class.font)

    class.content = ""
    class.index = 1
    class.speed = 1.0
    class.timer = 1.0

    setmetatable(class, self)
    return class

end


----------------------------------------------------------------
function Dialogue:done()

    return self.index >= #self.content

end


----------------------------------------------------------------
function Dialogue:play(text, charactersPerSecond)

    local _, wrappedText = self.font:getWrap(text, 640)
    wrappedText = table.concat(wrappedText, '\n'):gsub("% \n", '\n')

    self.content = wrappedText
    self.index   = 0
    self.speed   = charactersPerSecond or self.speed
    self.timer   = 0

end


----------------------------------------------------------------
function Dialogue:setColor(red, green, blue, alpha)

    self.color[1] = red
    self.color[2] = green
    self.color[3] = blue
    self.color[4] = alpha

end

----------------------------------------------------------------
function Dialogue:setMusicalScale(scale_name)

    self.pitches = Pitches[scale_name]

end


----------------------------------------------------------------
function Dialogue:update(deltaTime)

    if self:done() then
        return
    end

    self.timer = self.timer - deltaTime * self.speed

    if self.timer > 0 then
        return
    end

    -- Increment text characters
    self.index = math.floor(self.index + 1 - self.timer)
    self.text:set(self.content:sub(1, self.index))

    -- Pause on punctuations
    local sub_char = self.content:sub(self.index, self.index)

    if sub_char == '.' or sub_char == ',' then
        self.timer = 6
    elseif sub_char == ' ' then
        self.timer = 2
    else
        self.timer = 1
    end

    -- Play sound per character
    local seed = #self.content * string.byte(self.content)
    self.sound:setPitch(getNoisedPitch(self.pitches, self.index, seed))

    if self:done() then -- play final note on scale
        self.sound:setPitch(self.pitches[#self.pitches])
    end

    self.sound:play()

end


----------------------------------------------------------------
function Dialogue:draw()

    local r, g, b, a = love.graphics.getColor()

    love.graphics.push()
        love.graphics.setColor(unpack(self.color))
        love.graphics.translate(-self.text:getWidth() / 2, -self.text:getHeight() / 2) -- centering text
        love.graphics.draw(self.text)
        love.graphics.setColor(r, g, b, a)
    love.graphics.pop()

end


return Dialogue
