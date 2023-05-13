local NetworkIsPlayerActive <const> = NetworkIsPlayerActive

CreateThread(function()
    while not sl.cache.playerid and not NetworkIsPlayerActive(supv.cache.playerid) do Wait(0) end
    sl.onNet('playerLoaded')
end)

sl.onNet('playerLoaded', function(...)
    print('playerLoaded', ...)
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
