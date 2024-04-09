local Assets = {}

function Assets.getFileExtension(filepath)
    return filepath:match("^.+(%..+)$")
end

function Assets.getFileName(filepath)
    return filepath:match("^.+\\(.+)$") or filepath:match("^.+/(.+)$")
end

function Assets.load(filepath)
    local file = io.open(filepath, "rb")
    if not file then error("Could not open and read the path: " .. filepath, 2) end

    local contents = file:read("*a")
    local data = love.filesystem.newFileData(contents, filepath)

    file:close()
    return data
end

return Assets