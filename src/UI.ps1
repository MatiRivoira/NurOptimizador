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
