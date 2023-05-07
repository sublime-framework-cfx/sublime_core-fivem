
--- sl.string.first_to_upperv: convert the first character of a string to uppercase
---@param _string string
---@return string
local function FirstToUpper(_string)
    return (_string:gsub("^%l", string.upper))
end

--- sl.string.money_format: format a number to a money format
---@param amount number
---@param stepper string
---@return string
local function MoneyFormat(amount, stepper)
    local left <const>, center <const>, right <const> = string.match(math.floor(amount), "^([^%d]*%d)(%d*)(.-)$")
	return (left .. string.reverse(string.gsub(string.reverse(center), "(%d%d%d)", "%1" .. (stepper or " "))) .. right)
end

--- sl.string.random: generate a random string
---@param length number
---@param randomTemplate string
---@return string
local function Random(length, randomTemplate)
    local charset <const> = (randomTemplate or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    local randomString = ""
    for i = 1, (length or 10) do
        local randomNumber <const> = math.random(1, #charset)
        randomString = randomString .. charset:sub(randomNumber, randomNumber)
    end
    return (randomString)
end

--- sl.string.contains: check if a string contains a pattern
---@param stringToFind string
---@param pattern string
---@return string
local function Contains(stringToFind, pattern)
    return (stringToFind:find(pattern) ~= nil)
end

--- sl.string.replace_all: replace all occurences of a pattern in a string
---@param str string
---@param find string
---@param replace string
---@return string
local function ReplaceAll(str, find, replace)
    return (str:gsub(find, replace))
end

--- sl.string.split: split a string by a delimiter
---@param str string
---@param delimiter string
---@return string
local function Split(str, delimiter)
	if not str then return {} end
	local result = {}
	for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
		result[#result + 1] = match
	end
	return result
end

--- sl.string.hash: get the hash of a string
---@param string string
---@return string
local function Hash(string)
    return GetHashKey(string)
end

return {
    first_to_upper = FirstToUpper,
    money_format = MoneyFormat,
    random = Random,
    contains = Contains,
    replace_all = ReplaceAll,
    split = Split,
    hash = Hash
}