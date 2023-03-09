
-- local function SayForAll()
--TODO
-- end

--- sl.npc.say : npc talk and say speech
---@param npcId number
---@param speech string
---@param param table
local function Say(npcId, speech, param)
    if not DoesEntityExist(npcId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    PlayAmbientSpeech1(npcId, speech, param)
end

--- sl.npc.set_soldier : set npc like a soldier
---@param npcId any
local function SetSoldier(npcId)
    if not DoesEntityExist(npcId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    SetPedSeeingRange(npcId, 100.0)
    SetPedHearingRange(npcId, 100.0)
    SetPedCombatAttributes(npcId, 46, 1)
    SetPedFleeAttributes(npcId, 0, true)
    SetPedCombatRange(npcId,2)
    SetPedArmour(npcId, 100)
    SetPedAccuracy(npcId, 100)
end

--- sl.npc.set_scenario : set start a scenario
---@param npcId number
---@param scenario string
---@param instantly boolean
local function SetScenario(npcId, scenario, instantly)
    if not DoesEntityExist(npcId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    if instantly then
        ClearPedTasksImmediately(npcId)
    else
        ClearPedTasks(npcId)
    end
    TaskStartScenarioInPlace(npcId, scenario, 0, not instantly)
end

--- sl.npc.set_weapon : give weapon to npc
---@param npcId number
---@param weapon string|weaponhash 
local function SetWeapon(npcId, weapon)
    if not DoesEntityExist(npcId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end

    GiveWeaponToPed(npcId, weapon, 1000, false, true)
    SetCurrentPedWeapon(npcId, weapon, true)
end

--- sl.npc.settings : setting of npc
---@param npcId number
---@param args table
local function Settings(npcId, args)
    if not DoesEntityExist(npcId) then
        local debug <const> = debug.getinfo
        return sl.log.print(3, "Ped didnt exist (Function : ^5%s^7, From : [^5%s^7 : %s])", debug(1, "n").name, debug(2, "Sl").short_src, debug(2, "Sl").currentline)
    end
    

    if args.weapon then
        SetWeapon(args.weapon)
    end
    if args.freeze then
        sl.entity.set_freeze(npcId, true)
    end
    if args.scenario then
        SetScenario(npcId, args.scenario.name, args.scenario.instantly)
    end
    if args.soldier then
        SetSoldier(npcId)
    end
    if args.randomprops then
        SetPedRandomComponentVariation(npcId, 0)
        SetPedRandomProps(npcId)
    end
    if args.godmode then
        SetEntityInvincible(npcId, args.godmode)
    end
    if not args.ai then
        SetBlockingOfNonTemporaryEvents(npcId, true)
        SetPedFleeAttributes(npcId, 0, 0)
    end
end

--- sl.npc.create : create npc in coords and set settings
---@param model string|number
---@param coords vector3|number
---@param heading number
---@param properties table
---@param cb function
---@param netWork boolean
local function Create(model, coords, heading, settings, cb, netWork)
    netWork = netWork == nil and true or false
    sl.request.model(model)
    if netWork then
        sl.callback.trigger("sl:createNpc", function(netnpc)
            while not NetworkDoesNetworkIdExist(netnpc) do Wait(100) end
            local npc <const> = NetToPed(netnpc)
            SetEntityAsMissionEntity(npc, true, true)
            Settings(npc, settings)
            if cb then cb(npc) end
        end, model, coords, heading)
    else
        CreateThread(function()
            local npc <const> = CreatePed(1, model, coords.x, coords.y, coords.z, heading, false, true)
            while not DoesEntityExist(npc) do Wait(50) end
            SetEntityAsMissionEntity(npc, true, true)
            if settings then Settings(npc, settings) end
            if cb then cb(npc) end
        end)
    end
    SetModelAsNoLongerNeeded(model)
end

return {
    say = Say,
    set_soldier = SetSoldier,
    set_scenario = SetScenario,
    set_weapon = SetWeapon,
    settings = Settings,
    create = Create,
}