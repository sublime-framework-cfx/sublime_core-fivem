
--- sl.string_firstToUpper
---@param string_ string
sl.string_firstToUpper = function(string_)
    return (string_:gsub("^%l", string.upper))
end

--- sl.string_moneyFormat
---@param amount number
---@param stepper string
sl.string_moneyFormat = function(amount, stepper)
    local left <const>, center <const>, right <const> = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return (left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right)
end

--- sl.string_random
---@param length number
---@param randomTemplate string
sl.string_random = function(length, randomTemplate)
    local charset <const> = (randomTemplate or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    local randomString = ""
    for i = 1, (length or 10) do
        local randomNumber <const> = math.random(1, #charset)
        randomString = randomString .. charset:sub(randomNumber, randomNumber)
    end
    return (randomString)
end

--- sl.string_contains
---@param stringToFind string
---@param pattern string
sl.string_contains = function(stringToFind, pattern)
    return (stringToFind:find(pattern) ~= nil)
end

--- sl.string_replaceAll
---@param str string
---@param find string
---@param replace string
sl.string_replaceAll = function(str, find, replace)
    return (str:gsub(find, replace))
end


--- sl.string_split
---@param str string
---@param delimiter string
sl.string_split = function(str, delimiter)
	if (not (str)) then return {} end
	local result = {}
	for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
		result[#result + 1] = match
	end
	return (result)
end


--- sl.string_prefixFormat
---@param string string
sl.string_prefixFormat = function(string)
    return ("sl_%s"):format(sl.string_hash(string))
end


--- sl.string_hash
---@param string string
sl.string_hash = function(string)
    return GetHashKey(string)
end
