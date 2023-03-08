
--- Clear
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

--- GetMugshot
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

--- IsDriver
---@param pedId number
---@return boolean
local function IsDriver(pedId)
    if not DoesEntityExist(pedId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    return IsPedInAnyVehicle(pedId, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(pedId, false), -1) == pedId
end

--- LeaveVehicle
---@param pedId number
---@param instant boolean
local function LeaveVehicle(pedId, instant)
    if not DoesEntityExist(pedId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    TaskLeaveAnyVehicle(pedId, 0, instant and 16 or 0)
end

--- EnterVehicle
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

--- WalkToPosition
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

--- CreateNpc
---@param model string|number
---@param coords vector3|number
---@param heading number
---@param properties table
---@param cb function
---@param netWork boolean
---@return any
local function CreateNpc(model, coords, heading, properties, cb, netWork)
    assert(type(model) == "string" or type(model) == "number")
    netWork = netWork == nil and true or false
    local npc
    sl.request.model(model)
    if netWork then
        sl.callback.trigger("sl:createNpc", function(netnpc)
            while not NetworkDoesNetworkIdExist(netnpc) do Wait(100) end
            npc = NetToPed(netnpc)
            goto continue
        end, model, coords, heading)
    else
        npc = CreatePed(1, model, coords.x, coords.y, coords.z, heading, false, true)
        while not DoesEntityExist(npc) do Wait(50) end
        goto continue
    end

    ::continue::
    SetModelAsNoLongerNeeded(model)
    if cb then cb(npc) end
    return npc
end

return {
    clear = Clear,
    get_mugshot = GetMugshot,
    is_driver = IsDriver,
    leave_vehicle = LeaveVehicle,
    enter_vehicle = EnterVehicle,
    walk_to_position = WalkToPosition,
    create_npc = CreateNpc,
}