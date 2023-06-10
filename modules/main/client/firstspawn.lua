-- this module is used for first spawn and preview player but work only on FiveM for now.. but it's planned to be ported on RedM & can got some bugs on restart resource
-- also this module is not finished yet, it's just a preview of what it will look like

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
local DestroyCam <const> = DestroyCam
local CreateCameraWithParams <const> = CreateCameraWithParams
local GetOffsetFromEntityInWorldCoords <const> = GetOffsetFromEntityInWorldCoords
local SetCamActive <const> = SetCamActive
local RenderScriptCams <const> = RenderScriptCams
local ClearOverrideWeather <const> = ClearOverrideWeather
local NetworkOverrideClockTime <const> = NetworkOverrideClockTime
local SetWeatherTypeNow <const> = SetWeatherTypeNow
local NetworkClearClockTimeOverride <const> = NetworkClearClockTimeOverride
-- local SetNuiFocus <const> = SetNuiFocus

local p <const> = require 'imports.promise.shared'
local hidePlayer, playerLoaded, charSpawned = true, false, false
local AwaitLogin = nil

print('started module?')

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

--Citizen.CreateThreadNow(function()
--    local can <const> = sl.await(p.async(function(resolve)
--        while not cache.playerid or not NetworkIsPlayerActive(cache.playerid) do
--            Wait(500)
--        end
--        while not IsScreenFadedOut do
--            DoScreenFadeOut(0)
--            Wait(250)
--        end
--        Wait(250)
--        print(true, 'TRUUUUUUUUUUUUUUUUE')
--        resolve(true)
--    end))
--    if can then
--        print('??xD')
--        sl:emitNet('playerLoaded')
--    end
--end)

local function PlayerPeview(toggle)
    if toggle then
        hidePlayer = true
        CreateThread(function()
            while not playerLoaded do
                DisableAllControlActions(0)
                ThefeedHideThisFrame()
                HideHudAndRadarThisFrame()
                Wait(0)
            end

            while hidePlayer do
                --DisableAllControlActions(0)
                ThefeedHideThisFrame()
                HideHudAndRadarThisFrame()

                -- + control thread ?

                Wait(0)
            end
        end)

        CreateThread(function()
            while not charSpawned do
                ClearOverrideWeather()
                ClearWeatherTypePersist()
                SetWeatherTypePersist('EXTRASUNNY')
                SetWeatherTypeNow('EXTRASUNNY')
                SetWeatherTypeNowPersist('EXTRASUNNY')
                NetworkOverrideClockTime(10, 0, 0)
                Wait(100000)
            end
        end)

        FreezeEntityPosition(cache.ped, true)
        SetEntityVisible(cache.ped, false)
    else
        hidePlayer = false
    end
end

sl:onNet('playerLoaded', function()
    if AwaitLogin then return end
    AwaitLogin = true
    local default <const> = require 'config.client.firstspawn'
    local inLoadingScreen = GetIsLoadingScreenActive()
    if not playerLoaded then
        print('locked?')
        RequestModel(default.model)
        while not HasModelLoaded(default.model) do
            Wait(100)
        end
        SetPlayerModel(cache.playerid, default.model)
        SetModelAsNoLongerNeeded(default.model)
        SetPedDefaultComponentVariation(cache.ped)
        Wait(500)
        playerLoaded = true
    end

    Wait(500)
    PlayerPeview(true)

    local success <const> = sl.await(p.async(function(resolve)
        if inLoadingScreen then SendLoadingScreenMessage(json.encode({loginOpen = true})) end
        local login <const> = sl:openLogin()
        print('login?')
        if login then
            if inLoadingScreen then SendLoadingScreenMessage(json.encode({fullyLoaded = true})) end
            AwaitLogin = nil
        end
        FreezeEntityPosition(cache.ped, true)
        SetEntityCoordsNoOffset(cache.ped, default.coords.x, default.coords.y, default.coords.z, true, true, false)
        StartPlayerTeleport(cache.playerid, default.coords.x, default.coords.y, default.coords.z, default.coords.w, false, true, false)
        resolve(true)
    end))

    if success then
        Wait(3500)
        
        if inLoadingScreen then
            ShutdownLoadingScreenNui()
            ShutdownLoadingScreen()
        end

        inLoadingScreen = nil

        NetworkStartSoloTutorialSession()
        SetPlayerControl(cache.playerid, true, 0) -- maybe false ?
        SetPlayerInvincible(cache.playerid, true)
        DoScreenFadeOut(200)
        Wait(1000)
        DoScreenFadeIn(500)

        Wait(250)
        sl:resetFocus() -- prevent: focus from being stuck or not visible
        Wait(250)

        SetEntityCoordsNoOffset(cache.ped, default.coords.x, default.coords.y, default.coords.z, true, true, false)
        StartPlayerTeleport(cache.playerid, default.coords.x, default.coords.y, default.coords.z, default.coords.w, false, true, false)
        FreezeEntityPosition(cache.ped, true)

        local offset = GetOffsetFromEntityInWorldCoords(cache.ped, 0.0, 4.7, 0.2)
        local cam = CreateCameraWithParams('DEFAULT_SCRIPTED_CAMERA', offset.x, offset.y, offset.z, 0.0, 0.0, 0.0, 30.0, false, 0)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 0.0, true, true)
        local spawn <const> = sl:openProfile(cam, hidePlayer)

        if spawn then
            ---@todo: spawn player
            -- event server-side: playerSpawned
            charSpawned = true
            RenderScriptCams(false, false, 0, true, true)
            DestroyCam(cam, false)
            
            NetworkClearClockTimeOverride()
            ClearOverrideWeather()
            NetworkEndTutorialSession()
            cam = nil

            ---@debug
            sl:resetFocus()
            PlayerPeview(false)
            SetPlayerModel(PlayerId(), spawn.model) 
            cache.ped = PlayerPedId()
            SetPedDefaultComponentVariation(cache.ped) 
            SetEntityAsMissionEntity(cache.ped, true, true) 
            SetModelAsNoLongerNeeded(cache.ped)
            SetEntityCollision(cache.ped, true, true)
            SetEntityCoordsNoOffset(cache.ped, default.coords.x, default.coords.y, default.coords.z, true, true, false)
            SetEntityHeading(cache.ped, default.coords.w)
            FreezeEntityPosition(cache.ped, false)
            SetEntityVisible(cache.ped, true)
            SetPlayerInvincible(cache.playerid, false)
            SetPlayerControl(cache.playerid, true, 0)
            ClearPlayerWantedLevel(cache.playerid)
            NetworkResurrectLocalPlayer(default.coords.x, default.coords.y, default.coords.z, default.coords.w, true, false)
            SetGameplayCamRelativeHeading(0)
        else
            ---@todo: kick player / unload
        end
    end
end)