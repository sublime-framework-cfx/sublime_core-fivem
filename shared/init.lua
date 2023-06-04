---@load modules.handlers
require 'shared.modules.handlers.config'
require 'shared.modules.handlers.translation'

setmetatable(math, {
    __index = function(self, k)
        local v = rawget(self, k)
        if not v then
            v = require ('imports.math.shared')[k]
            rawset(self, k, v)
        end
        return v
    end,
})