
--- sl.math_round
---@param number number
---@param decimalPlace number
sl.math_round = function(number, decimalPlace)
    local mult = 10 ^ (decimalPlace or 0)
    return math.floor(number * mult + 0.5) / mult
end


--- sl.math_group
---@param value number
sl.math_group = function(value)
    local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. ","):reverse()) .. right
end


--- sl.math_price
---@param value number
---@param decimalPlace number
---@param color string
sl.math_price = function(value, decimalPlace, color)
    return ("%s%s$~s~"):format(color or '~g~', sl.math_group(sl.math_round(value, decimalPlace or 0)))
end


--- sl.math_getInversedHeading
---@param heading number
sl.math_getInversedHeading = function(heading)
    return (heading + 180) % 360
end


--- sl.math_timeFormat
---@param seconds number
sl.math_timeFormat = function(seconds)
    seconds = seconds or 0
    local hours <const>, minutes <const> = math.floor(seconds/3600), math.floor((seconds/60)%60)
    seconds = math.floor(seconds%60)
    return {hours = hours, minutes = minutes, seconds = seconds}
end


--- sl.math_trim
---@param number number
sl.math_trim = function(number)
    return (string.gsub(number, "^%s*(.-)%s*$", "%1"))
end
