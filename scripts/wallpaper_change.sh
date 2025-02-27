#!/bin/bash

# Ajustar: --bg-scale
# Preencher: --bg-fill
# Centralizar: --bg-center
# Repetir: --bg-tile

# Lê o arquivo wallpaper.profile
PROFILE="$HOME/.config/scripts/wallpaper.profile"
SOCKS="$HOME/.config/scripts/wallpaper.socks"
# Cria o arquivo zerado se ele não existe
ADJUST=""
IMAGE=""
if [ ! -f $PROFILE ]; then
	echo "0:"
	ADJUST="0"
else
	ADJUST=$(cat "$PROFILE" | cut -d':' -f1)
	IMAGE=$(cat "$PROFILE" | cut -d':' -f2)
fi

if [ -f "$IMAGE" ]; then
	DIMENSIONS=$(file "$IMAGE" | grep -Eo "[[:digit:]]+ *x *[[:digit:]]+")
	IMAGEPATH=$(dirname "$IMAGE")
else
	DIMENSIONS="Sem dimensões"
	IMAGEPATH="Não encontrada"
fi
ADJUSTTXT=("Ajustada" "Preenchida" "Centralizada" "Repetida")

RESULT=$(yad --width=600 --height=300 --title="Papel de Parede" \
	--form \
	--field="Ajuste de Imagem:CB" "Ajustar!Preencher!Centralizar!Repetir" \
 	--field="Selecione a Imagem:FL" --file-filter="*.jpg *.jpeg *.png" \
 	--field="<span font='8'>Escolha uma nova imagem de Papel de Parede nas extensões PNG, JPG ou JPEG</span>\n\n\:LBL" \
	--field="<span font='16'><b>Imagem Atual</b></span>\n<span font='10'><b>Caminho:</b> $IMAGEPATH \n<b>Dimensões</b>: $DIMENSIONS\n<b>Tipo de Ajuste:</b> ${ADJUSTTXT[$ADJUST]}</span>:LBL" \
	--separator=",")

if [ $? -eq 0 ]; then
	VALUEADJ=$(echo $RESULT | cut -d',' -f1)
	VALUEIMG=$(echo $RESULT | cut -d',' -f2)
	if [ -f "$VALUEIMG" ]; then
		case $VALUEADJ in
			"Ajustar")
				ADJ="0";;
			"Preencher")
				ADJ="1";;
			"Centralizar")
				ADJ="2";;
			"Repetir")
				ADJ="3";;
		esac
		echo "$ADJ:$VALUEIMG" > "$PROFILE"
		echo "1" > "$SOCKS"
	else
		yad --warning --title="Aviso" --text="A imagem escolhida não é um arquivo válido ou suportado!"
		exit
	fi
fi