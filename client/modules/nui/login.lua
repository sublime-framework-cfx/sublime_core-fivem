local GetResourceKvpString <const>, SetResourceKvp <const>, p = GetResourceKvpString, SetResourceKvp

sl:registerReactCallback('sl:login:submit', function(data, cb)
    cb(1)
    if type(data) == 'boolean' then
        sl:emitNet('login:submit', 'forgot_password')
        return
    end
    if data.saveKvp then
        SetResourceKvp('sl:username', data.username)
        SetResourceKvp('sl:password', data.password)
    end

    local profile <const> = callback.sync('callback:login', false, data)
    if not profile or type(profile) ~= 'string' then
        sl:sendReactMessage(true, {
            action = 'sl:login:opened',
            data = {}
        })
        return
    end
    sl:resetFocus()
    p:resolve(profile)
end)

function sl:openLogin()
    if p then return end
    local AlreadyLogin <const> = callback.sync('callback:login', false, nil)
    if AlreadyLogin then 
        Wait(3000)    
        return AlreadyLogin 
    end
    local d = {}
    d.username = GetResourceKvpString('sl:username') or nil
    d.password = GetResourceKvpString('sl:password') or nil
    d.saveKvp = d.username and d.password and true or nil
    self:sendReactMessage(true, {
        action = 'sl:login:opened',
        data = next(d) and d or nil
    }, {
        focus = true
    })
    p = promise.new()
    return self.await(p)
end