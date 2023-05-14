local nui <const>, callback <const>, p = require 'client.modules.nui', require 'imports.callback.client'
local GetResourceKvpString <const> = GetResourceKvpString

nui.RegisterReactCallback('sl:login:submit', function(data, cb)
    cb(1)
    if type(data) == 'boolean' then
        sl.emitNet('login:submit', 'forgot_password')
        return
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
    if profile.save then
        SetResourceKvp('sl:username', profile.username)
        SetResourceKvp('sl:password', profile.password)
    end
    p:resolve(profile.username)
end)

function sl.openLogin()
    if p then return end
    nui.SendReactMessage(true, {
        action = 'sl:login:opened',
        data = {
            username = GetResourceKvpString('sl:username') or nil,
            password = GetResourceKvpString('sl:password') or nil
        }
    }, {
        focus = true
    })
    p = promise.new()
    return sl.await(p)
end

---@todo save cache disk client side pré login
--[[

    SetResourceKvp(
        key: string, 
        value: string 
    )

    local retval: string =
        GetResourceKvpString(
            key: string
        )
--]]