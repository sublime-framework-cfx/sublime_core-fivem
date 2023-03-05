
---sl.time.hours_to_ms: convert hours to milliseconds
---@param hours number
---@return number
local function hoursToMilliseconds(hours)
  return hours * 60 * 60 * 1000
end

---sl.time.days_to_ms: convert days to milliseconds
---@param days number
---@return integer
local function daysToMilliseconds(days)
  return days * 24 * 60 * 60 * 1000
end

---sl.time.split_ms: split milliseconds into paliers
---@param milliseconds number
---@param palier number default 30000
---@return table
local function splitMilliseconds(milliseconds, palier)
    local palier = palier or 30000
  local paliers = {}
  local currentPalier = 0
  while milliseconds > 0 do
    if milliseconds >= palier then
      currentPalier = palier
    else
      currentPalier = milliseconds
    end
    table.insert(paliers, currentPalier)
    milliseconds = milliseconds - currentPalier
  end
  return paliers
end

return {
    hours_to_ms = hoursToMilliseconds,
    days_to_ms = daysToMilliseconds,
    split_ms = splitMilliseconds
}