local connect <const> = require 'config.server.connect'

function sl.playerLoaded(source)
    sl.emitNet('playerLoaded', source)
end

sl.onNet('playerLoaded', function(source)
    local _source = source
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