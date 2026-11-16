<p align="center">
  <a href="../README.md">English</a> ·
  <a href="./README.zh-CN.md">简体中文</a> ·
  <a href="./README.ru.md">Русский</a> ·
  <a href="./README.pt-BR.md">Português (Brasil)</a> ·
  <b>Français</b> ·
  <a href="./README.es.md">Español</a> ·
  <a href="./README.de.md">Deutsch</a> ·
  <a href="./README.ko.md">한국어</a>
</p>

# KlinK - Mod En Ligne pour Ravenswatch

Mod pour jouer à **Ravenswatch** en coopération en ligne (via Radmin VPN, ZeroTier ou réseau local) sans dépendre de serveurs externes.

- **Version du jeu :** `1.06.00.04.27511` (`Build 2026/09/07 #16d45d2f01`)

## Avertissement

Ce dépôt ne partage **ni** le jeu **ni** aucune copie de celui-ci. Vous devez déjà posséder **Ravenswatch** installé — KlinK sert uniquement à jouer en ligne sans dépendre de serveurs externes.

## Installation

1. Copiez tout le contenu de `kit/` (`KlinK.bat`, `winhttp.dll` et `mods/`) dans le dossier contenant `Ravenswatch.exe`.
2. Rejoignez le même réseau Radmin VPN (ou réseau local) que vos amis.

## Utilisation

Lancez **`KlinK.bat`** (au premier lancement, il demandera votre pseudo en jeu) :

- **Hôte :** choisissez l'option `2`, validez votre IP Radmin et attendez que le jeu se lance. Envoyez à vos amis l'IP affichée dans la fenêtre (avec les points, ex. `26.10.10.2`) puis le code du salon créé dans le jeu. Gardez la fenêtre réduite du serveur ouverte pendant la partie.
- **Client :** choisissez l'option `1`, saisissez l'IP de l'hôte avec les points (ex. `26.10.10.2`) puis rejoignez le salon avec le code une fois le jeu ouvert.
- **Changer de pseudo :** choisissez l'option `3` dans le menu de `KlinK.bat`.

## Notes

- Au premier lancement, le pare-feu Windows n'autorise que les ports du mod (`TCP 8090` et `UDP 30100`) limités aux sous-réseaux LAN/VPN. Utilisez-le uniquement en réseau local ou sur un VPN privé avec des personnes connues (n'ouvrez pas ces ports directement sur internet).
- Tous les fichiers, paramètres, identifiant et `_log.txt` restent dans `mods/KlinK/`.
