return { -- ps: false no one can change / true everyone can change / table only specific permission can change / number only specific permission can change with power >= number

    power = {
        ['dev'] = 100,
        ['owner'] = 100,
        ['admin'] = 80,
        ['mod'] = 60,
        ['helper'] = 20,
        ['player'] = 0,
    },

    profiles = {
        username = {['owner'] = true, ['admin'] = true}, -- change username
        password = false, -- change password 
        logo = false,
    },

    resource = {
        stop = {['dev'] = true, ['owner'] = true, ['admin'] = true}, -- stop resource
    },

    command = {
        -- not implemented yet!
    }
}