local nui <const>, callback <const>, onCharacter = require 'client.modules.nui', require 'imports.callback.client'

nui.RegisterReactCallback('sl:profiles:onSelect', function(data, cb)
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
                { type = 'input', placeholder = 'Username' }
            } or data == 'password' and {
                { type = 'password', placeholder = 'Password' },
                { type = 'password', placeholder = 'Confirm Password' }
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

nui.RegisterReactCallback('sl:profiles:onSubmit', function(data, cb)
    cb(1)
    if data.submit == 'disconnect' then
        sl.emitNet('profiles:onSubmit', 'disconnect')
    elseif data.submit == 'newChar' then
        local models <const> = callback.sync('callback:profiles:can', false, data.submit)
        if models then
            local input = sl.openModal({
                type = 'custom',
                title = 'New Character',
                options = {
                    { type = 'input', label = translate('first_name'), placeholder = 'John', required = true },
                    { type = 'input', label = translate('last_name'), placeholder = 'Doe', required = true },
                    { type = 'slider', label = translate('height'), min = 120, max = 220, default = 180, required = true },
                    { type = 'select', data = models, label = translate('model'), required = true },
                    { type = 'date-input', label = translate('date_of_birth'), required = true }
                }
            })
            if not input then return end
            local modelSelected <const> = require('shared.modules.models')[input[4]]
            onCharacter = {
                firstname = input[1],
                lastname = input[2],
                height = input[3],
                model = modelSelected.name,
                sex = modelSelected.sex == 0 and 'M' or modelSelected.sex == 1 and 'F' or 'N',
                dob = input[5]
            }
            sl.emitNet('profiles:onSubmit', 'newCharValid', onCharacter)
            onCharacter = nil
        end
    end
end)

function sl.openProfiles()
    local profiles <const> = callback.sync('callback:getProfilesNui')
    if not profiles then return end
    nui.SendReactMessage(true, {
        action = 'sl:profiles:opened',
        data = profiles
    }, {
        focus = true,
        keepInput = true
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
        focus = true,
        keepInput = true
    })
end)