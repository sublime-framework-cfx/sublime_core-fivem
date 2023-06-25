local SublimePlayer <const> = require 'modules.main.server.class.player' ---@type SublimePlayer
local GetPlayerEndpoint <const> = GetPlayerEndpoint
local config <const>, connectingPlayers, mysql <const> = require 'config.server.setting', {}, require 'modules.mysql.server.function'
sl.tempId, sl.players, GlobalState.playersCount = {}, {}, 0

---@param reason string
AddEventHandler('playerDropped', function(reason) ---@type void
    local _source = source
    local player = sl.getPlayerFromId(_source)
    if not player then return end
    player:emitNet('playerDropped')
    Wait(1000)
    player:quit()
end)

---@param tempid number
AddEventHandler('playerJoining', function(tempId) ---@type void
    -- print('playerJoining', source, tempId)
    local _source, _tempId = source, tonumber(tempId)
    SetTimeout(1000, function()
        local player <const> = sl.getPlayerFromId(_tempId)
        if not player then return warn(player, _source, 'not player', _tempId) end
        player:set('source', _source)
        player:set('tempId', _tempId)
        Wait(200)
        sl.players[_source] = player
        sl.players[_tempId] = nil
    end)
end)

CreateThread(function()
    while true do
        Wait(30000) -- 30 seconds
        for tempId in pairs(connectingPlayers) do
            --print('tempid', tempId, type(tempId), GetPlayerEndpoint(tempId))
            if not GetPlayerEndpoint(tempId) then
                connectingPlayers[tempId] = nil
            end
        end
    end
end)

---@param name string
---@param setKickReason string
---@param deferrals table
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) ---@type void
    local _source, connect <const> = source, sl.getConfig('connect')
    --print('playerConnecting (trying)', _source, GetPlayerEndpoint(_source))

    if connectingPlayers[_source] then
        --print('playerConnecting (already)', _source, GetPlayerEndpoint(_source))
        return deferrals.done('You are already connecting to the server.')
    end

    connectingPlayers[_source] = true
    sl.tempId[_source] = _source

    if connect.useWhitelist then
        ---@todo Not implemented yet
        return deferrals.done('Whitelist is enabled, please turn off this feature, reason: is not implemented.')
    end

    if connect.useDeferral then
        local d <const> = require 'modules.deferrals.server.main'
        d(_source, name, setKickReason, deferrals)
    end
end)

local function StartAutoSave()
    CreateThread(function()
        while true do
            Wait(config.saveInterval)
            ---@todo: save all about players
        end
    end)
end

---@param from string | 'client' | 'server'
---@param source integer
local function PlayerLoaded(from, source)
    if from == 'client' then
        sl:emitNet('playerLoaded', source)
        local player <const> = sl.getPlayerFromId(source)
        if not player then return end
        if player.tempId and connectingPlayers[player.tempId] then
            connectingPlayers[player.tempId] = nil
        end
    elseif from == 'server' then
        local player <const> = sl.getPlayerFromId(source)
        Wait(500)
        sl:emit('playerLoaded', source, player or false)
        if not player then return end
        if player.tempId and connectingPlayers[player.tempId] then
            connectingPlayers[player.tempId] = nil
        end
    end
end

---@param resourceName string
AddEventHandler('onResourceStart', function(resourceName) ---@type void
    if resourceName ~= GetCurrentResourceName() then return end
    Wait(1000)
    local players <const> = GetPlayers()
    if #players > 0 then
        for i = 1, #players do
            local _source = players[i]
            PlayerLoaded('client', _source)
        end
    end

    StartAutoSave()
end)

---@param resourceName string
AddEventHandler('onResourceStop', function(resourceName) ---@type void
    if resourceName ~= sl.name then return end
    local players <const> = sl.getPlayers()
    for id, player in pairs(players) do
        if id then player:quit() end
    end

    ---@todo: save all characters
end)

---@param source integer
sl:onNet('playerLoaded', function(source) ---@type void
    local _source = source
    PlayerLoaded('client', _source)
end)

--[[
    function sl:saveAllCharacters() --- that will be moved
        local parameters, size = {}, 0
        local players <const> = sl.getPlayers(true)
        if not players or not next(players) then return end
    
        for i = 1, #players do
            local char <const> = players[i].char
            size += 1
            parameters[size] = char:prepareSave()
        end
    
        if size > 0 then
            mysql.updateCharacters(parameters)
        end
    end
]]

---@todo Not implemented yet 
--[[
local loadedInstance, SetPlayerRoutingBucket <const> = {}, SetPlayerRoutingBucket
sl:onNet('setLoadedInstance', function(source)
    if loadedInstance[source] then return end
    loadedInstance[source] = source
    SetPlayerRoutingBucket(source, source)
end)
---]]

-- RegisterCommand('xp', function(source)
--     local player = sl.getPlayerFromId(source)
--     if not player then 
--         return print('not player xp')
--     end
--     print(player:get('test'), 'test', player.source)
-- end)

-----@param cb fun(source: integer, player: table, reason: string)
--function sl:playerDropped(cb) ---@type void
--    print('is init from', self.env)
--    return self:on('playerDropped', function(source, player, reason)
--        print('trololol')
--        print(player, source, 'playerDropped')
--        cb(source, player, reason)
--    end)
--end