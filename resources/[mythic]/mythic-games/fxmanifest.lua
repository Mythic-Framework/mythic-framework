fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

client_scripts {
    'config.lua',
    'client/*.lua',
    --'demo_games.lua',
}

server_scripts {
    'config.lua',
    'server/*.lua',
}

ui_page 'ui/dist/index.html'
files {"ui/dist/index.html", 'ui/dist/*.png', 'ui/dist/*.webp', 'ui/dist/*.js', 'ui/dist/*.mp3', 'ui/dist/*.ogg', 'ui/dist/*.ttf'}