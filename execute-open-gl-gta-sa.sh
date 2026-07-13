#!/bin/bash

export WINEPREFIX=$HOME/.wine-opengl
export MESA_GL_VERSION_OVERRIDE=4.6
export MESA_GLSL_VERSION_OVERRIDE=460
export mesa_glthread=true
WINEDLLOVERRIDES="dxgi=n, d3d9=n"

dir="$(dirname "$(realpath "$0")")"
game=$dir"/gta_sa_modloader_controller"
echo "Directorio de juego"; echo $game

exec_instruction="mangohud --dlsym \"$game\""
echo "Instrucción a ejecutar"; echo $exec_instruction
eval $exec_instruction

echo "Listo..."
