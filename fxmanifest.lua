fx_version "bodacious"
game "gta5"
lua54 "yes"


client_scripts {
	"@vrp/lib/utils.lua",
	"client/*"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"config/config.lua",
	"server/*"
}