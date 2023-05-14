local nui <const>, callback <const>, p = require 'client.modules.nui', require 'imports.callback.client'
local GetResourceKvpString <const>, SetResourceKvp <const> = GetResourceKvpString, SetResourceKvp

nui.RegisterReactCallback('sl:login:submit', function(data, cb)
    cb(1)
    if type(data) == 'boolean' then
        sl.emitNet('login:submit', 'forgot_password')
        return
    end
    if data.saveKvp then
        SetResourceKvp('sl:username', data.username)
        SetResourceKvp('sl:password', data.password)
    end
    local profile <const> = callback.sync('callback:login', false, data)
    if not profile or type(profile) ~= 'string' then
        nui.SendReactMessage(true, {
            action = 'sl:login:opened',
            data = {}
        })
        return
    end
    nui.ResetFocus()
    p:resolve(profile)
end)

function sl.openLogin()
    if p then return end
    local d = {}
    d.username = GetResourceKvpString('sl:username') or nil
    d.password = GetResourceKvpString('sl:password') or nil
    d.saveKvp = d.username and d.password and true or nil
    nui.SendReactMessage(true, {
        action = 'sl:login:opened',
        data = next(d) and d or nil
    }, {
        focus = true
    })
    p = promise.new()
    return sl.await(p)
end