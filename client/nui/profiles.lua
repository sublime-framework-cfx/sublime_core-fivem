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
    if data.edit == 'profile' then
        if data.key == 'logo' then
            sl.emitNet('profiles:edit', data.key, data.value)
        else
            local options = data.key == 'username' and {
                {
                    type = 'input',
                    placeholder = 'Username',
                }
            } or data == 'password' and {
                {
                    type = 'password',
                    placeholder = 'Password',
                },
                {
                    type = 'password',
                    placeholder = 'Confirm Password',
                }
            }
            local input = sl.openModal({
                type = 'custom',
                title = 'Edit Profile',
                options = options
            })
            if not input then return end
            if data.key == 'username' then
                sl.emitNet('profiles:edit', data.key, input[1])
            elseif data.key == 'password' then
                local p1, p2 = input[1], input[2]
                p1, p2 = p1:gsub('%s+', ''), p2:gsub('%s+', '')
                if p1 ~= p2 then
                    print('passwords do not match :(') -- replace to notification later
                    return
                end
                sl.emitNet('profiles:edit', data.key, p1)
            end
        end
    elseif data.edit == 'char' then
        -- sl.emitNet('characters:edit', data.key, data.value)
    end
end)

nui.RegisterReactCallback('sl:profiles:onSubmit', function (data, cb)
    cb(1)
    if data.submit == 'disconnect' then
        sl.emitNet('profiles:onSubmit', 'disconnect')
    end
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

sl.onNet('refresh:profile', function(key, value)
    nui.SendReactMessage(true, {
        action = 'sl:update:profile',
        data = {
            key = key,
            value = value
        }
    }, {
        focus = true
    })
end)