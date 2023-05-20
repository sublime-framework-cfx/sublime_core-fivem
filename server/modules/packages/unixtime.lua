local export <const> = exports[sl.name]

---@param unixtime number
---@param format? string-'DD/MM/YYYY'
---@return string as date format
local function moment(unixtime, format)
    return export:convertUnixTimeToDate(unixtime, format)
end

return moment