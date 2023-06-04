CreateThread(function()
    local SetVehicleModelIsSuppressed <const> = SetVehicleModelIsSuppressed
    local SetPedModelIsSuppressed <const> = SetPedModelIsSuppressed
    local SetRandomBoats <const> = SetRandomBoats
    local SetRandomTrains <const> = SetRandomTrains
    local SetGarbageTrucks <const> = SetGarbageTrucks
    local SetCreateRandomCops <const> = SetCreateRandomCops
    local SetCreateRandomCopsNotOnScenarios <const> = SetCreateRandomCopsNotOnScenarios
    local SetCreateRandomCopsOnScenarios <const> = SetCreateRandomCopsOnScenarios
    local SetDispatchCopsForPlayer <const> = SetDispatchCopsForPlayer
    local SetPedPopulationBudget <const> = SetPedPopulationBudget
    local SetVehiclePopulationBudget <const> = SetVehiclePopulationBudget
    local SetNumberOfParkedVehicles <const> = SetNumberOfParkedVehicles

    local config <const> = require 'config.client.setting'.population

    SetRandomBoats(config.enable.boats)
    SetRandomTrains(config.enable.trains)
    SetGarbageTrucks(config.enable.garbage_truck)
    SetCreateRandomCops(config.enable.cops)
    SetCreateRandomCopsNotOnScenarios(config.enable.cops)
    SetCreateRandomCopsOnScenarios(config.enable.cops)
    SetDispatchCopsForPlayer(cache.playerid, config.enable.cops)
    SetPedPopulationBudget(config.traffic.npc)
    SetVehiclePopulationBudget(config.traffic.vehicle)
    SetNumberOfParkedVehicles(config.traffic.parked)

    if config.pedBlacklist and #config.pedBlacklist > 0 then
        for i = 1, #config.pedBlacklist do
            local ped = config.pedBlacklist[i]
            ped = type(ped) == 'number' and ped or joaat(ped)
            SetPedModelIsSuppressed(ped, true)
        end
    end

    if config.vehicleBlacklist and #config.vehicleBlacklist > 0 then
        for i = 1, #config.vehicleBlacklist do
            local veh = config.vehicleBlacklist[i]
            veh = type(veh) == 'number' and veh or joaat(veh)
            SetVehicleModelIsSuppressed(veh, true)
        end
    end
end)