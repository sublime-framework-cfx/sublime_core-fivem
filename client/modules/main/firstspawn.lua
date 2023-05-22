-- not used actually or used in other module later i will see :eyes:
local GetPlayerPed <const> = GetPlayerPed
local PlayerId <const> = PlayerId
local IsEntityVisible <const> = IsEntityVisible
local IsPedInAnyVehicle <const> = IsPedInAnyVehicle
local SetEntityCollision <const> = SetEntityCollision
local ClearPedTasksImmediately <const> = ClearPedTasksImmediately
local IsPedFatallyInjured <const> = IsPedFatallyInjured
local joaat <const> = joaat
local PlayerPedId <const> = PlayerPedId
local NetworkResurrectLocalPlayer <const> = NetworkResurrectLocalPlayer
local SetModelAsNoLongerNeeded <const> = SetModelAsNoLongerNeeded
local ClearPlayerWantedLevel <const> = ClearPlayerWantedLevel
local RequestCollisionAtCoord <const> = RequestCollisionAtCoord
local GetGameTimer <const> = GetGameTimer
local HasCollisionLoadedAroundEntity <const> = HasCollisionLoadedAroundEntity
local IsScreenFadedIn <const> = IsScreenFadedIn
local CreateCameraWithParams <const> = CreateCameraWithParams
local GetOffsetFromEntityInWorldCoords <const> = GetOffsetFromEntityInWorldCoords
local SetCamActive <const> = SetCamActive
local RenderScriptCams <const> = RenderScriptCams

-- used for first spawn
local SetPlayerModel <const> = SetPlayerModel
local SetPedDefaultComponentVariation <const> = SetPedDefaultComponentVariation
local SetEntityCoordsNoOffset <const> = SetEntityCoordsNoOffset
local IsScreenFadedOut <const> = IsScreenFadedOut
local NetworkIsPlayerActive <const> = NetworkIsPlayerActive
local SetPlayerInvincible <const> = SetPlayerInvincible
local SetPlayerControl <const> = SetPlayerControl
local RequestModel <const> = RequestModel
local HasModelLoaded <const> = HasModelLoaded
local FreezeEntityPosition <const> = FreezeEntityPosition
local SetEntityVisible <const> = SetEntityVisible
local StartPlayerTeleport <const> = StartPlayerTeleport
local SendLoadingScreenMessage <const> = SendLoadingScreenMessage
local DisableAllControlActions <const> = DisableAllControlActions
local ThefeedHideThisFrame <const> = ThefeedHideThisFrame
local HideHudAndRadarThisFrame <const> = HideHudAndRadarThisFrame
local ShutdownLoadingScreenNui <const> = ShutdownLoadingScreenNui
local GetIsLoadingScreenActive <const> = GetIsLoadingScreenActive
local NetworkStartSoloTutorialSession <const> = NetworkStartSoloTutorialSession
local DoScreenFadeOut <const> = DoScreenFadeOut
local ShutdownLoadingScreen <const> = ShutdownLoadingScreen
local DoScreenFadeIn <const> = DoScreenFadeIn
local NetworkEndTutorialSession <const> = NetworkEndTutorialSession
-- local SetNuiFocus <const> = SetNuiFocus

local p <const> = require 'imports.promise.shared'
local default <const> = require 'config.client.firstspawn'
local hidePlayer, playerLoaded = false, false

p.new(function(resolve)
    while not cache.playerid or not NetworkIsPlayerActive(cache.playerid) do
        Wait(500)
    end
    while not IsScreenFadedOut do
        DoScreenFadeOut(0)
        Wait(250)
    end
    Wait(250)
    resolve(true)
end):Then(function()
    sl:emitNet('playerLoaded')
end)

function cache.onUpdate.ped(value)
    if not hidePlayer then return end
    FreezeEntityPosition(value, true)
    SetEntityVisible(value, false, false)
end

local function PlayerPeview(toggle)
    if toggle then
        hidePlayer = true -- moving soon by player is spawned statebag server-side
        CreateThread(function()
            while not playerLoaded do
                DisableAllControlActions(0)
                ThefeedHideThisFrame()
                HideHudAndRadarThisFrame()
                Wait(0)
            end

            while hidePlayer do
                DisableAllControlActions(0)
                ThefeedHideThisFrame()
                HideHudAndRadarThisFrame()

                -- + control thread ?

                Wait(0)
            end
        end)

        FreezeEntityPosition(cache.ped, true)
        SetEntityVisible(cache.ped, false, false)
    else
        hidePlayer = false
        FreezeEntityPosition(cache.ped, false)
        SetEntityVisible(cache.ped, true, false)
    end
end

sl:onNet('playerLoaded', function()
    
    SetPlayerControl(cache.playerid, false, 0)
    SetPlayerInvincible(cache.playerid, true)

    Wait(500)

    PlayerPeview(true)

    if not playerLoaded then
        local playerModel <const> = default.model
        RequestModel(playerModel)
        while not HasModelLoaded(playerModel) do
            Wait(100)
        end
        SetPlayerModel(cache.playerid, playerModel)
        SetPedDefaultComponentVariation(cache.ped)
        Wait(500)
        playerLoaded = true
    end

    Wait(500)

    local success <const> = sl.await(p.async(function(resolve)
        SendLoadingScreenMessage(json.encode({loginOpen = true}))
        local login <const> = sl:openLogin()
        if login then
            SendLoadingScreenMessage(json.encode({fullyLoaded = true}))
        end
        SetEntityCoordsNoOffset(cache.ped, default.coords.x, default.coords.y, default.coords.z, true, true, false)
        StartPlayerTeleport(cache.playerid, default.coords.x, default.coords.y, default.coords.z, default.coords.w, false, true, false)
        resolve(true)
    end))

    if success then
        Wait(3500)
        
        if GetIsLoadingScreenActive() then
            ShutdownLoadingScreenNui()
            ShutdownLoadingScreen()
        end

        SetEntityCoordsNoOffset(cache.ped, default.coords.x, default.coords.y, default.coords.z, true, true, false)
        StartPlayerTeleport(cache.playerid, default.coords.x, default.coords.y, default.coords.z, default.coords.w, false, true, false)
        NetworkStartSoloTutorialSession()
        SetPlayerControl(cache.playerid, true, 0) -- maybe false ?
        SetPlayerInvincible(cache.playerid, false)
        DoScreenFadeOut(200)
        Wait(1000)
        DoScreenFadeIn(500)

        Wait(500)
        sl:resetFocus() -- prevent: focus from being stuck or not visible
        Wait(500)

        local spawn <const> = sl:openProfile()

        if spawn then
            ---@todo: spawn player
            -- event server-side: playerSpawned
            PlayerPeview(false)
            NetworkEndTutorialSession()
        else
            ---@todo: kick player / unload
        end
    end
end)