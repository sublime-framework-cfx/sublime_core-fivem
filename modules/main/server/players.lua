require 'modules.main.server.class.profile'

local config <const>, connectingPlayers, mysql <const> = require 'config.server.setting', {}, require 'modules.mysql.server.function'
sl.tempId, sl.profiles = {}, {}
GlobalState.playersCount = 0

---@param source integer
local function PlayerLoaded(source)
    print('sss,', source)
    sl:emitNet('playerLoaded', source)
end

function sl:playerLoaded(source)
    return PlayerLoaded(source)
end

sl:onNet('playerLoaded', function(source)
    local _source = source
    --sl.loadProfil(_source)
    print('playerLoaded?!', _source)
    PlayerLoaded(source)
end, 3000)

---@param reason string
AddEventHandler('playerDropped', function(reason) ---@type void
    local _source = source
    print('playerDropped', _source, reason)
    sl:playerDropped(_source, reason)
end)

---@param source integer
---@param reason string
function sl:playerDropped(source, reason) ---@type void
    self:emitNet('playerDropped', source, reason)
end

---@param tempid number
AddEventHandler('playerJoining', function(tempId) ---@type void
    print('playerJoining', source, tempId)
    local _source = source
    SetTimeout(1000, function()
        local player <const> = sl:getProfileFromId(tonumber(tempId))
        player:set('source', _source)
        sl.profiles[_source] = player
        sl.profiles[tonumber(tempId)] = nil
        for k,v in pairs(sl.profiles[_source]) do
            print('debug',k, v)
        end
    end)
end)

CreateThread(function()
    local GetPlayerEndpoint <const> = GetPlayerEndpoint
    local count = 0
    while true do
        Wait(30000) -- 30 seconds
        for tempId in pairs(connectingPlayers) do
            if not GetPlayerEndpoint(tempId) then
                connectingPlayers[tempId] = nil
            end
        end

        if next(sl.profiles) then count = #sl.profiles end
        print('playersCount', count, #sl.profiles)
        if (count ~= GlobalState.playersCount) then
            GlobalState.playersCount = count
        end
    end
end)

---@param name string
---@param setKickReason string
---@param deferrals table
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) ---@type void
    local _source, connect <const> = source, sl:getConfig('connect')
    print('playerConnecting (trying)', _source, GetPlayerEndpoint(_source))

    if connectingPlayers[_source] then
        print('playerConnecting (already)', _source, GetPlayerEndpoint(_source))
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

---@todo Not implemented yet 
--[[
local loadedInstance, SetPlayerRoutingBucket <const> = {}, SetPlayerRoutingBucket
sl:onNet('setLoadedInstance', function(source)
    if loadedInstance[source] then return end
    loadedInstance[source] = source
    SetPlayerRoutingBucket(source, source)
end)
---]]

function sl:saveAllCharacters()
    local parameters, size = {}, 0
    local players <const> = self:getPlayers(true)
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

CreateThread(function()
    while not next(sl.profiles) do Wait(1000) end

    while true do
        Wait(config.saveInterval)
        -- Wait(5000) -- 5 seconds
        sl:saveAllCharacters()

        -- Wait((1000 * 60) * 5) -- 5 minutes
        -- sl:saveAllVehicles(sql) -- @todo for persistance not implemented yet
    end
end)

AddEventHandler('onResourceStart', function(resourceName) ---@type void
    if resourceName ~= GetCurrentResourceName() then return end
    Wait(1000)
    local players <const> = GetPlayers()
    if #players > 0 then
        for i = 1, #players do
            local _source = players[i]
            sl:playerLoaded(_source)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName) ---@type void
    if resourceName ~= sl.name then return end
    local profiles <const> = sl:getPlayers()
    if next(profiles) then
        for _,v in pairs(profiles) do --- force save profiles
            v:save()
        end

        sl:saveAllCharacters() --- force save characters
    end
end)

declare(sl.playerLoaded)
declare(sl.playerDropped)