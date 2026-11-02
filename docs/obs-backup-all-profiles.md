En Debian 13, si instalaste OBS mediante `apt`, normalmente encontrarás los datos en:

```
~/.config/obs-studio/
```

Ojo: los perfiles de emisión y grabación se guardan separados de las colecciones de escenas. Puedes exportar ambos.

## Método 1: Exportar desde OBS (recomendado)

Es el método más limpio y compatible entre Debian y Windows.

1. Abre OBS.
2. Entra en Perfil → Exportar.
3. Selecciona una carpeta de destino.
4. OBS generará un archivo de exportación del perfil.
5. Pásalo a Windows.
6. En Windows, abre OBS y selecciona Perfil → Importar.

Esto transfiere resolución, FPS, bitrate, codificador y configuraciones de emisión y grabación.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://obsproject.com\&sz=32)

OBS



## Método 2: Copiar mediante terminal

Si prefieres hacerlo desde Debian:

Primero, comprueba tus perfiles:

```
ls ~/.config/obs-studio/basic/profiles/
```

Para comprimirlos todos:

```
cd ~/.config/obs-studio/basic/
tar -czvf ~/obs-profiles.tar.gz profiles/
```

Tendrás el archivo:

```
~/obs-profiles.tar.gz
```

Puedes pasarlo a Windows y extraerlo, aunque para importar perfiles individuales prefiero el método 1.

## ¿Y las colecciones de escenas?

También puedes exportarlas desde:

Colección de escenas → Exportar

O respaldarlas desde:

```
~/.config/obs-studio/basic/scenes/
```

## ¡Cuidado con la clave de transmisión!

El archivo `service.json` puede contener tu clave RTMP de Rumble. No compartas públicamente el archivo exportado ni el respaldo completo.&#x20;

[image](https://www.google.com/s2/favicons?domain=https://space-node.net\&sz=32)

Space-Node



Mi recomendación: utiliza el método 1. Es más cómodo y evita copiar configuraciones internas innecesarias.

Además, puedes crear tus tres perfiles en Debian:

- `Rumble - Equilibrado`
- `Rumble - Calidad`
- `Rumble - Estabilidad`

Y exportarlos individualmente para importarlos en Windows.

Una ventaja: OBS permite compartir perfiles entre sistemas operativos, aunque tendrás que revisar los codificadores disponibles y las rutas de grabación, porque Windows y Debian no utilizan necesariamente los mismos.