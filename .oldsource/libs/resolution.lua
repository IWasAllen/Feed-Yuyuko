local Resolution = {}

local originalX, originalY = love.graphics.getWidth(), love.graphics.getHeight()

function Resolution.setResolution(x, y) -- Sets the original resolution
    originalX = x originalY = y
end

function Resolution.getScaleX()
    return love.graphics.getWidth() / originalX
end

function Resolution.getScaleY()
    return love.graphics.getHeight() / originalY
end

function Resolution.getCenterX(width, scale)
    return love.graphics.getWidth() / 2 - (width * Resolution.getScaleX() / (scale or 1)) / 2
end

function Resolution.getCenterY(height, scale)
    return love.graphics.getHeight() / 2 - (height * Resolution.getScaleY() / (scale or 1)) / 2
end

function Resolution.getBottomY(height, scale)
    return love.graphics.getHeight() - height / (scale or 1) * Resolution.getScaleY()
end

return Resolution