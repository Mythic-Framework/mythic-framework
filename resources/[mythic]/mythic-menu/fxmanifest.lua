fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

ui_page "ui/html/index.html"

files {
    "ui/html/*.*",
}

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}