--- sl.math.round: round a number to a given decimal
---@param number number
---@param decimal? integer
---@return number
local function MathRound(number, decimal)
    return tonumber(string.format("%." .. (decimal or 0) .. "f", number))
end

--- sl.math.group: group a number by thousands
---@param value number
---@return string
local function MathGroup(value)
    local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. ","):reverse()) .. right
end

--- sl.math.price: format a number as a price
---@param number number
---@param decimal? integer
---@param color? string
---@return string
local function MathPrice(number, decimal, color)
    return ("%s%s$~s~"):format(color or '', MathGroup(MathRound(number, decimal or 0)))
end

--- sl.math.inverse_heading: inverse a heading
---@param heading float
---@return number
local function InverseHeading(heading)
    if type(heading) ~= 'number' then return end
    return (heading + 180) % 360
end

--- sl.math.two_digits : retourne une valeur sur 2 digit (exemple 1 retourne 01)
---@param number number
---@return string
local function DeuxDigits(number)
    return string.format("%02d", number)
end

--- sl.math.trim: trim a string
---@param number number
---@return string
local function MathTrim(number)
    if type(number) ~= 'number' then return end
    return string.gsub(number, "^%s*(.-)%s*$", "%1")
end

return {
    round = MathRound,
    group = MathGroup,
    price = MathPrice,
    trim = MathTrim,
    two_digits = DeuxDigits,
    inverse_heading = InverseHeading
}