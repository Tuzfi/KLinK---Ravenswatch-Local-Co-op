<p align="center">
  <a href="../README.md">English</a> ·
  <a href="./README.zh-CN.md">简体中文</a> ·
  <a href="./README.ru.md">Русский</a> ·
  <b>Português (Brasil)</b> ·
  <a href="./README.fr.md">Français</a> ·
  <a href="./README.es.md">Español</a> ·
  <a href="./README.de.md">Deutsch</a> ·
  <a href="./README.ko.md">한국어</a>
</p>

# KlinK - Mod Online para Ravenswatch

Mod para jogar **Ravenswatch** online em coop (via Radmin VPN, ZeroTier ou rede local), sem depender de servidores externos.

- **Versão do jogo:** `1.06.00.04.27511` (`Build 2026/09/07 #16d45d2f01`)

## Aviso

Este repositório **não** compartilha o jogo e nem qualquer cópia dele. Para usar o mod é necessário já possuir o **Ravenswatch** instalado — o KlinK serve apenas para permitir partidas online sem depender de servidores externos.

## Instalação

1. Copie tudo que está dentro da pasta `kit/` (`KlinK.bat`, `winhttp.dll` e `mods/`) para a pasta onde está o `Ravenswatch.exe`.
2. Conecte no Radmin VPN (ou na mesma rede) com quem vai jogar.

## Como usar

Abra o **`KlinK.bat`** (na primeira vez ele pede seu nome no jogo):

- **Host (quem cria a sala):** escolha a opção `2`, confirme seu IP do Radmin e aguarde abrir o jogo. Passe para os amigos o IP que aparece na janela (com pontos, ex: `26.10.10.2`) e depois o código da sala criado dentro do jogo. Deixe a janela minimizada do servidor aberta enquanto joga.
- **Cliente (quem vai entrar):** escolha a opção `1`, digite o IP do host com pontos (ex: `26.10.10.2`) e, quando o jogo abrir, entre usando o código da sala.
- **Trocar nome:** escolha a opção `3` no menu do `KlinK.bat`.

## Observações

- Na primeira execução, o Firewall do Windows libera apenas as portas do mod (`TCP 8090` e `UDP 30100`) restritas às faixas de LAN/VPN. Use apenas em rede local ou VPN privada com conhecidos (não abra essas portas direto na internet).
- Tudo do mod fica concentrado em `mods/KlinK/` (configurações, identidade e `_log.txt`).
