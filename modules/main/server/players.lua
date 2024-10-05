local PlayerClass = require 'modules.main.server.class.player'

---@param source integer
---@param data table
---@return table
function sublime.CreatePlayerObject(source, data)
    if sublime.players[source] then
        return sublime.players[source]
    end

    data.metadata = data.metadata or {}
    data.group = data.group or 'user'
    data.databaseId = data.databaseId or 0 ---@todo: get from database id
    data.licenses = data.licenses or {} ---@todo: use license manager

    local object = { 
        source = source,
        export = 'player.'..source,
        private = data
    }

    local player <const> = PlayerClass.new(object)
    sublime.players[source] = player
    --sublime.playersDatabaseId[player.private.databaseId] = source

    return player
end

sublime.CreatePlayerObject(1, { name = 'John', age = 20 })
local p = sublime.CreatePlayerObject(2, { name = 'Doe', age = 10 })

p:init()


RegisterCommand('hh', function()
    local player2 = sublime.GetPlayerData(2)
    print(player2?.source)
    if not player2 then
        print('Player not found')
        return
    end
    print(player2:getName())
end)