local log_types <const> = {
    [1] = "^2SUCCESS^7",
    [2] = "^3WARNING^7",
    [3] = "^1ERROR^7",
    [4] = "^5INFO^7",
}

--- sl.log.print
---@param id integer
---@param message string
---@param ... any
local function Log(id, message, ...)
    if type(message) ~= 'string' and #message < 1 then return end
    if ... then message = (message):format(...) end
    print(('[^6%s^7] | [^6%s^7] %s^7'):format(sl.name, log_types[id], message))
end

return {
    print = Log
}