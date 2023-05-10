local cards <const> = require(('server.modules.cards.%s'):format(sl.lang))

local function GetAllIdentifiers(source)
    local identifiers = {}
    for _, v in ipairs(GetPlayerIdentifiers(source)) do
        if v:match('steam:') then
            identifiers.steam = v:gsub('steam:', '')
        end
        if v:match('license:') then
            identifiers.license = v:gsub('license:', '')
        end
        if v:match('xbl:') then
            identifiers.xbl = v:gsub('xbl:', '')
        end
        if v:match('ip:') then
            identifiers.ip = v:gsub('ip:', '')
        end
        if v:match('discord:') then
            identifiers.discord = v:gsub('discord:', '')
        end
        if v:match('live:') then
            identifiers.live = v:gsub('live:', '')
        end
        identifiers.token = GetPlayerToken(source)
    end
    return json.encode(identifiers)
end

local function RegisterCard(d, callback, _source)
    Wait(50)
    d.presentCard(cards.register, function(rdata, raw)
        if rdata.submit_type == 'cancel' then callback(d) end
        if rdata.submit_type == 'register' then
            local username, password, cpassword = rdata.username, rdata.password, rdata.confirm_password

            if not username or not password or not cpassword then
                d.update(translate('d_missing_fields'))
                Wait(3000)
                return RegisterCard(d, callback, _source)
            end

            password = joaat(password:gsub('%s+', '_'))
            cpassword = joaat(cpassword:gsub('%s+', '_'))
            username = username:gsub('%s+', '-')

            if password ~= cpassword then
                d.update(translate('d_passwords_not_match'))
                Wait(3000)
                return RegisterCard(d, callback, _source)
            end

            ---@todo SQL: Add more security checks about identifier want create multiple account if you don't authorized to do that
            local user_exist = MySQL.scalar.await('SELECT 1 FROM `profils` WHERE `user` = ?', {username})
            if user_exist then
                d.update(translate('d_user_already_exist'))
                Wait(3000)
                return RegisterCard(d, callback)
            end

            local success = MySQL.insert.await('INSERT INTO profils (user, password, createdBy) VALUES (?, ?, ?)', {username, tostring(password), GetAllIdentifiers(_source)})
            if success then
                d.update(translate('d_account_created'))
                Wait(3000)
                return callback(d, _source)
            end
        end
    end)
end

local function HomeCard(d, _source)
    Wait(100)
    d.presentCard(cards.home, function(data, raw)
        if not data or data.submitId == 'quit' then
            d.done(translate('d_see_you_soon'))
            return CancelEvent()
        end

        if data.submitId == 'login' then
            local username, password = data.username, data.password
            if not username or not password then
                d.update(translate('d_missing_fields'))
                Wait(3000)
                return HomeCard(d, _source)
            end

            password = tostring(joaat(password:gsub('%s+', '_')))
            username = username:gsub('%s+', '-')

            local user_exist = MySQL.scalar.await('SELECT 1 FROM `profils` WHERE `user` = ? AND `password` = ?', {username, password})
            if not user_exist then
                d.update(translate('d_user_not_exist'))
                Wait(3000)
                return HomeCard(d, _source)
            end

            local ids = json.decode(GetAllIdentifiers(_source)) 
            MySQL.update.await('UPDATE profils SET identifiers = ?, previousId = ? WHERE `user` = ? AND `password` = ?', {json.encode(ids), ids.token, username, password})
            sl.previousId[ids.token] = true
            d.done()
        elseif data.submitId == 'register' then
            Wait(50)
            RegisterCard(d, HomeCard, _source)
        end
    end)
end

return function(_source, name, setKickReason, d)
    d.defer()
    Wait(500)
    HomeCard(d, _source)
end
