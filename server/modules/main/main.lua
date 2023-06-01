sl.previousId = {}
GlobalState.playersCount = 0

function sl:playerLoaded(source)
    self:emitNet('playerLoaded', source)
end

sl:onNet('playerLoaded', function(source)
    local _source = source
    --sl.loadProfil(_source)
    sl:playerLoaded(_source)
end)

---@param reason string
AddEventHandler('playerDropped', function(reason) ---@type void
    local _source = source
    sl:playerDropped(_source, reason)
end)

---@param source integer
---@param reason string
function sl:playerDropped(source, reason) ---@type void
    self:emitNet('playerDropped', source, reason)
end

---@param name string
---@param setKickReason string
---@param deferrals table
AddEventHandler('playerConnecting', function(name, setKickReason, deferrals) ---@type void
    local _source, connect <const> = source, require 'config.server.connect'

    if connect.useWhitelist then
        ---@todo Not implemented yet
        return deferrals.done('Whitelist is enabled, please try again later.')
    end

    if connect.useDeferral then
        local d <const> = require 'server.modules.deferrals.main'
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
            sl:playerLoaded(_source)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName) ---@type void
    if resourceName ~= sl.name then return end
    local profiles <const> = sl:getPlayers()
    if next(profiles) then
        for _,v in pairs(profiles) do
            v:save()
        end
    end
end)

---@todo Not implemented yet 
local loadedInstance, SetPlayerRoutingBucket <const> = {}, SetPlayerRoutingBucket
sl:onNet('setLoadedInstance', function(source)
    if loadedInstance[source] then return end
    loadedInstance[source] = source
    SetPlayerRoutingBucket(source, source)
end)

print([[
^6###############################################################################
^6# ^2ssss   u  u  bbbbb   l    iii mm   mm  eeee      cccc   ooo   rrrrrr  eeee  ^6#
^6# ^2s      u  u  b    b  l     i  mmm mmm ee   e    c      o   o  rrr    ee   e ^6#
^6# ^2 sss   u  u  bbbbb   l     i  mm m mm eeeee     c      o   o  rr     eeeee  ^6#
^6# ^2    s  u  u  b    b  l     i  mm   mm ee    ^7...^2 c      o   o  rr     ee     ^6#
^6# ^2ssss   uuuu  bbbbbb  llll iii mm   mm  eeee ^7...^2  cccc   ooo   rr      eeee  ^6#
^6#                                                                             ^6#
^6#                   ^2Github: soon                                              ^6#
^6#                                                                             ^6#
^6###############################################################################
]])