<p align="center">
  <a href="../README.md">English</a> ·
  <b>简体中文</b> ·
  <a href="./README.ru.md">Русский</a> ·
  <a href="./README.pt-BR.md">Português (Brasil)</a> ·
  <a href="./README.fr.md">Français</a> ·
  <a href="./README.es.md">Español</a> ·
  <a href="./README.de.md">Deutsch</a> ·
  <a href="./README.ko.md">한국어</a>
</p>

# KlinK - Ravenswatch 联机 Mod

用于在 **Ravenswatch** 中进行多人联机合作的 Mod（支持 Radmin VPN、ZeroTier 或局域网），无需依赖外部服务器。

- **游戏版本：** `1.06.00.04.27511`（`Build 2026/09/07 #16d45d2f01`）

## 声明

本仓库**不**分享游戏本体或其任何副本。使用前请确保你已拥有并安装了 **Ravenswatch** —— KlinK 仅用于让你在不依赖外部服务器的情况下进行联机游玩。

## 安装

1. 将 `kit/` 文件夹中的所有内容（`KlinK.bat`、`winhttp.dll` 和 `mods/`）复制到 `Ravenswatch.exe` 所在目录。
2. 与好友连接到同一个 Radmin VPN 房间或同一局域网。

## 使用方法

运行 **`KlinK.bat`**（首次启动会要求输入游戏内名称）：

- **房主（建房）：** 选择 `2`，确认你的 Radmin IP，等待游戏启动。将窗口中显示的带点 IP（例如 `26.10.10.2`）发给好友，然后在游戏内创建房间并将房间代码发给他们。游玩期间请保持最小化的服务端窗口运行。
- **成员（加入）：** 选择 `1`，输入房主带点的 IP（例如 `26.10.10.2`），游戏打开后在联机菜单输入房间代码加入。
- **修改名称：** 在 `KlinK.bat` 菜单中选择 `3`。

## 说明

- 首次运行仅在 Windows 防火墙中放行 Mod 所需端口（`TCP 8090` 和 `UDP 30100`），且限制仅允许局域网/VPN 网段访问。请仅在局域网或与熟人共用的私有 VPN 中使用（不要将端口直接暴露到公网）。
- Mod 的全部配置、身份信息及 `_log.txt` 均保存在 `mods/KlinK/` 中。
