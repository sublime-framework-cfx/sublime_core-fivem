---@param export string 'resourceName.methodName'
---@param ... any
---@return void | any
local function Exports(_, export, ...)
    local resourceName <const> = export:match('(.+)%..+')
    local methodName <const> = export:match('.+%.(.+)')
    return exports[resourceName][methodName](nil, ...)
end

local ExportMethod, MyClassExport = {}, {}
sublime.exports = setmetatable({}, {
    __call = Exports
})


---@param resource string resource name you have use supv.class with exportable on true
---@param name string export identifier name
---@param prototype? table if you want add prototype
---@return table
function sublime.exports.class(resource, name, prototype)
    ExportMethod[name] = {}
    setmetatable(ExportMethod[name], {
        __index = function(_, index)
            ExportMethod[name] = exports[resource]:GetExportMethod(index)
            return ExportMethod[name][index]
        end
    })

    MyClassExport[name] = {}
    local Class = MyClassExport[name]
    function Class:__index(index)
        local method = MyClassExport[name][index]

        if method then
            return function(...)
                return method(self, ...)
            end
        end

        local export = ExportMethod[name][index]

        if export then
            return function(...)
                return exports[resource]:CallExportMethod(name, index, ...)
            end
        end
    end

    return setmetatable(prototype or {}, Class)
end

return sublime.exports