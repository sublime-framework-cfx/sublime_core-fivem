local SublimePlayer, playerExports = {}, {}

setmetatable(playerExports, {
    __index = function(_, index)
        playerExports = sl.getPlayersExports()
        return playerExports[index]
    end
})

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

---@todo: add more method index can be played in loop avoid call export every time

local function GetPlayerFromId(source)
    local p = sl.getPlayerFromId(source)
    return p and setmetatable(p, SublimePlayer)
end

---@todo: add get player(s) method

return {
    getFromId = GetPlayerFromId,
}