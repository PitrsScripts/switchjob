fx_version 'cerulean'
game 'gta5'
lua54 'yes' 

server_only 'yes'

server_scripts {
	'@oxmysql/lib/MySQL.lua', 
	'@es_extended/imports.lua',  
	'config.lua',  
	'switchjob.lua'  
}

dependencies {
    'oxmysql',   
    'ox_lib', 
    'es_extended',  
}
