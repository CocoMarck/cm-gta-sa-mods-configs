# Configuración de OBS Studio: 1080p / 10 FPS (Modo Debug)

Para transmitir a **1080p a 10 fps** sin que se rompa la imagen en movimientos rápidos y manteniendo un consumo de CPU sumamente bajo, la estrategia cambia: al bajar los fotogramas a 10 fps, el procesador trabaja poquísimo en codificación, pero necesitas **bitrate y espacio entre fotogramas clave ajustados** para mantener la coherencia del video.

Configuración optimizada para modo debug en **1080p / 10 fps**. Esta configuración es **compatible con cualquier servicio de streaming** (Kick, Twitch, YouTube, etc.).

## 1. Video (Settings > Video)

| Opción | Valor | Explicación |
|---|---|---|
| Base (Canvas) Resolution | `1920x1080` | Resolución nativa, sin escalado innecesario. |
| Output (Scaled) Resolution | `1920x1080` | Sin escalado para ahorrar carga de CPU. |
| Downscale Filter | `Bicubic` | No aplica al no escalar, pero se puede dejar por defecto. |
| Common FPS Values | `10` | FPS reducido para minimizar carga de CPU. |

## 2. Output > Streaming (Settings > Output > Streaming)

| Parámetro | Valor recomendado | Razón técnica |
|---|---|---|
| **Control de la frecuencia (Rate Control)** | `CBR` | Exigido por las plataformas de streaming. Más estable para directo. |
| **Tasa de bits (Bitrate)** | **`4000 kbps` a `5000 kbps`** | Al ser solo 10 fps, 5000 kbps le da **500 kb por fotograma** (suficiente para que un render 1080p completo no se bloquee). |
| **Intervalo de keyframes (Keyframe Interval)** | `2 s` | Fuerza un fotograma completo cada 20 fotogramas (2 segundos a 10 fps). |
| **Preset de CPU (CPU Usage Preset)** | **`veryfast`** o **`faster`** | Mantiene el consumo de CPU bajísimo. |
| **Perfil (Profile)** | `high` | Indispensable para compresión 1080p. |
| **Sintonizar (Tune)** | `zerolatency` | **Clave para modo debug:** elimina el búfer de fotogramas, reduciendo la latencia de codificación al mínimo absoluto. |
| **Encoder** | `x264 (Software)` | Recomendado para este enfoque. |

## 3. Opciones de x264 personalizadas (Advanced)

Copia y pega este comando en la casilla **x264 Options**:

```text
keyint=20 min-keyint=10 no-scenecut=1 aq-mode=2 aq-strength=1.1
```

* **`keyint=20`:** Como transmites a 10 fps, esto le indica al codificador que haga un Keyframe estricto cada 20 fotogramas (2 segundos). Evita que los cambios bruscos deformen el video por falta de imágenes clave.
* **`min-keyint=10`:** Permite cierta flexibilidad mínima sin romper la estructura forzada.
* **`no-scenecut=1`:** Evita que el codificador inserte keyframes extraños en saltos de pantalla rápidos, manteniendo estable el uso de CPU y de red.
* **`aq-mode=2` (Adaptive Quantization):** Distribuye los bits inteligentemente entre zonas planas y zonas con mucho detalle/movimiento.
* **`aq-strength=1.1`:** Refuerza esa distribución para reducir artefactos en transiciones bruscas.

## 4. Recomendaciones

- **Captura correcta según tu sistema.** En **Linux/Wayland**, usa **Window Capture** (captura de ventana) o **PipeWire Screen Capture / Desktop Capture** según lo que funcione mejor para tu entorno. En Windows puedes priorizar Game Capture. Nunca uses Display Capture de forma innecesaria (consume más CPU).
- **Desactiva Preview mientras stremeas.** El preview consume CPU extra innecesario.
- **Sin grabación local.** No actives `Record` ni `Replay Buffer` a menos que sea estrictamente necesario.

## Impacto estimado en CPU

* **Uso de CPU estimado:** **5% – 12%** total del sistema.
* **Razonamiento:** 1080p a 10 fps son ~20.7 millones de pixeles/segundo. Es prácticamente el mismo volumen de datos que procesar 720p a 20 fps, por lo que el procesador ni lo sentirá aunque uses `faster`.

Esta configuración es ideal para modo debug, ya que prioriza la estabilidad y la latencia mínima sobre la fluidez máxima de fotogramas.
