fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

client_scripts {
    'config.lua',
    'shared/**/*.lua',
    'client/**/*.lua'
}

server_scripts {
    'config.lua',
    'shared/**/*.lua',
    'server/**/*.lua',
}