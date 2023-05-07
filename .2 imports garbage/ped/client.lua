
--- sl.ped.clear : clear ped
---@param pedId number
local function Clear(pedId)
    if not DoesEntityExist(pedId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    ClearPedProp(pedId,0)
    ClearPedBloodDamage(pedId)
    ClearPedTasksImmediately(pedId)
end

--- sl.ped.get_mugshot : get ped selfie
---@param pedId number
---@param transparentBackground boolean
---@return any|string
local function GetMugshot(pedId, transparentBackground)
    if not DoesEntityExist(pedId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    local headshot = transparentBackground and RegisterPedheadshotTransparent(pedId) or RegisterPedheadshot(pedId)
    while not IsPedheadshotReady(headshot) and not IsPedHeadshotValid(headshot) do Wait(0) end
    return headshot, GetPedheadshotTxdString(headshot)
end

--- sl.ped.is_driver : is ped a driver actually
---@param pedId number
---@return boolean
local function IsDriver(pedId)
    if not DoesEntityExist(pedId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    return IsPedInAnyVehicle(pedId, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(pedId, false), -1) == pedId
end

--- sl.ped.leave_vehicle : ped leave the vehicle
---@param pedId number
---@param instant boolean
local function LeaveVehicle(pedId, instant)
    if not DoesEntityExist(pedId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    TaskLeaveAnyVehicle(pedId, 0, instant and 16 or 0)
end

--- sl.ped.enter_vehicle : ped enter in vehicle
---@param pedId number
---@param vehicleId number
---@param seat number
local function EnterVehicle(pedId, vehicleId, seat)
    if not DoesEntityExist(pedId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end
    if not DoesEntityExist(vehicleId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    TaskWarpPedIntoVehicle(pedId, vehicleId, seat or -1)
end

--- sl.ped.walk_to_position : ped walk to position
---@param pedId number
---@param coords vector3|table
---@param speed number
---@param duration number
---@param heading number
---@param distanceToSlide number
local function WalkToPosition(pedId, coords, speed, duration, heading, distanceToSlide)
    if not DoesEntityExist(pedId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    TaskGoStraightToCoord(pedId, coords, speed, duration, heading, distanceToSlide)
end

--- sl.ped.permanently_follow_entity : ped follow a entity
---@param pedId number
---@param entityId number
---@param speed number
local function PermanentlyFollowEntity(pedId, entityId, speed)
    if not DoesEntityExist(pedId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end
    if not DoesEntityExist(entityId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Entity didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    TaskGoToEntity(pedId, entityId, -1, 0.00001, speed or 2, 1073741824.0, 0)
    SetPedKeepTask(pedId, true)
end

return {
    clear = Clear,
    get_mugshot = GetMugshot,
    is_driver = IsDriver,
    leave_vehicle = LeaveVehicle,
    enter_vehicle = EnterVehicle,
    walk_to_position = WalkToPosition,
    permanently_follow_entity = PermanentlyFollowEntity,
}