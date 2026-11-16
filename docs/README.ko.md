<p align="center">
  <a href="../README.md">English</a> ·
  <a href="./README.zh-CN.md">简体中文</a> ·
  <a href="./README.ru.md">Русский</a> ·
  <a href="./README.pt-BR.md">Português (Brasil)</a> ·
  <a href="./README.fr.md">Français</a> ·
  <a href="./README.es.md">Español</a> ·
  <a href="./README.de.md">Deutsch</a> ·
  <b>한국어</b>
</p>

# KlinK - Ravenswatch 온라인 모드

외부 서버에 의존하지 않고 **Ravenswatch**를 온라인 협동으로 플레이할 수 있는 모드입니다 (Radmin VPN, ZeroTier 또는 LAN 지원).

- **게임 버전:** `1.06.00.04.27511` (`Build 2026/09/07 #16d45d2f01`)

## 안내

이 저장소는 게임 파일이나 복사본을 **공유하지 않습니다**. 이 모드를 사용하려면 **Ravenswatch** 정품을 보유하고 설치되어 있어야 하며, KlinK는 외부 서버 없이 온라인 플레이가 가능하도록 돕는 용도로만 제공됩니다.

## 설치 방법

1. `kit/` 폴더 안의 모든 파일(`KlinK.bat`, `winhttp.dll`, `mods/`)을 `Ravenswatch.exe`가 있는 폴더로 복사합니다.
2. 함께 플레이할 친구들과 Radmin VPN 또는 같은 네트워크에 연결합니다.

## 사용 방법

**`KlinK.bat`**를 실행합니다 (처음 실행 시 게임 내 닉네임을 입력합니다):

- **호스트 (방 만들기):** `2`번을 선택하고 Radmin IP를 확인한 뒤 게임이 열릴 때까지 기다립니다. 창에 표시된 점(`.`)이 포함된 IP(예: `26.10.10.2`)와 게임 내에서 생성된 방 코드를 친구들에게 알려주세요. 플레이하는 동안 최소화된 서버 창은 닫지 마세요.
- **클라이언트 (참가하기):** `1`번을 선택하고 호스트의 IP를 점 포함해서 입력한 뒤(예: `26.10.10.2`), 게임이 열리면 방 코드로 참가합니다.
- **닉네임 변경:** `KlinK.bat` 메뉴에서 `3`번을 선택합니다.

## 참고

- 처음 실행 시 Windows 방화벽에서 모드 포트(`TCP 8090`, `UDP 30100`)만 LAN/VPN 대역에 한해 허용됩니다. 지인과의 LAN 또는 사설 VPN에서만 사용하세요 (공용 인터넷에 포트를 직접 열지 마세요).
- 모든 모드 파일, 설정, 프로필 및 `_log.txt`는 `mods/KlinK/` 안에 저장됩니다.
