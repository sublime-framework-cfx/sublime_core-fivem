return {
    server = {
        'players',
        'profiles',
        'spawn',
        'death'
    },

    client = {
        'cache',
        'firstspawn',
        -- 'death' not needed because i loaded it in firstspawn when onCharacterSpawn is played but need to confirm this module from config
    }
}