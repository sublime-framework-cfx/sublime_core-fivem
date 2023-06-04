--- sl.math.round
---@param number number
---@param decimals? number
---@return number
local function MathRound(number, decimals)
    return tonumber(("%."..(decimals or 0).."f"):format(number))
end

--- supv.math.chance
---@param percent number
---@param cb? function
---@return boolean, number|nil
local function Chance(percent, cb)
    if type(percent) ~= 'number' then return 
    elseif percent <= 0 then return false
    elseif percent >= 100 then return true
    end

    local result = math.random(1, 100)
    if cb then cb(result) end ---@deprecated use the second return value
    return result <= percent, result
end

--- supv.math.twoDigits (ex: 1 -> 01)
---@param nombre string | number
---@return string
local function TwoDigits(nombre)
	nombre = type(nombre) == 'string' and ('%02d'):format(nombre) or ('%02d'):format(tostring(nombre))
	return nombre
end

return {
    round = MathRound,
    chance = Chance,
    twoDigits = TwoDigits,
}