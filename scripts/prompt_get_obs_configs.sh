#!/bin/bash
# Script para escribir un prompt para un agente AI. Que servirá para obtener configuraciones adecuadas para HW y SW del usuario.
# Dependencias: fastfetch, curl.
set -euo pipefail

# Constantes
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
PROMPT_TEMPLATE="$SCRIPT_DIR/prompt_template_get_obs_configs.md"

# Variables necesarias
export fastfetch_output=""
export internet_upload=""
export internet_download=""
export internet_receptor="Ethernet"
export resolution="720p"
export fps="20"
export multimedia_servicies="PeerTube"
export stream_type="Unilateral"
export audio_indications="Sin especificar. Por defecto esta bien."
output=""

# Funciones
usage() {
    cat <<'USAGE'
Uso: prompt_get_obs_configs.sh [opciones]
    
    -u MB       Subida en Mbps          (default: mide con curl)
    -d MB       Bajada en Mbps          (default: mide con curl)
    -r TEXTO    Medio de conexión       (default: Ethernet)
    -f TEXTO    Resolución de salida    (default: 720p)
    -n NUM      FPS                     (default: 20)
    -c TEXTO    Plataformas/contenido   (default: PeerTube)
    -s TEXTO    Tipo de stream          (default: Unilateral)
    -a TEXTO    Indicaciones para audio
    -o ARCHIVO  Escribe el archivo      
                (default: stdout, y escribe "generated_get_obs_configs_prompt.md")
    -h          Esta ayuda

Ejemplos:
    ./prompt_get_obs_configs.sh
    ./prompt_get_obs_configs.sh -u 90 -d 90 -r "Wifi" -s Multistream -c "PeerTube" -f "1080p" -n "20" -a "Stream musical"

USAGE
}

# Funciones Internet
measure_download() {
    curl -o /dev/null -sS -w '%{speed_download}' --max-time 60 --retry 2 \
        'https://speed.cloudflare.com/__down?bytes=30000000'
}
measure_upload() {
    set +o pipefail
    head -c 40000000 /dev/zero \
        | curl -o /dev/null -sS -w '%{speed_upload}' --max-time 60 \
            -X POST --data-binary @- 'https://speed.cloudflare.com/__up'
    local st=$?
    set -o pipefail
    return $st
}
bytes_to_mbps(){
    # Es que curl obtiene en B/s.
    awk -v b="$1" 'BEGIN { m=(b*8)/1000000; if (m>0) printf "%.2f", m; else printf "0"}'
}


# Funciones fastfetch
run_fastfetch() {
    fastfetch -s os:kernel:de:wm:cpu:gpu:memory:disk:display --logo none
}

# Funciones obtener texto
get_prompt_template_string() {
    cat "$PROMPT_TEMPLATE"
}

# Funciones remplazar texto
render() {
    envsubst <"$PROMPT_TEMPLATE"
}


# ------------ args
while getopts u:d:r:f:n:c:s:a:o:h flag
do
    case "$flag" in
        u) internet_upload=${OPTARG};;
        d) internet_download=${OPTARG};;
        r) internet_receptor=${OPTARG};;
        s) stream_type=${OPTARG};;
        f) resolution=${OPTARG};;
        n) fps=${OPTARG};;
        a) audio_indications=${OPTARG};;
        c) multimedia_servicies=${OPTARG};;
        o) output=${OPTARG};;
        h) usage; exit 0;;
        ?) usage >&2; exit 1;;
    esac
done

# Obtener o no default
if [ -z "$fastfetch_output" ]; then
    echo "Obtener output de fastfetch"
    fastfetch_output=$(run_fastfetch)
fi

if [ -z "$internet_upload" ]; then
    echo "Obtener velocidad de subida"
    bs_upload=$(measure_upload)
    internet_upload=$(bytes_to_mbps $bs_upload)
fi
if [ -z "$internet_download" ]; then
    echo "Obtener velocidad de descarga"
    internet_download=$(bytes_to_mbps $(measure_download))
fi

if [ -z "$output" ]; then
    echo "Generar archivo por defecto"
    output="$SCRIPT_DIR/generated_get_obs_configs_prompt.md"
fi

# Debug
#echo -e "$fastfetch_output\n$internet_download\n$internet_upload\n$output"

# Remplazar texto de tamplate y guardar texto
text=$(render)
echo -e "$text"
echo -e "$text" > "$output"
