local config = {}

---@param key string
---@return any
local function GetConfig(key)
    if not config[key] then
        local module = ("config.%s.%s"):format(sl.service, key)
        config[key] = require(module)
        if not config[key] then
            module = ("config.shared.%s"):format(key)
            config[key] = require(module)
            if not config[key] then
                error(("Impossible de charger la configuration %s"):format(module), 3)
            end
        end
    end
    return config[key]
end

sl.getConfig = GetConfig