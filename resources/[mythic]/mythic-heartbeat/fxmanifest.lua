game 'gta5'
fx_version 'bodacious'
lua54 'yes'
version '1.0.4'



client_scripts {
    'config.lua',
    'client.lua'
}
escrow_ignore {
    'config.lua'
}

ui_page "html/index.html"

files {
    'html/index.html',
    'html/app.js'
}
dependency '/assetpacks'