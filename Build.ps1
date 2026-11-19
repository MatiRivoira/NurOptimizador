# Junta config + xaml + src en un único dist\optimizer.ps1
$root = $PSScriptRoot
$out  = Join-Path $root 'dist\optimizer.ps1'
New-Item (Split-Path $out) -ItemType Directory -Force | Out-Null

$json = Get-Content "$root\config\tweaks.json" -Raw -Encoding UTF8
$null = $json | ConvertFrom-Json   # valida el JSON; falla si está roto
$xaml = Get-Content "$root\xaml\MainWindow.xaml" -Raw -Encoding UTF8
$core = Get-Content "$root\src\Core.ps1" -Raw -Encoding UTF8
$ui   = Get-Content "$root\src\UI.ps1"   -Raw -Encoding UTF8

$header = @'
# Mi Optimizador - generado por Build.ps1, no editar a mano
$ScriptUrl = 'https://raw.githubusercontent.com/MatiRivoira/NurOptimizador/main/dist/optimizer.ps1'

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    if ($PSCommandPath) { $cmd = "& '$PSCommandPath'" } else { $cmd = "irm '$ScriptUrl' | iex" }
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$cmd`""
    return
}
'@

$content = @(
    $header,
    "`$script:Tweaks = @'`n$json`n'@ | ConvertFrom-Json",
    "`$script:Xaml = @'`n$xaml`n'@",
    $core,
    $ui
) -join "`n`n"

[IO.File]::WriteAllText($out, $content, (New-Object Text.UTF8Encoding $false))
Write-Host "Generado: $out"

# Set-ItemProperty : Intento de realizar una operación no válida.
# En línea: 1741 Carácter: 5                                                                                                  +     Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value (Conv ...                                                 +     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~                                                         + CategoryInfo          : PermissionDenied: (AllowNewsAndInterests:String) [Set-ItemProperty], UnauthorizedAccessExcep     tion                                                                                                                         + FullyQualifiedErrorId : System.UnauthorizedAccessException,Microsoft.PowerShell.Commands.SetItemPropertyCommand

# Stop-Process : No se encuentra ningún proceso con el nombre "explorer". Compruebe el nombre del proceso y ejecute de nuevo
# el cmdlet.
# En línea: 1 Carácter: 1
# + Stop-Process -Name explorer -ForceRR
#     + CategoryInfo          : ObjectNotFound: (explorer:String) [Stop-Process], ProcessCommandException
#     + FullyQualifiedErrorId : NoProcessFoundForGivenName,Microsoft.PowerShell.Commands.StopProcessCommand

# Stop-Process : No se encuentra ningún proceso con el nombre "explorer". Compruebe el nombre del proceso y ejecute de nuevo
# el cmdlet.
# En línea: 1 Carácter: 280
# + ... rce -ErrorAction SilentlyContinue; Stop-Process -Name explorer -Force
# +                                        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#     + CategoryInfo          : ObjectNotFound: (explorer:String) [Stop-Process], ProcessCommandException
#     + FullyQualifiedErrorId : NoProcessFoundForGivenName,Microsoft.PowerShell.Commands.StopProcessCommand
