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

---@param tempId number
AddEventHandler('playerJoining', function(tempId) ---@type void
    -- print('playerJoining', source, tempId)
    local _source, _tempId = source, tonumber(tempId)
    SetTimeout(1000, function()
        local player <const> = sl.getPlayerFromId(_tempId)
        if not player then 
            return print(player, _source, 'not player', _tempId) 
        end
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
    local _source, connect <const> = source, require 'config.server.connect'
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
            Wait(config.saveInterval or 60000) -- 1 minute
            local players <const> = sl.getPlayers()
            for id, player in pairs(players) do
                if id then 
                    player:save(player.char)
                end
            end
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
    local players = sl.getPlayers()
    for id, player in pairs(players) do
        if id then
            print(id, 'onResourceStop', player.quit, player.char.charid)
            player:save(player.char)
        end
        ---@todo: save all characters
    end
end)

RegisterCommand('tex', function(source)
    local player = sl.getCharacterFromId(source)
    if not player then 
        return print('not player tex')
    end
    -- player:save()
end)

---@param source integer
sl:onNet('playerLoaded', function(source) ---@type void
    local _source = source
    PlayerLoaded('client', _source)
end)

CreateThread(function()
    while true do
        for id, player in pairs(sl.players) do
            if id then
                local char = player:getCharacter()
                if char and DoesEntityExist(char.ped) then
                    char:getCoords(true)
                    Wait(1000)
                end
            end
        end
        Wait(3500)
    end
end)