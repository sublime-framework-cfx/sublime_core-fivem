local NetworkIsPlayerActive <const> = NetworkIsPlayerActive

local loaded 
loaded = SetInterval(function()
    if cache.playerid and NetworkIsPlayerActive(cache.playerid) then
        ClearInterval(loaded)
        sl.emitNet('playerLoaded')
        print(loaded)
    end
end, 1000)

sl.onNet('playerLoaded', function(...)
    print(cache.ped, cache.playerid, cache.serverid, cache.screen_x, cache.screen_y)
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
