local dir <const> = 'shared/data'

local groups = json.decode(LoadResourceFile(sl.name, ('%s/groups.json'):format(dir)))

--- sl.groups
---@param group? string
---@return table
function sl.groups(group)
    return groups[group] or groups
end

local perms = json.decode(LoadResourceFile(sl.name, ('%s/perms.json'):format(dir)))

--- sl.permission
---@param perm? string
---@return table
function sl.permission(perm)
    return perms[perm] or perms
end

--- sl.reload_file
---@param key string
---@return boolean
function sl.reload_file(key)
    if key == 'groups' or key == 'group' then
        groups = json.decode(LoadResourceFile(sl.name, ('%s/groups.json'):format(dir)))
        return true
    elseif key == 'perms' or key == 'perm' or key == 'permission' then
        perms = json.decode(LoadResourceFile(sl.name, ('%s/perms.json'):format(dir)))
        return true
    end
    return false
end