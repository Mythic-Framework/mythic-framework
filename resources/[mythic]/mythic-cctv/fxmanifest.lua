fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

client_scripts {
    'config/client.lua',
    'config/shared.lua',
    'shared/**/*.lua',
    'client/**/*.lua',
}

server_scripts {
    'config/server.lua',
    'config/shared.lua',
    'shared/**/*.lua',
    'server/**/*.lua',
}