fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
description 'Blue Sky Limb Damage'
client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

version '2.0.0'

client_scripts {
	'sh_*.lua',
	'client/**/*.lua',
}

server_scripts {
	'sh_*.lua',
	'server/**/*.lua',
}