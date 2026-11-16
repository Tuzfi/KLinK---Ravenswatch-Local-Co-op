param(
    [ValidateSet('', 'Host', 'Client')]
    [string]$Mode = '',
    [switch]$NoWait
)

$ErrorActionPreference = 'Stop'
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

$klinkDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$gameDir = (Get-Item $klinkDir).Parent.Parent.FullName
$exe = Join-Path $gameDir 'Ravenswatch.exe'

if (-not (Test-Path $exe)) {
    Write-Host '[ERRO] Coloque KlinK.bat, winhttp.dll e a pasta mods\KlinK na pasta de Ravenswatch.exe!' -ForegroundColor Red
    if (-not $NoWait) { Read-Host 'Pressione ENTER para sair' }
    exit 1
}

$backendFile = Join-Path $klinkDir 'backend.txt'
$idFile = Join-Path $klinkDir 'lan-id.txt'
$rosterFile = Join-Path $klinkDir 'lan-roster.txt'
$hostIpFile = Join-Path $klinkDir 'host-ip.txt'
$gridDir = Join-Path $klinkDir 'grid'
$toolsDir = Join-Path $klinkDir '.tools'

function Write-Utf8([string]$path, [string]$text) {
    $parent = Split-Path -Parent $path
    if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
    [System.IO.File]::WriteAllText($path, $text, $utf8NoBom)
}

function Migrate-LegacyFiles {
    $oldId = Join-Path $gameDir 'lan-id.txt'
    $oldRoster = Join-Path $gameDir 'lan-roster.txt'
    $oldBackend = Join-Path $gameDir 'mods\.rsmm_backend'
    if (-not (Test-Path $idFile) -and (Test-Path $oldId)) { Copy-Item $oldId $idFile -Force }
    if (-not (Test-Path $rosterFile) -and (Test-Path $oldRoster)) { Copy-Item $oldRoster $rosterFile -Force }
    if (-not (Test-Path $backendFile) -and (Test-Path $oldBackend)) { Copy-Item $oldBackend $backendFile -Force }
}

function Test-TcpPort([string]$hostIp, [int]$port, [int]$timeoutMs = 250) {
    if ([string]::IsNullOrWhiteSpace($hostIp)) { return $false }
    $client = New-Object System.Net.Sockets.TcpClient
    try {
        $ar = $client.BeginConnect($hostIp, $port, $null, $null)
        if ($ar.AsyncWaitHandle.WaitOne($timeoutMs, $false)) {
            $client.EndConnect($ar)
            return $true
        }
        return $false
    } catch {
        return $false
    } finally {
        $client.Dispose()
    }
}

function Get-CandidateIps {
    Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
        Where-Object { $_.IPAddress -ne '127.0.0.1' -and $_.IPAddress -notlike '169.254.*' -and $_.AddressState -eq 'Preferred' } |
        Sort-Object {
            if ($_.InterfaceAlias -match 'Radmin' -or $_.IPAddress -like '26.*') { 0 }
            elseif ($_.InterfaceAlias -match 'ZeroTier|Tailscale|Hamachi|WireGuard|Wintun') { 1 }
            elseif ($_.InterfaceAlias -match 'Wi-Fi|Ethernet') { 2 }
            else { 3 }
        } |
        Select-Object -ExpandProperty IPAddress -Unique
}

function Ensure-FirewallRules([bool]$includeServerPorts) {
    $cmds = @()
    $vpnSubnets = "@('LocalSubnet','26.0.0.0/8','10.0.0.0/8','172.16.0.0/12','192.168.0.0/16','100.64.0.0/10')"
    $hasGameFw = Get-NetFirewallApplicationFilter -ErrorAction SilentlyContinue | Where-Object { $_.Program -ieq $exe }
    if (-not $hasGameFw) {
        $cmds += "New-NetFirewallRule -DisplayName 'Ravenswatch KlinK LAN' -Direction Inbound -Action Allow -Program '$($exe.Replace("'", "''"))' -RemoteAddress $vpnSubnets -Profile Any -ErrorAction SilentlyContinue | Out-Null"
    }
    if ($includeServerPorts) {
        $stormExe = Join-Path $toolsDir 'stormancer\stormancer.exe'
        if (-not (Get-NetFirewallRule -DisplayName 'KlinK-Stormancer-TCP-LAN' -ErrorAction SilentlyContinue)) {
            $cmds += "Remove-NetFirewallRule -DisplayName 'KlinK-Stormancer-TCP' -ErrorAction SilentlyContinue"
            $cmds += "New-NetFirewallRule -DisplayName 'KlinK-Stormancer-TCP-LAN' -Direction Inbound -Action Allow -Program '$($stormExe.Replace("'", "''"))' -Protocol TCP -LocalPort 8090 -RemoteAddress $vpnSubnets -Profile Any -ErrorAction SilentlyContinue | Out-Null"
        }
        if (-not (Get-NetFirewallRule -DisplayName 'KlinK-Stormancer-UDP-LAN' -ErrorAction SilentlyContinue)) {
            $cmds += "Remove-NetFirewallRule -DisplayName 'KlinK-Stormancer-UDP' -ErrorAction SilentlyContinue"
            $cmds += "New-NetFirewallRule -DisplayName 'KlinK-Stormancer-UDP-LAN' -Direction Inbound -Action Allow -Program '$($stormExe.Replace("'", "''"))' -Protocol UDP -LocalPort 30100 -RemoteAddress $vpnSubnets -Profile Any -ErrorAction SilentlyContinue | Out-Null"
        }
    }
    if ($cmds.Count -gt 0) {
        Write-Host 'Liberando Firewall do Windows (pode pedir confirmacao de Admin)...' -ForegroundColor Yellow
        try {
            Start-Process powershell.exe -Verb RunAs -Wait -ArgumentList '-NoProfile', '-Command', ($cmds -join '; ')
        } catch {
            Write-Host '[AVISO] Nao foi possivel liberar o Firewall automaticamente.' -ForegroundColor Yellow
        }
    }
}

function Set-GameDisplayName([string]$name) {
    if ([string]::IsNullOrWhiteSpace($name)) { return }
    $emuIni = Join-Path $gameDir 'steam_emu.ini'
    if (Test-Path $emuIni) {
        $content = Get-Content $emuIni -Raw
        if ($content -match '(?m)^UserName=') {
            Write-Utf8 $emuIni ([regex]::Replace($content, '(?m)^UserName=.*$', "UserName=$name"))
        }
    }
    $gseIni = Join-Path $gameDir 'steam_settings\configs.user.ini'
    if (Test-Path $gseIni) {
        $content = Get-Content $gseIni -Raw
        if ($content -match '(?m)^account_name=') {
            Write-Utf8 $gseIni ([regex]::Replace($content, '(?m)^account_name=.*$', "account_name=$name"))
        }
    }
}

function Normalize-LanId([string]$s) {
    if ([string]::IsNullOrWhiteSpace($s)) { return '' }
    $n = $s.Normalize([Text.NormalizationForm]::FormD) -replace '\p{Mn}', ''
    ($n.ToLowerInvariant() -replace '[^a-z0-9_-]', '-' -replace '-{2,}', '-').Trim('-')
}

function Ensure-Identity([bool]$forceRename = $false) {
    $valid = $false
    $existingId = $null
    $existingKey = $null
    if (Test-Path $idFile) {
        $lines = @(Get-Content $idFile | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' })
        if ($lines.Count -ge 2 -and $lines[0] -match '^[a-z0-9_-]{1,32}$' -and $lines[1] -match '^[0-9a-f]{64}$') {
            $valid = $true
            $existingId = $lines[0]
            $existingKey = $lines[1]
        }
    }

    if ($valid -and -not $forceRename) {
        $emuIni = Join-Path $gameDir 'steam_emu.ini'
        if ((Test-Path $emuIni) -and ((Get-Content $emuIni -Raw) -match '(?m)^UserName=Player\r?$')) {
            Set-GameDisplayName $existingId
        }
        return
    }

    Write-Host ''
    Write-Host '=== Configuracao de Jogador ===' -ForegroundColor Cyan
    $rawUser = (Read-Host 'Digite seu nome no jogo (ex: Joao) [ENTER = manter/aleatorio]').Trim()
    $norm = Normalize-LanId $rawUser
    $rng = [System.Security.Cryptography.RandomNumberGenerator]::Create()

    if ($valid -and $forceRename -and -not [string]::IsNullOrWhiteSpace($rawUser)) {
        Set-GameDisplayName $rawUser
        Write-Host "Nome alterado para '$rawUser' (ID mantido: $existingId)." -ForegroundColor Green
        return
    }

    $b3 = New-Object byte[] 3
    $rng.GetBytes($b3)
    $rand6 = ($b3 | ForEach-Object { $_.ToString('x2') }) -join ''

    if ([string]::IsNullOrWhiteSpace($norm)) {
        $id = 'jogador-' + $rand6
        $displayName = $id
    } else {
        $displayName = $rawUser
        $sug = $norm.Substring(0, [Math]::Min(27, $norm.Length)) + '-' + $rand6.Substring(0, 4)
        $rawId = Read-Host "ID unico na sala [ENTER = $sug]"
        $custom = Normalize-LanId $rawId
        $id = if ([string]::IsNullOrWhiteSpace($custom)) { $sug } else { $custom.Substring(0, [Math]::Min(32, $custom.Length)) }
    }

    if (-not $existingKey) {
        $b32 = New-Object byte[] 32
        $rng.GetBytes($b32)
        $existingKey = ($b32 | ForEach-Object { $_.ToString('x2') }) -join ''
    }
    Write-Utf8 $idFile "$id`n$existingKey`n"
    Set-GameDisplayName $displayName
    Write-Host "Identidade salva: nome='$displayName' | id='$id'" -ForegroundColor Green
}

function Start-KlinKHost {
    $stormExe = Join-Path $toolsDir 'stormancer\stormancer.exe'
    $cfgPath = Join-Path $gridDir 'default.json'
    if (-not (Test-Path $stormExe) -or -not (Test-Path $cfgPath)) {
        Write-Host '[ERRO] Pasta do servidor nao encontrada em mods\KlinK\.tools / grid.' -ForegroundColor Red
        return $null
    }

    Ensure-FirewallRules -includeServerPorts $true

    $cands = @(Get-CandidateIps)
    $ip = if ($cands.Count -gt 0) { $cands[0] } else { '127.0.0.1' }
    if (-not $Mode) {
        Write-Host ''
        if ($cands.Count -gt 1) { Write-Host ("IPs detectados neste PC: " + ($cands -join ', ')) -ForegroundColor DarkGray }
        $typed = (Read-Host "IP do Host (com pontos) [ENTER = $ip]").Trim()
        if (-not [string]::IsNullOrWhiteSpace($typed)) { $ip = $typed }
    }

    $rawCfg = Get-Content $cfgPath -Raw
    $rawCfg = $rawCfg -replace '"publicIp":\s*"[^"]*"', "`"publicIp`": `"$ip`""
    $rawCfg = $rawCfg -replace '"loadBalancedIp":\s*"[^"]*"', "`"loadBalancedIp`": `"$ip`""
    $rawCfg = $rawCfg -replace '("public":\s*\{\s*"ip":\s*)"[^"]*"', "`${1}`"$ip`""
    Write-Utf8 $cfgPath $rawCfg

    Write-Utf8 $backendFile "http://${ip}:8090"
    Write-Utf8 $hostIpFile $ip
    if (-not (Test-Path $rosterFile)) { Write-Utf8 $rosterFile '' }

    Get-Process stormancer, RsmmBackend -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    Start-Sleep -Milliseconds 300

    $dotnetDir = Join-Path $toolsDir 'dotnet'
    $stormDir = Join-Path $toolsDir 'stormancer'
    $env:DOTNET_ROOT = $dotnetDir
    $env:DOTNET_CLI_TELEMETRY_OPTOUT = '1'
    $env:RSMM_LAN_ROSTER = $rosterFile
    $env:PATH = "$dotnetDir;$stormDir;$env:PATH"

    Write-Host "Iniciando servidor Stormancer em $ip..." -ForegroundColor Cyan
    $proc = Start-Process -FilePath $stormExe -ArgumentList 'start' -WorkingDirectory $gridDir -WindowStyle Minimized -PassThru

    $ready = $false
    for ($i = 0; $i -lt 45; $i++) {
        if ($proc.HasExited) { break }
        if (Test-TcpPort '127.0.0.1' 8091 200) { $ready = $true; break }
        Start-Sleep -Milliseconds 500
    }

    if (-not $ready) {
        Write-Host '[ERRO] Servidor KlinK nao respondeu na porta 8091.' -ForegroundColor Red
        return $null
    }

    return $ip
}

function Prepare-KlinKClient {
    Ensure-FirewallRules -includeServerPorts $false

    $curHost = ''
    if (Test-Path $backendFile) {
        $curUrl = (Get-Content $backendFile -Raw).Trim()
        if ($curUrl -match '^https?://([^:/]+)') { $curHost = $Matches[1] }
    }

    if (Test-TcpPort $curHost 8090 250) {
        Write-Host "Servidor encontrado em http://${curHost}:8090" -ForegroundColor Green
        return
    }

    foreach ($cand in (Get-CandidateIps)) {
        if (Test-TcpPort $cand 8090 150) {
            Write-Utf8 $backendFile "http://${cand}:8090"
            Write-Host "Servidor local detectado automaticamente: http://${cand}:8090" -ForegroundColor Cyan
            return
        }
    }

    while ($true) {
        Write-Host ''
        if ($curHost) { Write-Host "Servidor anterior ($curHost) nao respondeu." -ForegroundColor Yellow }
        $newHost = (Read-Host "Digite o IP do Host COM PONTOS (ex: 26.10.10.2) [ENTER = manter $curHost]").Trim()
        if ([string]::IsNullOrWhiteSpace($newHost)) {
            if ($curHost) { break }
            continue
        }
        $newHost = $newHost -replace '^https?://', '' -replace ':.*$', ''
        Write-Utf8 $backendFile "http://${newHost}:8090"
        if (Test-TcpPort $newHost 8090 500) {
            Write-Host "Conectado a http://${newHost}:8090!" -ForegroundColor Green
            break
        }
        Write-Host "Aviso: $newHost ainda nao respondeu na porta 8090. Verifique o Radmin e se o Host iniciou o servidor." -ForegroundColor Yellow
        $ans = (Read-Host 'Abrir o jogo mesmo assim? [S/N]').Trim()
        if ($ans -match '^(s|sim|y)$') { break }
    }
}

Migrate-LegacyFiles
Ensure-Identity

$choice = $Mode
while (-not $choice) {
    Write-Host ''
    Write-Host '============================================' -ForegroundColor Cyan
    Write-Host '        Ravenswatch - KlinK LAN Mod' -ForegroundColor Cyan
    Write-Host '============================================' -ForegroundColor Cyan
    Write-Host '  [1] Entrar em sala (Cliente)'
    Write-Host '  [2] Hostear sala + Jogar (Host neste PC)'
    Write-Host '  [3] Trocar meu nome no jogo'
    Write-Host ''
    $pick = (Read-Host 'Escolha [1/2/3]').Trim()
    switch ($pick) {
        '1' { $choice = 'Client' }
        '2' { $choice = 'Host' }
        '3' { Ensure-Identity -forceRename $true }
        default { $choice = 'Client' }
    }
}

$hostedIp = $null
if ($choice -eq 'Host') {
    $hostedIp = Start-KlinKHost
    if (-not $hostedIp) {
        if (-not $NoWait) { Read-Host 'Pressione ENTER para sair' }
        exit 1
    }
} else {
    Prepare-KlinKClient
}

Set-Location $gameDir
Write-Host 'Abrindo Ravenswatch (-p2papi=stormancer)...' -ForegroundColor Green
Start-Process -FilePath $exe -WorkingDirectory $gameDir -ArgumentList '-p2papi=stormancer'

if ($hostedIp -and -not $NoWait) {
    Write-Host ''
    Write-Host '====================================================' -ForegroundColor Green
    Write-Host '  SERVIDOR KLINK ONLINE!' -ForegroundColor Green
    Write-Host "  SEU IP PARA OS AMIGOS (COM PONTOS): $hostedIp" -ForegroundColor Cyan
    Write-Host '  (O servidor continua rodando em segundo plano)' -ForegroundColor DarkGray
    Write-Host '====================================================' -ForegroundColor Green
    Write-Host ''
    Read-Host 'Pressione ENTER quando quiser apenas fechar este aviso' | Out-Null
}
