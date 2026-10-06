# Prompt template para pedir mejor config para PC.

### Información para el lector humano
> Remplaza la información según tu PC. Este prompt lo escribí para mi PC (2026).
> Si quieres hacer stream de musical, mencionarlo en la linea `- Audio:`
> Es un prompt. Cambia lo que se te de la gana. Eso si, no mientas con el HW y SW. Esta información es la base con la que trabajara la AI.
> Solo existen dos tipos de streaming: Unilateral, Multistream. Pos que en una plataforma, o en varias plataformas.

--- 

Hola, necesito recomendaciones de configuración para **OBS Studio** basadas en este hardware y OS:

### Internet
- Subida: `99 Mbps`
- Bajada: `97 Mbps`

### SW info
Uso el sistema operativo `Debian 13`. Dale prioridad a la información relacionada con este OS.

### HW Info
- Uso ethernet

#### GNU/Linux: 

Command:
```bash
fastfetch -s os:kernel:de:wm:cpu:gpu:memory:disk:display --logo none
```

Output:
```
OS: Debian GNU/Linux 13 (trixie) x86_64
Kernel: Linux 6.12.101+deb13-amd64
DE: KDE Plasma 6.3.6
WM: KWin (Wayland)
CPU: AMD Ryzen 5 3500X (6) @ 4.12 GHz
GPU: AMD Radeon RX 6400 [Discrete]
Memory: 9.53 GiB / 15.55 GiB (61%)
Disk (/): 209.68 GiB / 271.53 GiB (77%) - ext4
Disk (/media/public/500gb-games-ext4): 261.49 GiB / 445.68 GiB (59%) - ext4
Disk (/media/public/500gb-games-ntfs): 262.04 GiB / 500.00 GiB (52%) - ntfs3
Disk (/media/public/SSD-256): 186.15 GiB / 238.46 GiB (78%) - exfat
Display (MSI MP223): 1920x1080 @ 100 Hz in 21" [External]
```

#### Windows >= 10
PowerShell Command:
```powershell
Write-Host "OS: $((Get-CimInstance Win32_OperatingSystem).Caption) $((Get-CimInstance Win32_OperatingSystem).Version)"
Write-Host "CPU: $((Get-CimInstance Win32_Processor).Name)"
Write-Host "GPU: $((Get-CimInstance Win32_VideoController).Name -join ', ')"
Write-Host "Memory: $([math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)) GB"
Write-Host "Disks:"
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    $size = [math]::Round($_.Size / 1GB, 1)
    $free = [math]::Round($_.FreeSpace / 1GB, 1)
    Write-Host "  $($_.DeviceID) $size GB (Free: $free GB)"
}
Write-Host "Display: $((Get-CimInstance Win32_VideoController).CurrentHorizontalResolution)x$((Get-CimInstance Win32_VideoController).CurrentVerticalResolution)"
```

Output:
```
(Output generado)
OS: Microsoft Windows 11 Pro 10.0.26100
CPU: AMD Ryzen 5 3500X 6-Core Processor (6 cores / 6 threads)
GPU: AMD Radeon RX 6400
Memory: 16 GB
Disks:
  C: 476.9 GB (Free: 312.4 GB) - NVMe
  D: 465.7 GB (Free: 189.2 GB) - SSD
Display: 1920x1080 @ 100 Hz
```

### Por favor ayúdame a configurar OBS
#### Solicitud
- Recomendación para configuración de streaming.
- Recomendación para configuración de video.

#### Objetivo del video/stream
- Resolución de salida: `720p`
- FPS: `20 fps`.
- Audio: Sin especificar (por defecto suele estar bien)
- Contenido para: Kick, PeerTube, Facebook, BiliBili, tiktok.

#### Configuraciones
- Tipo de stream: Unilateral.

**Para Streaming**
1. Configuración para imagen estable, y sin que se trabe el streaming. Punto intermedio entre configuraciones dos y tres.
2. Configuración en prioridad de imagen estable, sin perdida de calidad, máxima calidad sin importar compresión.
3. Configuración en prioridad de streaming sin trabarse.

**Para grabación de video local**
1. Equilibrada -> calidad de imagen aceptable, no mucho uso de PC, no mucho peso de video.
2. Prioridad a bajo uso de PC -> Calidad de imagen aceptable. Sacrificando espacio.
3. Prioridad calidad -> Sacrificando poder, pero no peso, ese debe ser aceptable.

#### Detalles
- Si crees que el PC es low-spec o hight-spec para el objetivo del video/stream, mencionado de manera breve. Y recomienda un objetivo equilibrado entre calidad, y rendimiento, también de manera breve.
- Cuando digo "trabarse" me refiero a cortes o freezes en el stream (encoding lag o network drops)
- Menciona lo relacionado a plataformas especificas al final.