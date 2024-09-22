local player = {}

---@param key string
---@param value any
---@param force? 'ignore' | boolean
function player:set(key, value, force)
    if not self[key] or self[key] ~= value or force then
        self[key] = value
        if force and force == 'ignore' then return end
        TriggerEvent('sublime:player:set:'..key, value)
    end
end

---@param coords vec3
---@return number
function player:distance(coords)
    return #(self.coords - coords)
end

CreateThread(function()
    player:set('id', PlayerId())
    player:set('serverid', GetPlayerServerId(player.id))

    while true do
        player:set('ped', PlayerPedId())
        player:set('coords', GetEntityCoords(player.ped), 'ignore')
        player:set('vec4', vec4(player.coords.x, player.coords.y, player.coords.z, GetEntityHeading(player.ped)), 'ignore')

        local hasWeapon <const>, weaponHash <const> = GetCurrentPedWeapon(player.ped, true)
        player:set('weapon', hasWeapon and weaponHash or false)

        local vehicle <const> = GetVehiclePedIsIn(player.ped, false)
        if vehicle > 0 then
            player:set('vehicle', vehicle)

            if not player.seat or GetPedInVehicleSeat(vehicle, player.seat) ~= player.ped then
                for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
                    if GetPedInVehicleSeat(vehicle, i) == player.ped then
                        player:set('seat', i)
                        break
                    end
                end
            end
        else
            player:set('vehicle', false)
            player:set('seat', false)
        end
    
        Wait(500)
    end
end)

---@param key string
---@return any
function sublime.GetPlayer(key)
    return player[key] or key == 'vehicle' and false or false
end

_ENV.player = player