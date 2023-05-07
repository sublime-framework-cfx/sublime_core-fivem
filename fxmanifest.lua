fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'

name 'sublime_core'
author 'SUBLiME'
version '0.0.0'
repository 'https://github.com/SUBLiME-Association/sublime_core'
description 'Un framework pour tout type de serveur'

shared_script '_g.lua' -- need to be init first

shared_scripts {
    'config/shared/*.lua', -- on top
    'shared/handlers/*.lua',
}

client_scripts {
    'config/client/*.lua', -- on top
}

server_scripts {
    'config/server/*.lua', -- on top
}

-- ui_page 'web/build/index.html'

files {
    'obj.lua',
    'locales/*',
    'imports/**/shared.lua',    
    'imports/**/client.lua',
}


