local callback <const>, change <const> = require 'imports.callback.server', require('config.server.permission').profiles

sl.onNet('profiles:edit', function(source, key, value)
    local profile = sl.getProfileFromId(source)
    if not profile then return end
    if (change[key] == true) or (change[key][profile.permission]) then
        if key == 'logo' then
            profile:setMetadata(key, value)
        else
            if key == 'username' then
                local exist <const> = MySQL.scalar.await('SELECT 1 FROM profils WHERE user = ?', { value })
                if exist then
                    warn(('Username %s already exist.'):format(value))
                    return
                end
            end
            profile:set(key, key == 'password' and joaat(value) or value)
            if key ~= 'password' then
                sl.emitNet('refresh:profile', source, key, value)
            end
        end
    else
        warn(('User %s don\'t have permission to change this value. (%s)'):format(profile.username, key))
    end
end)

sl.onNet('profiles:onSubmit', function(source, key)
    local player <const> = sl.getProfileFromId(source)
    if key == 'disconnect' then
        player:kick("Merci d'avoir joué sur notre serveur !") ---@todo translate it
    end
end)

sl.onNet('login:submit', function(source, key, value)
    local getIdentifierFromSource <const> = require('server.modules.getIdentifier').getIdentifierFromSource
    local player = sl.previousId[getIdentifierFromSource(source, 'token')] or getIdentifierFromSource(source, 'token')
    player = MySQL.single.await('SELECT * FROM profils WHERE previousId = ?', { player })
    if not player.id then 
        warn("???")
        DropPlayer(source, 'You are not founded in memory of server. cya')
        return 
    end
    if key == 'forgot_password' then
        sl.webhook('embed', 'forgot_password', {
            title = ('%s has forgot his password.'):format(GetPlayerName(source)),
            description = ([[
                **ID:** %s
                **Username:** %s
                **Password:** %s
            ]]):format(player.id, player.user, player.password),
        })
    end
end, 60000)

callback.register('callback:getProfilesNui', function(source, data)
    local player <const> = sl.getProfileFromId(source)
    if not player then return false end
    return player:loadNuiProfiles()
end)

callback.register('callback:login', function(source, data)
    local profile <const> = sl.createPlayerObj(source, data.username, data.password)
    return profile?.username and profile.username or false
end)