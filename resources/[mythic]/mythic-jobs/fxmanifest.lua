fx_version 'cerulean'
game 'gta5'
lua54 'yes'

client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

server_scripts {
    'server/**/*.lua',
}

shared_scripts {
    'config/config.lua',
    'config/spawns.lua',
    'config/defaultJobs/*.lua',
}

client_scripts {
    'client/**/*.lua',
}