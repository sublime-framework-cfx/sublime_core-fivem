function sl.playerLoaded(source)
    --print('listen?')
    TriggerClientEvent('sublime_core:client:PlayerLoaded', source)
end

RegisterNetEvent('sublime_core:server:playerLoaded', function()
    local _source = source
    --print('here')
    sl.playerLoaded(_source)
end)