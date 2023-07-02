local script <const> = require 'config.shared.script'
local client, server = {}, {}

if script.ox_inventory then
    client[#client + 1] = 'ox_inventory'
    server[#server + 1] = 'ox_inventory'
end

if #client > 0 or #server > 0 then

    return {
        client = #client > 0 and client or nil,
        server = #server > 0 and server or nil
    }
end