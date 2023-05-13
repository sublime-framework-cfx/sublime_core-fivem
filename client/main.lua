local NetworkIsPlayerActive <const> = NetworkIsPlayerActive

CreateThread(function()
    while not cache.playerid or not NetworkIsPlayerActive(cache.playerid) do
        Wait(500)
    end
    sl.emitNet('playerLoaded')
end)

sl.onNet('playerLoaded', function(...)
    --print(cache.ped, cache.playerid, cache.serverid, cache.screen_x, cache.screen_y)
    --print('playerLoaded is Loaded?', ...)
    local profile <const> = sl.openLogin()
    print(profile)
end)

RegisterCommand('tt', function()
    local tt = sl.openModal({
        type = 'custom',
        title = 'Test',
        options = {
            { type = 'input', name = 'inputField', label = 'Input Field', required = true },
            {
                type = 'checkbox',
                name = 'checkboxField',
                label = 'Checkbox Field',
                checked = true,
            },
            {
                type = 'password',
                name = 'inputField',
                label = 'Input Field',
                required = true,
            },
        }
    })
    print(tt["1"], tt[1])
    print(json.encode(tt))
end)
