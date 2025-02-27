#!/bin/bash

zenity --question --text="Deseja realmente encerrar a sessão?" --title="Logout"

if [ $? -eq 0 ]; then
    openbox --exit
fi