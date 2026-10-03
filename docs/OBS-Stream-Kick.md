# Configuración de OBS Studio para Kick (720p - Estable)

Configuración optimizada para GTA SA a **720p 20 FPS**, usando **solo CPU**, priorizando estabilidad con buena calidad.

> **Bitrate alto es obligatorio, no opcional.** Con `1100 kbps` la imagen se **pixela y se rompe en bloques** en cuanto hay movimiento rápido. El motivo es simple: **1100 kbps es demasiado bajo para 720p**, incluso a 20 FPS. Con tan pocos datos por segundo, en cuanto la pantalla cambia rápido el algoritmo de compresión de x264 no tiene espacio suficiente y destruye la imagen.
>
> Kick no aplica los límites estrictos que solía tener Twitch en cuentas no afiliadas, así que podemos subir el bitrate sin castigar la calidad.

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
| Bitrate | **`4000` a `4500 Kbps`** | **Multiplica por 4 los datos por fotograma.** Es el cambio clave para eliminar el bloqueado en movimiento rápido. |
| Keyframe Interval | `2s` | Estándar obligatorio en Kick. |
| CPU Usage Preset | `fast` o `faster` | Mantiene el uso de tu Ryzen 5 controlado aun con el bitrate alto. |
| Tune | `zerolatency` *(si juegas algo muy rápido)* o `Ninguno` | Reduce el retardo de compresión. |
| Profile | `high` | Activa algoritmos de compresión más avanzados. Costo de CPU casi nulo. |
| x264 Threads | `6` | Forzado a 6 hilos. Reparte mejor la carga entre OBS y el juego, dando más estabilidad. |

## 3. Advanced (Settings > Advanced)

| Opción | Valor | Explicación |
|---|---|---|
| Process Priority | `Above Normal` | Punto dulce para estabilidad. **No uses High**, puede quitarle prioridad al GTA SA. |
| x264 Options | `aq-mode=2 aq-strength=1.1` | Ver sección siguiente. |

### Opciones de x264 personalizadas

Si aun subiendo el bitrate a `4000+ kbps` notas pequeños artefactos en transiciones bruscas, añade esta línea en **x264 Options** dentro de la pestaña de Salida:

```text
aq-mode=2 aq-strength=1.1
```

- **`aq-mode=2` (Adaptive Quantization):** Distribuye los bits de forma inteligente entre las zonas planas y las zonas con mucho detalle/movimiento, evitando que los fondos en movimiento se destruyan visualmente.
- **`aq-strength=1.1`:** Intensidad de esa redistribución, ligeramente por encima del valor por defecto.


## 4. Recomendaciones para mantenerlo estable

- **Captura correcta según tu sistema.** En **Linux/Wayland**, evita depender de Game Capture (muchas veces no es estable). Usa **Window Capture** (captura de ventana) o **PipeWire Screen Capture / Desktop Capture** según lo que funcione mejor para tu entorno. **En Windows** sí puedes priorizar Game Capture. **Nunca uses Display Capture** de forma innecesaria (consume más CPU).
- **Sin grabación local.** Kick ya guarda el VOD automáticamente. No actives `Record` ni `Replay Buffer`.
- **Desactiva Preview mientras stremeas.** El preview consume CPU extra innecesario.
- **Escena lo más limpia posible.** Quita overlays, GIFs, fuentes animadas, transiciones o filtros pesados.
- **Un solo perfil/escena.** Entre menos fuentes activas tengas, más colchón de CPU te queda.
- **Velocidad de subida necesaria.** Para transmitir a `4000–4500 Kbps` sin interrupciones ni cuadros perdidos (frames drop en rojo), necesitas al menos **8–10 Mbps reales de subida** en tu conexión a Internet.

## Notas

Con `fast`/`faster + zerolatency + Profile: high + 4000–4500 Kbps + CBR` eliminas casi por completo el bloqueado/pixeleado en movimiento rápido. El equilibrio es estable para 720p 20 FPS con solo CPU.
