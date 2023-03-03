
--- sl.time_setCurrent
sl.time_getTime = function()
    return (os.time())
end


--- sl.time_getCurrent
sl.time_getDate = function()
    local actualTime = os.date("*t")
    return (("%s/%s/%s %sh%s"):format(actualTime.day, actualTime.month, actualTime.year, actualTime.hour, actualTime.min))
end


--- sl.time_decode
---@param timeDecode any
sl.time_decode = function(timeDecode)
    local actualTime = os.date("*t", timeDecode)
    return (("%s/%s/%s %sh%s"):format(actualTime.day, actualTime.month, actualTime.year, actualTime.hour, actualTime.min))
end


