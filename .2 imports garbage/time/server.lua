--- time.get_time: get the current time in seconds
---@return number
local function getTime()
    return os.time()
end

--- time.get_date: get the current date as a string
---@return string
local function getDate()
    local actualTime = os.date("*t")
    return ("%s/%s/%s %sh%s"):format(actualTime.day, actualTime.month, actualTime.year, actualTime.hour, actualTime.min)
end

--- time.decode: decode a time value and return it as a string
---@param decodeTime any
---@return string
local function decodeTime(decodeTime)
    local actualTime = os.date("*t", decodeTime)
    return ("%s/%s/%s %sh%s"):format(actualTime.day, actualTime.month, actualTime.year, actualTime.hour, actualTime.min)
end

return {
    get_time = getTime,
    get_date = getDate,
    decode = decodeTime,
}
