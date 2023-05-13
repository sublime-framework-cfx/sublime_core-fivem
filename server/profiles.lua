local callback <const>, change <const> = require 'imports.callback.server', require('config.server.permission').profiles

sl.onNet('profiles:edit', function(source, key, value)
    local profile = sl.getProfileFromId(source)
    if not profile then return end
    if (change[key] == true) or (change[key][profile.permission]) then
        profile:setMetadata(key, value)
    else
        warn(('User %s don\'t have permission to change this value. (%s)'):format(profile.username, key))
    end
end)

callback.register('callback:getProfilesNui', function(source, data)
    local player <const> = sl.getProfileFromId(source)
    if not player then return false end
    return player:loadNuiProfiles()
end)

callback.register('callback:login', function(source, data)
    local profile <const> = sl.createPlayerObj(source, data.username, data.password)
    return profile?.username or false
end)