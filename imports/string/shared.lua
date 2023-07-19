---@param str string
---@return string
local function FirstToUpper(str)
    str = str:lower()
    return (str:gsub("^%l", string.upper))
end

local function GenerateUUID()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return template:gsub('[xy]', function(repl)
        local v = (repl == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return ('%x'):format(v)
    end)
end

return {
    firstToUpper = FirstToUpper,
    uuid = GenerateUUID
}