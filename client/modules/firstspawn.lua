local GetPlayerPed <const> = GetPlayerPed
local PlayerId <const> = PlayerId
local IsEntityVisible <const> = IsEntityVisible
local IsPedInAnyVehicle <const> = IsPedInAnyVehicle
local FreezeEntityPosition <const> = FreezeEntityPosition
local SetEntityVisible <const> = SetEntityVisible
local SetEntityCollision <const> = SetEntityCollision
local ClearPedTasksImmediately <const> = ClearPedTasksImmediately
local IsPedFatallyInjured <const> = IsPedFatallyInjured
local SetPlayerInvincible <const> = SetPlayerInvincible
local SetPlayerControl <const> = SetPlayerControl
local RequestModel <const> = RequestModel
local HasModelLoaded <const> = HasModelLoaded
local joaat <const> = joaat
local PlayerPedId <const> = PlayerPedId
local SetPedDefaultComponentVariation <const> = SetPedDefaultComponentVariation
local SetEntityCoordsNoOffset <const> = SetEntityCoordsNoOffset
local NetworkResurrectLocalPlayer <const> = NetworkResurrectLocalPlayer
local SetModelAsNoLongerNeeded <const> = SetModelAsNoLongerNeeded
local ClearPlayerWantedLevel <const> = ClearPlayerWantedLevel
local RequestCollisionAtCoord <const> = RequestCollisionAtCoord
local GetGameTimer <const> = GetGameTimer
local HasCollisionLoadedAroundEntity <const> = HasCollisionLoadedAroundEntity
local ShutdownLoadingScreen <const> = ShutdownLoadingScreen
local DoScreenFadeIn <const> = DoScreenFadeIn
local IsScreenFadedIn <const> = IsScreenFadedIn
local IsScreenFadedOut <const> = IsScreenFadedOut
local SetPlayerModel <const> = SetPlayerModel

local defaultCoords <const> = vec4(-74.69, -819.09, 326.17, 44.80)
local defaultModel <const> = 'mp_m_freemode_01'

local function FreezePlayer(freeze)
    local player = PlayerId()
    local playerPed = GetPlayerPed(player)
    SetPlayerControl(player, freeze and not freeze or false, false)
    if not freeze then
        if not IsEntityVisible(playerPed) then
            SetEntityVisible(playerPed, true)
        end
        if not IsPedInAnyVehicle(playerPed) then
            SetEntityCollision(playerPed, true)
        end
        FreezeEntityPosition(playerPed, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(playerPed) then
            SetEntityVisible(playerPed, false)
        end
        SetEntityCollision(playerPed, false)
        FreezeEntityPosition(playerPed, true)
        SetPlayerInvincible(player, true)
        if not IsPedFatallyInjured(playerPed) then
            ClearPedTasksImmediately(playerPed)
        end
    end
end

local function InitSpawn(p)
    local modelHash <const> = joaat(defaultModel)
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(1)
    end
    FreezePlayer(true)
    RequestCollisionAtCoord(defaultCoords.x, defaultCoords.y, defaultCoords.z)
    SetPlayerModel(PlayerId(), modelHash)
    SetPedDefaultComponentVariation(PlayerPedId())
    SetEntityCoordsNoOffset(PlayerPedId(), defaultCoords.x, defaultCoords.y, defaultCoords.z, false, false, false, true)
    NetworkResurrectLocalPlayer(defaultCoords.x, defaultCoords.y, defaultCoords.z, defaultCoords.w, true, false)
    SetPlayerInvincible(PlayerId(), false)
    SetModelAsNoLongerNeeded(modelHash)
    ClearPlayerWantedLevel(PlayerId())
    local time = GetGameTimer()

    while (not HasCollisionLoadedAroundEntity(PlayerPedId()) and (GetGameTimer() - time) < 5000) do
        Wait(0)
    end

    ShutdownLoadingScreen()

    if IsScreenFadedOut() then
        DoScreenFadeIn(500)
        while not IsScreenFadedIn() do
            Wait(0)
        end
        p:resolve(true)
    end
    p:resolve(true)
    return sl.await(p)
end

return InitSpawn