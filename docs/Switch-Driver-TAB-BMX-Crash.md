# Problema confirmado: `settings-switch-driver` (BMX + TAB)

## Problema

Al subirse a una **BMX**, presionar `TAB` salía el siguiente mensaje:

```text
Voce precisa marcar um destino no mapa para ele dirigir ate lá
```

Tras eso, el juego **crasheaba**.

## Mod culpable

**`settings-switch-driver`**, ubicado dentro del perfil `settings-gta-sa` en `modloader.ini`.

## Explicación del porqué

La razón es bastante simple: **`TAB` es una tecla que recibe Switch Driver**.

- Este mod usa la tecla `TAB` para activar su lógica de "Switch Driver" (cambio de conductor o funciones relacionadas a IA de conducción).
- Esa lógica está pensada **únicamente para vehículos con motor** (autos, etc.), **no para bicicletas (BMX)**.
- Al presionar `TAB` estando en una BMX, el script intenta ejecutarse de todas formas. Al no poder aplicarse a una bici, intenta lanzar su flujo de "marcar destino en el mapa para que conduzca", cosa que no tiene sentido para una BMX.
- Ese intento de ejecución en un contexto no soportado es lo que provoca que aparezca el mensaje y, finalmente, **el crash**.

Básicamente: el mod intercepta `TAB` y, al no validar si el vehículo es una bici, lo intenta procesar y falla.

## Solución

**Desactivar `settings-switch-driver`** del perfil `settings-gta-sa` en `modloader.ini`.

Al quitarlo, `TAB` deja de ser capturado por ese script cuando estás en BMX, por lo que no intenta ejecutar esa lógica, no aparece el mensaje y **ya no crashea**.

## Confirmación

Tras quitar ese mod, el problema se solucionó por completo.