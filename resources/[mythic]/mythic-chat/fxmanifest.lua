fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

client_scripts {
    'client/component.lua',
    'client/cl_chat.lua',
  }
  
  server_scripts {
    'server/component.lua',
    'server/sv_chat.lua',
    'server/utils.lua',
    'server/commands.lua',
  }

ui_page 'ui/dist/index.html'
files {"ui/dist/index.html", 'ui/dist/*.png', 'ui/dist/*.webp', 'ui/dist/*.js', 'ui/dist/*.mp3', 'ui/dist/*.ttf'}