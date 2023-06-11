local class = {}

---@param prototype table
---@return { new: fun(obj: table): table }
function class.new(prototype)
    local self = {
        __index = prototype
    }

    function self.new(obj)
        return setmetatable(obj, self)
    end

    return self
end

return class