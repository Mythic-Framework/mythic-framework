fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'Mythic Weapon Damage Modifier'

client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}