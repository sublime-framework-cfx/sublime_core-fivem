local PlayerPedId <const> = PlayerPedId
local PlayerId <const> = PlayerId
local GetPlayerServerId <const> = GetPlayerServerId 
local GetVehiclePedIsIn <const> = GetVehiclePedIsIn
local GetPedInVehicleSeat <const> = GetPedInVehicleSeat
local GetVehicleMaxNumberOfPassengers <const> = GetVehicleMaxNumberOfPassengers
local GetCurrentPedWeapon <const> = GetCurrentPedWeapon
local cache = _ENV.cache

function cache:set(key, value)
    if self[key] ~= value then
        self[key] = value
        sl:emit(('cache:%s'):format(key), value)
        return true
    end
end

cache:set('playerid', PlayerId())
cache:set('serverid', GetPlayerServerId(cache.playerid))

CreateThread(function()
    while true do
        cache:set('ped', PlayerPedId())

        local hasWeapon, weaponHash = GetCurrentPedWeapon(cache.ped, true)
        cache:set('weapon', hasWeapon and weaponHash or false)

        local vehicle = GetVehiclePedIsIn(cache.ped, false)
        if vehicle > 0 then
            cache:set('vehicle', vehicle)

            if not cache.seat or GetPedInVehicleSeat(vehicle, cache.seat) ~= cache.ped then
                for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
                    if GetPedInVehicleSeat(vehicle, i) == cache.ped then
                        cache:set('seat', i)
                        break
                    end
                end
            end
        else
            cache:set('vehicle', false)
            cache:set('seat', false)
        end

        Wait(750)
    end
end)

function sl.getCache(key)
    return cache[key]
end
