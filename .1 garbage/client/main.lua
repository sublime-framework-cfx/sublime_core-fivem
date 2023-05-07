--- Check if player is loaded client-side
print('file loaded?')
CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do Wait(0) end
    TriggerServerEvent('sublime_core:server:playerLoaded')
end)



RegisterNetEvent('sublime_core:client:PlayerLoaded', function()

end)