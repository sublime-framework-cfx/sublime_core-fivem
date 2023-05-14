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

return {
    getIdentifierFromSource = GetIdentifierFromSource
}