fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

client_scripts {
    'client/**/*.lua'
}

server_scripts {
    'server/**/*.lua'
}

ui_page 'ui/dist/index.html'
files {"ui/dist/index.html", 'ui/dist/*.png', 'ui/dist/*.js', 'ui/dist/*.ttf'}