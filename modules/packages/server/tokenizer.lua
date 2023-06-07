local export <const> = exports[sl.name]

---@return string uuid (randomly generated when resource start)
local token <const> = export:getToken()
return token