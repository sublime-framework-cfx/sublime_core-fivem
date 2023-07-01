local SublimePlayer, SublimeCharacter, playerExports, characterExports = {}, {}, {}, {}

setmetatable(playerExports, {
    __index = function(_, index)
        playerExports = sl.getPlayersExports()
        return playerExports[index]
    end
})

setmetatable(characterExports, {
    __index = function(_, index)
        characterExports = sl.getCharacterExports()
        return characterExports[index]
    end
})

local function GetPlayerFromId(source, character)
    if not character then
        local p = sl.getPlayerFromId(source)
        return p and setmetatable(p, SublimePlayer)
    end
    local c = sl.getCharacterFromId(source)
    return c and setmetatable(c, SublimeCharacter)
end

function SublimeCharacter:__index(index)
    local method = SublimeCharacter[index]
    
    if method then
        return function(...)
            return method(self, ...)
        end
    end

    local export = characterExports[index]

    if export then
        return function(...)
            return sl.callCharacterMethod(self.source, index, ...)
        end
    end
end

function SublimePlayer:__index(index)
    local method = SublimePlayer[index]

    if method then
        return function(...)
            return method(self, ...)
        end
    end

    local export = playerExports[index]

    if export then
        return function(...)
            return sl.callPlayerMethod(self.source, index, ...)
        end
    end
end

function SublimePlayer:getCharacter()
    return GetPlayerFromId(self.source, true)
end

function SublimeCharacter:getDistanceFromCoords(_, coords)
    local x, y, z in self:getCoords()
    return #(vec3(x, y, z) - vec3(coords.x, coords.y, coords.z))    
end

---@todo: add more method index can be played in loop avoid call export every time

---@todo: add get player(s) method

return {
    getFromId = GetPlayerFromId,
}