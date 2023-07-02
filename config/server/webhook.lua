local active <const> = true
local LoadJson <const> = active and require 'imports.json.server'.load

return active and LoadJson('data/server/webhook')

--[[
return active and {
    localization = 'fr_FR',

    channel = {
        ['sublime_core'] = '', -- got webhook update
        ['forgot_password'] = 'https://discord.com/api/webhooks/1107109224636502016/Xamepba_7bGHY_xSfBVOgm1LZJBWmCaEfT1Vf4u6nQGSEpCGvZ6Z6y3XsCfb3kFG7plZ' -- got in embed when user forgot password
    },

    default = {
        date_format = 'letter', -- letter or numeric
        color = 7055103,
        foot_icon = 'https://avatars.githubusercontent.com/u/95303960?s=280&v=4',
        avatar = "https://avatars.githubusercontent.com/u/95303960?s=280&v=4"
    },

    playing_from = 'server' -- shared or server
}
--]]