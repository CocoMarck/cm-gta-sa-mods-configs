# Configuración de OBS Studio para Kick (720p - Estable)

Configuración optimizada para GTA SA a **720p 20 FPS**, usando **solo CPU**, priorizando estabilidad con buena calidad.

## 1. Video (Settings > Video)

| Opción | Valor | Explicación |
|---|---|---|
| Base (Canvas) Resolution | `1280x720` | 720p directo, evita reescalado innecesario. |
| Output (Scaled) Resolution | `1280x720` | Mismo valor para reducir carga de CPU. |
| Downscale Filter | `Bicubic` | Buen balance entre nitidez y estabilidad. |
| Common FPS Values | `20` | Reduce mucho la carga de CPU y sigue fluido para gameplay. |

## 2. Output > Streaming (Settings > Output > Streaming)

| Opción | Valor | Explicación |
|---|---|---|
| Service | `Kick` | Plataforma a usar. |
| Server | `Auto` | Déjalo automático, funciona bien. |
| Stream Key | (Tu Stream Key de Kick > Creator Dashboard) | **Nunca lo compartas.** |
| Encoder | `x264 (Software)` | Obligatorio al no poder usar GPU. |
| Rate Control | `CBR` | Más estable para directo. Evita picos de bitrate. |
| Bitrate | `1000 Kbps` | Óptimo para 720p 20 FPS. Da buen equilibrio entre calidad y estabilidad. |
| Keyframe Interval | `2s` | Requisito estándar en Kick. |
| CPU Usage Preset | `veryfast` | **Perfecto aquí.** Estable en tu Ryzen 5 3500X y mejora mucho el movimiento vs `ultrafast`. |
| Tune | `zerolatency` | Mantiene el stream estable y con menor buffer. Ideal para priorizar estabilidad. |
| Profile | `high` | Mejor compresión y menos artefactos. Costo de CPU casi nulo con este preset. |
| x264 Threads | `6` | Forzado a 6 hilos. Reparte mejor la carga entre OBS y el juego, dando más estabilidad. |

## 3. Advanced (Settings > Advanced)

| Opción | Valor | Explicación |
|---|---|---|
| Process Priority | `Above Normal` | Punto dulce para estabilidad. **No uses High**, puede quitarle prioridad al GTA SA. |
| x264 Options | (Vacío) | No hace falta rellenar nada. |

## 4. Recomendaciones para mantenerlo estable

- **Usa Game Capture.** Obligatorio. **Nunca** uses Display Capture, consume mucho más CPU.
- **Sin grabación local.** Kick ya guarda el VOD automáticamente. No actives `Record` ni `Replay Buffer`.
- **Desactiva Preview mientras stremeas.** El preview consume CPU extra innecesario.
- **Escena lo más limpia posible.** Quita overlays, GIFs, fuentes animadas, transiciones o filtros pesados.
- **Un solo perfil/escena.** Entre menos fuentes activas tengas, más colchón de CPU te queda.

## Notas

Con `veryfast + zerolatency + Profile: high + 1000 Kbps` consigues el mejor **balance estabilidad/calidad** para 720p 20 FPS solo con CPU. Es el setup más recomendable para evitar picos y mantenerlo fluido.