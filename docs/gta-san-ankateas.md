# GTA San Anskateas
El mod es [ryglizzy, GTA-San-Anskateas](https://github.com/ryglizzy/GTA-San-AnSkateas/tree/main/).

---

## Dependencias
Primeramente descargamos el release. (Podríamos usar el script de instalación, pero por motivos de control se puede hacer de manera manual).

### Decompilar Skate 3
Necesitas un `Skate 3.iso` original para XBox 360. Extraes con la herramienta [Github XboxDev extract-xiso](https://github.com/XboxDev/extract-xiso).

Ejemplo:
```bash
extract-xiso -x "Skate 3.iso"
```

### Mods necesarios para gta sa
- Essentials pack MixMods, o simplemente solo; Ultimate Asi Loader, y Modloader.

### [DXVK](https://github.com/doitsujin/DXVK) (opcional)
Se arreglan bugs específicos por el uso del mod.

### `skate_fill.dll`
Este archivo esta en el release.

---

## Instalación
#### Creación de carpeta del mod
Nos ubicamos en modloader, y creamos una carpeta, ponle de nombre lo que quieras, ejemplo `gta-san-anskateas`.

#### Mod y config
En esta carpeta pon los `asi` y `ini`, llamados `SanAnskateas`.

En el ini asegurate que `AssetsDir` diga:
```ini
AssetsDir=SanAnskateas\skate-data\assets
```

#### Assets y dll necesaria
En la misma carpeta, creamos la subcarpeta: `SanAnskateas`. Y pegamos la iso extraída de `Skate 3`, deben estar las carpetas asi: `skate-data\assets`. Esto es lo necesario, pero si hay mas files puedes pegar todo lo del extraído.

En la subcarpeta, pegamos la `skate-fill.dll`, y el texto: `version.txt`.

#### Ejemplo de árbol de instalación correcta
```
gta_sa/
    modloader/
        gta-san-anskateas/
            SanAnskateas/
                skate-data/
                    assets/
                skate_fii.dll
                version.txt
            SanAnskateas.asi
            SanAnskateas.ini
```