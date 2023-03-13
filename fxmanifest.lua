fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
game 'gta5'
lua54 'yes'

name 'sublime_core'
author 'SUBLiME'
version '0.0.0'
repository 'https://github.com/SUBLiME-Association/sublime_core'
description 'Un framework pour tout type de serveur'

shared_script '_g.lua'
shared_script 'shared/*.lua'

client_script 'client/**.lua'

server_script 'server/**.lua'

ui_page 'web/build/index.html'

files {
    'obj.lua',
    'locales/*.lua',
    'imports/**/shared.lua',    
    'imports/**/client.lua',
    'shared/data/*.json',
    'web/build/index.html',
    'web/build/**/*'
}


