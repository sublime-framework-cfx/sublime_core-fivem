local nui <const>, callback <const>, p = require 'client.modules.nui', require 'imports.callback.client'

nui.RegisterReactCallback('sl:login:submit', function(data, cb)
    cb(1)
    print(json.encode(data))
    local profile <const> = callback.sync('callback:login', false, data)
    print(profile, 'profile')
    if not profile or type(profile) ~= 'string' then
        print('here?')
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
    nui.SendReactMessage(true, {
        action = 'sl:login:opened',
        data = {}
    }, {
        focus = true
    })
    p = promise:new()
    return sl.await(p)
end