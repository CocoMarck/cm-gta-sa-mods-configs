@echo off
setlocal enabledelayedexpansion

rem =====================================================================
rem  Prompt OBS - Windows (Win >= 10)
rem  Equivalente Windows de prompt_get_obs_configs.sh
rem  Genera el prompt a partir de prompt_template_get_obs_configs_windows.md
rem
rem  Dependencias (ya vienen con Windows 10, NO instala nada):
rem    - powershell.exe  info del hardware y conversion de velocidad
rem    - curl.exe        medicion de red (incluido desde Windows 10 1803)
rem  Si falta alguna, se usa "No se" en lugar de abortar.
rem
rem  Flags al estilo Windows (tambien acepta -flag / --flag):
rem    /u /d /r /f /n /c /s /a /o /?      (ver :usage)
rem =====================================================================

set "SCRIPT_DIR=%~dp0"
set "PROMPT_TEMPLATE=%SCRIPT_DIR%prompt_template_get_obs_configs_windows.md"

rem ------------------------ valores por defecto ------------------------
set "internet_upload="
set "internet_download="
set "internet_receptor=Ethernet"
set "resolution=720p"
set "fps=20"
set "multimedia_servicies=PeerTube"
set "stream_type=Unilateral"
set "audio_indications=Sin especificar. Por defecto esta bien."
set "output="
set "HWFILE="
set "SPEEDFILE="
set "HAVE_PS=0"
set "HAVE_CURL=0"

rem ------------------------ argumentos ------------------------
:parse_args
if "%~1"=="" goto :args_done
set "arg=%~1"
if "!arg:~0,2!"=="--" set "arg=/%arg:~2%"
if "!arg:~0,1!"=="-"  set "arg=/%arg:~1%"
if /i "!arg!"=="/u"    (set "internet_upload=%~2" & shift & shift & goto :parse_args)
if /i "!arg!"=="/d"    (set "internet_download=%~2" & shift & shift & goto :parse_args)
if /i "!arg!"=="/r"    (set "internet_receptor=%~2" & shift & shift & goto :parse_args)
if /i "!arg!"=="/f"    (set "resolution=%~2" & shift & shift & goto :parse_args)
if /i "!arg!"=="/n"    (set "fps=%~2" & shift & shift & goto :parse_args)
if /i "!arg!"=="/c"    (set "multimedia_servicies=%~2" & shift & shift & goto :parse_args)
if /i "!arg!"=="/s"    (set "stream_type=%~2" & shift & shift & goto :parse_args)
if /i "!arg!"=="/a"    (set "audio_indications=%~2" & shift & shift & goto :parse_args)
if /i "!arg!"=="/o"    (set "output=%~2" & shift & shift & goto :parse_args)
if /i "!arg!"=="/?"    goto :show_help
if /i "!arg!"=="/h"    goto :show_help
if /i "!arg!"=="/help" goto :show_help
echo Opcion desconocida: %~1 1>&2
call :usage 1>&2
exit /b 1

:show_help
call :usage
exit /b 0

:args_done

rem ------------------------ dependencias ------------------------
where powershell.exe >nul 2>&1 && set "HAVE_PS=1"
where curl.exe >nul 2>&1 && set "HAVE_CURL=1"
if "%HAVE_PS%"=="0" echo Aviso: no se encontro powershell.exe. Sin info de hardware. 1>&2

rem ------------------------ info del hardware ------------------------
if not "%HAVE_PS%"=="1" goto :hw_done
set "HWFILE=%TEMP%\obs_hw_%RANDOM%%RANDOM%.txt"
powershell -NoProfile -Command "[System.Threading.Thread]::CurrentThread.CurrentCulture = [cultureinfo]::InvariantCulture; $os = Get-CimInstance Win32_OperatingSystem; $cpu = Get-CimInstance Win32_Processor; $gpu = Get-CimInstance Win32_VideoController; $ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1); Write-Output ('OS: ' + $os.Caption + ' ' + $os.Version); Write-Output ('CPU: ' + $cpu.Name); Write-Output ('GPU: ' + ($gpu.Name -join ', ')); Write-Output ('Memory: ' + $ram + ' GB'); Write-Output 'Disks:'; Get-CimInstance Win32_LogicalDisk -Filter 'DriveType=3' | ForEach-Object { Write-Output ('  ' + $_.DeviceID + ' ' + [math]::Round($_.Size / 1GB, 1) + ' GB (Free: ' + [math]::Round($_.FreeSpace / 1GB, 1) + ' GB)') }; Write-Output ('Display: ' + $gpu.CurrentHorizontalResolution + 'x' + $gpu.CurrentVerticalResolution)" > "%HWFILE%"
if not exist "%HWFILE%" set "HWFILE="
if defined HWFILE for %%A in ("%HWFILE%") do if %%~zA==0 set "HWFILE="
:hw_done

rem ------------------------ velocidad de red ------------------------
if defined internet_upload if defined internet_download goto :speed_done
if not "%HAVE_CURL%"=="1" goto :no_net
if not "%HAVE_PS%"=="1" goto :no_net
echo Midiendo velocidad de red (Cloudflare)... 1>&2
set "SPEEDFILE=%TEMP%\obs_speed_%RANDOM%%RANDOM%.txt"
powershell -NoProfile -Command "[System.Threading.Thread]::CurrentThread.CurrentCulture = [cultureinfo]::InvariantCulture; function M($s){ $v=0.0; if($s -and [double]::TryParse($s,[Globalization.NumberStyles]::Float,[cultureinfo]::InvariantCulture,[ref]$v)){ $x=$v*8/1e6; if($x -gt 0){ return [math]::Round($x,2).ToString([cultureinfo]::InvariantCulture) } }; return 'No se' }; $d = curl.exe -o NUL -sS -w '%%{speed_download}' --max-time 120 --retry 2 'https://speed.cloudflare.com/__down?bytes=30000000'; $f = [IO.Path]::GetTempFileName(); [IO.File]::WriteAllBytes($f, (New-Object byte[] 40000000)); $u = curl.exe -o NUL -sS -w '%%{speed_upload}' --max-time 120 -X POST --data-binary ('@' + $f) 'https://speed.cloudflare.com/__up'; Remove-Item $f -Force -ErrorAction SilentlyContinue; '{0}|{1}' -f (M $d), (M $u)" > "%SPEEDFILE%"
if not exist "%SPEEDFILE%" set "SPEEDFILE="
if defined SPEEDFILE for %%A in ("%SPEEDFILE%") do if %%~zA==0 set "SPEEDFILE="
if not defined SPEEDFILE goto :no_net

set "MEASURED_DL="
set "MEASURED_UL="
for /f "usebackq tokens=1,2 delims=|" %%A in ("%SPEEDFILE%") do (
    set "MEASURED_DL=%%A"
    set "MEASURED_UL=%%B"
)
if not defined internet_download if defined MEASURED_DL set "internet_download=!MEASURED_DL!"
if not defined internet_upload if defined MEASURED_UL set "internet_upload=!MEASURED_UL!"
goto :speed_done

:no_net
echo Aviso: no pude medir la red. Usa /u y /d, o quedara "No se". 1>&2

:speed_done
if not defined internet_download set "internet_download=No se"
if not defined internet_upload set "internet_upload=No se"

rem ------------------------ archivo de salida ------------------------
if not defined output set "output=%SCRIPT_DIR%generated_get_obs_configs_prompt.md"

if not exist "%PROMPT_TEMPLATE%" (
    echo No existe el template: %PROMPT_TEMPLATE% 1>&2
    call :cleanup
    exit /b 1
)

rem --------------------------------------------------------------------
rem  Render:
rem  Se recorre el template con findstr /n para no perder las lineas
rem  vacias. Los tokens %var% se reemplazan con valores de variables.
rem  Para buscar el token literal "%var%" sin que cmd lo expanda, se usa
rem  una variable auxiliar T_x cuyo valor es exactamente "%var%"
rem  (por eso se escribe con %%var%% al asignarla).
rem --------------------------------------------------------------------

set "T_internet_upload=%%internet_upload%%"
set "T_internet_download=%%internet_download%%"
set "T_internet_receptor=%%internet_receptor%%"
set "T_resolution=%%resolution%%"
set "T_fps=%%fps%%"
set "T_multimedia_servicies=%%multimedia_servicies%%"
set "T_stream_type=%%stream_type%%"
set "T_audio_indications=%%audio_indications%%"
set "T_powershell_output=%%powershell_output%%"

if exist "%output%" del /q "%output%" >nul 2>&1

for /f "usebackq delims=" %%L in (`findstr /n "^" "%PROMPT_TEMPLATE%"`) do (
    set "line=%%L"
    set "line=!line:*:=!"
    if "!line!"=="%T_powershell_output%" (
        if defined HWFILE type "%HWFILE%" >> "%output%"
    ) else (
        if defined line (
            set "line=!line:%T_internet_upload%=%internet_upload%!"
            set "line=!line:%T_internet_download%=%internet_download%!"
            set "line=!line:%T_internet_receptor%=%internet_receptor%!"
            set "line=!line:%T_audio_indications%=%audio_indications%!"
            set "line=!line:%T_multimedia_servicies%=%multimedia_servicies%!"
            set "line=!line:%T_stream_type%=%stream_type%!"
            set "line=!line:%T_resolution%=%resolution%!"
            set "line=!line:%T_fps%=%fps%!"
        )
        echo(!line!>>"%output%"
    )
)

if not exist "%output%" (
    echo Error: no se pudo escribir %output% 1>&2
    call :cleanup
    exit /b 1
)

call :cleanup
echo Prompt escrito en: %output% 1>&2
type "%output%"
exit /b 0

rem ------------------------ limpieza ------------------------
:cleanup
if defined HWFILE del /q "%HWFILE%" >nul 2>&1
if defined SPEEDFILE del /q "%SPEEDFILE%" >nul 2>&1
exit /b 0

rem ------------------------ ayuda ------------------------
:usage
echo.
echo Uso: prompt_get_obs_configs.bat [opciones]
echo.
echo     /u VALOR    Subida en Mbps        (default: mide con curl)
echo     /d VALOR    Bajada en Mbps        (default: mide con curl)
echo     /r TEXTO    Medio de conexion     (default: Ethernet)
echo     /f TEXTO    Resolucion de salida  (default: 720p)
echo     /n NUM      FPS                   (default: 20)
echo     /c TEXTO    Plataformas/contenido (default: PeerTube)
echo     /s TEXTO    Tipo de stream        (default: Unilateral)
echo     /a TEXTO    Indicaciones para audio
echo     /o ARCHIVO  Escribe el archivo    (default: generated_get_obs_configs_prompt.md)
echo(    /?          Esta ayuda
echo.
echo Tambien acepta -flag o --flag como alias (ej. -u, --help).
echo.
echo Ejemplos:
echo     prompt_get_obs_configs.bat
echo     prompt_get_obs_configs.bat /u 90 /d 90 /r "Wifi" /s Multistream /c "PeerTube, Kick" /f "1080p" /n "20" -a "Stream musical"
echo.
exit /b 0