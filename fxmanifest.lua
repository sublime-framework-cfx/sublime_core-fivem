fx_version 'cerulean'
games {'gta5', 'rdr3'}
lua54 'yes'
use_experimental_fxv2_oal 'yes'

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

server_scripts {
    'config/server/*.lua', -- on top
    'server/sql/*.lua',
    'server/class/*.lua',
    'server/*.lua'
}

client_scripts {
    'config/client/*.lua', -- on top
    'client/*.lua',
    'client/nui/*.lua'
}

ui_page 'web/build/index.html'

files {
    'obj.lua',
    'locales/*',
    'client/modules/*.lua',
    'imports/**/shared.lua',    
    'imports/**/client.lua',
    'web/build/index.html',
    'web/build/**/*'
}


