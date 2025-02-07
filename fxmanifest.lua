-- PT 1 & 2

fx_version 'cerulean'
game 'gta5'

shared_scripts {
    '@ox_lib/init.lua',

    '@qbx_core/modules/lib.lua',     -- if you are using qbox make sure this isnt commented out

    'config.lua'
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua'
}

lua54 'yes'
use_fxv2_oal 'yes'