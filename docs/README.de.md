<p align="center">
  <a href="../README.md">English</a> ·
  <a href="./README.zh-CN.md">简体中文</a> ·
  <a href="./README.ru.md">Русский</a> ·
  <a href="./README.pt-BR.md">Português (Brasil)</a> ·
  <a href="./README.fr.md">Français</a> ·
  <a href="./README.es.md">Español</a> ·
  <b>Deutsch</b> ·
  <a href="./README.ko.md">한국어</a>
</p>

# KlinK - Online-Mod für Ravenswatch

Mod zum Online-Koop-Spielen in **Ravenswatch** (über Radmin VPN, ZeroTier oder LAN), ohne auf externe Server angewiesen zu sein.

- **Spielversion:** `1.06.00.04.27511` (`Build 2026/09/07 #16d45d2f01`)

## Hinweis

Dieses Repository teilt **weder** das Spiel noch eine Kopie davon. Du musst **Ravenswatch** bereits besitzen und installiert haben — KlinK dient ausschließlich dazu, online spielen zu können, ohne von externen Servern abhängig zu sein.

## Installation

1. Kopiere den gesamten Inhalt von `kit/` (`KlinK.bat`, `winhttp.dll` und `mods/`) in den Ordner, in dem sich `Ravenswatch.exe` befindet.
2. Verbinde dich mit deinen Freunden über Radmin VPN (oder dasselbe lokale Netzwerk).

## Verwendung

Starte **`KlinK.bat`** (beim ersten Start wird nach deinem Spielernamen gefragt):

- **Host:** wähle Option `2`, bestätige deine Radmin-IP und warte, bis das Spiel startet. Schicke deinen Freunden die im Fenster angezeigte IP mit Punkten (z. B. `26.10.10.2`) und danach den im Spiel erstellten Lobby-Code. Lass das minimierte Serverfenster während des Spielens offen.
- **Client:** wähle Option `1`, gib die IP des Hosts mit Punkten ein (z. B. `26.10.10.2`) und tritt im Spiel über den Lobby-Code bei.
- **Namen ändern:** wähle Option `3` im Menü von `KlinK.bat`.

## Hinweise

- Beim ersten Start werden in der Windows-Firewall nur die Mod-Ports (`TCP 8090` und `UDP 30100`) beschränkt auf LAN-/VPN-Netze freigegeben. Nur im LAN oder privaten VPN mit Bekannten verwenden (keine Ports direkt ins öffentliche Internet freigeben).
- Alle Dateien, Einstellungen, Identität und `_log.txt` liegen in `mods/KlinK/`.
