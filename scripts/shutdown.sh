#!/bin/bash

zenity --question --text="Deseja realmente desligar o PC?" --title="Desligar"

if [ $? -eq 0 ]; then
    systemctl poweroff
fi