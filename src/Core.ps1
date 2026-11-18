# ---------- Core: lógica de tweaks con snapshot + undo ----------
$script:AppDir     = Join-Path $env:LOCALAPPDATA 'MiOptimizador'
$script:BackupFile = Join-Path $script:AppDir 'backup.clixml'
$script:LogBox     = $null
$script:UiReady    = $false
New-Item $script:AppDir -ItemType Directory -Force | Out-Null

function Write-Log {
    param([string]$Message)
    $line = "[{0}] {1}" -f (Get-Date -Format 'HH:mm:ss'), $Message
    Add-Content -Path (Join-Path $script:AppDir 'log.txt') -Value $line
    if ($script:LogBox) {
        $script:LogBox.AppendText($line + "`r`n")
        $script:LogBox.ScrollToEnd()
        if ($script:UiReady) { Update-UI }   # refresca la ventana durante tareas largas
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
    $snap = @{ Registry = @(); Services = @(); Tasks = @() }
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
    foreach ($t in $Tweak.task) {
        $task = Get-ScheduledTask -TaskPath $t.Path -TaskName $t.Name -ErrorAction SilentlyContinue
        if ($task) { $snap.Tasks += @{ Path = $t.Path; Name = $t.Name; State = [string]$task.State } }
    }
    return $snap
}

function ConvertTo-RegValue($Type, $Value) {
    switch ($Type) {
        'DWord' { return [int]$Value }
        'QWord' { return [long]$Value }
        'Binary' {
            if ($Value -is [byte[]]) { return ,$Value }
            $bytes = [byte[]](($Value -split ',') | ForEach-Object { [Convert]::ToByte($_.Trim(), 16) })
            return ,$bytes
        }
        default { return [string]$Value }
    }
}

function Set-RegValue($Path, $Name, $Type, $Value) {
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force | Out-Null }
    Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value (ConvertTo-RegValue $Type $Value) -Force
}

# Devuelve $true si el tweak ya está aplicado (para mostrar el interruptor en ON al abrir)
function Test-TweakApplied($Tweak) {
    if ($Tweak.commands.test) {
        try { return [bool](& ([scriptblock]::Create($Tweak.commands.test))) } catch { return $false }
    }
    $checked = $false
    if ($Tweak.registry) {
        foreach ($r in $Tweak.registry) {
            $p = Get-ItemProperty -Path $r.Path -Name $r.Name -ErrorAction SilentlyContinue
            if ($null -eq $p) { return $false }
            $cur = $p.($r.Name)
            if ($r.Type -eq 'Binary') {
                $curHex = (@($cur) | ForEach-Object { '{0:x2}' -f $_ }) -join ','
                $want   = (($r.Value -split ',') | ForEach-Object { $_.Trim().ToLower().PadLeft(2, '0') }) -join ','
                if ($curHex -ne $want) { return $false }
            }
            elseif ("$cur" -ne "$($r.Value)") { return $false }
        }
        $checked = $true
    }
    if ($Tweak.service) {
        foreach ($s in $Tweak.service) {
            $svc = Get-Service -Name $s.Name -ErrorAction SilentlyContinue
            if (-not $svc) { continue }   # servicio que no existe en este equipo: se ignora
            if ([string]$svc.StartType -ne $s.StartupType) { return $false }
            $checked = $true
        }
    }
    if ($Tweak.task) {
        foreach ($t in $Tweak.task) {
            $task = Get-ScheduledTask -TaskPath $t.Path -TaskName $t.Name -ErrorAction SilentlyContinue
            if (-not $task) { continue }   # tarea que no existe en este equipo: se ignora
            if ([string]$task.State -ne 'Disabled') { return $false }
            $checked = $true
        }
    }
    if ($checked) { return $true }
    # Tweaks solo de comandos: se considera aplicado si lo aplicamos nosotros
    return (Get-Backup).ContainsKey($Tweak.Id)
}

# Devuelve $true si salió bien, $false si hubo error
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
                $svc = Get-Service -Name $s.Name -ErrorAction SilentlyContinue
                if (-not $svc) { Write-Log "  Servicio $($s.Name): no existe en este equipo, se omite"; continue }
                Set-Service -Name $s.Name -StartupType $s.StartupType -ErrorAction SilentlyContinue
                if ($s.StartupType -eq 'Disabled') { Stop-Service -Name $s.Name -Force -ErrorAction SilentlyContinue }
                Write-Log "  Servicio $($s.Name): $($s.StartupType)"
            }
            foreach ($t in $Tweak.task) {
                $task = Get-ScheduledTask -TaskPath $t.Path -TaskName $t.Name -ErrorAction SilentlyContinue
                if (-not $task) { Write-Log "  Tarea $($t.Name): no existe en este equipo, se omite"; continue }
                Disable-ScheduledTask -TaskPath $t.Path -TaskName $t.Name -ErrorAction SilentlyContinue | Out-Null
                Write-Log "  Tarea $($t.Name): desactivada"
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
                    if ($s.StartType -eq 'Automatic') { Start-Service -Name $s.Name -ErrorAction SilentlyContinue }
                }
                foreach ($t in $snap.Tasks) {
                    if ($t.State -ne 'Disabled') { Enable-ScheduledTask -TaskPath $t.Path -TaskName $t.Name -ErrorAction SilentlyContinue | Out-Null }
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
                foreach ($t in $Tweak.task) {
                    Enable-ScheduledTask -TaskPath $t.Path -TaskName $t.Name -ErrorAction SilentlyContinue | Out-Null
                }
            }
            if ($Tweak.commands.undo) { & ([scriptblock]::Create($Tweak.commands.undo)) | Out-Null }
        }
        Write-Log '  OK'
        return $true
    } catch {
        Write-Log "  ERROR: $($_.Exception.Message)"
        return $false
    }
}

# Borra temporales y devuelve los MB liberados
function Clear-TempFiles {
    $paths = @($env:TEMP, "$env:SystemRoot\Temp") | Select-Object -Unique
    $before = 0
    foreach ($p in $paths) {
        $before += [long](Get-ChildItem $p -Recurse -Force -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    }
    foreach ($p in $paths) {
        Write-Log "  Limpiando $p"
        Get-ChildItem $p -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
    $after = 0
    foreach ($p in $paths) {
        $after += [long](Get-ChildItem $p -Recurse -Force -File -ErrorAction SilentlyContinue | Measure-Object Length -Sum).Sum
    }
    $mb = [math]::Round(($before - $after) / 1MB, 1)
    Write-Log "  Espacio liberado: $mb MB"
}

# Acciones de un solo uso (limpieza, reparación): sin undo. Devuelve $true/$false
function Invoke-Action {
    param($Tweak)
    Write-Log "Ejecutando: $($Tweak.Name)"
    try {
        foreach ($pkg in $Tweak.appx) {
            $found = Get-AppxPackage -AllUsers -Name $pkg -ErrorAction SilentlyContinue
            if ($found) {
                $found | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
                Write-Log "  Quitada: $pkg"
            }
            Get-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue |
                Where-Object { $_.DisplayName -eq $pkg } |
                Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null
        }
        if ($Tweak.commands.apply) { & ([scriptblock]::Create($Tweak.commands.apply)) | Out-Null }
        Write-Log '  OK'
        return $true
    } catch {
        Write-Log "  ERROR: $($_.Exception.Message)"
        return $false
    }
}

# ---------- Funciones auxiliares usadas por tweaks y acciones ----------
function Remove-OneDrive {
    Write-Log '  Cerrando OneDrive...'
    Stop-Process -Name OneDrive -Force -ErrorAction SilentlyContinue
    $setup = Join-Path $env:SystemRoot 'SysWOW64\OneDriveSetup.exe'
    if (-not (Test-Path $setup)) { $setup = Join-Path $env:SystemRoot 'System32\OneDriveSetup.exe' }
    if (Test-Path $setup) {
        Write-Log '  Desinstalando OneDrive...'
        Start-Process -FilePath $setup -ArgumentList '/uninstall' -Wait
    }
    elseif (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Log '  Desinstalando OneDrive con winget...'
        winget uninstall --id Microsoft.OneDrive --silent --accept-source-agreements | Out-Null
    }
    else {
        throw 'No se encontró el desinstalador de OneDrive.'
    }
}

function Remove-LegacyFeatures {
    $caps = @('App.StepsRecorder', 'MathRecognizer', 'Print.Fax.Scan', 'Media.WindowsMediaPlayer')
    foreach ($c in $caps) {
        $found = Get-WindowsCapability -Online -Name "$c*" -ErrorAction SilentlyContinue | Where-Object { $_.State -eq 'Installed' }
        foreach ($f in $found) {
            Write-Log "  Quitando capacidad: $($f.Name)"
            Remove-WindowsCapability -Online -Name $f.Name -ErrorAction SilentlyContinue | Out-Null
        }
    }
    $feats = @('MicrosoftWindowsPowerShellV2Root', 'MicrosoftWindowsPowerShellV2', 'SMB1Protocol', 'WorkFolders-Client', 'Printing-XPSServices-Features')
    foreach ($f in $feats) {
        $o = Get-WindowsOptionalFeature -Online -FeatureName $f -ErrorAction SilentlyContinue
        if ($o -and $o.State -eq 'Enabled') {
            Write-Log "  Desactivando característica: $f"
            Disable-WindowsOptionalFeature -Online -FeatureName $f -NoRestart -ErrorAction SilentlyContinue | Out-Null
        }
    }
    Write-Log '  Algunos cambios pueden requerir reiniciar la PC.'
}

# Menú Inicio: guarda una copia de los anclados y los borra (Windows los regenera según la política)
function Get-StartMenuPaths {
    $dir = Join-Path $env:LOCALAPPDATA 'Packages\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy\LocalState'
    $bk  = Join-Path $script:AppDir 'start-backup'
    return @($dir, $bk)
}
function Clear-StartMenuPins {
    $dir, $bk = Get-StartMenuPaths
    New-Item $bk -ItemType Directory -Force | Out-Null
    foreach ($f in 'start.bin', 'start2.bin') {
        $src = Join-Path $dir $f
        if (Test-Path $src) {
            if (-not (Test-Path (Join-Path $bk $f))) { Copy-Item $src $bk -Force }   # no pisar la primera copia
            Remove-Item $src -Force -ErrorAction SilentlyContinue
        }
    }
    Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue
}
function Restore-StartMenuPins {
    $dir, $bk = Get-StartMenuPaths
    foreach ($f in 'start.bin', 'start2.bin') {
        $src = Join-Path $bk $f
        if (Test-Path $src) { Copy-Item $src $dir -Force }
    }
    Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue
}

# Flecha de accesos directos: se reemplaza por un ícono transparente generado acá mismo
function New-BlankIcon([string]$Path) {
    $ms = New-Object System.IO.MemoryStream
    $bw = New-Object System.IO.BinaryWriter($ms)
    $bw.Write([uint16]0); $bw.Write([uint16]1); $bw.Write([uint16]1)                     # cabecera ICO
    $bw.Write([byte]16); $bw.Write([byte]16); $bw.Write([byte]0); $bw.Write([byte]0)    # 16x16
    $bw.Write([uint16]1); $bw.Write([uint16]32); $bw.Write([uint32]1128); $bw.Write([uint32]22)
    $bw.Write([uint32]40); $bw.Write([int32]16); $bw.Write([int32]32)                     # BITMAPINFOHEADER
    $bw.Write([uint16]1); $bw.Write([uint16]32); $bw.Write([uint32]0); $bw.Write([uint32]1088)
    $bw.Write([int32]0); $bw.Write([int32]0); $bw.Write([uint32]0); $bw.Write([uint32]0)
    $bw.Write([byte[]](New-Object byte[] 1024))                                           # píxeles transparentes
    $bw.Write([byte[]](New-Object byte[] 64))                                             # máscara
    [System.IO.File]::WriteAllBytes($Path, $ms.ToArray())
}
function Hide-ShortcutArrow {
    $ico = Join-Path $script:AppDir 'blank.ico'
    New-BlankIcon $ico
    $key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons'
    if (-not (Test-Path $key)) { New-Item -Path $key -Force | Out-Null }
    Set-ItemProperty -Path $key -Name '29' -Value "$ico,0" -Type String -Force
    Stop-Process -Name explorer -Force
}
function Show-ShortcutArrow {
    Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons' -Name '29' -ErrorAction SilentlyContinue
    Stop-Process -Name explorer -Force
}
