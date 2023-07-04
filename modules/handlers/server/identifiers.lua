local GetPlayerIdentifiers <const>, GetPlayerIdentifierByType<const>, GetPlayerToken <const> = GetPlayerIdentifiers, GetPlayerIdentifierByType, GetPlayerToken
local identifiersApproved <const> = { steam = true, license = true, xbl = true, ip = true, discord = true, live = true }

---@param source integer
---@param key? string
---@return unknown
local function GetIdentifierFromSource(source, key) ---@todo move or add in import
    if key == "token" or not identifiersApproved[key] then
        return GetPlayerToken(source)
    end
    local identifier = GetPlayerIdentifierByType(source, key)
    return (identifier and identifier:gsub('([^:]+):', '')) or nil
end

---@param source integer
---@param encode? boolean
---@return table|string<json>
local function GetIdentifiersFromSource(source, encode) ---@todo move or add in import
    local identifiers = {}
    for _,v in ipairs(GetPlayerIdentifiers(source)) do
        local keyIdentifier = v:match('([^:]+)')
        if identifiersApproved[keyIdentifier] then
            identifiers[keyIdentifier] = v:gsub('([^:]+):', '')
        end
    end
    identifiers.token = GetPlayerToken(source)
    return (encode and json.encode(identifiers, { indent = true })) or identifiers
end

sl.getIdentifiersFromId = GetIdentifiersFromSource
sl.getIdentifierFromId = GetIdentifierFromSource