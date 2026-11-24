# ---------- UI: layout tipo Winhance con estilo glassmorphism ----------
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

# Acrílico real de Windows 11 (22H2+) vía DWM. En versiones viejas se usa un fondo de respaldo.
if (-not ('NurGlass' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;
public static class NurGlass {
    [StructLayout(LayoutKind.Sequential)]
    struct MARGINS { public int L, R, T, B; }
    [DllImport("dwmapi.dll")]
    static extern int DwmSetWindowAttribute(IntPtr hwnd, int attr, ref int value, int size);
    [DllImport("dwmapi.dll")]
    static extern int DwmExtendFrameIntoClientArea(IntPtr hwnd, ref MARGINS m);
    public static bool Enable(IntPtr hwnd) {
        try {
            int dark = 1;   DwmSetWindowAttribute(hwnd, 20, ref dark, 4);   // modo oscuro
            int round = 2;  DwmSetWindowAttribute(hwnd, 33, ref round, 4);  // esquinas redondeadas
            MARGINS m = new MARGINS(); m.L = -1; m.R = -1; m.T = -1; m.B = -1;
            DwmExtendFrameIntoClientArea(hwnd, ref m);
            int acrylic = 3;                                                // 3 = acrílico
            return DwmSetWindowAttribute(hwnd, 38, ref acrylic, 4) == 0;
        } catch { return false; }
    }
}
'@
}

$reader = New-Object System.Xml.XmlNodeReader ([xml]$script:Xaml)
$script:window = [Windows.Markup.XamlReader]::Load($reader)

$script:Tint         = $script:window.FindName('Tint')
$script:LogBox       = $script:window.FindName('LogBox')
$script:PageTitle    = $script:window.FindName('PageTitle')
$script:PageSub      = $script:window.FindName('PageSub')
$script:SearchBox    = $script:window.FindName('SearchBox')
$script:SearchHint   = $script:window.FindName('SearchHint')
$script:SearchBorder = $script:window.FindName('SearchBorder')

$script:PageUI = @{
    Optimizar    = $script:window.FindName('PageOptimizar')
    Personalizar = $script:window.FindName('PagePersonalizar')
    Mantenimiento = $script:window.FindName('PageMantenimiento')
    Registro     = $script:window.FindName('PageRegistro')
}
$script:Nav = @{
    Optimizar    = $script:window.FindName('NavOptimizar')
    Personalizar = $script:window.FindName('NavPersonalizar')
    Mantenimiento = $script:window.FindName('NavMantenimiento')
    Registro     = $script:window.FindName('NavRegistro')
}
$script:Panels = @{
    Optimizar    = $script:window.FindName('PanelOptimizar')
    Personalizar = $script:window.FindName('PanelPersonalizar')
    Mantenimiento = $script:window.FindName('PanelMantenimiento')
}
$script:PageInfo = @{
    Optimizar    = @('Optimizar', 'Privacidad, rendimiento y limpieza de Windows')
    Personalizar = @('Personalizar', 'Cómo se ve y se comporta el Explorador y el sistema')
    Mantenimiento = @('Mantenimiento', 'Limpieza y reparación del sistema')
    Registro     = @('Registro', 'Todo lo que hizo la app en esta sesión')
}
# Qué categoría del JSON va en qué página
$script:CategoryPage = @{
    'Privacidad' = 'Optimizar'; 'Rendimiento' = 'Optimizar'; 'Debloat' = 'Optimizar'
    'Interfaz'   = 'Personalizar'; 'Barra de tareas' = 'Personalizar'; 'Menú Inicio' = 'Personalizar'; 'Sonido' = 'Personalizar'
    'Limpieza'   = 'Mantenimiento'; 'Reparación' = 'Mantenimiento'
}
$script:CurrentPage  = 'Optimizar'
$script:RestoreDone  = $false
$script:Sections     = New-Object System.Collections.ArrayList
$script:Controls     = @{}
$script:TweakById    = @{}

# ---------- Helpers ----------
function Get-Brush([string]$Hex) {
    (New-Object System.Windows.Media.BrushConverter).ConvertFromString($Hex)
}

function Update-UI {
    $script:window.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Render)
}

function Show-Page([string]$Name) {
    $script:CurrentPage = $Name
    foreach ($k in $script:PageUI.Keys) {
        $script:PageUI[$k].Visibility = if ($k -eq $Name) { 'Visible' } else { 'Collapsed' }
    }
    $script:PageTitle.Text = $script:PageInfo[$Name][0]
    $script:PageSub.Text   = $script:PageInfo[$Name][1]
    $script:SearchBorder.Visibility = if ($Name -eq 'Registro') { 'Collapsed' } else { 'Visible' }
}

function New-TweakRow($Tweak, [bool]$ShowSeparator) {
    $grid = New-Object Windows.Controls.Grid
    $c1 = New-Object Windows.Controls.ColumnDefinition
    $c1.Width = [Windows.GridLength]::new(1, [Windows.GridUnitType]::Star)
    $c2 = New-Object Windows.Controls.ColumnDefinition
    $c2.Width = [Windows.GridLength]::Auto
    [void]$grid.ColumnDefinitions.Add($c1)
    [void]$grid.ColumnDefinitions.Add($c2)

    $left = New-Object Windows.Controls.StackPanel

    $name = New-Object Windows.Controls.TextBlock
    $name.Text = $Tweak.Name
    $name.FontSize = 14
    $name.FontWeight = [Windows.FontWeights]::SemiBold
    $name.Foreground = [Windows.Media.Brushes]::White

    $desc = New-Object Windows.Controls.TextBlock
    $desc.Text = $Tweak.Description
    $desc.TextWrapping = 'Wrap'
    $desc.FontSize = 12
    $desc.Foreground = Get-Brush '#B3FFFFFF'
    $desc.Margin = [Windows.Thickness]::new(0, 3, 0, 0)

    switch ($Tweak.Risk) {
        'Bajo'  { $chipBg = '#3322C55E'; $chipFg = '#FF86EFAC' }
        'Medio' { $chipBg = '#33F59E0B'; $chipFg = '#FFFCD34D' }
        default { $chipBg = '#33EF4444'; $chipFg = '#FFFCA5A5' }
    }
    $chip = New-Object Windows.Controls.Border
    $chip.CornerRadius = [Windows.CornerRadius]::new(8)
    $chip.Padding = [Windows.Thickness]::new(8, 2, 8, 2)
    $chip.Margin = [Windows.Thickness]::new(0, 8, 0, 0)
    $chip.HorizontalAlignment = 'Left'
    $chip.Background = Get-Brush $chipBg
    $chipText = New-Object Windows.Controls.TextBlock
    $chipText.Text = "Riesgo $($Tweak.Risk)"
    $chipText.FontSize = 11
    $chipText.Foreground = Get-Brush $chipFg
    $chip.Child = $chipText

    [void]$left.Children.Add($name)
    [void]$left.Children.Add($desc)
    [void]$left.Children.Add($chip)

    if ($Tweak.Kind -eq 'action') {
        # Acción de un solo uso: botón en lugar de interruptor
        $sw = New-Object Windows.Controls.Button
        $sw.Style = $script:window.FindResource('GlassButton')
        $sw.Content = 'Ejecutar'
        $sw.MinWidth = 100
        $sw.VerticalAlignment = 'Center'
        $sw.Margin = [Windows.Thickness]::new(20, 0, 0, 0)
        $sw.Tag = $Tweak
        $sw.Add_Click({
            param($sender, $e)
            $t = $sender.Tag
            if ($t.Confirm) {
                $ans = [Windows.MessageBox]::Show($t.Confirm, 'NurOptimizador', 'YesNo', 'Question')
                if ($ans -ne 'Yes') { return }
            }
            $sender.IsEnabled = $false
            $sender.Content = 'Trabajando...'
            Update-UI
            $res = Invoke-Action -Tweak $t
            $ok = [bool]($res | Select-Object -Last 1)
            $sender.Content = if ($ok) { 'Hecho' } else { 'Reintentar' }
            $sender.IsEnabled = $true
        })
    }
    else {
        $sw = New-Object Windows.Controls.Primitives.ToggleButton
        $sw.Style = $script:window.FindResource('Switch')
        $sw.VerticalAlignment = 'Center'
        $sw.Margin = [Windows.Thickness]::new(20, 0, 0, 0)
        $sw.Tag = $Tweak
        $sw.IsChecked = [bool](Test-TweakApplied $Tweak)   # antes de enganchar el evento Click

        # Click solo se dispara por acción del usuario: ON = aplicar, OFF = revertir
        $sw.Add_Click({
            param($sender, $e)
            $t = $sender.Tag
            $want = [bool]$sender.IsChecked
            $res = if ($want) { Invoke-Tweak -Tweak $t } else { Invoke-Tweak -Tweak $t -Undo }
            $ok = [bool]($res | Select-Object -Last 1)
            if (-not $ok) { $sender.IsChecked = -not $want }   # volver atrás si falló
        })
    }

    $script:Controls[$Tweak.Id] = $sw
    [Windows.Controls.Grid]::SetColumn($sw, 1)
    [void]$grid.Children.Add($left)
    [void]$grid.Children.Add($sw)

    $row = New-Object Windows.Controls.Border
    $row.Padding = [Windows.Thickness]::new(20, 14, 20, 14)
    if ($ShowSeparator) {
        $row.BorderThickness = [Windows.Thickness]::new(0, 0, 0, 1)
        $row.BorderBrush = Get-Brush '#1AFFFFFF'
    }
    $row.Child = $grid
    return $row
}

# ---------- Construir las páginas desde tweaks.json ----------
foreach ($group in ($script:Tweaks | Group-Object Category)) {
    $pageKey = if ($script:CategoryPage.ContainsKey($group.Name)) { $script:CategoryPage[$group.Name] } else { 'Optimizar' }

    $section = New-Object Windows.Controls.StackPanel
    $section.Margin = [Windows.Thickness]::new(0, 0, 0, 20)

    $title = New-Object Windows.Controls.TextBlock
    $title.Text = $group.Name
    $title.FontSize = 16
    $title.FontWeight = [Windows.FontWeights]::SemiBold
    $title.Foreground = [Windows.Media.Brushes]::White
    $title.Margin = [Windows.Thickness]::new(6, 0, 0, 8)

    $card = New-Object Windows.Controls.Border
    $card.Style = $script:window.FindResource('GlassCard')
    $stack = New-Object Windows.Controls.StackPanel
    $card.Child = $stack

    $items = @($group.Group)
    $rows = New-Object System.Collections.ArrayList
    for ($i = 0; $i -lt $items.Count; $i++) {
        $row = New-TweakRow $items[$i] ($i -lt $items.Count - 1)
        [void]$stack.Children.Add($row)
        [void]$rows.Add(@{
            Element = $row
            Text    = ("$($items[$i].Name) $($items[$i].Description) $($group.Name)").ToLower()
        })
    }

    [void]$section.Children.Add($title)
    [void]$section.Children.Add($card)
    [void]$script:Panels[$pageKey].Children.Add($section)
    [void]$script:Sections.Add(@{ Element = $section; Rows = $rows; Page = $pageKey })
}

# ---------- Eventos ----------
foreach ($k in @($script:Nav.Keys)) {
    $script:Nav[$k].Add_Checked({
        param($sender, $e)
        Show-Page $sender.Name.Substring(3)    # NavOptimizar -> Optimizar
    })
}

$script:SearchBox.Add_TextChanged({
    $q = $script:SearchBox.Text.Trim().ToLower()
    $script:SearchHint.Visibility = if ($q) { 'Collapsed' } else { 'Visible' }
    $hits = @{ Optimizar = 0; Personalizar = 0; Mantenimiento = 0 }
    foreach ($s in $script:Sections) {
        $vis = 0
        foreach ($r in $s.Rows) {
            $match = ($q -eq '') -or $r.Text.Contains($q)
            $r.Element.Visibility = if ($match) { 'Visible' } else { 'Collapsed' }
            if ($match) { $vis++ }
        }
        $s.Element.Visibility = if ($vis -gt 0) { 'Visible' } else { 'Collapsed' }
        $hits[$s.Page] += $vis
    }
    # Si la página actual no tiene resultados, saltar a la primera que sí
    if ($q -and $hits.ContainsKey($script:CurrentPage) -and $hits[$script:CurrentPage] -eq 0) {
        $first = $hits.Keys | Where-Object { $hits[$_] -gt 0 } | Select-Object -First 1
        if ($first) { $script:Nav[$first].IsChecked = $true }
    }
})

$script:window.FindName('TitleBar').Add_MouseLeftButtonDown({ $script:window.DragMove() })
$script:window.FindName('BtnMin').Add_Click({ $script:window.WindowState = 'Minimized' })
$script:window.FindName('BtnClose').Add_Click({ $script:window.Close() })
$script:window.FindName('BtnRestore').Add_Click({
    Write-Log 'Creando punto de restauración (puede tardar unos segundos)...'
    Update-UI
    New-RestorePoint
    $script:RestoreDone = $true
})

# Acrílico: se activa cuando la ventana ya tiene handle
$script:window.Add_SourceInitialized({
    $ok = $false
    if ([Environment]::OSVersion.Version.Build -ge 22621) {
        $hwnd = (New-Object System.Windows.Interop.WindowInteropHelper($script:window)).Handle
        $src = [System.Windows.Interop.HwndSource]::FromHwnd($hwnd)
        $src.CompositionTarget.BackgroundColor = [System.Windows.Media.Colors]::Transparent
        $ok = [NurGlass]::Enable($hwnd)
    }
    if (-not $ok) {
        $script:Tint.Background = $script:window.FindResource('FallbackBg')
        Write-Log 'Acrílico no disponible en esta versión de Windows: usando fondo de respaldo.'
    }
})

# ---------- Asistente de inicio: punto de restauración -> modo rápido / avanzado ----------
foreach ($tw in $script:Tweaks) { $script:TweakById[$tw.Id] = $tw }
$script:BatchOk    = 0
$script:BatchFail  = New-Object System.Collections.ArrayList
$script:ActionDone = @{}
$script:OptChecks  = @()
$script:Dirty      = $false

$script:Wizard      = $script:window.FindName('Wizard')
$script:WzProgBar   = $script:window.FindName('WzProgBar')
$script:WzProgText  = $script:window.FindName('WzProgText')
$script:WzProgCount = $script:window.FindName('WzProgCount')
$script:WzProgTitle = $script:window.FindName('WzProgTitle')
$script:WzOptList   = $script:window.FindName('WzOptList')
$script:WzDoneText  = $script:window.FindName('WzDoneText')
$script:WzPages = @{}
foreach ($n in 'Restore', 'Mode', 'Progress', 'Optional', 'Done') { $script:WzPages[$n] = $script:window.FindName("Wz$n") }

function Show-WizardPage([string]$Name) {
    foreach ($k in $script:WzPages.Keys) {
        $script:WzPages[$k].Visibility = if ($k -eq $Name) { 'Visible' } else { 'Collapsed' }
    }
}

# Después de aplicar cosas en el asistente, deja los interruptores del modo avanzado en su estado real
function Sync-Controls {
    foreach ($id in @($script:Controls.Keys)) {
        $c = $script:Controls[$id]
        $t = $script:TweakById[$id]
        if ($t.Kind -eq 'action') { if ($script:ActionDone.ContainsKey($id)) { $c.Content = 'Hecho' } }
        else { $c.IsChecked = [bool](Test-TweakApplied $t) }
    }
}

function Enter-Advanced {
    if ($script:Dirty) { Sync-Controls; $script:Dirty = $false }
    $script:Wizard.Visibility = 'Collapsed'
    $script:window.FindName('Sidebar').Visibility = 'Visible'
    $script:window.FindName('ContentArea').Visibility = 'Visible'
}

# Aplica una lista de ajustes mostrando la barra de progreso
function Invoke-BatchCore([string[]]$Ids) {
    $total = $Ids.Count
    $i = 0
    foreach ($id in $Ids) {
        $t = $script:TweakById[$id]
        if (-not $t) { continue }
        $script:WzProgBar.Value  = [math]::Round(100 * $i / $total)
        $script:WzProgText.Text  = $t.Name
        $script:WzProgCount.Text = "$($i + 1) de $total"
        Update-UI
        $res = if ($t.Kind -eq 'action') { Invoke-Action -Tweak $t } else { Invoke-Tweak -Tweak $t }
        if ([bool]($res | Select-Object -Last 1)) {
            $script:BatchOk++
            if ($t.Kind -eq 'action') { $script:ActionDone[$id] = $true }
        }
        else { [void]$script:BatchFail.Add($t.Name) }
        $i++
    }
    $script:Dirty = $true
    $script:WzProgBar.Value = 100
    $script:WzProgText.Text = 'Terminando...'
    Update-UI
}

function Start-Batch([string[]]$Ids) {
    $script:DeferExplorer = $true      # varios ajustes reinician el Explorador: se hace una sola vez al final
    try { Invoke-BatchCore $Ids }
    finally {
        $script:DeferExplorer = $false
        if ($script:ExplorerPending) {
            $script:WzProgText.Text = 'Reiniciando el Explorador...'
            Update-UI
            Invoke-ExplorerRestart
        }
    }
}

function Show-Done {
    $txt = "Se aplicaron $($script:BatchOk) ajustes."
    if ($script:BatchFail.Count -gt 0) {
        $txt += "`n`nNo se pudieron aplicar ($($script:BatchFail.Count)): " + ($script:BatchFail -join ', ') + ".`nMirá la pestaña Registro del modo avanzado para ver el motivo."
    }
    $txt += "`n`nAlgunos cambios se ven recién al cerrar sesión o reiniciar la PC."
    $script:WzDoneText.Text = $txt
    Show-WizardPage 'Done'
}

function New-OptionRow($Tweak, [bool]$ShowSeparator) {
    $grid = New-Object Windows.Controls.Grid
    $c1 = New-Object Windows.Controls.ColumnDefinition
    $c1.Width = [Windows.GridLength]::new(1, [Windows.GridUnitType]::Star)
    $c2 = New-Object Windows.Controls.ColumnDefinition
    $c2.Width = [Windows.GridLength]::Auto
    [void]$grid.ColumnDefinitions.Add($c1)
    [void]$grid.ColumnDefinitions.Add($c2)

    $left = New-Object Windows.Controls.StackPanel
    $name = New-Object Windows.Controls.TextBlock
    $name.Text = $Tweak.Name
    $name.FontSize = 14
    $name.FontWeight = [Windows.FontWeights]::SemiBold
    $name.Foreground = [Windows.Media.Brushes]::White
    $desc = New-Object Windows.Controls.TextBlock
    $desc.Text = $Tweak.Description
    $desc.TextWrapping = 'Wrap'
    $desc.FontSize = 12
    $desc.Foreground = Get-Brush '#B3FFFFFF'
    $desc.Margin = [Windows.Thickness]::new(0, 3, 0, 0)
    [void]$left.Children.Add($name)
    [void]$left.Children.Add($desc)

    $sw = New-Object Windows.Controls.Primitives.ToggleButton
    $sw.Style = $script:window.FindResource('Switch')
    $sw.VerticalAlignment = 'Center'
    $sw.Margin = [Windows.Thickness]::new(20, 0, 0, 0)
    $sw.Tag = $Tweak
    $sw.IsChecked = $false

    [Windows.Controls.Grid]::SetColumn($sw, 1)
    [void]$grid.Children.Add($left)
    [void]$grid.Children.Add($sw)

    $row = New-Object Windows.Controls.Border
    $row.Padding = [Windows.Thickness]::new(18, 12, 18, 12)
    if ($ShowSeparator) {
        $row.BorderThickness = [Windows.Thickness]::new(0, 0, 0, 1)
        $row.BorderBrush = Get-Brush '#1AFFFFFF'
    }
    $row.Child = $grid
    $row.Tag = $sw          # para poder leer el interruptor desde la fila
    return $row
}

function Show-OptionalPage {
    $opt = @($script:Tweaks | Where-Object { $_.Optional })
    if ($opt.Count -eq 0) { Show-Done; return }
    $script:WzOptList.Children.Clear()
    $script:OptChecks = @()
    foreach ($g in ($opt | Group-Object OptionalGroup)) {
        $title = New-Object Windows.Controls.TextBlock
        $title.Text = $g.Name
        $title.FontSize = 15
        $title.FontWeight = [Windows.FontWeights]::SemiBold
        $title.Foreground = [Windows.Media.Brushes]::White
        $title.Margin = [Windows.Thickness]::new(4, 8, 0, 6)
        [void]$script:WzOptList.Children.Add($title)

        $card = New-Object Windows.Controls.Border
        $card.Style = $script:window.FindResource('GlassCard')
        $card.Margin = [Windows.Thickness]::new(0, 0, 0, 8)
        $stack = New-Object Windows.Controls.StackPanel
        $card.Child = $stack
        $items = @($g.Group)
        for ($i = 0; $i -lt $items.Count; $i++) {
            $row = New-OptionRow $items[$i] ($i -lt $items.Count - 1)
            [void]$stack.Children.Add($row)
            $script:OptChecks += $row.Tag
        }
        [void]$script:WzOptList.Children.Add($card)
    }
    Show-WizardPage 'Optional'
}

function Start-QuickMode {
    $ids = @($script:Tweaks | Where-Object { $_.Quick } | ForEach-Object { $_.Id })
    $msg = "El modo rápido va a aplicar $($ids.Count) ajustes, entre ellos:`n`n" +
           "  - Quitar OneDrive, apps preinstaladas y características heredadas`n" +
           "  - Quitar IA de Windows, Edge y Office`n" +
           "  - Desanclar todo de la barra de tareas y del menú Inicio`n`n" +
           "Casi todo se puede revertir desde el modo avanzado, pero quitar apps y OneDrive no.`n`n¿Continuar?"
    $ans = [Windows.MessageBox]::Show($msg, 'NurOptimizador', 'YesNo', 'Question')
    if ($ans -ne 'Yes') { return }
    $script:WzProgTitle.Text = 'Optimizando tu PC...'
    Show-WizardPage 'Progress'
    Update-UI
    Start-Batch $ids
    Show-OptionalPage
}

$quickCount = @($script:Tweaks | Where-Object { $_.Quick }).Count
$script:window.FindName('WzQuickDesc').Text = "Aplica $quickCount ajustes recomendados de una vez, con una barra de progreso. Al final te pregunta por algunos opcionales."
$script:window.FindName('WzAdvDesc').Text   = 'Elegí ajuste por ajuste con interruptores, viendo qué hace cada uno. Cada uno se puede revertir.'

$script:window.FindName('WzRestoreYes').Add_Click({
    $script:window.FindName('WzRestoreButtons').Visibility = 'Collapsed'
    $script:window.FindName('WzRestoreBusy').Visibility = 'Visible'
    Write-Log 'Creando punto de restauración (puede tardar unos segundos)...'
    Update-UI
    New-RestorePoint
    $script:RestoreDone = $true
    Show-WizardPage 'Mode'
})
$script:window.FindName('WzRestoreNo').Add_Click({ Show-WizardPage 'Mode' })
$script:window.FindName('WzQuick').Add_Click({ Start-QuickMode })
$script:window.FindName('WzAdvanced').Add_Click({ Enter-Advanced })
$script:window.FindName('WzOptApply').Add_Click({
    $ids = @($script:OptChecks | Where-Object { $_.IsChecked } | ForEach-Object { $_.Tag.Id })
    if ($ids.Count -gt 0) {
        $script:WzProgTitle.Text = 'Aplicando ajustes opcionales...'
        Show-WizardPage 'Progress'
        Update-UI
        Start-Batch $ids
    }
    Show-Done
})
$script:window.FindName('WzOptSkip').Add_Click({ Show-Done })
$script:window.FindName('WzDoneAdvanced').Add_Click({ Enter-Advanced })
$script:window.FindName('WzDoneClose').Add_Click({ $script:window.Close() })

Show-WizardPage 'Restore'

# Versión visible: barra de título, barra lateral, pantalla de inicio y Registro
function Set-AppText([string]$Name, [string]$Text) {
    $el = $script:window.FindName($Name)
    if ($el) { $el.Text = $Text }
}
Set-AppText 'TitleText'  "NurOptimizador  v$($script:AppVersion)"
Set-AppText 'SideVersion' "Versión $($script:AppVersion)"
Set-AppText 'WzVersion'   "Versión $($script:AppVersion)"
Write-Log "NurOptimizador v$($script:AppVersion)"

$script:UiReady = $true
Show-Page 'Optimizar'
Write-Log 'Listo. Cada interruptor aplica o revierte el ajuste al instante.'
[void]$script:window.ShowDialog()
