<p align="center">
  <b>English</b> ·
  <a href="./docs/README.zh-CN.md">简体中文</a> ·
  <a href="./docs/README.ru.md">Русский</a> ·
  <a href="./docs/README.pt-BR.md">Português (Brasil)</a> ·
  <a href="./docs/README.fr.md">Français</a> ·
  <a href="./docs/README.es.md">Español</a> ·
  <a href="./docs/README.de.md">Deutsch</a> ·
  <a href="./docs/README.ko.md">한국어</a>
</p>

# KlinK - Online Mod for Ravenswatch

Mod to play **Ravenswatch** online in co-op (over Radmin VPN, ZeroTier, or LAN) without relying on external servers.

- **Game version:** `1.06.00.04.27511` (`Build 2026/09/07 #16d45d2f01`)

## Notice

This repository does **not** share the game or any copy of it. You must already own and have **Ravenswatch** installed — KlinK only lets you play online without relying on external servers.

## Installation

1. Copy everything inside `kit/` (`KlinK.bat`, `winhttp.dll`, and `mods/`) into the folder where `Ravenswatch.exe` is located.
2. Connect to Radmin VPN (or the same network) with your friends.

## How to use

Run **`KlinK.bat`** (on first launch it asks for your in-game name):

- **Host:** choose option `2`, confirm your Radmin IP, and wait for the game to open. Send friends the IP shown in the console (with dots, e.g. `26.10.10.2`) and then the lobby code created inside the game. Keep the minimized server window open while playing.
- **Client:** choose option `1`, enter the host's IP with dots (e.g. `26.10.10.2`), and join using the lobby code once the game opens.
- **Change name:** choose option `3` in the `KlinK.bat` menu.

## Notes

- On first launch, Windows Firewall allows only the mod ports (`TCP 8090` and `UDP 30100`) restricted to LAN/VPN subnets. Use only on LAN or a private VPN with people you know (never forward these ports to the public internet).
- All mod files, settings, identity, and `_log.txt` stay inside `mods/KlinK/`.
