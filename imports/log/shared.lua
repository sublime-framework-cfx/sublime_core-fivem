
--- log
---@param type number
---@param message string
---@param ... any
local log = function(type, message, ...)
    if (message ~= nil or message ~= "") then
        local rssName <const> = "Sublime"
        local type <const> = string.upper(sl.table_findValueByIndex(sl.log_type, type))
        if (...) then
            message = (message):format(...)
        end
        print(('[^6%s^7] | [^6%s^7] %s^7'):format(rssName, type, message))
    end
end


--- sl.log
---@param type number
---@param message string
---@param ... any
sl.log = function(type, message, ...)
    log(type, message,...)
end