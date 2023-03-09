
--- sl.entity.getVehicles
---@return any
local function GetVehicles()
    return GetGamePool('CVehicle')
end

--- sl.entity.getObjects
---@return any
local function GetObjects()
    return GetGamePool('CObject')
end

--- sl.entity.getAllPedsAndPlayers
---@return any
local function GetAllPedsAndPlayers()
    return GetGamePool('CPed')
end

--- sl.entity.getPickups
---@return any
local function GetPickups()
    return GetGamePool('CPickup')
end

--- sl.entity.getPeds
---@param filter table
---@return table
local function GetPeds(filter)
    local peds, player, pool, filtered = {}, PlayerPedId(), GetAllPedsAndPlayers(), nil
    if filter then
        filtered = {}
        for i = 1, #pool do
            if filter[GetPedType(pool[i])] then
                peds[#peds+1] = pool[i]
            end
        end
        return peds
    end
    for i = 1, #pool do
        if pool[i] ~= player then
            peds[#peds+1] = pool[i]
        end
    end
    return peds
end

--- sl.entity.getPlayers
---@return table
local function GetPlayers()
    local players, player = {}, PlayerId()
    for k,v in pairs(GetActivePlayers()) do
        local playersPed = GetPlayerPed(v)
        if DoesEntityExist(playersPed) and player ~= v then
            players[v] = playersPed
        end
    end
    return players
end

--- sl.entity.getClosestEntity
---@param entities table
---@param playerEntities boolean
---@param coords vec3|table|nil
---@param filter table
---@return number,integer
local function GetClosest(entities, playerEntities, coords, filter)
    local closestEntity, closestEntityDistance, filtered, distance = -1, -1, nil
    if coords then
        coords = vec3(coords.x, coords.y, coords.z)
    else
        coords = GetEntityCoords(PlayerPedId())
    end
    if filter then
        filtered = {}
        for _,v in pairs(entities)do
            if filter[GetEntityModel(v)] then
                filtered[#filtered+1] = v
            end
        end
    end
    for k,v in pairs(filtered or entities) do
        distance = #(coords - GetEntityCoords(v))
        if (closestEntityDistance == -1) or distance < closestEntityDistance then
            closestEntity, closestEntityDistance = playerEntities and k or v, distance
        end
    end
    return closestEntity, closestEntityDistance
end

--- sl.entity.getClosestPed
---@param coords vec3|table|nil
---@param filter1 table|nil
---@param filter2 table|nil
---@return number,integer
local function GetClosestPed(coords, filter1, filter2)
    return GetClosest(GetPeds(filter1 or nil), false, coords, filter2)
end

--- sl.entity.getClosestVehicle
---@param coords vec3|table|nil
---@param filter table|nil
---@return number,integer
local function GetClosestVehicle(coords, filter)
    return GetClosest(GetVehicles(), false, coords, filter)
end

--- sl.entity.getClosestPlayer
---@param coords vec3|table|nil
---@return number, integer
local function GetClosestPlayer(coords)
    return GetClosest(GetPlayers(), true, coords)
end

--- sl.entity.getClosestObject
---@param coords vec3|table|nil
---@param filter table|nil
---@return number
local function GetClosestObject(coords, filter)
    return GetClosest(GetVehicles(), false, coords, filter)
end

--- EnumEntitiesInDistance
---@param entities table
---@param playerEntities any
---@param coords  vec3|table|nil
---@param maxDistance number
---@return table
local function EnumEntitiesInDistance(entities, playerEntities, coords, maxDistance)
    local nearby, distance = {}
    if coords then
        coords = vec3(coords.x, coords.y, coords.z)
    else
        coords = GetEntityCoords(PlayerPedId())
    end
    for k,v in pairs(entities) do
        distance = #(coords - GetEntityCoords(v))
        if distance <= maxDistance then
            nearby[#nearby+1] = playerEntities and k or v
        end
    end
    return nearby
end

--- sl.entity.getVehiclesInArena
---@param coords vec3|table|nil
---@param maxDistance integer|number
---@return table
local function GetVehiclesInArea(coords, maxDistance)
    return EnumEntitiesInDistance(GetVehicles(), false, coords, maxDistance)
end

--- entity.getPlayersInArena
---@param coords vec3|table|nil
---@param maxDistance integer|number
---@return table
local function GetPlayersInArea(coords, maxDistance)
    return EnumEntitiesInDistance(GetPlayers(), true, coords, maxDistance)
end

--- sl.entity.getPedsInArena
---@param coords vec3|table|nil
---@param maxDistance integer|number
---@param filter table|nil
---@return table
local function GetPedsInArea(coords, maxDistance, filter)
    return EnumEntitiesInDistance(GetPeds(filter or nil), false, coords, maxDistance)
end

--- sl.entity.isZoneClear
---@param coords vec3|table|nil
---@param maxDistance integer|number
---@param filter table|nil
---@param filterPeds table|nil
---@return length
local function IsZoneClear(coords, maxDistance, filter, filterPeds)
    if filter == 'vehicles' or not filter then
        return #GetVehiclesInArea(coords, maxDistance)
    elseif filter == 'peds' then
        return #GetPedsInArea(coords, maxDistance, filterPeds)
    elseif filter == 'players' then
        return #GetPlayersInArea(coords, maxDistance)
    end
end

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
---@param vectorType number
---@return number vector3|number
local function GetPosition(entityId, vectorType)
    if not DoesEntityExist(entityId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Entity didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end
    
    local coords <const> = GetEntityCoords(entityId)
    return vectorType == 3 and coords or vector4(coords.x, coords.y, coords.z, GetEntityHeading(entityId))
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
    if not DoesEntityExist(entityId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Entity didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    local entityCoords <const> = GetPosition(entityId, 3)
    targetCoords = DoesEntityExist(targetCoords) and GetPosition(targetCoords, 3) or targetCoords

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

    local entityCoords <const> = GetPosition(entityId)
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    while not HasCollisionLoadedAroundEntity(entityId) do
        Wait(0)
    end
    if keepVehicle then
        local vehicle <const> = GetVehiclePedIsIn(entityId, false)
        if DoesEntityExist(vehicle) and vehicle ~= 0 then
            SetPedCoordsKeepVehicle(entityId, coords.x, coords.y, coords.z)
            SetEntityHeading(vehicle, heading or entityCoords.w)
            goto continue
        end
    end
    SetEntityCoords(entityId, coords.x, coords.y, coords.z)
    SetEntityHeading(entityId, heading or entityCoords.w)
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
    get_vehicles = GetVehicles,
    get_objects = GetObjects,
    get_peds_and_players = GetAllPedsAndPlayers,
    get_pickups = GetPickups,
    get_peds = GetPeds,
    get_players = GetPlayers,
    get_closest = GetClosest,
    get_closest_ped = GetClosestPed,
    get_closest_vehicle = GetClosestVehicle,
    get_closest_player = GetClosestPlayer,
    get_closest_object = GetClosestObject,
    enum_entities_in_distance = EnumEntitiesInDistance,
    get_vehicles_in_area = GetVehiclesInArea,
    get_players_in_area = GetPlayersInArea,
    get_peds_in_area = GetPedsInArea,
    is_area_clear = IsZoneClear,
    get_type = GetType,
    get_position = GetPosition,
    delete = Delete,
    get_distance = GetDistance,
    set_position = SetPosition,
    set_freeze = SetFreeze,
}