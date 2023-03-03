--- sl.math.round
---@param number number
---@param decimal? integer
---@return number
local function MathRound(number, decimal)
    return tonumber(string.format("%." .. (decimal or 0) .. "f", number))
end

--- sl.math.group
---@param value number
---@return string
local function MathGroup(value)
    local left, num, right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')
    return left .. (num:reverse():gsub('(%d%d%d)', '%1' .. ","):reverse()) .. right
end

--- sl.math.price
---@param number number
---@param decimal? integer
---@param color? string
---@return string
local function MathPrice(number, decimal, color)
    return ("%s%s$~s~"):format(color or '', MathGroup(MathRound(number, decimal or 0)))
end

--- sl.math.inverse_heading
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

--- sl.math.format_date : convertit un temps (en seconde) en SEM JJ HH MM SS
---@param sec number
---@param value? string
---@return integer|nil
---@return integer|nil
---@return string|nil
---@return string|nil
---@return string|nil
local function DateFormat(sec, value)
    --valeur possible semaine, jour, heure, minute ou seconde
    local sem, jj, hh, mm, ss, reste = 0, 0, 0, 0, 0
    if not value or value == 'semaine' or value == 'week' then 
        sem = math.floor(sec / (60 * 60 * 24 * 7))
        reste = sec % 604800
        jj = math.floor(reste / (60 * 60 * 24))
        reste = (reste % 86400)
        hh = math.floor(reste / (60 * 60))
        reste = (reste % 3600)
        mm = math.floor(reste / 60)
        ss = (reste % 60)
        return sem, jj, DeuxDigits(hh), DeuxDigits(mm), DeuxDigits(ss)
    elseif value == 'jour' or value == 'day' then
        jj = math.floor(sec / (60 * 60 * 24))
        reste = (sec % 86400)
        hh = math.floor(reste / (60 * 60))
        reste = (reste % 3600)
        mm = math.floor(reste / 60)
        ss = (reste % 60)
        return jj, DeuxDigits(hh), DeuxDigits(mm), DeuxDigits(ss)
    elseif value == 'heure' or value == 'hours' then
        hh = math.floor(sec / (60 * 60))
        reste = (sec % 3600)
        mm = math.floor(reste / 60)
        ss = (reste % 60)
        return DeuxDigits(hh), DeuxDigits(mm), DeuxDigits(ss)
    elseif value == 'minute' then
        mm = math.floor(sec / 60)
        reste = (sec % 60)
        ss = (reste)
        return DeuxDigits(mm), DeuxDigits(ss)
    elseif value == 'seconde' then
        ss = sec
        return DeuxDigits(ss)
    end
end

--- sl.math.trim
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
    format_date = DateFormat,
    inverse_heading = InverseHeading
}