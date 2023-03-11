
--- sl.vehicle.delete : delete the vehicle
---@param vehicleId number
local function Delete(self)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    SetEntityAsMissionEntity(self.vehicle, 0, 1)
    DeleteVehicle(self.vehicle)
    return nil, collectgarbage()
end

--- sl.vehicle.clean : clean the vehicle
---@param vehicleId number
local function Clean(self)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    SetVehicleDirtLevel(self.vehicle, 0.0)
    WashDecalsFromVehicle(self.vehicle, 1.0)
end

--- sl.vehicle.get_fuel_level : get fuel level of vehicle
---@param vehicleId number
---@return number
local function GetFuelLevel(self)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    return GetVehicleFuelLevel(self.vehicle)
end

--- sl.vehicle.get_fuel_tank : get fuel tank of vehicle
---@param vehicleId number
---@return number
local function GetFuelTank(self)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    ---@type number
    local fuel <const> = GetVehicleHandlingFloat(self.vehicle, "CHandlingData", "fPetrolTankVolume")
    return fuel
end

--- sl.vehicle.model_name : get vehicle name
---@param vehicleId number
---@return string
local function ModelName(self)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    ---@type string
    local model <const> = GetDisplayNameFromVehicleModel(GetEntityModel(self.vehicle))
    return model
end

--- sl.vehicle.get_plate : get vehicle plate
---@param vehicleId number
---@return string|number
local function GetPlate(self)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    local plate <const> = GetVehicleNumberPlateText(self.vehicle)
    return plate
end

--- sl.vehicle.get_states : get vehicle state 
---@param vehicleId number
---@return table
local function GetStates(self)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

--TODO IMPROVE THIS FUNCTION

    local vehicleState <const> = {
        engineHealth = GetVehicleEngineHealth(self.vehicle),
        vehicleBodyHealth = GetVehicleBodyHealth(self.vehicle),
        dirtLevel = GetVehicleDirtLevel(self.vehicle),
        engineState = (GetIsVehicleEngineRunning(self.vehicle) == 1)
    }
    return vehicleState
end

--- sl.vehicle.open_door : open vehicle door
---@param vehicleId number
local function OpenDoor(self, doorId, canBeClosed, instantly)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    if doorId == "all" then
        for i = 0, 5 do
            SetVehicleDoorOpen(self.vehicle, i, canBeClosed or false, instantly or false)
        end
    else
        SetVehicleDoorOpen(self.vehicle, doorId, canBeClosed or false, instantly or false)
    end
end

--- sl.vehicle.lock : lock or unlock vehicle door
---@param vehicleId number
---@param state boolean
local function Lock(self, state)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    SetVehicleDoorsLocked(self.vehicle, state and 2 or 1)
end

--- sl.vehicle.repair : repair vehicle
---@param vehicleId number
local function Repair(self)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    SetVehicleFixed(self.vehicle)
    SetVehicleDirtLevel(self.vehicle, 0.0)
    SetVehicleDeformationFixed(self.vehicle)
end

--- sl.vehicle.set_fuel : set vehicle fuel
---@param vehicleId number
---@param fuel number
local function SetFuel(self, fuel)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    return SetVehicleFuelLevel(self.vehicle, fuel)
end

--- sl.vehicle.get_type : get vehicle type
---@param model string
---@return string
local function GetType(model)
	local VehicleType = GetVehicleClassFromName(model)
	local type = "automobile"
	if VehicleType == 15 then
		type = "heli"
	elseif VehicleType == 16 then
		type = "plane"
	elseif VehicleType == 14 then
		type = "boat"
	elseif VehicleType == 11 then
		type = "trailer"
	elseif VehicleType == 21 then
		type = "train"
	elseif VehicleType == 13 or VehicleType == 8 then
		type = "bike"
	end
	if model == `submersible` or model == `submersible2` then
		type = "submarine"
	end
    return type
end

--- sl.vehicle.is_empty : is vehicle empty
---@param vehicleId number
---@return boolean
local function IsEmpty(self)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end
    
    local passengers = GetVehicleNumberOfPassengers(self.vehicle)
    local driverSeatFree = IsVehicleSeatFree(self.vehicle, -1)
    return passengers == 0 and driverSeatFree
end


--- sl.vehicle.get_vehicle_properties
---@param vehicle number
---@return table VehicleProperties?
local function GetVehicleProperties(self)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    local colorPrimary, colorSecondary = GetVehicleColours(self.vehicle)
	local pearlescentColor, wheelColor = GetVehicleExtraColours(self.vehicle)
	if GetIsVehiclePrimaryColourCustom(self.vehicle) then
		colorPrimary = {GetVehicleCustomPrimaryColour(self.vehicle)}
	end
	if GetIsVehicleSecondaryColourCustom(self.vehicle) then
		colorSecondary = {GetVehicleCustomSecondaryColour(self.vehicle)}
	end
	local extras = {}
	for i = 1, 15 do
		if DoesExtraExist(self.vehicle, i) then
			extras[i] = IsVehicleExtraTurnedOn(self.vehicle, i) and 0 or 1
		end
	end
    local modLivery = GetVehicleMod(self.vehicle, 48)
	if modLivery == -1 then
		local modLivery2 = GetVehicleLivery(self.vehicle)
		if modLivery2 ~= 0 then
			modLivery = modLivery2
		end
	end
	local damage = {
		windows = {},
		doors = {},
		tyres = {},
	}
	local windows = 0
	for i = 0, 7 do
		if not IsVehicleWindowIntact(self.vehicle, i) then
			windows += 1
			damage.windows[windows] = i
		end
	end
	local doors = 0
	for i = 0, 5 do
		if IsVehicleDoorDamaged(self.vehicle, i) then
			doors += 1
			damage.doors[doors] = i
		end
	end
	for i = 0, 5 do
		if IsVehicleTyreBurst(self.vehicle, i, false) then
			damage.tyres[i] = IsVehicleTyreBurst(self.vehicle, i, true) and 2 or 1
		end
	end
	local neons = {}
	for i = 0, 3 do
        neons[i + 1] = IsVehicleNeonLightEnabled(self.vehicle, i)
	end
	return {
		model = GetEntityModel(self.vehicle),
		plate = GetVehicleNumberPlateText(self.vehicle),
		plateIndex = GetVehicleNumberPlateTextIndex(self.vehicle),
		bodyHealth = math.floor(GetVehicleBodyHealth(self.vehicle) + 0.5),
		engineHealth = math.floor(GetVehicleEngineHealth(self.vehicle) + 0.5),
		tankHealth = math.floor(GetVehiclePetrolTankHealth(self.vehicle) + 0.5),
		fuelLevel = math.floor(GetVehicleFuelLevel(self.vehicle) + 0.5),
		dirtLevel = math.floor(GetVehicleDirtLevel(self.vehicle) + 0.5),
		color1 = colorPrimary,
		color2 = colorSecondary,
		pearlescentColor = pearlescentColor,
		interiorColor = GetVehicleInteriorColor(self.vehicle),
		dashboardColor = GetVehicleDashboardColour(self.vehicle),
		wheelColor = wheelColor,
        wheelWidth = GetVehicleWheelWidth(self.vehicle),
        wheelSize = GetVehicleWheelSize(self.vehicle),
		wheels = GetVehicleWheelType(self.vehicle),
		windowTint = GetVehicleWindowTint(self.vehicle),
		xenonColor = GetVehicleXenonLightsColor(self.vehicle),
		neonEnabled = neons,
		neonColor = {GetVehicleNeonLightsColour(self.vehicle)},
		extras = extras,
		tyreSmokeColor = {GetVehicleTyreSmokeColor(self.vehicle)},
		modSpoilers = GetVehicleMod(self.vehicle, 0),
		modFrontBumper = GetVehicleMod(self.vehicle, 1),
		modRearBumper = GetVehicleMod(self.vehicle, 2),
		modSideSkirt = GetVehicleMod(self.vehicle, 3),
		modExhaust = GetVehicleMod(self.vehicle, 4),
		modFrame = GetVehicleMod(self.vehicle, 5),
		modGrille = GetVehicleMod(self.vehicle, 6),
		modHood = GetVehicleMod(self.vehicle, 7),
		modFender = GetVehicleMod(self.vehicle, 8),
		modRightFender = GetVehicleMod(self.vehicle, 9),
		modRoof = GetVehicleMod(self.vehicle, 10),
		modEngine = GetVehicleMod(self.vehicle, 11),
		modBrakes = GetVehicleMod(self.vehicle, 12),
		modTransmission = GetVehicleMod(self.vehicle, 13),
		modHorns = GetVehicleMod(self.vehicle, 14),
		modSuspension = GetVehicleMod(self.vehicle, 15),
		modArmor = GetVehicleMod(self.vehicle, 16),
		modNitrous = GetVehicleMod(self.vehicle, 17),
		modTurbo = IsToggleModOn(self.vehicle, 18),
		modSubwoofer = GetVehicleMod(self.vehicle, 19),
		modSmokeEnabled = IsToggleModOn(self.vehicle, 20),
		modHydraulics = IsToggleModOn(self.vehicle, 21),
		modXenon = IsToggleModOn(self.vehicle, 22),
		modFrontWheels = GetVehicleMod(self.vehicle, 23),
		modBackWheels = GetVehicleMod(self.vehicle, 24),
		modCustomTiresF = GetVehicleModVariation(self.vehicle, 23),
		modCustomTiresR = GetVehicleModVariation(self.vehicle, 24),
		modPlateHolder = GetVehicleMod(self.vehicle, 25),
		modVanityPlate = GetVehicleMod(self.vehicle, 26),
		modTrimA = GetVehicleMod(self.vehicle, 27),
		modOrnaments = GetVehicleMod(self.vehicle, 28),
		modDashboard = GetVehicleMod(self.vehicle, 29),
		modDial = GetVehicleMod(self.vehicle, 30),
		modDoorSpeaker = GetVehicleMod(self.vehicle, 31),
		modSeats = GetVehicleMod(self.vehicle, 32),
		modSteeringWheel = GetVehicleMod(self.vehicle, 33),
		modShifterLeavers = GetVehicleMod(self.vehicle, 34),
		modAPlate = GetVehicleMod(self.vehicle, 35),
		modSpeakers = GetVehicleMod(self.vehicle, 36),
		modTrunk = GetVehicleMod(self.vehicle, 37),
		modHydrolic = GetVehicleMod(self.vehicle, 38),
		modEngineBlock = GetVehicleMod(self.vehicle, 39),
		modAirFilter = GetVehicleMod(self.vehicle, 40),
		modStruts = GetVehicleMod(self.vehicle, 41),
		modArchCover = GetVehicleMod(self.vehicle, 42),
		modAerials = GetVehicleMod(self.vehicle, 43),
		modTrimB = GetVehicleMod(self.vehicle, 44),
		modTank = GetVehicleMod(self.vehicle, 45),
		modWindows = GetVehicleMod(self.vehicle, 46),
		modDoorR = GetVehicleMod(self.vehicle, 47),
		modLivery = modLivery,
        modRoofLivery = GetVehicleRoofLivery(self.vehicle),
		modLightbar = GetVehicleMod(self.vehicle, 49),
		windows = damage.windows,
		doors = damage.doors,
		tyres = damage.tyres,
		leftHeadlight = damage.leftHeadlight,
		rightHeadlight = damage.rightHeadlight,
		frontBumper = damage.frontBumper,
		rearBumper = damage.rearBumper,
	}
end

--- sl.vehicle.set_vehicle_properties
---@param vehicle number
---@param props table
---@return boolean
local function SetVehicleProperties(self, props)
    if not DoesEntityExist(self.vehicle) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Vehicle didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end
    if not props then return end
    
    local colorPrimary, colorSecondary = GetVehicleColours(self.vehicle)
    local pearlescentColor, wheelColor = GetVehicleExtraColours(self.vehicle)
    SetVehicleModKit(self.vehicle, 0)
    SetVehicleAutoRepairDisabled(self.vehicle, true)
    if props.plate then
        SetVehicleNumberPlateText(self.vehicle, props.plate)
    end
    if props.plateIndex then
        SetVehicleNumberPlateTextIndex(self.vehicle, props.plateIndex)
    end
    if props.bodyHealth then
        SetVehicleBodyHealth(self.vehicle, props.bodyHealth + 0.0)
    end
    if props.engineHealth then
        SetVehicleEngineHealth(self.vehicle, props.engineHealth + 0.0)
    end
    if props.tankHealth  then
        SetVehiclePetrolTankHealth(self.vehicle, props.tankHealth + 0.0)
    end
    if props.fuelLevel then
        SetVehicleFuelLevel(self.vehicle, props.fuelLevel + 0.0)
    end
    if props.oilLevel then
        SetVehicleOilLevel(self.vehicle, props.oilLevel + 0.0)
    end
    if props.dirtLevel then
        SetVehicleDirtLevel(self.vehicle, props.dirtLevel + 0.0)
    end
    if props.color1 then
        if type(props.color1) == 'number' then
            SetVehicleColours(self.vehicle, props.color1, colorSecondary)
        else
            SetVehicleCustomPrimaryColour(self.vehicle, props.color1[1], props.color1[2], props.color1[3])
        end
    end
    if props.color2 then
        if type(props.color2) == 'number' then
            SetVehicleColours(self.vehicle, props.color1 or colorPrimary, props.color2)
        else
            SetVehicleCustomSecondaryColour(self.vehicle, props.color2[1], props.color2[2], props.color2[3])
        end
    end
    if props.pearlescentColor or props.wheelColor then
        SetVehicleExtraColours(self.vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor or wheelColor)
    end
    if props.interiorColor then
        SetVehicleInteriorColor(self.vehicle, props.interiorColor)
    end
    if props.dashboardColor then
        SetVehicleDashboardColor(self.vehicle, props.dashboardColor)
    end
    if props.wheels then
        SetVehicleWheelType(self.vehicle, props.wheels)
    end
    if props.wheelSize then
        SetVehicleWheelSize(self.vehicle, props.wheelSize)
    end
    if props.wheelWidth then
        SetVehicleWheelWidth(self.vehicle, props.wheelWidth)
    end
    if props.windowTint then
        SetVehicleWindowTint(self.vehicle, props.windowTint)
    end
    if props.neonEnabled then
        for i = 1, #props.neonEnabled do
            SetVehicleNeonLightEnabled(self.vehicle, i - 1, props.neonEnabled[i])
        end
    end
    if props.extras then
        for id, state in pairs(props.extras) do
            SetVehicleExtra(self.vehicle, id, state)
        end
    end
    if props.windows then
        for i = 1, #props.windows do
            SmashVehicleWindow(self.vehicle, props.windows[i])
        end
    end
    if props.doors then
        for i = 1, #props.doors do
            SetVehicleDoorBroken(self.vehicle, props.doors[i], true)
        end
    end
    if props.tyres then
        for tyre, state in pairs(props.tyres) do
            if state == 1 then
                SetVehicleTyreBurst(self.vehicle, tyre, false, 1000.0)
            else
                SetVehicleTyreBurst(self.vehicle, tyre, true)
            end
        end
    end
    if props.neonColor then
        SetVehicleNeonLightsColour(self.vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3])
    end
    if props.modSmokeEnabled then
        ToggleVehicleMod(self.vehicle, 20, true)
    end
    if props.tyreSmokeColor then
        SetVehicleTyreSmokeColor(self.vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3])
    end
    if props.modSpoilers then
        SetVehicleMod(self.vehicle, 0, props.modSpoilers, false)
    end
    if props.modFrontBumper then
        SetVehicleMod(self.vehicle, 1, props.modFrontBumper, false)
    end
    if props.modRearBumper then
        SetVehicleMod(self.vehicle, 2, props.modRearBumper, false)
    end
    if props.modSideSkirt then
        SetVehicleMod(self.vehicle, 3, props.modSideSkirt, false)
    end
    if props.modExhaust then
        SetVehicleMod(self.vehicle, 4, props.modExhaust, false)
    end
    if props.modFrame then
        SetVehicleMod(self.vehicle, 5, props.modFrame, false)
    end
    if props.modGrille then
        SetVehicleMod(self.vehicle, 6, props.modGrille, false)
    end
    if props.modHood then
        SetVehicleMod(self.vehicle, 7, props.modHood, false)
    end
    if props.modFender then
        SetVehicleMod(self.vehicle, 8, props.modFender, false)
    end
    if props.modRightFender then
        SetVehicleMod(self.vehicle, 9, props.modRightFender, false)
    end
    if props.modRoof then
        SetVehicleMod(self.vehicle, 10, props.modRoof, false)
    end
    if props.modEngine then
        SetVehicleMod(self.vehicle, 11, props.modEngine, false)
    end
    if props.modBrakes then
        SetVehicleMod(self.vehicle, 12, props.modBrakes, false)
    end
    if props.modTransmission then
        SetVehicleMod(self.vehicle, 13, props.modTransmission, false)
    end
    if props.modHorns then
        SetVehicleMod(self.vehicle, 14, props.modHorns, false)
    end
    if props.modSuspension then
        SetVehicleMod(self.vehicle, 15, props.modSuspension, false)
    end
    if props.modArmor then
        SetVehicleMod(self.vehicle, 16, props.modArmor, false)
    end
    if props.modNitrous then
        SetVehicleMod(self.vehicle, 17, props.modNitrous, false)
    end
    if props.modTurbo then
        ToggleVehicleMod(self.vehicle, 18, props.modTurbo)
    end
    if props.modSubwoofer then
        ToggleVehicleMod(self.vehicle, 19, props.modSubwoofer)
    end
    if props.modHydraulics then
        ToggleVehicleMod(self.vehicle, 21, props.modHydraulics)
    end
    if props.modXenon then
        ToggleVehicleMod(self.vehicle, 22, props.modXenon)
    end
    if props.xenonColor then
        SetVehicleXenonLightsColor(self.vehicle, props.xenonColor)
    end
    if props.modFrontWheels then
        SetVehicleMod(self.vehicle, 23, props.modFrontWheels, props.modCustomTiresF)
    end
    if props.modBackWheels then
        SetVehicleMod(self.vehicle, 24, props.modBackWheels, props.modCustomTiresR)
    end
    if props.modPlateHolder then
        SetVehicleMod(self.vehicle, 25, props.modPlateHolder, false)
    end
    if props.modVanityPlate then
        SetVehicleMod(self.vehicle, 26, props.modVanityPlate, false)
    end
    if props.modTrimA then
        SetVehicleMod(self.vehicle, 27, props.modTrimA, false)
    end
    if props.modOrnaments then
        SetVehicleMod(self.vehicle, 28, props.modOrnaments, false)
    end
    if props.modDashboard then
        SetVehicleMod(self.vehicle, 29, props.modDashboard, false)
    end
    if props.modDial then
        SetVehicleMod(self.vehicle, 30, props.modDial, false)
    end
    if props.modDoorSpeaker then
        SetVehicleMod(self.vehicle, 31, props.modDoorSpeaker, false)
    end
    if props.modSeats then
        SetVehicleMod(self.vehicle, 32, props.modSeats, false)
    end
    if props.modSteeringWheel then
        SetVehicleMod(self.vehicle, 33, props.modSteeringWheel, false)
    end
    if props.modShifterLeavers then
        SetVehicleMod(self.vehicle, 34, props.modShifterLeavers, false)
    end
    if props.modAPlate then
        SetVehicleMod(self.vehicle, 35, props.modAPlate, false)
    end
    if props.modSpeakers then
        SetVehicleMod(self.vehicle, 36, props.modSpeakers, false)
    end
    if props.modTrunk then
        SetVehicleMod(self.vehicle, 37, props.modTrunk, false)
    end
    if props.modHydrolic then
        SetVehicleMod(self.vehicle, 38, props.modHydrolic, false)
    end
    if props.modEngineBlock then
        SetVehicleMod(self.vehicle, 39, props.modEngineBlock, false)
    end
    if props.modAirFilter then
        SetVehicleMod(self.vehicle, 40, props.modAirFilter, false)
    end
    if props.modStruts then
        SetVehicleMod(self.vehicle, 41, props.modStruts, false)
    end
    if props.modArchCover then
        SetVehicleMod(self.vehicle, 42, props.modArchCover, false)
    end
    if props.modAerials then
        SetVehicleMod(self.vehicle, 43, props.modAerials, false)
    end
    if props.modTrimB then
        SetVehicleMod(self.vehicle, 44, props.modTrimB, false)
    end
    if props.modTank then
        SetVehicleMod(self.vehicle, 45, props.modTank, false)
    end
    if props.modWindows then
        SetVehicleMod(self.vehicle, 46, props.modWindows, false)
    end
    if props.modDoorR then
        SetVehicleMod(self.vehicle, 47, props.modDoorR, false)
    end
    if props.modLivery then
        SetVehicleMod(self.vehicle, 48, props.modLivery, false)
        SetVehicleLivery(self.vehicle, props.modLivery)
    end
    if props.modLightbar then
        SetVehicleMod(self.vehicle, 49, props.modLightbar, false)
    end
    return true
end

--- sl:setVehicleProperties
---@param netid number
---@param data table
RegisterNetEvent('sl:setVehicleProperties', function(netid, data)
    local timeout = 100
    while not NetworkDoesEntityExistWithNetworkId(netid) and timeout > 0 do
        Wait(0)
        timeout -= 1
    end
    if timeout > 0 then
        SetVehicleProperties(NetToVeh(netid), data)
    end
end)

--- sl.vehicle.create
---@param model number
---@param coords vec3|table
---@param args table
---@param cb function
---@param netWork boolean
local function Create(model, coords, args, cb)
    local self = {}
    self.model = model
    self.coords = coords
    self.args = args
    self.netWork = args == nil or args.netWork == nil and true or false
    sl.request.model(self.model)

    if self.netWork then
        sl.callback.trigger("sl:createVehicle", function(netvehicle)
            while not NetworkDoesNetworkIdExist(netvehicle) do Wait(100) end
            local vehicle <const> = NetToVeh(netvehicle)
            self.vehicle = vehicle
        end, self.model, self.coords)
    else
        CreateThread(function()
            local vehicle <const> = CreateVehicle(self.model, self.coords.xyzw, self.netWork, false)
            while not DoesEntityExist(vehicle) do Wait(50) end
            self.vehicle = vehicle
        end)
    end
    while not DoesEntityExist(self.vehicle) do Wait(50) end

    SetEntityAsMissionEntity(self.vehicle, true, true)
    SetEntityCoordsNoOffset(self.vehicle, self.coords.x, self.coords.y, self.coords.z + 0.5, 0.0, 0.0, 0.0)
    SetVehicleOnGroundProperly(self.vehicle)
    SetVehicleHasBeenOwnedByPlayer(self.vehicle, true)
    SetVehRadioStation(self.vehicle, 'OFF')

    self.clean = Clean
    self.delete = Delete
    self.get_fuel_level = GetFuelLevel
    self.get_fuel_tank = GetFuelTank
    self.model_name = ModelName
    self.get_plate = GetPlate
    self.get_states = GetStates
    self.open_door = OpenDoor
    self.lock = Lock
    self.repair = Repair
    self.set_fuel = SetFuel
    self.get_type = GetType
    self.is_empty = IsEmpty
    self.get_vehicle_properties = GetVehicleProperties
    self.set_vehicle_properties = SetVehicleProperties

    self:set_vehicle_properties(self.args)

    if cb then
        cb(self)
    end
    SetModelAsNoLongerNeeded(model)
    return self
end

--- sl:returnVehicleType [[CALLBACK]]
---@param model any
sl.callback.register("sl:returnVehicleType", function(model)
	return GetType(model)
end)

return {
    delete = Delete,
    clean = Clean,
    get_fuel_level = GetFuelLevel,
    get_fuel_tank = GetFuelTank,
    model_name = ModelName,
    get_plate = GetPlate,
    get_states = GetStates,
    open_door = OpenDoor,
    lock = Lock,
    repair = Repair,
    set_fuel = SetFuel,
    get_type = GetType,
    is_empty = IsEmpty,
    get_vehicle_properties = GetVehicleProperties,
    set_vehicle_properties = SetVehicleProperties,
    create = Create,
}