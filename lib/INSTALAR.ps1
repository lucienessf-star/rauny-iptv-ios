param([string]$Projeto = 'C:\Users\Rauny\rauny_iptv_player')
$ErrorActionPreference = 'Stop'
try {
    $destino = (Resolve-Path -LiteralPath $Projeto).Path
    if (!(Test-Path -LiteralPath (Join-Path $destino 'pubspec.yaml'))) {
        throw 'Escolha a pasta do projeto Flutter, que contém pubspec.yaml.'
    }
    $flutterExe = (Get-Command flutter -ErrorAction Stop).Source
    $copia = Join-Path $destino ('backup-antes-hls-' + (Get-Date -Format 'yyyyMMdd-HHmmss'))
    New-Item -ItemType Directory -Path $copia -Force | Out-Null
    foreach ($relativo in @('lib/main.dart','lib/hls_web.dart','lib/hls_stub.dart','web/hls.min.js','web/hls-LICENSE.txt','pubspec.yaml','pubspec.lock')) {
        $original = Join-Path $destino $relativo
        if (Test-Path -LiteralPath $original) {
            $arquivoBackup = Join-Path $copia $relativo
            New-Item -ItemType Directory -Path (Split-Path -Parent $arquivoBackup) -Force | Out-Null
            Copy-Item -LiteralPath $original -Destination $arquivoBackup
        }
    }
    foreach ($relativo in @('lib/main.dart','lib/hls_web.dart','lib/hls_stub.dart','web/hls.min.js','web/hls-LICENSE.txt')) {
        $alvo = Join-Path $destino $relativo
        New-Item -ItemType Directory -Path (Split-Path -Parent $alvo) -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $PSScriptRoot $relativo) -Destination $alvo -Force
    }
    Push-Location -LiteralPath $destino
    try {
        & $flutterExe pub add 'video_player_web:2.4.0' 'video_player_platform_interface:6.9.0' 'web:1.1.1'
        if ($LASTEXITCODE -ne 0) { throw 'Não foi possível resolver as dependências. Consulte o erro acima.' }
    } finally { Pop-Location }
    Write-Host "Instalação concluída. Cópia anterior: $copia"
    Write-Host 'No terminal do projeto execute: flutter run -d chrome'
} catch {
    Write-Host "Falha: $($_.Exception.Message)" -ForegroundColor Red
    if ($copia) { Write-Host "Se houver arquivos anteriores, estão em: $copia" }
    exit 1
}
