local cards <const> = require(('server.modules.cards.%s'):format(sl.lang))

local function RegisterCard(d, callback)
    Wait(50)
    d.presentCard(cards.register, function(rdata, raw)
        print(json.encode(data, { indent = true }))
        if rdata.submit_type == 'cancel' then callback(d) end
        if rdata.submit_type == 'register' then
            local username, password, cpassword = rdata.username, rdata.password, rdata.confirm_password

            if not username or not password or not cpassword then
                d.update(translate('d_missing_fields'))
                Wait(1000)
                return RegisterCard(d, callback)
            end

            if password ~= cpassword then
                d.update(translate('d_passwords_not_match'))
                Wait(1000)
                return RegisterCard(d, callback)
            end

            ---@todo SQL method to check if user exists
        end
    end)
end

local function HomeCard(d)
    Wait(100)
    d.presentCard(cards.home, function(data, raw)
        if not data or data.submitId == 'quit' then
            d.done(translate('d_see_you_soon'))
            return CancelEvent()
        end

        if data.submitId == 'login' then
            ---@todo SQL method to check if user exists
        elseif data.submitId == 'register' then
            Wait(50)
            RegisterCard(d, HomeCard)
        end

        print(json.encode(data, { indent = true }))
    end)
end

return function(_source, name, setKickReason, d)
    d.defer()
    Wait(500)
    HomeCard(d)
end
