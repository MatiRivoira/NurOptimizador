# Mi Optimizador - generado por Build.ps1, no editar a mano
$ScriptUrl = 'https://raw.githubusercontent.com/TU_USUARIO/mi-optimizador/main/dist/optimizer.ps1'

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    if ($PSCommandPath) { $cmd = "& '$PSCommandPath'" } else { $cmd = "irm '$ScriptUrl' | iex" }
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `"$cmd`""
    return
}

$script:Tweaks = @'
[
  {
    "Id": "DisableTelemetry",
    "Category": "Privacidad",
    "Name": "Desactivar telemetría",
    "Description": "Reduce el envío de datos de diagnóstico a Microsoft y detiene el servicio DiagTrack.",
    "Risk": "Bajo",
    "registry": [
      { "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection", "Name": "AllowTelemetry", "Type": "DWord", "Value": "0", "OriginalValue": "<RemoveEntry>" }
    ],
    "service": [
      { "Name": "DiagTrack", "StartupType": "Disabled", "OriginalType": "Automatic" }
    ]
  },
  {
    "Id": "DisableActivityHistory",
    "Category": "Privacidad",
    "Name": "Desactivar historial de actividad",
    "Description": "Evita que Windows registre y suba tu historial de actividad (Timeline).",
    "Risk": "Bajo",
    "registry": [
      { "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System", "Name": "EnableActivityFeed", "Type": "DWord", "Value": "0", "OriginalValue": "<RemoveEntry>" },
      { "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System", "Name": "PublishUserActivities", "Type": "DWord", "Value": "0", "OriginalValue": "<RemoveEntry>" },
      { "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System", "Name": "UploadUserActivities", "Type": "DWord", "Value": "0", "OriginalValue": "<RemoveEntry>" }
    ]
  },
  {
    "Id": "DisableAdvertisingId",
    "Category": "Privacidad",
    "Name": "Desactivar ID de publicidad",
    "Description": "Impide que las apps usen tu ID de publicidad para anuncios personalizados.",
    "Risk": "Bajo",
    "registry": [
      { "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\AdvertisingInfo", "Name": "Enabled", "Type": "DWord", "Value": "0", "OriginalValue": "1" }
    ]
  },
  {
    "Id": "DisableConsumerFeatures",
    "Category": "Debloat",
    "Name": "Desactivar apps sugeridas / consumer features",
    "Description": "Evita que Windows instale automáticamente apps promocionales (Candy Crush, etc.).",
    "Risk": "Bajo",
    "registry": [
      { "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\CloudContent", "Name": "DisableWindowsConsumerFeatures", "Type": "DWord", "Value": "1", "OriginalValue": "<RemoveEntry>" }
    ]
  },
  {
    "Id": "DisableBingSearch",
    "Category": "Debloat",
    "Name": "Desactivar Bing en el menú Inicio",
    "Description": "La búsqueda del menú Inicio deja de mandar consultas a Bing y mostrar sugerencias web.",
    "Risk": "Bajo",
    "registry": [
      { "Path": "HKCU:\\Software\\Policies\\Microsoft\\Windows\\Explorer", "Name": "DisableSearchBoxSuggestions", "Type": "DWord", "Value": "1", "OriginalValue": "<RemoveEntry>" }
    ]
  },
  {
    "Id": "DisableGameDVR",
    "Category": "Rendimiento",
    "Name": "Desactivar Game DVR / Game Bar capture",
    "Description": "Apaga la grabación en segundo plano de Xbox Game Bar. Menos overhead en juegos.",
    "Risk": "Bajo",
    "registry": [
      { "Path": "HKCU:\\System\\GameConfigStore", "Name": "GameDVR_Enabled", "Type": "DWord", "Value": "0", "OriginalValue": "1" },
      { "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\GameDVR", "Name": "AllowGameDVR", "Type": "DWord", "Value": "0", "OriginalValue": "<RemoveEntry>" }
    ]
  },
  {
    "Id": "HighPerformancePower",
    "Category": "Rendimiento",
    "Name": "Plan de energía: Alto rendimiento",
    "Description": "Activa el plan de alto rendimiento. En notebooks aumenta el consumo de batería.",
    "Risk": "Bajo",
    "commands": {
      "apply": "powercfg /setactive SCHEME_MIN",
      "undo": "powercfg /setactive SCHEME_BALANCED"
    }
  },
  {
    "Id": "DisableHibernation",
    "Category": "Rendimiento",
    "Name": "Desactivar hibernación",
    "Description": "Libera varios GB (hiberfil.sys). También desactiva Inicio rápido.",
    "Risk": "Medio",
    "commands": {
      "apply": "powercfg /hibernate off",
      "undo": "powercfg /hibernate on"
    }
  },
  {
    "Id": "ShowFileExtensions",
    "Category": "Interfaz",
    "Name": "Mostrar extensiones de archivo",
    "Description": "Muestra .exe, .pdf, etc. en el Explorador. Mejora la seguridad.",
    "Risk": "Bajo",
    "registry": [
      { "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "HideFileExt", "Type": "DWord", "Value": "0", "OriginalValue": "1" }
    ]
  },
  {
    "Id": "ShowHiddenFiles",
    "Category": "Interfaz",
    "Name": "Mostrar archivos ocultos",
    "Description": "Muestra archivos y carpetas ocultos en el Explorador.",
    "Risk": "Bajo",
    "registry": [
      { "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced", "Name": "Hidden", "Type": "DWord", "Value": "1", "OriginalValue": "2" }
    ]
  }
]

'@ | ConvertFrom-Json

$script:Xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Mi Optimizador - Windows 11" Width="760" Height="660"
        WindowStartupLocation="CenterScreen" Background="#1E1E2E">
  <Window.Resources>
    <Style TargetType="CheckBox">
      <Setter Property="Foreground" Value="#E6E6F0"/>
      <Setter Property="Margin" Value="12,4,0,4"/>
    </Style>
    <Style TargetType="Button">
      <Setter Property="Padding" Value="14,6"/>
      <Setter Property="Margin" Value="0,0,8,0"/>
    </Style>
  </Window.Resources>
  <Grid Margin="12">
    <Grid.RowDefinitions>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="*"/>
      <RowDefinition Height="Auto"/>
      <RowDefinition Height="150"/>
    </Grid.RowDefinitions>
    <TextBlock Grid.Row="0" Text="Mi Optimizador para Windows 11" FontSize="20"
               FontWeight="Bold" Foreground="White" Margin="0,0,0,10"/>
    <ScrollViewer Grid.Row="1" VerticalScrollBarVisibility="Auto">
      <StackPanel x:Name="TweaksPanel"/>
    </ScrollViewer>
    <StackPanel Grid.Row="2" Orientation="Horizontal" Margin="0,10,0,10">
      <Button x:Name="BtnApply" Content="Aplicar seleccionados"/>
      <Button x:Name="BtnUndo" Content="Revertir seleccionados"/>
      <Button x:Name="BtnRestore" Content="Crear punto de restauración"/>
    </StackPanel>
    <TextBox Grid.Row="3" x:Name="LogBox" IsReadOnly="True" Background="#11111B"
             Foreground="#A6E3A1" FontFamily="Consolas" VerticalScrollBarVisibility="Auto"
             TextWrapping="Wrap"/>
  </Grid>
</Window>

'@

# ---------- Core: lógica de tweaks con snapshot + undo ----------
$script:AppDir     = Join-Path $env:LOCALAPPDATA 'MiOptimizador'
$script:BackupFile = Join-Path $script:AppDir 'backup.clixml'
$script:LogBox     = $null
New-Item $script:AppDir -ItemType Directory -Force | Out-Null

function Write-Log {
    param([string]$Message)
    $line = "[{0}] {1}" -f (Get-Date -Format 'HH:mm:ss'), $Message
    Add-Content -Path (Join-Path $script:AppDir 'log.txt') -Value $line
    if ($script:LogBox) {
        $script:LogBox.AppendText($line + "`r`n")
        $script:LogBox.ScrollToEnd()
    }
}

function Get-Backup {
    if (Test-Path $script:BackupFile) { return (Import-Clixml $script:BackupFile) }
    return @{}
}
function Save-Backup($b) { $b | Export-Clixml -Path $script:BackupFile }

function New-RestorePoint {
    try {
        Enable-ComputerRestore -Drive "$env:SystemDrive\" -ErrorAction SilentlyContinue
        Checkpoint-Computer -Description 'MiOptimizador' -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
        Write-Log 'Punto de restauración creado.'
    } catch {
        # Windows limita a 1 punto cada 24h por defecto
        Write-Log "No se pudo crear el punto de restauración: $($_.Exception.Message)"
    }
}

function Get-Snapshot($Tweak) {
    $snap = @{ Registry = @(); Services = @() }
    foreach ($r in $Tweak.registry) {
        $item = @{ Path = $r.Path; Name = $r.Name; Type = $r.Type; Existed = $false; Value = $null }
        $p = Get-ItemProperty -Path $r.Path -Name $r.Name -ErrorAction SilentlyContinue
        if ($null -ne $p) { $item.Existed = $true; $item.Value = $p.($r.Name) }
        $snap.Registry += $item
    }
    foreach ($s in $Tweak.service) {
        $svc = Get-Service -Name $s.Name -ErrorAction SilentlyContinue
        if ($svc) { $snap.Services += @{ Name = $s.Name; StartType = [string]$svc.StartType } }
    }
    return $snap
}

function ConvertTo-RegValue($Type, $Value) {
    switch ($Type) {
        'DWord' { return [int]$Value }
        'QWord' { return [long]$Value }
        default { return [string]$Value }
    }
}

function Set-RegValue($Path, $Name, $Type, $Value) {
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value (ConvertTo-RegValue $Type $Value) -Force
}

function Invoke-Tweak {
    param($Tweak, [switch]$Undo)
    $backup = Get-Backup
    $mode = if ($Undo) { 'Revirtiendo' } else { 'Aplicando' }
    Write-Log "${mode}: $($Tweak.Name)"

    try {
        if (-not $Undo) {
            # Guardar estado original solo la primera vez
            if (-not $backup.ContainsKey($Tweak.Id)) {
                $backup[$Tweak.Id] = Get-Snapshot $Tweak
                Save-Backup $backup
            }
            foreach ($r in $Tweak.registry) { Set-RegValue $r.Path $r.Name $r.Type $r.Value }
            foreach ($s in $Tweak.service) {
                Set-Service -Name $s.Name -StartupType $s.StartupType -ErrorAction SilentlyContinue
                if ($s.StartupType -eq 'Disabled') { Stop-Service -Name $s.Name -Force -ErrorAction SilentlyContinue }
            }
            if ($Tweak.commands.apply) { & ([scriptblock]::Create($Tweak.commands.apply)) | Out-Null }
        }
        else {
            $snap = $backup[$Tweak.Id]
            if ($snap) {
                foreach ($r in $snap.Registry) {
                    if ($r.Existed) { Set-RegValue $r.Path $r.Name $r.Type $r.Value }
                    else { Remove-ItemProperty -Path $r.Path -Name $r.Name -ErrorAction SilentlyContinue }
                }
                foreach ($s in $snap.Services) {
                    Set-Service -Name $s.Name -StartupType $s.StartType -ErrorAction SilentlyContinue
                    if ($s.StartType -ne 'Disabled') { Start-Service -Name $s.Name -ErrorAction SilentlyContinue }
                }
                $backup.Remove($Tweak.Id)
                Save-Backup $backup
            }
            else {
                # Sin snapshot: usar OriginalValue del JSON
                foreach ($r in $Tweak.registry) {
                    if ($r.OriginalValue -eq '<RemoveEntry>') { Remove-ItemProperty -Path $r.Path -Name $r.Name -ErrorAction SilentlyContinue }
                    else { Set-RegValue $r.Path $r.Name $r.Type $r.OriginalValue }
                }
                foreach ($s in $Tweak.service) {
                    Set-Service -Name $s.Name -StartupType $s.OriginalType -ErrorAction SilentlyContinue
                }
            }
            if ($Tweak.commands.undo) { & ([scriptblock]::Create($Tweak.commands.undo)) | Out-Null }
        }
        Write-Log '  OK'
    } catch {
        Write-Log "  ERROR: $($_.Exception.Message)"
    }
}


# ---------- UI: ventana WPF generada desde XAML + tweaks.json ----------
Add-Type -AssemblyName PresentationFramework

$reader = New-Object System.Xml.XmlNodeReader ([xml]$script:Xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$panel         = $window.FindName('TweaksPanel')
$script:LogBox = $window.FindName('LogBox')
$checks        = @()

foreach ($group in ($script:Tweaks | Group-Object Category)) {
    $header = New-Object Windows.Controls.TextBlock
    $header.Text = $group.Name
    $header.FontSize = 15
    $header.FontWeight = 'Bold'
    $header.Foreground = '#89B4FA'
    $header.Margin = '0,12,0,4'
    [void]$panel.Children.Add($header)

    foreach ($t in $group.Group) {
        $cb = New-Object Windows.Controls.CheckBox
        $cb.Content = "$($t.Name)  [riesgo: $($t.Risk)]"
        $cb.ToolTip = $t.Description
        $cb.Tag = $t
        [void]$panel.Children.Add($cb)
        $checks += $cb
    }
}

$window.FindName('BtnApply').Add_Click({
    $sel = $checks | Where-Object { $_.IsChecked }
    if (-not $sel) { Write-Log 'No hay tweaks seleccionados.'; return }
    New-RestorePoint
    foreach ($cb in $sel) { Invoke-Tweak -Tweak $cb.Tag }
    Write-Log 'Listo. Algunos cambios requieren reiniciar sesión o la PC.'
})
$window.FindName('BtnUndo').Add_Click({
    foreach ($cb in ($checks | Where-Object { $_.IsChecked })) { Invoke-Tweak -Tweak $cb.Tag -Undo }
})
$window.FindName('BtnRestore').Add_Click({ New-RestorePoint })

Write-Log 'Listo. Marcá los tweaks y apretá Aplicar.'
[void]$window.ShowDialog()
