local mt_pvt = {
    __metatable = 'private',
    __ext = 0,
    __pack = function() return '' end,
}

---@param obj table
---@return table
local function NewInstance(self, obj)
    if obj.private then
        setmetatable(obj.private, mt_pvt)
    end

    setmetatable(obj, self)

    if self.init then obj:init() end

    if obj.export then
        self.__export[obj.export] = obj
    end

    return obj
end

---@param name string
---@param super? table
---@param exportMethod? boolean
---@return table
function sublime.class(name, super, exportMethod)
    if not name then return end
    if super or exportMethod then
        local self = {
            __name = name,
            new = NewInstance
        }

        self.__index = self

        if exportMethod and not super then
            self.__exportMethod = {}
            self.__export = {}

            setmetatable(self, {
                __newindex = function(_, key, value)
                    rawset(_, key, value)
                    self.__exportMethod[key] = true
                end
            })

            exports('GetExportMethod', function()
                return self.__exportMethod
            end)

            exports('CallExportMethod', function(name, method, ...)
                local export <const> = self.__export[name]
                return export[method](export, ...)
            end)
        end

        return super and setmetatable(self, {
            __index = super,
            __newindex = function(_, key, value)
                rawset(_, key, value)
                if type(value) == 'function' then
                    self.__exportMethod[key] = true
                end
            end
        }) or self
    else
        local self = {
            __index = name
        }

        function self.new(obj)
            if obj.private then
                setmetatable(obj.private, mt_pvt)
            end

            if self.init then obj:init() end

            return setmetatable(obj, self)
        end

        return self
    end
end

return sublime.class