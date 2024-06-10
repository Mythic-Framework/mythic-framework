fx_version 'cerulean'
games {'gta5'}
lua54 'yes'
client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

description 'AuthenticRP Businesses - Random Stuff For Random Businesses'
name 'AuthenticRP: mythic-businesses'
author 'Dr Nick'
version 'v1.0.0'
url 'https://www.mythicrp.com'

server_scripts {
    'config/sv_config.lua',
    'config/businesses/*.lua',
    'shared/**/*.lua',
    'server/**/*.lua',
}

client_scripts {
    'shared/**/*.lua',
    'client/**/*.lua',
}

files {
    'dui/bowling/app.js',
    'dui/bowling/index.html',
    'dui/bowling/*.png',
    'dui/bowling/gifs/*.gif',
    'dui/tvs/app.js',
    'dui/tvs/index.html',
}