#!/bin/bash

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
posx=$(get_center_x "200")
posy=$(get_center_y "100")
if yad --question --title="Logout" --text="Deseja encerrar a sessão atual?" --width=200 --height=100 --posx=$posx --posy=$posy; then
    openbox --exit
fi