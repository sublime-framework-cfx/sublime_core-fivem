---@param str string
---@return string
local function FirstToUpper(str)
    str = str:lower()
    return (str:gsub("^%l", string.upper))
end

return {
    firstToUpper = FirstToUpper
}