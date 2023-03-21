fx_version 'adamant'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/*.ttf',
	'html/bank-icon.png',
	'html/letter.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_script {
	'c/client.lua',
}

server_scripts {
	's/server.lua',
}

dependency '/assetpacks'