<p align="center">
  <a href="../README.md">English</a> ·
  <a href="./README.zh-CN.md">简体中文</a> ·
  <a href="./README.ru.md">Русский</a> ·
  <a href="./README.pt-BR.md">Português (Brasil)</a> ·
  <a href="./README.fr.md">Français</a> ·
  <b>Español</b> ·
  <a href="./README.de.md">Deutsch</a> ·
  <a href="./README.ko.md">한국어</a>
</p>

# KlinK - Mod Online para Ravenswatch

Mod para jugar **Ravenswatch** online en cooperativo (por Radmin VPN, ZeroTier o red local) sin depender de servidores externos.

- **Versión del juego:** `1.06.00.04.27511` (`Build 2026/09/07 #16d45d2f01`)

## Aviso

Este repositorio **no** comparte el juego ni ninguna copia del mismo. Para usar el mod es necesario tener ya instalado **Ravenswatch** — KlinK solo sirve para permitir partidas online sin depender de servidores externos.

## Instalación

1. Copia todo lo que está dentro de `kit/` (`KlinK.bat`, `winhttp.dll` y `mods/`) en la carpeta donde está `Ravenswatch.exe`.
2. Conéctate a Radmin VPN (o a la misma red) con tus amigos.

## Cómo usar

Abre **`KlinK.bat`** (la primera vez te pedirá tu nombre en el juego):

- **Host:** elige la opción `2`, confirma tu IP de Radmin y espera a que abra el juego. Pásales a tus amigos la IP que aparece en la ventana (con puntos, ej. `26.10.10.2`) y luego el código de la sala creado dentro del juego. Mantén abierta la ventana minimizada del servidor mientras juegan.
- **Cliente:** elige la opción `1`, escribe la IP del host con puntos (ej. `26.10.10.2`) y, cuando abra el juego, entra con el código de la sala.
- **Cambiar nombre:** elige la opción `3` en el menú de `KlinK.bat`.

## Notas

- En la primera ejecución, el Firewall de Windows solo permite los puertos del mod (`TCP 8090` y `UDP 30100`) restringidos a redes LAN/VPN. Úsalo solo en red local o VPN privada con conocidos (no abras estos puertos directo a internet).
- Todo lo del mod queda dentro de `mods/KlinK/` (ajustes, identidad y `_log.txt`).
