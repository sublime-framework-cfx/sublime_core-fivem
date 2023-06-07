sl.config = require 'config._define'[sl.service]

---@param key string
---@return any
local function GetConfig(self, key)
    return self.config[key] or self.config
end

function sl:getConfig(shared, key)
    return GetConfig(self, shared, key)
end