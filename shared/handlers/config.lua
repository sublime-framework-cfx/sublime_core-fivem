local cfg = {}

---@param key string
---@return table
function sl.getConfig(key)
    if not cfg[key] then
        local module = ("config.%s.%s"):format(supv.service, key)
        cfg[key] = require(module)
        if not cfg[key] then error(("Impossible de charger la configuration %s"):format(module), 3) end
    end
    return cfg[key]
end