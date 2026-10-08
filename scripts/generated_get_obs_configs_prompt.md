# Obtener configuraciones para OBS

Hola, necesito recomendaciones de configuración para **OBS Studio** basadas en este hardware y OS:

### Internet
- Subida: `71.33 Mbps`
- Bajada: `90.79 Mbps`

### HW Info
- Receptor de internet: Ethernet

PowerShell command:
```powershell
$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$gpu = Get-CimInstance Win32_VideoController
$ram = [math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)

Write-Output"OS: $($os.Caption) $($os.Version)"
Write-Output"CPU: $($cpu.Name)"
Write-Output"GPU: $($gpu.Name -join ', ')"
Write-Output"Memory: $ram GB"
Write-Output"Disks:"
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    $size = [math]::Round($_.Size / 1GB, 1)
    $free = [math]::Round($_.FreeSpace / 1GB, 1)
    Write-Output"  $($_.DeviceID) $size GB (Free: $free GB)"
}
Write-Output"Display: $($gpu.CurrentHorizontalResolution)x$($gpu.CurrentVerticalResolution)"
```

PowerShell Output:
```
OS: Microsoft Windows 11 Pro 10.0.26200
CPU: AMD Ryzen 5 3500X 6-Core Processor             
GPU: AMD Radeon RX 6400
Memory: 15.9 GB
Disks:
  C: 199.9 GB (Free: 85.4 GB)
  D: 500 GB (Free: 238 GB)
  E: 238.5 GB (Free: 52.3 GB)
Display: 1920x1080
```

### Por favor ayúdame a configurar OBS
#### Solicitud
- Recomendación para configuraciones de streaming.
- Recomendación para configuraciones de video local.

#### Objetivo del video/stream
- Resolución de salida: `720p`
- FPS: `20 FPS`
- Audio: Sin especificar. Por defecto esta bien.
- Contenido para: PeerTube

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
