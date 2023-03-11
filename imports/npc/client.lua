
-- local function SayForAll()
--TODO
-- end

--- sl.npc.say : npc talk and say speech
---@param npcId number
---@param speech string
---@param param table
local function Say(self, speech, param)
    if not DoesEntityExist(self.ped) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    PlayPedAmbientSpeechNative(self.ped, speech, param)
end

--- sl.npc.set_soldier : set npc like a soldier
---@param npcId any
local function SetSoldier(self)
    if not DoesEntityExist(self.ped) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    SetPedSeeingRange(self.ped, 100.0)
    SetPedHearingRange(self.ped, 100.0)
    SetPedCombatAttributes(self.ped, 46, 1)
    SetPedFleeAttributes(self.ped, 0, true)
    SetPedCombatRange(self.ped,2)
    SetPedArmour(self.ped, 100)
    SetPedAccuracy(self.ped, 100)
end

--- sl.npc.set_scenario : set start a scenario
---@param npcId number
---@param scenario string
---@param instantly boolean
local function SetScenario(self, scenario, instantly)
    if not DoesEntityExist(self.ped) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    if instantly then
        ClearPedTasksImmediately(self.ped)
    else
        ClearPedTasks(self.ped)
    end
    TaskStartScenarioInPlace(self.ped, scenario, 0, not instantly)
end

--- sl.npc.set_weapon : give weapon to npc
---@param npcId number
---@param weapon string|weaponhash 
local function SetWeapon(self, weapon)
    if not DoesEntityExist(self.ped) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    GiveWeaponToPed(self.ped, weapon, 1000, false, true)
    SetCurrentPedWeapon(self.ped, weapon, true)
end

--- sl.npc.settings : setting of npc
---@param npcId number
---@param args table
local function Settings(self, args)
    if not DoesEntityExist(self.ped) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    if not args then return end

    if not args.ai then
        SetBlockingOfNonTemporaryEvents(self.ped, true)
        SetPedFleeAttributes(self.ped, 0, 0)
    end
    if args.weapon then
        SetWeapon(self, args.weapon)
    end
    if args.freeze then
        sl.entity.set_freeze(self.ped, true)
    end
    if args.scenario then
        SetScenario(self, args.scenario.name, args.scenario.instantly)
    end
    if args.soldier then
        SetSoldier(self)
    end
    if args.randomprops then
        SetPedRandomComponentVariation(self.ped, 0)
        SetPedRandomProps(self.ped)
    end
    if args.godmode then
        SetEntityInvincible(self.ped, args.godmode)
    end
end

--- sl.npc.create : create npc in coords and set settings
---@param model string|number
---@param coords vector3|number
---@param heading number
---@param properties table
---@param cb function
---@param netWork boolean
local function Create(model, coords, args, cb)
    local self = {}
    self.model = model 
    self.coords = coords
    self.args = args
    self.netWork = args.netWork == nil and true or false
    sl.request.model(model)

    if self.netWork then
        sl.callback.trigger("sl:createNpc", function(netnpc)
            while not NetworkDoesNetworkIdExist(netnpc) do Wait(100) end
            local npc <const> = NetToPed(netnpc)
            self.ped = npc
        end, self.model, self.coords)
    else
        CreateThread(function()
            local npc <const> = CreatePed(_, self.model, self.coords.xyzw, false, true)
            while not DoesEntityExist(npc) do Wait(50) end
            self.ped = npc
        end)
    end
    while not DoesEntityExist(self.ped) do Wait(50) end

    SetEntityAsMissionEntity(self.ped, true, true)
    SetEntityCoordsNoOffset(self.ped, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0)

    self.say = Say
    self.set_soldier = SetSoldier
    self.set_scenario = SetScenario
    self.set_weapon = SetWeapon
    self.settings = Settings

    self:settings(self.args)

    if cb then
        cb(self)
    end
    SetModelAsNoLongerNeeded(model)
    return self
end

return {
    say = Say,
    set_soldier = SetSoldier,
    set_scenario = SetScenario,
    set_weapon = SetWeapon,
    settings = Settings,
    create = Create,
}