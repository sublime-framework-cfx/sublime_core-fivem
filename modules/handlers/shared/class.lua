local mt_pvt, class = {
    __metatable = 'private',
    __ext = 0,
    __pack = function() return '' end,
}, {}

---@param prototype table?
---@return { new: fun(obj): table }
function class.new(prototype)
    local self = { __index = prototype }

    function self.new(obj)
        if obj.private then
            setmetatable(obj.private, mt_pvt)
        end

        return setmetatable(obj, self)
    end

    return self
end

return class