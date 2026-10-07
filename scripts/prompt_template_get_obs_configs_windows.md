# Obtener configuraciones para OBS

Hola, necesito recomendaciones de configuración para **OBS Studio** basadas en este hardware y OS:

### Internet
- Subida: `$internet_upload Mbps`
- Bajada: `$internet_download Mbps`

### HW Info
- Receptor de internet: $internet_receptor

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
$powershell_output
```

### Por favor ayúdame a configurar OBS
#### Solicitud
- Recomendación para configuraciones de streaming.
- Recomendación para configuraciones de video local.

#### Objetivo del video/stream
- Resolución de salida: `$resolution`
- FPS: `$fps FPS`
- Audio: $audio_indications
- Contenido para: $multimedia_servicies

#### Configuraciones
- Tipo de stream: $stream_type.

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
