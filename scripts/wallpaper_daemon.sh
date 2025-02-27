#!/bin/bash

# Socks:
# 0 - Finaliza o script
# 1 - Atualiza a leitura do profile 
# 2
# 3 - Encerra os slides

# Ajustar: --bg-scale
# Preencher: --bg-fill
# Centralizar: --bg-center
# Repetir: --bg-tile
ADJUST=("--bg-scale" "--bg-fill" "--bg-center" "--bg-tile")
# Necessário instalar inotify-tools

SOCKS="$HOME/.config/scripts/wallpaper.socks"
PROFILE="$HOME/.config/scripts/wallpaper.profile"

# Cria o arquivo .socks se não existe
if [ ! -f "$SOCKS" ]; then
	echo "1" > "$SOCKS"
fi
if [ ! -f "$PROFILE" ]; then
	cat "0:" > "$PROFILE"
fi

# Lê o profile e altera o wallpaper
update(){
	ADJ=$(cat $PROFILE | cut -d':' -f1)
	IMG=$(cat $PROFILE | cut -d':' -f2)	
	if [ -f $IMG ]; then
		feh "${ADJUST[$ADJ]}" "$IMG"
	fi
}

# Verifica as mudanças no arquivo socks e opera conforme os parametros 
while true; do
	update
	# Monitora as mudanças no arquivo socks
	inotifywait -q -e modify "$SOCKS"
	if [ "$(cat $SOCKS)" -eq 0 ];then
		break
	fi
done