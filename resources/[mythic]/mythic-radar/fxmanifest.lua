lua54 'yes'
fx_version "cerulean"
game "gta5"
client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

client_scripts {
	'config.lua',
	'client/*.lua',
}

server_scripts {
	'config.lua',
	'server/*.lua',
}

ui_page "ui/dist/index.html"

files {
	"ui/dist/*",
}