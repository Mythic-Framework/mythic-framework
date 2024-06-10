fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

client_scripts {
    'config/*.lua',
    'client/utils.lua',
    'client/main.lua',
    'client/menu.lua',
    'client/bindings.lua',
    'client/emotes.lua',
    'client/ptfxsync.lua',
    'client/pedfeatures.lua',
    'client/sharedemotes.lua',
    'client/pointing.lua',
    'client/items.lua',
    'client/chairs.lua',
    'client/selfie.lua',
}

server_scripts {
    'config/*.lua',
    'server/*.lua',
}