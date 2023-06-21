local createPed <const> = require 'imports.npc.client'
local default <const> = require 'config.client.firstspawn'
local lastIndex, Charlist, ped, onCharacter, pedInfo  = 0, {}
local Promise
---------------------------------------------------------

local function StartPreview(cam)
    SetPlayerControl(cache.playerid, true, 0)
    FreezeEntityPosition(cache.ped, true)

    CreateThread(function()
        local mouseX = 0.0
        local mouseY = 0.0
        local rotationSpeed = 2.0
        local rotationAngle = 0.0
        local camDistance = 5.0 -- Distance initiale entre la caméra et le personnage
        while Promise do
            Wait(0)
            DisableControlAction(0, 24, true) -- Désactiver les attaques
            ---@todo: ajout de plus de control a desactiver plus tards ...
            if IsControlPressed(0, 25) then -- 25 (bouton de la souris)
                mouseX = (2.0 * GetControlNormal(0, 239) - 1.0)
                if mouseX < -0.1 then
                    rotationAngle = rotationAngle + (mouseX * rotationSpeed)
                elseif mouseX > 0.1 then
                    rotationAngle = rotationAngle + (mouseX * rotationSpeed)
                end
    
                mouseY = (2.0 * GetControlNormal(0, 240) - 1.0)
    
                -- Gérer le zoom et le dézoom avec la molette de la souris
                local scrollValue = 0.0
                if IsControlJustPressed(0, 15) then -- 243 (molette de la souris vers le haut)
                    scrollValue += 0.1 -- Valeur de zoom positive
                elseif IsControlJustPressed(0, 14) then -- 242 (molette de la souris vers le bas)
                    scrollValue -= 0.1 -- Valeur de zoom négative
                end
                camDistance = camDistance + (scrollValue * 1.0) -- Ajuster la distance de la caméra en fonction du zoom
    
                camDistance = math.max(1.0, math.min(5.0, camDistance)) -- Limiter la distance de la caméra entre 1.0 et 3.0
    
                local camX = default.coords.x + (math.sin(math.rad(rotationAngle)) * camDistance)
                local camY = default.coords.y + (math.cos(math.rad(rotationAngle)) * camDistance)
                local camZ = default.coords.z + (mouseY * 2.0) -- Ajuster la hauteur de la caméra en fonction du mouvement de la souris
    
                -- Orienter la caméra vers le personnage
                SetCamCoord(cam, camX, camY, camZ)
                PointCamAtEntity(cam, ped?.ped or cache.ped, 0.0, 0.0, 0.0, true)
            end
        end
    end)
end

--- Function ---

function sl.openProfile(cam)
    Promise = promise.new()
    local profiles <const> = callback.sync('callback:getProfilesNui')
    Charlist = profiles.chars
    if not profiles then return end
    StartPreview(cam)
    sl.sendReactMessage(true, {
        action = 'sl:profiles:opened',
        data = profiles
    }, {
        focus = true,
        keepInput = true
    })

    return sl.await(Promise)
end

--- DEBUG ---

RegisterCommand('spawn', function()
   --if not next(pedInfo) or not Promise then return end
   if ped then ped = ped:remove() end
   Promise:resolve(pedInfo)
   Promise = nil
end)

--- Event ---

sl:onNet('refresh:profile', function(key, value)
    if key == 'characters' then
        Charlist = {}
        Charlist = value
    end
    sl.sendReactMessage(true, {
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

--- Nui callback ---

sl.registerReactCallback('sl:profiles:onSelect', function(data, cb) ---@todo
    local selected <const> = callback.sync('callback:selectProfilesNui', data)
    if not selected then return end
    sl.sendReactMessage(true, {
        action = 'sl:profiles:update:selected',
        data = selected
    })
end)

-- Char selector
sl.registerReactCallback('sl:profile:callback:charSelect', function(data, cb)
    cb(1)
    local index = data + 1
    if index == lastIndex then return end
    lastIndex = index
    pedInfo = Charlist[index]

    -- local offSet = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 4.7, 0.2)
    -- local cam = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', offSet.x, offSet.y, offSet.z, 0.0, 0.0, 0.0, 30.0, false, 0)
    -- SetCamActive(cam, true)
    -- RenderScriptCams(true, false, 0.0, true, true)

    if ped then ped = ped:remove() end

    ped = createPed.preview(pedInfo.model, default.coords, 'anim@mp_player_intcelebrationmale@wave', 'wave')
end)

sl.registerReactCallback('sl:profiles:onSubmit', function(data, cb)
    cb(1)
    if data.submit == 'disconnect' then
        sl:emitNet('profiles:onSubmit', 'disconnect')
    elseif data.submit == 'spawn' then
        if ped then ped = ped:remove() end
        Promise:resolve(pedInfo)
        Promise = nil
    elseif data.submit == 'newChar' then
        local models <const> = callback.sync('callback:profiles:can', false, data.submit)
        if models then
            if ped then ped = ped:remove() end
            local input = sl.openModal('custom', {
                title = 'New Character',
                transition = {
                    name= 'skew-up',
                    duration= 200,
                    timingFunction= 'ease-in-out'
                },
                options = {
                    { type = 'input', label = translate('first_name'), placeholder = 'John', required = true, error = '' },
                    { type = 'input', label = translate('last_name'), placeholder = 'Doe', required = true, error = '' },
                    { type = 'slider', label = translate('height'), min = 120, max = 220, default = 180 },
                    { type = 'select', options = models, label = translate('model'), required = true , callback = true, error = ''},
                    { type = 'date', label = translate('date_of_birth'), required = true, error = '' }
                },
            }, function(index, value)
                print(index, value)
                if index == 4 then
                    if ped then ped = ped:remove() end
                    ped = createPed.preview(value, default.coords, 'anim@mp_player_intcelebrationmale@wave', 'wave')
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
            if ped then ped = ped:remove() end
        end
    end
end)

---@todo implement this to update the profile list profiles / char
sl.registerReactCallback('sl:profiles:onEdit', function(data, cb)
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
            local input = sl.openModal('custom', {
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
--- Resource Stop ---

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= sl.name then return end
    if ped then ped = ped:remove() end
end)

