local define <const> = require 'config.client.modules'
local modules = {}

RegisterNUICallback('sl:react:config', function(_, cb)
    cb({

    }) ---@todo config interface
end)

-- RegisterNUICallback('sl:react:locale', function(_, cb)
--     local 
--     cb({
-- 
--     }) ---@todo config interface
-- end)

cache = {
    on = function(key, cb)
        sl:on(('cache:%s'):format(key), cb)
    end
}

for k in pairs(define) do
    modules[#modules + 1] = k
end

table.sort(modules, function(a, b)
    return a < b
end)

for i = 1, #modules do
    local files = modules[i]
    if #define[files] > 1 then
        local M = define[files]
        for j = 1, #M do
            local module = M[j]
            require(('client.modules.%s.%s'):format(files, module))
        end
    else
        require(('client.modules.%s.%s'):format(files, define[files][1]))
    end
end

modules = nil