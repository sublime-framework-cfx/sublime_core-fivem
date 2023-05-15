local connect <const> = require 'config.server.connect'
sl.previousId = {}

function sl.playerLoaded(source)
    sl.emitNet('playerLoaded', source)
end

sl.onNet('playerLoaded', function(source)
    local _source = source
    --sl.loadProfil(_source)
    sl.playerLoaded(_source)
end)

---@param reason string
AddEventHandler('playerDropped', function(reason) ---@type void
    local _source = source
    sl.playerDropped(_source, reason)
end)

---@param source integer
---@param reason string
function sl.playerDropped(source, reason) ---@type void
    sl.emitNet('playerDropped', source, reason)
end

---@param name string
---@param setKickReason string
---@param deferrals table
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) ---@type void
    local _source = source

    if connect.useWhitelist then
        ---@todo Not implemented yet
        return deferrals.done('Whitelist is enabled, please try again later.')
    end

    if connect.useDeferral then
        local d <const> = require 'server.modules.deferrals'
        d(_source, name, setKickReason, deferrals)
    end
end)

AddEventHandler('onResourceStart', function(resourceName) ---@type void
    if resourceName ~= GetCurrentResourceName() then return end
    Wait(1000)
    local players <const> = GetPlayers()
    if #players > 0 then
        for i = 1, #players do
            local _source = players[i]
            sl.playerLoaded(_source)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName) ---@type void
    if resourceName ~= GetCurrentResourceName() then return end
    local profiles = next(sl.profils) and sl.profils
    if profiles then
        for _,v in pairs(profiles) do
            v:save()
        end
    end
end)

local loadedInstance, SetPlayerRoutingBucket <const> = {}, SetPlayerRoutingBucket
sl.onNet('setLoadedInstance', function(source)
    if loadedInstance[source] then return end
    loadedInstance[source] = source
    SetPlayerRoutingBucket(source, source)
end)