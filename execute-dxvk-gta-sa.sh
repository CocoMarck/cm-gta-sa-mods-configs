#!/bin/bash

export WINEPREFIX="$HOME/.wine"; 

dir="$(dirname "$(realpath "$0")")"
game=$dir"/gta_sa_modloader_controller"
echo "Directorio de juego"; echo $game

exec_instruction="mangohud \"$game\""
echo "Instrucción a ejecutar"; echo $exec_instruction
eval $exec_instruction

echo "Listo..."
