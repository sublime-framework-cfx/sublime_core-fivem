
--- GetType
---@param entityId number
---@return string|number
local function GetType(entityId)
    if not DoesEntityExist(entityId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Entity didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    local entityType <const> = GetEntityType(entityId)
    local type <const> = {
        [1] = "Ped",
        [2] = "Vehicle",
        [3] = "Object",
    }
    return type[entityType], entityType
end

--- GetPosition
---@param entityId number
---@return number vector3|number
local function GetPosition(entityId)
    if not DoesEntityExist(entityId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Entity didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    return GetEntityCoords(entityId), GetEntityHeading(entityId)
end

--- Delete
---@param entityId any
local function Delete(entityId)
    if not DoesEntityExist(entityId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Entity didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    SetEntityAsMissionEntity(entityId, 0, 1)
    DeleteEntity(entityId)
end

--- GetDistance
---@param entityId number
---@param coords vector3|number
---@return number
local function GetDistance(entityId, targetCoords)
    local entityCoords <const> = GetPosition(entityId)
    targetCoords = DoesEntityExist(targetCoords) and GetPosition(targetCoords) or targetCoords

    return #(entityCoords - targetCoords)
end

--- SetPosition
---@param entityId number
---@param coords vector3|table
---@param heading number
---@param keepVehicle boolean
---@param cb function
local function SetPosition(entityId, coords, heading, keepVehicle, cb)
    if not DoesEntityExist(entityId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Entity didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    local entityCoords, entityHeading <const> = GetPosition(entityId)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    while not HasCollisionLoadedAroundEntity(entityId) do
        Wait(0)
    end
    if keepVehicle then
        local vehicle <const> = GetVehiclePedIsIn(entityId, false)
        if DoesEntityExist(vehicle) and vehicle ~= 0 then
            SetPedCoordsKeepVehicle(entityId, coords.x, coords.y, coords.z)
            SetEntityHeading(vehicle, heading or entityHeading)
            goto continue
        end
    end
    SetEntityCoords(entityId, coords.x, coords.y, coords.z)
    SetEntityHeading(entityId, heading or entityHeading)
    :: continue ::
    if cb then cb() end
end

--- SetFreeze
---@param entityId number
---@param freeze boolean
local function SetFreeze(entityId, state)
    if not DoesEntityExist(entityId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Entity didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    FreezeEntityPosition(entityId, state)
end

return {
    get_type = GetType,
    get_position = GetPosition,
    delete = Delete,
    get_distance = GetDistance,
    set_position = SetPosition,
    set_freeze = SetFreeze,
}