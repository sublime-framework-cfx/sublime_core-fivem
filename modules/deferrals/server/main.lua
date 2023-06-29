local cards <const> = require(('modules.deferrals.server.cards.%s'):format(sl.lang))
local mysql <const> = require 'modules.mysql.server.function'
local SublimePlayer <const> = require 'modules.main.server.class.player' ---@type SublimePlayer

local function RegisterCard(d, cb, _source)
    Wait(50)
    d.presentCard(cards.register, function(rdata, raw)
        if rdata.submit_type == 'cancel' then cb(d) end
        if rdata.submit_type == 'register' then
            local password, confirm_password, username in rdata

            if not username or not password or not confirm_password then
                d.update(translate('d_missing_fields'))
                Wait(3000)
                return RegisterCard(d, cb, _source)
            end

            password = joaat(password:gsub('%s+', '_'))
            confirm_password = joaat(confirm_password:gsub('%s+', '_'))
            username = username:gsub('%s+', '-')

            if password ~= confirm_password then
                d.update(translate('d_passwords_not_match'))
                Wait(3000)
                return RegisterCard(d, cb, _source)
            end

            ---@todo SQL: Add more security checks about identifier want create multiple account if you don't authorized to do that
            local user_exist <const> = mysql.checkUserExist(username)
            if user_exist then
                d.update(translate('d_user_already_exist'))
                Wait(3000)
                return RegisterCard(d, cb)
            end

            local success <const> = mysql.createProfile(username, tostring(password), sl.getIdentifiersFromId(_source, true))
            if success then
                d.update(translate('d_account_created'))
                Wait(3000)
                return cb(d, _source)
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
            local username, password in data

            if not username or not password then
                d.update(translate('d_missing_fields'))
                Wait(3000)
                return HomeCard(d, _source)
            end

            password = tostring(joaat(password:gsub('%s+', '_')))
            username = username:gsub('%s+', '-')

            local user_exist <const> = mysql.loginToProfile(username, password)
            if not user_exist then
                d.update(translate('d_user_not_exist'))
                Wait(3000)
                return HomeCard(d, _source)
            end

            local player = SublimePlayer.new({
                userid = user_exist,
                source = _source,
                username = username,
                password = tonumber(password),
            })

            if player:init() then
                mysql.updateProfileIdentifiers(sl.getIdentifiersFromId(_source, true), player.userid)
                sl.tempId[_source] = _source
                sl.players[_source] = player
                Wait(500)
                return d.done()
            end

            return CancelEvent()
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
