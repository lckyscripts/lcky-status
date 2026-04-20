fx_version 'cerulean'
game 'gta5'

name 'lcky-status'
description 'Player - based status system'
version '0.2.0'

ox_lib 'locale'

shared_scripts {
    '@ox_lib/init.lua',
}

client_scripts {
    'client/main.lua',
    'client/interact.lua',
    'client/target.lua',
}

server_script 'server/main.lua'

dependencies {
    'qbx_core',
    'ox_target',
}

lua54 'yes'
