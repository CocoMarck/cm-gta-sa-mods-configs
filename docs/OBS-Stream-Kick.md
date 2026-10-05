# Configuración de OBS Studio para Kick (720p @ 20 FPS - Cero Tirones)

Configuración **verificada** para emitir en Kick a **1280x720 @ 20 FPS** codificando **solo por CPU (x264)**, con **cero tirones (stuttering)** en el reproductor y un **BPP (bits por píxel) elevado** que mantiene la imagen limpia en movimiento rápido.

## Contexto del sistema y hardware

| Componente | Valor | Implicación para el stream |
|---|---|---|
| **OS** | Debian GNU/Linux 13 (trixie) x86_64 | Kernel y drivers recientes, PipeWire disponible por defecto. |
| **DE / WM** | KDE Plasma 6.3.6 sobre **KWin (Wayland)** | La captura en Wayland requiere PipeWire o `obs-vkcapture`; X11 capture no aplica. |
| **CPU** | AMD Ryzen 5 3500X (6 núcleos / 6 hilos, **sin SMT**) | 6 hilos reales: por eso el preset `superfast` + `threads=0` es el punto dulce. |
| **GPU** | AMD Radeon RX 6400 (sin codificador H.264/HEVC dedicado) | **Prohibido usar NVENC/QSV/AMF**: la codificación es obligatoriamente por CPU con `x264`. |
| **Red** | Fibra simétrica 90+ Mbps (subida real ~**91.89 Mbps**) | La red **nunca** es el cuello de botella. Descartada como causa de tirones. |

> **Conclusión clave:** los tirones anteriores **no** eran falta de red ni saturación de CPU. Eran provocados por **`zerolatency`** y por el **reescalado duplicado en el menú de Salida**.

## ⚠️ REGLA PERMANENTE: escalar SOLO en la pestaña Video

**Aplica esto siempre, en cualquier configuración de OBS de este equipo:**

| Dónde | Ajuste | Valor |
|---|---|---|
| **Pestaña Salida** (Output > Emisión) | **Cambiar escala / Escalar la salida (Rescale Output)** | **DESACTIVADO — siempre, nunca lo marques** |
| **Pestaña Video** (Settings > Video) | **Lienzo (Base) → Salida (Scaled)** | **Escalar AQUÍ** (ej. `1920x1080` → `1280x720`) + filtro `Bicubic` |

**Por qué:** si marcas la casilla en la pestaña Salida, OBS **vuelve a escalar el vídeo una segunda vez por CPU**, además del escalado de la pestaña Video. Son **procesos duplicados**: compiten con el juego por la CPU, retrasan los fotogramas y producen tirones.

> El escalado ocurre **una sola vez**, en la pestaña Video. La pestaña Salida solo se encarga de codificar y enviar.



## 1. Video (Settings > Video)

| Opción | Valor | Explicación |
|---|---|---|
| Base (Canvas) Resolution | **`1920x1080`** | Resolución nativa del lienzo. Se hace el escalado **una sola vez**, aquí. |
| Output (Scaled) Resolution | **`1280x720`** | 720p de salida. BPP suficiente con `4500 Kbps`. |
| Downscale Filter | **`Bicubic`** | Optimizado para KWin/Wayland. Evita el borroso de `Lanczos` y el ringing de `Bilinear`. |
| Common FPS Values | **`20`** | Carga de CPU muy baja y suficiente fluidez para gameplay. |

## 2. Output > Streaming (Modo Avanzado)

| Opción | Valor | Explicación |
|---|---|---|
| Service | `Kick` | Plataforma objetivo. |
| Server | `Auto` | Déjalo automático, funciona bien. |
| Stream Key | (Tu Stream Key de Kick > Creator Dashboard) | **Nunca lo compartas.** |
| **Encoder** | **`x264 (Software)`** | Obligatorio: la RX 6400 no tiene VCN activo para H.264 en este flujo. |
| **Escalar la salida (Rescale Output)** | **DESMARCADO** | **Crítico.** Si se marca, OBS reescala **otra vez** en CPU y pelea con el juego. Todo el escalado vive en la pestaña Video. |
| **Rate Control** | **`CBR`** | Bitrate constante, sin picos que desborden el búfer del reproductor. |
| **Bitrate** | **`4500 Kbps`** | Aprovecha la fibra sin saturarla. Con tu subida de ~91 Mbps esto es <5% del ancho de banda. |
| **Keyframe Interval** | **`2 s`** | Estándar obligatorio en Kick. |
| **CPU Usage Preset** | **`superfast`** | Punto dulce: ~5% de uso de CPU y previene el lag de codificación. |
| **Profile** | **`high`** | Matriz de cuantización más detallada. Costo de CPU casi nulo. |
| **Tune** | **`(Ninguno)`** | **CRÍTICO: no usar `zerolatency`.** Provoca la rotura del búfer y los tirones en el reproductor. |
| **x264 Options** | **`threads=0 rc-lookahead=10`** | Auto-detección de hilos por x264 + lookahead acotado. Ver sección siguiente. |

### Opciones de x264 personalizadas

En **Settings > Advanced > x264 Options** (o en el campo homónimo de la pestaña Salida):

```text
threads=0 rc-lookahead=10
```

* **`threads=0`:** x264 detecta solo los 6 hilos reales del Ryzen 5 3500X (sin SMT). Evita el reparto manual que antes quitaba estabilidad.
* **`rc-lookahead=10`:** Acota el búfer de análisis a 10 fotogramas (medio segundo a 20 fps). Es el equilibrio entre calidad y **no romper el búfer**.

> Esta línea **reemplaza** a la anterior `aq-mode=2 aq-strength=1.1`. Ya no se toca la cuantización adaptativa: con `4500 Kbps` a 720p20 el BPP por sí solo ya da la calidad, y cada opción extra suma latencia de búfer.

## 3. Reglas técnicas y diagnóstico

1. **Captura en Wayland.** Usa **PipeWire Window/Screen Capture** o **`obs-vkcapture`**. Evitan la desincronización de fotogramas propia de la composición de KWin. **Nunca uses Display Capture** salvo necesidad real (consume CPU de sobra).
2. **Sin grabación local.** Kick ya guarda el VOD automáticamente. No actives `Record` ni `Replay Buffer`.
3. **Preview apagado mientras transmites.** El preview consume CPU extra innecesaria.
4. **Escena lo más limpia posible.** Quita overlays, GIFs, fuentes animadas, transiciones y filtros pesados.
5. **Un solo perfil/escena.** Entre menos fuentes activas, más colchón de CPU.

### Causa de los tirones (ya eliminada)

| Causa descartada | Motivo de descarte |
|---|---|
| **Red insuficiente** | 4500 Kbps contra ~91.89 Mbps reales de subida: <5% de uso. |
| **CPU saturada** | `superfast` con `threads=0` deja la codificación en ~5% de CPU. |
| **`zerolatency`** | **Causa real #1.** Rompe el búfer de codificación y provoca cortes en el reproductor. |
| **Reescalado en el menú de Salida** | **Causa real #2.** Escalado duplicado en CPU; compite con el juego y genera fotogramas tardíos. |

## Resultado esperado

| Métrica | Valor |
|---|---|
| Resolución | 1280x720 @ 20 FPS |
| Bitrate | 4500 Kbps CBR |
| BPP efectivo | `4500000 / (1280 × 720 × 20)` ≈ **0.24 bits/píxel/fotograma** |
| Consumo de CPU | ~5% (codificación) |
| Consumo de red | ~0.45 Mbps de 91.89 Mbps disponibles |
| Tirones (stuttering) | **Cero** |

Los BPP altos son la clave: `1100 kbps` en 720p **pixela y se rompe en bloques** en cuanto hay movimiento rápido. Subir a `4500 Kbps` multiplica por 4 los datos por fotograma y elimina ese bloqueado sin necesidad de tocar la CPU.
