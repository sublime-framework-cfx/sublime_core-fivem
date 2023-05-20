local preview <const>, onCharacter = require 'client.modules.main.firstspawn'

sl:registerReactCallback('sl:profiles:onSelect', function(data, cb)
    local selected <const> = callback.sync('callback:selectProfilesNui', data)
    if not selected then return end
    sl:sendReactMessage(true, {
        action = 'sl:profiles:update:selected',
        data = selected
    })
end)

---@todo implement this to update the profile list profiles / char
sl:registerReactCallback('sl:profiles:onEdit', function(data, cb)
    cb(1)
    if data.edit == 'profile' then
        if data.key == 'logo' then
            sl:emitNet('profiles:edit', data.key, data.value)
        else
            local options = data.key == 'username' and {
                { type = 'input', placeholder = 'Username' }
            } or data == 'password' and {
                { type = 'password', placeholder = 'Password' },
                { type = 'password', placeholder = 'Confirm Password' }
            }
            local input = sl:openModal({
                type = 'custom',
                title = 'Edit Profile',
                options = options
            })
            if not input then return end
            if data.key == 'username' then
                sl:emitNet('profiles:edit', data.key, input[1])
            elseif data.key == 'password' then
                local p1, p2 = input[1], input[2]
                p1, p2 = p1:gsub('%s+', ''), p2:gsub('%s+', '')
                if p1 ~= p2 then
                    print('passwords do not match :(') -- replace to notification later
                    return
                end
                sl:emitNet('profiles:edit', data.key, p1)
            end
        end
    elseif data.edit == 'char' then
        -- sl.emitNet('characters:edit', data.key, data.value)
    end
end)

sl:registerReactCallback('sl:profiles:onSubmit', function(data, cb)
    cb(1)
    if data.submit == 'disconnect' then
        sl:emitNet('profiles:onSubmit', 'disconnect')
    elseif data.submit == 'newChar' then
        local models <const> = callback.sync('callback:profiles:can', false, data.submit)
        if models then
            local input = sl:openModal({
                type = 'custom',
                title = 'New Character',
                options = {
                    { type = 'input', label = translate('first_name'), placeholder = 'John', required = true },
                    { type = 'input', label = translate('last_name'), placeholder = 'Doe', required = true },
                    { type = 'slider', label = translate('height'), min = 120, max = 220, default = 180, required = true },
                    { type = 'select', data = models, label = translate('model'), required = true , callback = true},
                    { type = 'date-input', label = translate('date_of_birth'), required = true }
                },
            }, function(index, value)
                print(index, value)
                if index == 4 then
                    local defaultCoords <const> = vec4(498.45, 5605.07, 797.90, 178.37)
                    local ped = preview.get('preview')
                    preview.delete('preview')
            
                    local offset = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 4.7, 0.2)
                    local cam = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, 30.0, false, 0)
                    SetCamActive(cam, true)
                    RenderScriptCams(true, true, 0.0, true, true)
                    preview.spawn('preview', joaat(value), defaultCoords, 'anim@mp_player_intcelebrationmale@wave', 'wave')
                    Wait(300)
                    ped = preview.get('preview')
                    FreezeEntityPosition(ped, true)
                    --TaskGoToCoordAnyMeans(ped, defaultCoords.x, defaultCoords.y, defaultCoords.z, 1.0, 0, 0, 786603, 0xbf800000)
                    Wait(500)
                    --TaskTurnPedToFaceCoord(ped, defaultCoords.x, defaultCoords.y, defaultCoords.z, -1)
                end
            end)
            if not input then return end
            local modelSelected <const> = require('config.shared.models')[input[4]]
            onCharacter = {
                firstname = input[1],
                lastname = input[2],
                height = input[3],
                model = modelSelected.name,
                sex = modelSelected.sex == 0 and 'M' or modelSelected.sex == 1 and 'F' or 'N',
                dob = input[5]
            }
            sl:emitNet('profiles:onSubmit', 'newCharValid', onCharacter)
            onCharacter = nil
        end
    end
end)

function sl:openProfile()
    local profiles <const> = callback.sync('callback:getProfilesNui')
    if not profiles then return end
    self:sendReactMessage(true, {
        action = 'sl:profiles:opened',
        data = profiles
    }, {
        focus = true,
        keepInput = true
    })
end

sl:onNet('refresh:profile', function(key, value)
    sl:sendReactMessage(true, {
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