
--- GetType
---@param source number
---@param model number
---@param cb function
local function GetType(source, model, cb)
    local type = sl.callback.trigger_await("sl:returnVehicleType", source, model)
    if cb then cb(type) end
    return type
end

--- CreateSyncVehicle
---@param source number
---@param model number
---@param coords vec3
---@param cb function
local function CreateSyncVehicle(source, model, coords, cb)
    model = type(model) == 'string' and joaat(model) or model
    CreateThread(function()
        GetType(source, model, function(Type)
            if Type then
                local vehicle <const> = CreateVehicleServerSetter(model, Type, coords.x, coords.y, coords.z, coords.w)
                while not DoesEntityExist(vehicle) do Wait(100) end
                local netWorkVehicle <const> = NetworkGetNetworkIdFromEntity(vehicle)
                if cb then
                    cb(vehicle, netWorkVehicle)
                end
            else
                sl.log.print(3, "Tried to spawn invalid vehicle - ^5%s^7", model)
            end
        end)
    end)
end

--- sl:createVehicle [[CALLBACK]]
---@param source number
---@param model string|number
---@param coords vector3|table
---@param heading number
---@return number
sl.callback.register("sl:createVehicle", function(source, model, coords)
    local spawned_vehicle
    CreateSyncVehicle(source, model, coords, function(vehicle)
        spawned_vehicle = vehicle
    end)
    while not DoesEntityExist(spawned_vehicle) do 
        Wait(100)
    end
    return NetworkGetNetworkIdFromEntity(spawned_vehicle)
end)

return {
    get_type = GetType,
    createvehicle_sync = CreateSyncVehicle,
}