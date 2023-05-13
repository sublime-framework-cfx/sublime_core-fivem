local nui <const> = require 'client.modules.nui'
local callback <const> = require 'imports.callback.client'

nui.RegisterReactCallback('sl:profiles:onSelect', function(data, cb)
    cb(1)
    --callback.async('callback:selectProfile', data)
    local selected <const> = callback.sync('callback:selectProfilesNui', data)
    if not selected then return end
    nui.SendReactMessage(true, {
        action = 'sl:profiles:update:selected',
        data = selected
    })
end)

---@todo implement this to update the profile list profiles / char
nui.RegisterReactCallback('sl:profiles:onEdit', function(data, cb)
    cb(1)
end)

function sl.openProfiles()
    local profiles <const> = callback.sync('callback:getProfilesNui')
    if not profiles then return end
    nui.SendReactMessage(true, {
        action = 'sl:profiles:opened',
        data = profiles
    }, {
        focus = true
    })
end