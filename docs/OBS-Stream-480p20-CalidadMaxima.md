# Configuración de OBS Studio: 480p / 20 FPS (Calidad Máxima)

Para obtener la **máxima calidad visual absoluta en 480p a 20 fps** reduciendo al mínimo la pixeleación y compresión sin importar si el juego o la pantalla se mueven rápido, la estrategia es aprovechar que la resolución es pequeña para meter un preset de CPU más pesado y un bitrate sobradísimo.

Al transmitir a 480p con 20 fps, el procesador trabaja tan holgado que puedes exigirle a la compresión `x264` que haga su mejor trabajo sin ahogar a tu Ryzen 5. Esta configuración es **compatible con cualquier servicio de streaming** (Kick, Twitch, YouTube, etc.).

> **Configuración de referencia verificada.** La config de producción sin tirones en este equipo es [`OBS-Stream-Kick.md`](./OBS-Stream-Kick.md) (720p @ 20 fps, x264 `superfast`, `threads=0 rc-lookahead=10`, tune `(Ninguno)`). Este documento es la variante 480p20 de calidad máxima. Ojo: **nunca uses `zerolatency`** — rompe el búfer y produce tirones en el reproductor.

## ⚠️ REGLA PERMANENTE: escalar SOLO en la pestaña Video

**Aplica esto siempre, en cualquier configuración de OBS de este equipo:**

| Dónde | Ajuste | Valor |
|---|---|---|
| **Pestaña Salida** (Output > Emisión) | **Cambiar escala / Escalar la salida (Rescale Output)** | **DESACTIVADO — siempre, nunca lo marques** |
| **Pestaña Video** (Settings > Video) | **Lienzo (Base) → Salida (Scaled)** | **Escalar AQUÍ** (ej. `1920x1080` → `854x480`) + filtro de escalado |

**Por qué:** si marcas la casilla en la pestaña Salida, OBS **vuelve a escalar el vídeo una segunda vez por CPU**, además del escalado de la pestaña Video. Son **procesos duplicados**: compiten con el juego por la CPU, retrasan los fotogramas y producen tirones.

> El escalado ocurre **una sola vez**, en la pestaña Video. La pestaña Salida solo se encarga de codificar y enviar.


## 1. Video (Settings > Video)

| Opción | Valor | Explicación |
|---|---|---|
| Base (Canvas) Resolution | `1920x1080` | Resolución nativa de tu monitor (ej. 1920x1080). No es necesario cambiar el lienzo. |
| Output (Scaled) Resolution | `854x480` | Para relación de aspecto 16:9 estándar (480p). |
| Downscale Filter | **`Lanczos`** *(36 samples)* | Al reducir de 1080p a 480p, Lanczos es fundamental para evitar que las letras pequeñas o líneas finas de código/debug se vuelvan borrosas. |
| Common FPS Values | `20` | FPS estable y ligero. |

## 2. Output > Streaming (Settings > Output > Streaming)

| Parámetro | Valor para Calidad Máxima | Explicación |
|---|---|---|
| **Control de la frecuencia (Rate Control)** | `CBR` | Exigido por plataformas de streaming. |
| **Tasa de bits (Bitrate)** | **`2500 kbps` a `3000 kbps`** | Para 480p a 20 fps, esto es una densidad enorme de datos por píxel (casi calidad sin pérdida por compresión de red). |
| **Intervalo de keyframes (Keyframe Interval)** | `2 s` | Estándar de transmisión. |
| **Preset de CPU (CPU Usage Preset)** | **`slow`** (o **`medium`** si tu CPU está más justo) | Como 480p20 requiere poquísimos píxeles por segundo, puedes usar `slow`. Aplica los algoritmos de búsqueda visual más profundos para eliminar parpadeos y macrobloques. |
| **Perfil (Profile)** | `high` | Fuerza la matriz de cuantización más detallada. |
| **Sintonizar (Tune)** | **`(Ninguno)`** | No uses `film` ni `zerolatency` con el resto de esta tabla. `film` alarga el búfer de análisis y `zerolatency` lo rompe: ambos causan tirones aquí. Si aun así quieres un extra de detalle fino, baja el bitrate en vez de tocar el tune. |
| **Escalar la salida (Rescale Output)** | **DESMARCADO** | El escalado se hace una sola vez en la pestaña Video. Marcado aquí duplica el trabajo en CPU. |
| **Encoder** | `x264 (Software)` | Óptimo para este enfoque. La RX 6400 no tiene codificador H.264 dedicado. |

## 3. Opciones de x264 personalizadas (Advanced)

Copia y pega exactamente la siguiente cadena en el campo **x264 Options**:

```text
threads=0 rc-lookahead=10 aq-mode=2 aq-strength=1.3 subme=9 me=umh
```

* **`threads=0`:** x264 detecta solo los 6 hilos reales del Ryzen 5 3500X (sin SMT). No fuerces un número manual de hilos.
* **`rc-lookahead=10`:** Acota el búfer de análisis a 10 fotogramas. Sin esto, los tunes pesados de x264 acumulan fotogramas y el stream se corta.
* **`aq-mode=2` y `aq-strength=1.3`:** Le da prioridad de bits a los textos pequeños, líneas finas e interfaces para que no se vuelvan borrosas en movimiento.
* **`subme=9`:** Activa subpixel motion estimation muy preciso, mejorando nitidez en detalles finos.
* **`me=umh` (Uneven Multi-Hexagon):** Método avanzado de estimación de movimiento por píxel. Proporciona la mejor calidad posible con un coste de CPU mínimo para esta baja resolución.

## 4. Recomendaciones

- **Captura correcta según tu sistema.** En **Linux/Wayland (KDE Plasma 6.3.6 sobre KWin)**, usa **PipeWire Window/Screen Capture** o **`obs-vkcapture`**; son los únicos que evitan la desincronización de fotogramas en la composición de KWin. En Windows puedes priorizar Game Capture. Nunca uses Display Capture de forma innecesaria (consume más CPU).
- **Desactiva Preview mientras stremeas.** El preview consume CPU extra innecesario.
- **Escena lo más limpia posible.** Quita overlays, GIFs, fuentes animadas, transiciones o filtros pesados innecesarios para maximizar el ancho de banda disponible para la imagen.
- **Sin grabación local.** No actives `Record` ni `Replay Buffer` a menos que sea estrictamente necesario.

## Impacto estimado en CPU

* **Uso en Ryzen 5 (y CPUs modernas):** **~8% a 15%** (incluso con preset `slow`).
* **Razonamiento:** **480p a 20 fps** procesa solo **~8.2 millones de píxeles por segundo**. Eso es menos del **7%** de lo que procesa un stream 1080p a 60 fps. Para cualquier procesador moderno (Ryzen 5000/7000, Intel Core 12ª generación en adelante), esto es literalmente insignificante.

### ¿Es "pesado" para el procesador?

No. Aunque el preset `slow` requiere más ciclos por píxel, la cantidad total de píxeles es diminuta. Las CPUs modernas terminan ese trabajo casi al instante y tienen mucho colchón libre. Esto hace que esta configuración sea perfecta para transmitir interfaces, logs, datos de debug o pruebas de rendimiento **sin robarle ciclos de CPU a lo que estés ejecutando en primer plano**.

### Ventaja adicional: Bajo costo para el viewer

La gran ventaja de **480p a 20 fps con alta calidad** no es solo el bajo costo en CPU, sino también **el bajo consumo de ancho de banda para quien te ve**. Esto hace que el stream sea mucho más estable para espectadores con conexiones más limitadas, sin sacrificar nitidez. Es una de las mejores opciones para contenido técnico/debug.
