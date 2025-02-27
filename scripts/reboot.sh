#!/bin/bash

zenity --question --text="Deseja realmente reiniciar o PC?" --title="Reiniciar"

if [ $? -eq 0 ]; then
    systemctl reboot
fi