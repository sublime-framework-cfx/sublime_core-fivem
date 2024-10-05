local PlayerExports, PlayerObject = {}, {}
setmetatable(PlayerExports, {
    __index = function(_, index)
        print(index, 'index meta')
        PlayerExports = sublime.GetPlayerExports()
        return PlayerExports[index]
    end
})

function sublime.GetPlayerObject(source)
    local player <const> = sublime.GetPlayerData(source)
    if not player then return end
    return setmetatable(player, PlayerObject)
end

function PlayerObject:__index(index)
    local method = PlayerObject[index]
    print(method, index)
    if method then
        return function(...)
            return method(self, ...)
        end
    end

    local export = PlayerExports[index]

    if export then
        return function(...)
            return sublime.CallPlayerMethod(self.source, index, ...)
        end
    end
end

function PlayerObject:test()
    return self.source .. ' from test ' .. self.getName()
end

return sublime.GetPlayerObject