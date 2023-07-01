fx_version 'cerulean'
games {'gta5', 'rdr3'} -- Work only on FiveM for now.. but it's planned to be ported on RedM
lua54 'yes'
use_experimental_fxv2_oal 'yes'

name 'sublime_core'
author 'SUBLiME'
version '0.0.0'
repository 'https://github.com/sublime-framework-cfx/sublime_core'
description 'Un framework pour tout type de serveur'

loadscreen 'modules/loadscreen/client/index.html' -- loadscreen
loadscreen_manual_shutdown "yes" -- enable manual shutdown
loadscreen_cursor 'yes' -- enable cursor

server_script 'package/dist/server/server.js' -- need to be init first
shared_script 'init.lua'
server_script 'modules/init.lua'
client_script 'modules/init.lua'

ui_page 'web/build/index.html'

files {
    'obj.lua',
    'locales/*',
    'data/*.json',
    'config/modules.lua',
    'config/client/*.lua',
    'config/shared/*.lua',
    --'client/modules/**',
    --'shared/modules/**',
    'modules/**/index.lua',
    'modules/**/shared/**',
    'modules/**/client/**',
    'imports/**/shared.lua',    
    'imports/**/client.lua',
    'web/build/index.html',
    'web/build/**/*'
}

dependencies {
    '/server:6461', -- requires at least server build 6461 (txAdmin v6)
    '/onesync', -- requires onesync enabled
    'oxmysql', -- requires oxmysql resource
}
