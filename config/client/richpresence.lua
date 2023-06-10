return {
    discord = {
        id = '1112818698168840372',
        largeIcon = 'logo',
        largeIconText = 'sublime',
        smallIcon = 'logo_supv',
        smallIconText = 'supv',
        wait = (1000 * 60) * 5, -- 5 min
        showPlayerCount = true,
        maxPlayers = GetConvarInt('sl:sv_maxclients', 48),
        buttons = {
            [0] = { text = 'Discord sublime', url = 'https://discord.gg/zdudS7xNpW' },
            [1] = { text = 'Discord supv', url = 'https://discord.gg/B6Z5VbA5wd' }, -- 'fivem://connect/localhost:30120'
        }
    },
    ---@todo maybe more in the future
}