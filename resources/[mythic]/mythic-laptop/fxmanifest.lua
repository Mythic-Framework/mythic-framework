name("Mythic Laptop")
description("Laptop")
author("[Alzar, Dr Nick]")
version("v1.0.0")
url("https://www.mythicrp.com")
lua54("yes")
fx_version("cerulean")
game("gta5")
client_script("@mythic-base/components/cl_error.lua")
client_script("@mythic-pwnzor/client/check.lua")

ui_page("ui/dist/index.html")

files({
	"ui/dist/*.*",
})

client_scripts({
	"client/*.lua",
	"client/apps/**/*.lua",
})
shared_scripts({
	"config.lua",
})

server_scripts({
	"server/*.lua",
	"server/apps/**/*.lua",
})
