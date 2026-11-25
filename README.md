# Mi Optimizador (Windows 11)

Estructura inspirada en WinUtil: tweaks definidos como datos (JSON), UI WPF, y un build que genera un único `.ps1`.

## Uso en desarrollo
    .\Build.ps1
    .\dist\optimizer.ps1        # se auto-eleva a administrador

## Uso final (una vez publicado en GitHub)
    irm "https://raw.githubusercontent.com/MatiRivoira/NurOptimizador/main/dist/optimizer.ps1" | iex

## Agregar un tweak
Sumá un objeto a `config/tweaks.json` (registry / service / commands) y corré `Build.ps1`.
El estado original se guarda en `%LOCALAPPDATA%\MiOptimizador\backup.clixml` para poder revertir.

## Créditos / licencias
Revisá las licencias de WinUtil y Winhance antes de copiar código o configs textuales y agregá atribución.
