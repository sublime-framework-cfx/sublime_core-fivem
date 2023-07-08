local function onPlayerDead()
    SetEntityHealth(cache.ped, 0)

    CreateThread(function()
        while cache.isDead do
            Wait(0)

            DisableAllControlActions(0)
            ThefeedHideThisFrame()
            HideHudAndRadarThisFrame()
        end
    end)
end

CreateThread(function()
    while true do
        if cache.ped and IsPedFatallyInjured(cache.ped) and not cache.isDead then
            sl:emitNet('onCharacterDeath', true)
        end
        Wait(850)
    end
end)

---@param playerDead boolean
sl:onNet('onCharacterDeath', function(playerDead)
    cache.isDead = playerDead

    if playerDead then
        return onPlayerDead()
    end

    local coords = GetEntityCoords(cache.ped)
    local heading = GetEntityHeading(cache.ped)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
end)