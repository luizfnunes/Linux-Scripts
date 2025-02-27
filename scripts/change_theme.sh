#!/bin/bash
GTK2_FILE="$HOME/.gtkrc-2.0"
GTK3_FILE="$HOME/.config/gtk-3.0/settings.ini"
GTK4_FILE="$HOME/.config/gtk-4.0/settings.ini"
OPENBOX_FILE="$HOME/.config/openbox/rc.xml"

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
    if [ ! -e "$OPENBOX_FILE" ]; then
        cat $HOME/.config/scripts/rc.xml > "$OPENBOX_FILE"
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

change_theme(){
    THEME="$1"
    set_new_theme "$THEME" "$GTK2_FILE"
    set_new_theme "$THEME" "$GTK3_FILE"
    set_new_theme "$THEME" "$GTK4_FILE" 
}

set_new_theme(){
   THEME="$1"
   FILENAME="$2"
   sed -i "s/^\(gtk-theme-name=\).*/\1$THEME/" "$FILENAME"
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

change_ob_theme(){
    THEME="$1"
    set_new_ob_theme "$THEME" "$OPENBOX_FILE"
    openbox --reconfigure
}

set_new_ob_theme(){
    THEME="$1"
    FILENAME="$2"
    sed -i "/<theme>/,/<\/theme>/s|<name>[^<]*</name>|<name>$THEME</name>|" "$FILENAME"
}

select_theme(){
    echo "Selecione um tema para alterar:"
    themes=$(find /usr/share/themes -type d -name 'gtk-*' -exec dirname {} \; | sort -u)  
    #theme_array=($themes)
    theme_array=()
    theme_array+=("Sair")
    for theme in $themes; do
        theme_array+=("$(basename "$theme")")
    done
    select theme in "${theme_array[@]}"; do
        if [ "$theme" == "Sair" ]; then
            echo "Encerrando..."
            break
        elif [ -n "$theme" ]; then
            change_theme "$theme"
            echo "Você selecionou o tema: $theme. Reinicie para aplicar o tema."
            break
        else
        
            echo "Opção inválida, por favor, selecione uma opção válida."
        fi
    done
}

check_files
select_theme
#change_theme "Adapta-Eta"
#change_icon "Papirus-Apps"
#change_ob_theme "Onyx"

openbox --reconfigure
