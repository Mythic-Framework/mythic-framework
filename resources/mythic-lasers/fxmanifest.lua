games {'gta5'}

fx_version 'cerulean'
lua54 'yes'
description 'Create moving lasers in FiveM!'
version '1.0.0'

client_scripts {
  'client/client.lua',
  'client/wrapper.lua',
}

local creationEnabled = true
if creationEnabled then
  client_scripts {
    'client/utils.lua',
    'client/creation.lua',
  }
  server_script 'server/creation.lua'
end
