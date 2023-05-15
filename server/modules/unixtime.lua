---@param unixtime number
---@param format? string-'DD/MM/YYYY'
---@return string as date format
local function moment(unixtime, format)
    return exports[sl.name]:convertUnixTimeToDate(unixtime, format)
end

return moment