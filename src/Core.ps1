# ---------- Core: lógica de tweaks con snapshot + undo ----------
$script:AppDir     = Join-Path $env:LOCALAPPDATA 'MiOptimizador'
$script:BackupFile = Join-Path $script:AppDir 'backup.clixml'
$script:LogBox     = $null
$script:UiReady    = $false
$script:AppVersion = '1.2.0'   # se sube con cada cambio, así se ve si la app se actualizó
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
        Checkpoint-Computer -Description 'NurOptimizador' -RestorePointType MODIFY_SETTINGS -ErrorAction Stop
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
    if (-not (Test-Path $Path)) { New-Item -Path $Path -Force -ErrorAction Stop | Out-Null }
    Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value (ConvertTo-RegValue $Type $Value) -Force -ErrorAction Stop
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
    $regFail = 0
    Write-Log "${mode}: $($Tweak.Name)"

    try {
        if (-not $Undo) {
            # Guardar estado original solo la primera vez
            if (-not $backup.ContainsKey($Tweak.Id)) {
                $backup[$Tweak.Id] = Get-Snapshot $Tweak
                Save-Backup $backup
            }
            foreach ($r in $Tweak.registry) {
                try { Set-RegValue $r.Path $r.Name $r.Type $r.Value }
                catch { $regFail++; Write-Log "  No se pudo escribir $($r.Name): $($_.Exception.Message)" }
            }
            foreach ($s in $Tweak.service) {
                $svc = Get-Service -Name $s.Name -ErrorAction SilentlyContinue
                if (-not $svc) { Write-Log "  Servicio $($s.Name): no existe en este equipo, se omite"; continue }
                Set-Service -Name $s.Name -StartupType $s.StartupType -ErrorAction SilentlyContinue
                if ($s.StartupType -eq 'Disabled') { Stop-Service -Name $s.Name -Force -ErrorAction SilentlyContinue }
                $now = [string](Get-Service -Name $s.Name -ErrorAction SilentlyContinue).StartType
                if ($now -eq $s.StartupType) { Write-Log "  Servicio $($s.Name): $($s.StartupType)" }
                else {
                    # algunos servicios no dejan cambiarse con Set-Service: se prueba directo en el registro
                    $val = switch ($s.StartupType) { 'Disabled' { 4 } 'Manual' { 3 } default { 2 } }
                    $rk  = "HKLM:\SYSTEM\CurrentControlSet\Services\$($s.Name)"
                    try {
                        Set-ItemProperty -Path $rk -Name Start -Value $val -Type DWord -ErrorAction Stop
                        Write-Log "  Servicio $($s.Name): $($s.StartupType) (se aplica al reiniciar)"
                    }
                    catch { Write-Log "  Servicio $($s.Name): no se pudo cambiar (Windows lo protege)" }
                }
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
        if ($regFail -gt 0) { Write-Log "  Terminó con $regFail error(es) de registro."; return $false }
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
        foreach ($cap in $Tweak.capabilities) {
            Get-WindowsCapability -Online -Name "$cap*" -ErrorAction SilentlyContinue | Where-Object { $_.State -eq 'Installed' } | ForEach-Object {
                Write-Log "  Quitando capacidad: $($_.Name)"
                Remove-WindowsCapability -Online -Name $_.Name -ErrorAction SilentlyContinue | Out-Null
            }
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

# Flecha de accesos directos: se reemplaza por un ícono transparente propio, en C:\Windows\blank.ico (como Winhance).
# Detalle importante: si TODOS los píxeles tienen alfa 0, Windows puede entender que el ícono "no tiene canal alfa"
# y dibujarlo como un cuadrado negro. Por eso hay un único píxel con alfa 1 (invisible) en cada imagen.
# Además las imágenes chicas (16 a 48) van como bitmaps de 32 bits con la máscara AND en "transparente",
# y las grandes (64 a 256) como PNG, que es la combinación que usan los .ico modernos.
function New-BlankIcon([string]$Path) {
    Add-Type -AssemblyName System.Drawing
    $sizes  = 16, 24, 32, 48, 64, 128, 256
    $images = @()
    foreach ($sz in $sizes) {
        if ($sz -le 48) {
            $pix  = [byte[]]::new($sz * $sz * 4)
            $pix[$pix.Length - 1] = 1                                   # un píxel con alfa 1 (casi invisible)
            $row  = [int]([math]::Ceiling($sz / 32.0) * 4)
            $mask = [byte[]]::new($row * $sz)
            for ($i = 0; $i -lt $mask.Length; $i++) { $mask[$i] = 255 }  # máscara AND: todo transparente
            $ms = New-Object System.IO.MemoryStream
            $w  = New-Object System.IO.BinaryWriter($ms)
            $w.Write([uint32]40); $w.Write([int32]$sz); $w.Write([int32]($sz * 2))
            $w.Write([uint16]1); $w.Write([uint16]32); $w.Write([uint32]0); $w.Write([uint32]($pix.Length + $mask.Length))
            $w.Write([int32]0); $w.Write([int32]0); $w.Write([uint32]0); $w.Write([uint32]0)
            $w.Write([byte[]]$pix); $w.Write([byte[]]$mask)
            $images += ,($ms.ToArray())
            $ms.Dispose()
        }
        else {
            $bmp = New-Object System.Drawing.Bitmap($sz, $sz, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
            $g = [System.Drawing.Graphics]::FromImage($bmp)
            $g.Clear([System.Drawing.Color]::Transparent)
            $g.Dispose()
            $bmp.SetPixel($sz - 1, 0, [System.Drawing.Color]::FromArgb(1, 0, 0, 0))   # un píxel con alfa 1
            $ms = New-Object System.IO.MemoryStream
            $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
            $images += ,($ms.ToArray())
            $ms.Dispose(); $bmp.Dispose()
        }
    }
    $out = New-Object System.IO.MemoryStream
    $bw  = New-Object System.IO.BinaryWriter($out)
    $bw.Write([uint16]0); $bw.Write([uint16]1); $bw.Write([uint16]$sizes.Count)           # cabecera ICO
    $offset = 6 + 16 * $sizes.Count
    for ($i = 0; $i -lt $sizes.Count; $i++) {
        $dim = if ($sizes[$i] -ge 256) { 0 } else { $sizes[$i] }                           # 0 significa 256
        $bw.Write([byte]$dim); $bw.Write([byte]$dim); $bw.Write([byte]0); $bw.Write([byte]0)
        $bw.Write([uint16]1); $bw.Write([uint16]32)
        $bw.Write([uint32]$images[$i].Length); $bw.Write([uint32]$offset)
        $offset += $images[$i].Length
    }
    foreach ($img in $images) { $bw.Write([byte[]]$img) }
    [System.IO.File]::WriteAllBytes($Path, $out.ToArray())
}

# Verifica el .ico sin usar System.Drawing.Icon (esa clase no sabe leer íconos con PNG adentro)
function Test-BlankIcon([string]$Path) {
    Add-Type -AssemblyName System.Drawing
    $b = [System.IO.File]::ReadAllBytes($Path)
    if ($b.Length -lt 22) { return $false }
    if ([BitConverter]::ToUInt16($b, 0) -ne 0 -or [BitConverter]::ToUInt16($b, 2) -ne 1) { return $false }   # cabecera ICO
    $count = [int][BitConverter]::ToUInt16($b, 4)
    if ($count -lt 1) { return $false }
    for ($i = 0; $i -lt $count; $i++) {
        $e   = 6 + 16 * $i
        $len = [int][BitConverter]::ToUInt32($b, $e + 8)
        $off = [int][BitConverter]::ToUInt32($b, $e + 12)
        if ($len -le 8 -or ($off + $len) -gt $b.Length) { return $false }                                     # entrada dentro del archivo
        if ($b[$off] -eq 0x89 -and $b[$off + 1] -eq 0x50 -and $b[$off + 2] -eq 0x4E -and $b[$off + 3] -eq 0x47) {
            # imagen PNG: se decodifica y el píxel central tiene que ser transparente
            $ms  = [System.IO.MemoryStream]::new($b, $off, $len)
            $img = [System.Drawing.Image]::FromStream($ms)
            $bmp = New-Object System.Drawing.Bitmap($img)
            $a   = $bmp.GetPixel([int]($bmp.Width / 2), [int]($bmp.Height / 2)).A
            $bmp.Dispose(); $img.Dispose(); $ms.Dispose()
            if ($a -ne 0) { return $false }
        }
        else {
            # imagen bitmap de 32 bits: cabecera de 40 bytes y píxel central con alfa 0
            if ([BitConverter]::ToUInt32($b, $off) -ne 40 -or [BitConverter]::ToUInt16($b, $off + 14) -ne 32) { return $false }
            $w = [BitConverter]::ToInt32($b, $off + 4)
            $h = [int]([BitConverter]::ToInt32($b, $off + 8) / 2)
            $idx = $off + 40 + ((([int]($h / 2)) * $w + [int]($w / 2)) * 4) + 3
            if ($idx -ge $b.Length -or $b[$idx] -ne 0) { return $false }
        }
    }
    return $true
}
function Hide-ShortcutArrow {
    $ico = Join-Path $env:SystemRoot 'blank.ico'
    New-BlankIcon $ico

    # Verificación: el ícono tiene que ser válido y transparente ANTES de tocar el registro
    if (-not (Test-BlankIcon $ico)) { throw 'El ícono transparente no se generó bien. No se cambió nada.' }
    Write-Log "  Ícono transparente verificado ($ico)."

    $key = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons'
    if (-not (Test-Path $key)) { New-Item -Path $key -Force | Out-Null }
    Set-ItemProperty -Path $key -Name '29' -Value $ico -Type String -Force
    Restart-Explorer -ClearIconCache
}
function Show-ShortcutArrow {
    Remove-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons' -Name '29' -ErrorAction SilentlyContinue
    Restart-Explorer -ClearIconCache
}
function Test-ShortcutArrowHidden {
    $v = (Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons' -Name '29' -ErrorAction SilentlyContinue).'29'
    return [bool]($v -and ($v -eq (Join-Path $env:SystemRoot 'blank.ico')) -and (Test-Path $v))
}

# ---------- Efectos visuales: aplicar en vivo (como la ventana "Opciones de rendimiento") ----------
if (-not ('NurSpi' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class NurSpi {
    [StructLayout(LayoutKind.Sequential)]
    struct ANIMATIONINFO { public uint cbSize; public int iMinAnimate; }
    [DllImport("user32.dll", SetLastError = true)]
    static extern bool SystemParametersInfo(uint action, uint param, IntPtr data, uint flags);
    [DllImport("user32.dll", SetLastError = true)]
    static extern bool SystemParametersInfo(uint action, uint param, ref ANIMATIONINFO data, uint flags);
    const uint SAVE = 0x01 | 0x02;   // SPIF_UPDATEINIFILE | SPIF_SENDCHANGE
    // acciones cuyo valor va en pvParam
    public static bool SetData(uint action, bool on) { return SystemParametersInfo(action, 0, new IntPtr(on ? 1 : 0), SAVE); }
    // acciones cuyo valor va en uiParam
    public static bool SetParam(uint action, bool on) { return SystemParametersInfo(action, on ? 1u : 0u, IntPtr.Zero, SAVE); }
    public static bool SetMinAnimate(bool on) {
        ANIMATIONINFO ai = new ANIMATIONINFO(); ai.cbSize = 8; ai.iMinAnimate = on ? 1 : 0;
        return SystemParametersInfo(0x0049, 8, ref ai, SAVE);
    }
}
'@
}

function Test-MaskBit($Mask, [int]$Index, [int]$Bit) {
    return [bool]($Mask[$Index] -band $Bit)
}

# Lee lo que hay en el registro y lo aplica a la sesión actual (sirve para aplicar y para revertir)
function Update-VisualEffectsLive {
    $d    = Get-ItemProperty 'HKCU:\Control Panel\Desktop' -ErrorAction SilentlyContinue
    $wm   = Get-ItemProperty 'HKCU:\Control Panel\Desktop\WindowMetrics' -ErrorAction SilentlyContinue
    $mask = [byte[]]$d.UserPreferencesMask
    if ($mask -and $mask.Length -ge 5) {
        [void][NurSpi]::SetData(0x1007, (Test-MaskBit $mask 0 0x08))   # desplazamiento suave de cuadros de lista
        [void][NurSpi]::SetData(0x1005, (Test-MaskBit $mask 0 0x04))   # deslizar cuadros combinados
        [void][NurSpi]::SetData(0x1003, (Test-MaskBit $mask 0 0x02))   # atenuar/deslizar menús
        [void][NurSpi]::SetData(0x101B, (Test-MaskBit $mask 1 0x20))   # sombra bajo el puntero
        [void][NurSpi]::SetData(0x1017, (Test-MaskBit $mask 1 0x08))   # atenuar/deslizar tooltips
        [void][NurSpi]::SetData(0x1015, (Test-MaskBit $mask 1 0x04))   # atenuar elementos tras hacer clic
        [void][NurSpi]::SetData(0x1025, (Test-MaskBit $mask 2 0x04))   # sombras bajo las ventanas
        [void][NurSpi]::SetData(0x1043, (Test-MaskBit $mask 4 0x02))   # animar controles dentro de ventanas
    }
    [void][NurSpi]::SetParam(0x0025, ($d.DragFullWindows -eq '1'))     # contenido de la ventana al arrastrar
    [void][NurSpi]::SetParam(0x004B, ($d.FontSmoothing -ne '0'))       # suavizar bordes de fuentes
    [void][NurSpi]::SetMinAnimate(($wm.MinAnimate -eq '1'))            # animar al minimizar/maximizar
    Write-Log '  Efectos aplicados a la sesión actual.'
    Restart-Explorer
}

# Compara por lo que importa (no por los bytes exactos de la máscara, que Windows puede reescribir)
function Test-VisualEffects {
    $d  = Get-ItemProperty 'HKCU:\Control Panel\Desktop' -ErrorAction SilentlyContinue
    $wm = Get-ItemProperty 'HKCU:\Control Panel\Desktop\WindowMetrics' -ErrorAction SilentlyContinue
    $a  = Get-ItemProperty 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -ErrorAction SilentlyContinue
    $m  = [byte[]]$d.UserPreferencesMask
    if (-not $m -or $m.Length -lt 5) { return $false }
    if (($m[0] -band 0x0E) -ne 0 -or ($m[1] -band 0x2C) -ne 0 -or ($m[2] -band 0x04) -ne 0 -or ($m[4] -band 0x02) -ne 0) { return $false }
    return ($d.DragFullWindows -eq '1' -and $d.FontSmoothing -eq '2' -and $wm.MinAnimate -eq '0' -and
            $a.ListviewAlphaSelect -eq 1 -and $a.IconsOnly -eq 0 -and $a.ListviewShadow -eq 0 -and $a.TaskbarAnimations -eq 0)
}

# ---------- Reinicio del Explorador ----------
$script:DeferExplorer     = $false   # en un lote (modo rápido) se pospone y se hace una sola vez al final
$script:ExplorerPending   = $false
$script:IconCachePending  = $false

function Invoke-ExplorerRestart {
    $clear = $script:IconCachePending
    $script:ExplorerPending  = $false
    $script:IconCachePending = $false
    Write-Log '  Reiniciando el Explorador...'
    Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    if ($clear) {
        Remove-Item "$env:LOCALAPPDATA\IconCache.db" -Force -ErrorAction SilentlyContinue
        Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\iconcache_*.db" -Force -ErrorAction SilentlyContinue
    }
    # Windows relanza el shell solo. Si en 10 segundos no volvió, lo lanzamos nosotros.
    $deadline = (Get-Date).AddSeconds(10)
    do { Start-Sleep -Milliseconds 400 } while (-not (Get-Process -Name explorer -ErrorAction SilentlyContinue) -and (Get-Date) -lt $deadline)
    if (-not (Get-Process -Name explorer -ErrorAction SilentlyContinue)) { Start-Process explorer.exe }
    if ($clear) {
        # le pide a Windows que vuelva a dibujar los íconos
        Start-Process -FilePath (Join-Path $env:SystemRoot 'System32\ie4uinit.exe') -ArgumentList '-show' -WindowStyle Hidden -ErrorAction SilentlyContinue
    }
}

function Restart-Explorer {
    param([switch]$ClearIconCache)
    if ($ClearIconCache) { $script:IconCachePending = $true }
    if ($script:DeferExplorer) { $script:ExplorerPending = $true; return }
    Invoke-ExplorerRestart
}

# ---------- Widgets ----------
# Ocultar el botón por registro/política no alcanza en las versiones nuevas de Windows 11 (sale "acceso denegado").
# Lo que sí funciona es desinstalar el paquete de Widgets, como hace WinUtil.
function Remove-Widgets {
    Write-Log '  Quitando Widgets...'
    Get-Process -Name 'Widgets', 'WidgetService' -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
    foreach ($n in 'MicrosoftWindows.Client.WebExperience', 'Microsoft.WidgetsPlatformRuntime') {
        $p = Get-AppxPackage -AllUsers -Name $n -ErrorAction SilentlyContinue
        if ($p) {
            $p | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue
            Write-Log "  Quitado: $n"
        }
    }
    try { Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarDa -Type DWord -Value 0 -ErrorAction Stop } catch { }
}
function Restore-Widgets {
    try { Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name TaskbarDa -Type DWord -Value 1 -ErrorAction Stop } catch { }
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Log '  Reinstalando Widgets (Windows Web Experience Pack)...'
        winget install --id 9MSSGKG348SP --source msstore --silent --accept-package-agreements --accept-source-agreements | Out-Null
        if ($LASTEXITCODE -ne 0) { Write-Log '  No se pudo reinstalar solo: instalá "Windows Web Experience Pack" desde la Microsoft Store.' }
    }
    else { Write-Log '  Para recuperar Widgets, instalá "Windows Web Experience Pack" desde la Microsoft Store.' }
}

# ---------- Microsoft Edge ----------
function Test-EdgeInstalled {
    foreach ($b in "${env:ProgramFiles(x86)}", $env:ProgramFiles) {
        if ($b -and (Test-Path (Join-Path $b 'Microsoft\Edge\Application\msedge.exe'))) { return $true }
    }
    return $false
}

function Remove-Edge {
    if (-not (Test-EdgeInstalled)) { Write-Log '  Edge no está instalado.'; return }
    $guid = '{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}'          # Microsoft Edge (canal estable)
    Write-Log '  Cerrando Edge...'
    Get-Process -Name msedge, MicrosoftEdgeUpdate -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

    # 1) Desinstalador propio de Edge
    $roots  = @("${env:ProgramFiles(x86)}\Microsoft\Edge\Application", "$env:ProgramFiles\Microsoft\Edge\Application") | Where-Object { Test-Path $_ }
    $setups = @($roots | ForEach-Object { Get-ChildItem $_ -Recurse -Filter setup.exe -ErrorAction SilentlyContinue | Where-Object { $_.DirectoryName -like '*\Installer' } })
    foreach ($st in $setups) {
        Write-Log "  Ejecutando el desinstalador de Edge ($($st.Directory.Parent.Name))..."
        Start-Process -FilePath $st.FullName -ArgumentList '--uninstall', '--system-level', '--verbose-logging', '--force-uninstall' -Wait -WindowStyle Hidden
    }

    # 2) Si no alcanzó, política oficial de Edge Update
    $pol = 'HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate'
    if (Test-EdgeInstalled) {
        Write-Log '  Primer intento sin éxito; probando con Edge Update...'
        if (-not (Test-Path $pol)) { New-Item -Path $pol -Force | Out-Null }
        Set-ItemProperty -Path $pol -Name "Uninstall$guid" -Value 1 -Type DWord -Force
        $mu = "${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe"
        if (Test-Path $mu) { Start-Process -FilePath $mu -ArgumentList '/ua', '/installsource', 'scheduler' -Wait -WindowStyle Hidden; Start-Sleep -Seconds 5 }
        Remove-ItemProperty -Path $pol -Name "Uninstall$guid" -ErrorAction SilentlyContinue
    }

    if (Test-EdgeInstalled) {
        throw 'Windows protege Edge en esta versión y no permitió quitarlo. No se cambió nada más.'
    }

    # 3) Quitado: que no vuelva solo. No se toca InstallDefault para no bloquear el runtime de WebView2.
    if (-not (Test-Path $pol)) { New-Item -Path $pol -Force | Out-Null }
    Set-ItemProperty -Path $pol -Name "Install$guid" -Value 0 -Type DWord -Force
    $upd = 'HKLM:\SOFTWARE\Microsoft\EdgeUpdate'
    if (-not (Test-Path $upd)) { New-Item -Path $upd -Force | Out-Null }
    Set-ItemProperty -Path $upd -Name 'DoNotUpdateToEdgeWithChromium' -Value 1 -Type DWord -Force
    Write-Log '  Edge desinstalado. Se bloqueó su reinstalación automática.'
}

function Disable-EdgeUpdateTasks {
    Get-ScheduledTask -TaskName 'MicrosoftEdgeUpdate*' -ErrorAction SilentlyContinue | ForEach-Object {
        Disable-ScheduledTask -InputObject $_ -ErrorAction SilentlyContinue | Out-Null
        Write-Log "  Tarea $($_.TaskName): desactivada"
    }
}
function Enable-EdgeUpdateTasks {
    Get-ScheduledTask -TaskName 'MicrosoftEdgeUpdate*' -ErrorAction SilentlyContinue | ForEach-Object {
        Enable-ScheduledTask -InputObject $_ -ErrorAction SilentlyContinue | Out-Null
    }
}

# ---------- Google Chrome ----------
function Test-ChromeInstalled {
    $files = @("$env:ProgramFiles\Google\Chrome\Application\chrome.exe", "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe", "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe")
    foreach ($f in $files) { if (Test-Path $f) { return $true } }
    foreach ($k in 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe', 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe') {
        if (Test-Path $k) { return $true }
    }
    return $false
}

function Install-Chrome {
    Write-Log 'Instalando Google Chrome...'
    try {
        if (Get-Command winget -ErrorAction SilentlyContinue) {
            winget install -e --id Google.Chrome --silent --accept-package-agreements --accept-source-agreements | Out-Null
            if ($LASTEXITCODE -eq 0 -and (Test-ChromeInstalled)) { Write-Log '  Chrome instalado (winget).'; return $true }
            Write-Log "  winget no pudo instalarlo (código $LASTEXITCODE). Probando la descarga directa..."
        }
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        $tmp = Join-Path $env:TEMP 'ChromeStandaloneSetup64.exe'
        Invoke-WebRequest -Uri 'https://dl.google.com/chrome/install/ChromeStandaloneSetup64.exe' -OutFile $tmp -UseBasicParsing
        Start-Process -FilePath $tmp -ArgumentList '/silent', '/install' -Wait
        Remove-Item $tmp -Force -ErrorAction SilentlyContinue
        if (Test-ChromeInstalled) { Write-Log '  Chrome instalado (descarga directa).'; return $true }
        throw 'La instalación terminó pero Chrome no aparece instalado.'
    }
    catch {
        Write-Log "  ERROR: $($_.Exception.Message)"
        return $false
    }
}

# ---------- Game Bar: integración ----------
# Al desinstalar Game Bar, juegos y mandos siguen intentando abrirlo y Windows muestra "necesitás una app nueva
# para abrir este enlace ms-gamebar / ms-gamingoverlay". Se apunta esos enlaces a un ejecutable inofensivo.
function Disable-GameBarIntegration {
    New-Item -Path 'HKCU:\SOFTWARE\Microsoft\GameBar' -Force | Out-Null
    Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\GameBar' -Name UseNexusForGameBarEnabled -Type DWord -Value 0
    New-Item -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' -Force | Out-Null
    Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' -Name AppCaptureEnabled -Type DWord -Value 0
    $cmd = '"' + (Join-Path $env:SystemRoot 'System32\systray.exe') + '"'
    foreach ($proto in 'ms-gamebar', 'ms-gamebarservices', 'ms-gamingoverlay') {
        $root = "Registry::HKEY_CLASSES_ROOT\$proto"
        New-Item -Path $root -Force | Out-Null
        Set-ItemProperty -Path $root -Name '(default)' -Value "URL:$proto"
        New-ItemProperty -Path $root -Name 'URL Protocol' -Value '' -PropertyType String -Force | Out-Null
        New-ItemProperty -Path $root -Name 'NoOpenWith' -Value '' -PropertyType String -Force | Out-Null
        New-Item -Path "$root\shell\open\command" -Force | Out-Null
        Set-ItemProperty -Path "$root\shell\open\command" -Name '(default)' -Value $cmd
    }
    Write-Log '  Integración de Game Bar desactivada (sin avisos de ms-gamebar).'
}
