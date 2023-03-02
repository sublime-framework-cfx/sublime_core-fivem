fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_fxv2_oal 'yes'
description 'Sublime Développement [sublime_core]'
version '1.0.0'




shared_scripts {

    'imports/**/shared.lua',
    'imports/**/shared/*.lua',
}


server_scripts {
    
    'imports/**/server.lua',
    'imports/**/server/*.lua',
}

client_scripts {
    
    'imports/**/client.lua',
    'imports/**/client/*.lua',
}