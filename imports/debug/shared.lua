local log_types <const> = {
    index = {
        [1] = "^2SUCCESS^7",
        [2] = "^3WARNING^7",
        [3] = "^1ERROR^7",
        [4] = "^5INFO^7",
    }, key = {
        success = "^2SUCCESS^7",
        warning = "^3WARNING^7",
        error   = "^1ERROR^7",
        info    = "^5INFO^7",
    }
}

---@param debugInfo? table
---@param id? integer-info
---@param message string
---@param ...? any
local function Debug(debugInfo, id, message, ...)
    local logs <const>, log = (type(id) == 'number' and log_types.index or log_types.key)
    if not logs then return end
    if type(message) ~= 'string' or #message < 1 then return end

    if table.type(logs) == 'array' then
        if not logs[id] then id = 4 end
        log = logs[id]
    else
        if not logs[id] then id = 'info' end
        log = logs[id]
    end

    if ... then message = (message):format(...) end

    if debugInfo then
print(([[
[^6%s^7] | [^6%s^7] %s^7
[^6Function^7] :
    [^3LINE^7] :
        [^3start^7]     : %s
        [^3current^7]   : %s
        [^3last^7]      : %s
    [^2NAME^7] :
        [^2type^7]      : %s
        [^2name^7]      : %s
        [^2source^7]    : %s
]]):format(sl.env, log, message, debugInfo.linedefined, debugInfo.currentline, debugInfo.lastlinedefined, debugInfo.namewhat, debugInfo.name, debugInfo.short_src))
    else
        print(('[^6%s^7] | [^6%s^7] %s^7'):format(sl.env, log, message))
    end
end

return {
    info = Debug
}

---@example
---@important You need to use the `debug.getinfo` function to get the debug information.
--[[

local function Test()
    local debugInfo <const> = debug.getinfo(1, 'Slntu')
    return sl.debug.info(debugInfo, 3, 'Mon petit test %s %s',  'args1', 'args2)
end

Test()

--]]