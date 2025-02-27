#!/bin/bash
GTK2_FILE="$HOME/.gtkrc-2.0"
GTK3_FILE="$HOME/.config/gtk-3.0/settings.ini"
GTK4_FILE="$HOME/.config/gtk-4.0/settings.ini"

get_center_x(){
    width=$1
    screen_width=$(xdpyinfo | awk '/dimensions:/ { print $2 }' | cut -d 'x' -f1)
    posx=$(( (screen_width - width) / 2 ))
    echo $posx
}

get_center_y(){
    height=$1
    screen_height=$(xdpyinfo | awk '/dimensions:/ { print $2 }' | cut -d 'x' -f2)
    posy=$(( (screen_height - height) / 2 ))
    echo $posy
}

check_files(){
    if [ ! -e "$GTK2_FILE" ]; then
        create_init_config "$GTK2_FILE" "Adwaita"        
    fi
    if [ ! -e "$GTK3_FILE" ]; then
        create_init_config "$GTK3_FILE" "Adwaita"
    fi
    if [ ! -e "$GTK4_FILE" ]; then
	    create_init_config "$GTK4_FILE" "Adwaita"
    fi
}

create_init_config(){
    FILENAME=$1
    THEME=$2
    TMP_CMD=$(dirname "$FILENAME")
    mkdir -p "$TMP_CMD"
    echo "Arquivo $FILENAME criado!"
    echo "[Settings]" >> "$FILENAME"
    echo "gtk-theme-name=$THEME" >> "$FILENAME"
    echo "gtk-icon-theme-name= " >> "$FILENAME"
}

change_icon(){
   THEME="$1"
   set_new_icon "$THEME" "$GTK2_FILE"
   set_new_icon "$THEME" "$GTK3_FILE"
   set_new_icon "$THEME" "$GTK4_FILE"
}

set_new_icon(){
   THEME="$1"
   FILENAME="$2"
   sed -i "s/^\(gtk-icon-theme-name=\).*/\1$THEME/" "$FILENAME"
}

select_icons(){
    themes=$(find /usr/share/icons -type f -name 'index.theme' -exec dirname {} \; | sort -u) 
    theme_array=()
    for theme in $themes; do
        theme_array+=("$(basename "$theme")")
    done
    posx=$(get_center_x "350")
    posy=$(get_center_y "350")
    themes_list=$(printf "%s\n" "${theme_array[@]}")
    selected_theme=$(echo "$themes_list" | yad --list --title="Selecione um tema de ícones" --column="Ícones" --height=400 --width=400 --posx=$posx --posy=$posy)    
    if [ $? -eq 0 ]; then
        icon=$(echo "$selected_theme" | cut -d'|' -f1)
        change_icon "$icon"
      	yad --info --title="Tema de ícones Alterado" --text="Tema de ícones alterado com sucesso! Reinicie o ambiente gráfico para visualizar as alterações!" --posx=$posx --posy=$posy
    fi
}

check_files
select_icons