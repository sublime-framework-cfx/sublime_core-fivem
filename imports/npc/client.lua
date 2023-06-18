local CreatePed <const> = CreatePed
local DoesEntityExist <const> = DoesEntityExist
local DeleteEntity <const> = DeleteEntity
local joaat <const> = joaat
local RequestModel <const> = RequestModel
local HasModelLoaded <const> = HasModelLoaded
local ClearPedTasks <const> = ClearPedTasks
local ClearPedSecondaryTask <const> = ClearPedSecondaryTask
local TaskSetBlockingOfNonTemporaryEvents <const> = TaskSetBlockingOfNonTemporaryEvents
local SetPedFleeAttributes <const> = SetPedFleeAttributes
local SetPedCombatAttributes <const> = SetPedCombatAttributes
local SetPedSeeingRange <const> = SetPedSeeingRange
local SetPedHearingRange <const> = SetPedHearingRange
local SetPedAlertness <const> = SetPedAlertness
local SetPedKeepTask <const> = SetPedKeepTask
local RequestAnimDict <const> = RequestAnimDict
local HasAnimDictLoaded <const> = HasAnimDictLoaded
local TaskPlayAnim <const> = TaskPlayAnim
local SetModelAsNoLongerNeeded <const> = SetModelAsNoLongerNeeded

-- native not used for now but soon
local SetBlockingOfNonTemporaryEvents <const> = SetBlockingOfNonTemporaryEvents
local SetEntityInvincible <const> = SetEntityInvincible
local FreezeEntityPosition <const> = FreezeEntityPosition
local SetPedComponentVariation <const> = SetPedComponentVariation
local SetPedDefaultComponentVariation <const> = SetPedDefaultComponentVariation
local GiveWeaponToPed <const> = GiveWeaponToPed

---@class NpcWeaponsProps
---@field model string|number
---@field ammo? number-0
---@field visible? boolean-true

---@class DataNpcProps
---@field network? boolean-true
---@field blockevent? boolean-true
---@field godmode? boolean-true
---@field freeze? boolean-true
---@field variation? number
---@field weapon? NpcWeaponsProps

---@return nil
local function Remove(self)
    if DoesEntityExist(self.ped) then
        DeleteEntity(self.ped)
        return nil, collectgarbage()
    end
end

---@param model string|number
---@param coords vec4
---@param data? DataNpcProps
---@return table
local function New(model, coords, data)
    local self = {}

    self.model = type(model) == 'number' and model or joaat(model)
    self.vec3 = vec3(coords.x, coords.y, coords.z)
    self.vec4 = vec4(coords.x, coords.y, coords.z, coords.w or coords.h or 0.0)
    self.remove = Remove

    local p = promise.new()

    CreateThread(function()
        RequestModel(self.hash)
        while not HasModelLoaded(self.hash) do
            Wait(10)
        end

        self.ped = CreatePed(nil, self.model, self.vec4.x, self.vec4.y, self.vec4.z, self.vec4.w, data?.network or true, false)
        SetModelAsNoLongerNeeded(self.model)

        if DoesEntityExist(self.ped) then
            SetBlockingOfNonTemporaryEvents(self.ped, data?.blockevent or true)
            SetEntityInvincible(self.ped, data?.godmode or true)
            FreezeEntityPosition(self.ped, data?.freeze or true)
            if data?.variation then SetPedComponentVariation(self.ped, data.variation) else SetPedDefaultComponentVariation(self.ped) end
            if data?.weapon and type(data.weapon) == 'table' and data.weapon.model then
                local weapon = type(data.weapon.model) == 'number' and data.weapon.model or joaat(data.weapon.model)
                GiveWeaponToPed(self.ped, weapon, data.weapon?.ammo or 0, data.weapon?.visible or true, true)
            end
            p:resolve(self)
        else
            p:reject(('Failed to create ped in %s'):format(sl.env))
        end
    end)

    return sl.await(p)
end



local function NewPreview(model, coords, animDict, animName)
    local self = {}

    self.model = type(model) == 'number' and model or joaat(model)
    self.vec3 = vec3(coords.x, coords.y, coords.z)
    self.vec4 = vec4(coords.x, coords.y, coords.z, coords.w or coords.h or 0.0)

    local p = promise.new()
    CreateThread(function()
        RequestModel(self.model)
        while not HasModelLoaded(self.model) do
            Wait(100)
        end

        self.ped = CreatePed(nil, self.model, self.vec4.x, self.vec4.y, self.vec4.z - 1.0, self.vec4.w, false, false)

        ClearPedTasks(self.ped)
        ClearPedSecondaryTask(self.ped)
        TaskSetBlockingOfNonTemporaryEvents(self.ped, true)
        SetPedFleeAttributes(self.ped, 0, 0)
        SetPedCombatAttributes(self.ped, 17, 1)
        SetPedSeeingRange(self.ped, 0.0)
        SetPedHearingRange(self.ped, 0.0)
        SetPedAlertness(self.ped, 0)
        SetPedKeepTask(self.ped, true)

        SetModelAsNoLongerNeeded(self.model)

        if animDict and animName then
            RequestAnimDict(animDict)
            while not HasAnimDictLoaded(animDict) do
                Wait(1)
            end
            TaskPlayAnim(self.ped, animDict, animName, 8.0, 0, -1, 1, 0, 0, 0)
        end

        SetEntityInvincible(self.ped, true)
        self.remove = Remove

        if DoesEntityExist(self.ped) then
            p:resolve(self)
        else
            p:reject(('Failed to create ped (preview) in %s'):format(sl.env))
        end
    end)

    return sl.await(p)
end

return {
    new = New,
    preview = NewPreview,
}
