---@todo [NEW] work in progress 0.0.2 to 0.1.0

-- loadscreen 'modules/loadscreen/client/index.html' -- loadscreen
-- loadscreen_manual_shutdown "yes" -- enable manual shutdown
-- loadscreen_cursor 'yes' -- enable cursor

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'

name 'sublime_core (fivem)'
author 'SUBLiME'
version '0.1.0 (wip)'
repository 'https://github.com/sublime-framework-cfx/sublime_core-fivem'
description 'A new modular framework for FiveM'

files {
    'config/modules.lua',
    'imports/**/shared.lua',
    'imports/**/client.lua',
    'import.lua',
    -- 'modules/**/shared/**',
    'modules/**/client/**',
}

shared_scripts {
    'init.lua',
    'modules/init.lua',
}