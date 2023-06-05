local GetPlayerIdentifiers <const>, GetPlayerToken <const> = GetPlayerIdentifiers, GetPlayerToken

---@param source integer
---@param key? string
---@return unknown
local function GetIdentifierFromSource(source, key) ---@todo move in module
    local listId = { steam = true, license = true, xbl = true, ip = true, discord = true, live = true }
    if key ~= 'token' then
        for _,v in ipairs(GetPlayerIdentifiers(source)) do
            if listId[key] and listId[v:match('([^:]+)')] then
                return v:gsub('([^:]+):', '')
            end
        end
    end
    return GetPlayerToken(source)
end

---@param source integer
---@param encode? boolean
---@return table|string<json>
local function GetIdentifiersFromSource(source, encode) ---@todo
    local listId = { steam = true, license = true, xbl = true, ip = true, discord = true, live = true }
    local identifiers = {}
    for _,v in ipairs(GetPlayerIdentifiers(source)) do
        if listId[v:match('([^:]+)')] then
            identifiers[v:match('([^:]+)')] = v:gsub('([^:]+):', '')
        end
    end
    identifiers.token = GetPlayerToken(source)
    return encode and json.encode(identifiers) or identifiers
end

function sl:getIdentifiersFromId(source, encode)
    return GetIdentifiersFromSource(source, encode)
end

function sl:getIdentifierFromId(source, key)
    return GetIdentifierFromSource(source, key)
end