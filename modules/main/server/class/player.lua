GlobalState.playersCount = 0
local PlayerExports = {}
local PlayerObject = setmetatable({}, {
    __newindex = function(self, key, value)
        rawset(self, key, value)
        print(key, value)
        PlayerExports[key] = true
    end
})

function sublime.GetPlayerExports()
    return PlayerExports
end

---@param id integer
---@param method string
---@param ... unknown?
---@return unknown?
function sublime.CallPlayerMethod(id, method, ...)
    print(id, method)
    local player = sublime.GetPlayerData(id)
    return PlayerObject[method](player, ...)
end

---@param source integer
function sublime.GetPlayerData(source)
    return sublime.players[source]
end

function sublime.RemovePlayerObject(source)
    local player = sublime.players[source]
    if player then
        sublime.players[source] = nil
        player = nil
        collectgarbage()
        TriggerEvent('sublime:player:remove', source)
    end
end

function PlayerObject:init()
    print(self.source, 'was initialized')
end

function PlayerObject:setName(name)
    self.private.name = name
end

function PlayerObject:getName()
    return self.private.name
end

---@param key string support nested keys separated by dots '.', exemple: 'metadata.name'
---@return unknown?
function PlayerObject:get(key)
    assert(key and type(key) == 'string', 'Invalid key: '..key)

    if key:find('.') then
        local keys <const> = {('.'):strsplit(key)}
        local value = self.private
        for i = 1, #keys do
            local key <const> = keys[i]
            value = value[key]
            if not value then
                return nil
            end
        end

        return value
    end

    return self.private[key]
end

local class <const> = require 'modules.handlers.shared.class'
return class.new(PlayerObject)

-----------------
--[[
function PlayerObject:init()
    GlobalState.playersCount += 1
end

function PlayerObject:__gc() -- destructor
    GlobalState.playersCount -= 1
end

function PlayerObject:save()
    -- save player in database
    return self
end

function PlayerObject:set(key, value, replicated)
    local _key, count = key:gsub('%W', '')

    if count > 0 then
        warn('Invalid key: '..key)
        key = _key
    end

    self.private.metadata[key] = value

    if replicated then
        --TriggerClientEvent('sublime:player:set', self.source, key, value)
    end
end

function PlayerObject:get(key)
    local metadata <const> = self.private.metadata
    if not key then return metadata end

    local _key, count = key:gsub('%W', '')

    if count > 0 then
        warn('Invalid key: '..key)
        key = _key
    end

    return metadata[key]
end

function PlayerObject:setName(name)
    self.private.name = name
    return self
end

function PlayerObject:getName()
    return self.private.name
end

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

    local player <const> = PlayerObject:new(object)
    sublime.players[source] = player
    --sublime.playersDatabaseId[player.private.databaseId] = source

    return player
end

---@param source integer
function sublime.RemovePlayerObject(source)
    local player = sublime.players[source]
    if player then
        sublime.players[source] = nil
        player = nil
        collectgarbage()
        TriggerEvent('sublime:player:remove', source)
    end
end

---@param source integer
function sublime.GetPlayerData(source)
    return sublime.players[source]
end]]