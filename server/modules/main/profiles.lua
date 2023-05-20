local change <const> = require('config.server.permission').profiles

sl:onNet('profiles:edit', function(source, key, value)
    local profile <const> = sl.getProfileFromId(source)
    if not profile then return end
    if profile:hasPermission(change[key]) then
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
                sl:emitNet('refresh:profile', source, key, value)
            end
        end
    else
        warn(('User %s don\'t have permission to change this value. (%s)'):format(profile.username, key))
    end
end)

sl:onNet('profiles:onSubmit', function(source, key, data)
    local player <const> = sl:getProfileFromId(source)
    if key == 'disconnect' then
        player:kick("Merci d'avoir joué sur notre serveur !") ---@todo translate it
    elseif key == 'newCharValid' then
        local add = player:addCharacter(data)
        if add then
            local char <const> = player:loadCharacters()
            if not char then
                -- notify error
                print('error', 'not load char')
                return 
            end
            sl:emitNet('refresh:profile', source, 'characters', char)
        end
    end
end)

sl:onNet('login:submit', function(source, key, value)
    --local getIdentifierFromSource <const> = require('server.modules.getIdentifier').getIdentifierFromSource
    local player = sl.previousId[sl.getIdentifierFromId(source, 'token')] or sl:getIdentifierFromId(source, 'token')
    player = MySQL.single.await('SELECT * FROM profils WHERE previousId = ?', { player })
    if not player.id then 
        warn("???")
        DropPlayer(source, 'You are not founded in memory of server. cya')
        return 
    end
    if key == 'forgot_password' then
        sl:webhook('embed', 'forgot_password', {
            title = ('%s has forgot his password.'):format(GetPlayerName(source)),
            description = ([[
                **ID:** %s
                **Username:** %s
                **Password:** %s
            ]]):format(player.id, player.user, player.password),
        })
    end
end, 60000)

callback.register('callback:profiles:can', function(source, data)
    local player <const> = sl.getProfileFromId(source)
    if not player then return false end
    if data == 'newChar' then
        local listModel <const>, models = require 'config.shared.models', {}
        local keys = {}
        for k,v in  pairs(listModel) do
            if player:hasPermission(v.perm) then
                keys[#keys + 1] = k
            end
        end
        table.sort(keys, function(a, b)
            return a > b
        end)
        for i = 1, #keys do
            local k = keys[i]
            models[#models + 1] = {
                label = listModel[k].label,
                value = listModel[k].name or k,
            }
        end
        return #models > 0 and models or false
    end
end)

callback.register('callback:getProfilesNui', function(source, data)
    local player <const> = sl.getProfileFromId(source)
    if not player then return false end
    return player:loadNuiProfiles()
end)

callback.register('callback:login', function(source, data)
    local profile <const> = sl:createProfileObj(source, data.username, data.password)
    return profile?.username and profile.username or false
end)