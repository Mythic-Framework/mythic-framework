fx_version 'cerulean'
game 'gta5'
lua54 'yes'
client_script "@mythic-base/components/cl_error.lua"
client_script "@mythic-pwnzor/client/check.lua"

client_scripts {
    '@mythic-polyzone/client.lua',
    '@mythic-polyzone/BoxZone.lua',
    '@mythic-polyzone/EntityZone.lua',
    '@mythic-polyzone/CircleZone.lua',
    '@mythic-polyzone/ComboZone.lua',
    
    'client/*.lua',
    'client/targets/*.lua',
}