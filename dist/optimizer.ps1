# Mi Optimizador - generado por Build.ps1, no editar a mano
$ScriptUrl = 'https://raw.githubusercontent.com/MatiRivoira/NurOptimizador/main/dist/optimizer.ps1'

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
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
        "Name": "AllowTelemetry",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "service": [
      {
        "Name": "DiagTrack",
        "StartupType": "Disabled",
        "OriginalType": "Automatic"
      }
    ]
  },
  {
    "Id": "DisableActivityHistory",
    "Category": "Privacidad",
    "Name": "Desactivar historial de actividad",
    "Description": "Evita que Windows registre y suba tu historial de actividad (Timeline).",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System",
        "Name": "EnableActivityFeed",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System",
        "Name": "PublishUserActivities",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\System",
        "Name": "UploadUserActivities",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      }
    ]
  },
  {
    "Id": "DisableAdvertisingId",
    "Category": "Privacidad",
    "Name": "Desactivar ID de publicidad",
    "Description": "Impide que las apps usen tu ID de publicidad para anuncios personalizados.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\AdvertisingInfo",
        "Name": "Enabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      }
    ]
  },
  {
    "Id": "DisableLocation",
    "Category": "Privacidad",
    "Name": "Desactivar rastreo de ubicación",
    "Description": "Bloquea el acceso de Windows y las apps a tu ubicación. Apps como Mapas o Clima dejan de ubicarte solas.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\CapabilityAccessManager\\ConsentStore\\location",
        "Name": "Value",
        "Type": "String",
        "Value": "Deny",
        "OriginalValue": "Allow"
      }
    ]
  },
  {
    "Id": "DisableCopilotRecall",
    "Category": "Privacidad",
    "Name": "Desactivar Copilot y Recall",
    "Description": "Aplica las políticas de Windows que apagan Copilot y el análisis de datos con IA (Recall), y oculta el botón de la barra. Según la compilación, Copilot como app aparte puede seguir instalado.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Policies\\Microsoft\\Windows\\WindowsCopilot",
        "Name": "TurnOffWindowsCopilotFeature",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsCopilot",
        "Name": "TurnOffWindowsCopilotFeature",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsAI",
        "Name": "DisableAIDataAnalysis",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
        "Name": "ShowCopilotButton",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      }
    ]
  },
  {
    "Id": "DisableConsumerFeatures",
    "Category": "Debloat",
    "Name": "Desactivar apps sugeridas / consumer features",
    "Description": "Evita que Windows instale automáticamente apps promocionales (Candy Crush, etc.).",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\CloudContent",
        "Name": "DisableWindowsConsumerFeatures",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      }
    ]
  },
  {
    "Id": "DisableBingSearch",
    "Category": "Debloat",
    "Name": "Desactivar Bing en el menú Inicio",
    "Description": "La búsqueda del menú Inicio deja de mandar consultas a Bing y mostrar sugerencias web.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Policies\\Microsoft\\Windows\\Explorer",
        "Name": "DisableSearchBoxSuggestions",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      }
    ]
  },
  {
    "Id": "DisableGameDVR",
    "Category": "Rendimiento",
    "Name": "Desactivar Game DVR / Game Bar capture",
    "Description": "Apaga la grabación en segundo plano de Xbox Game Bar. Menos overhead en juegos.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\System\\GameConfigStore",
        "Name": "GameDVR_Enabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\GameDVR",
        "Name": "AllowGameDVR",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      }
    ]
  },
  {
    "Id": "UltimatePerformance",
    "Category": "Rendimiento",
    "Name": "Plan de energía: Ultimate Performance",
    "Description": "Activa el plan de máximo rendimiento de Windows (menos latencia). En notebooks consume más batería. Al apagarlo vuelve a Equilibrado.",
    "Risk": "Bajo",
    "commands": {
      "apply": "powercfg /duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 99999999-9999-9999-9999-999999999999 | Out-Null; powercfg /setactive 99999999-9999-9999-9999-999999999999; if ($LASTEXITCODE -ne 0) { throw 'No se pudo activar Ultimate Performance en este equipo.' }",
      "undo": "powercfg /setactive SCHEME_BALANCED",
      "test": "[bool]((powercfg /getactivescheme) -match '99999999-9999-9999-9999-999999999999')"
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
    "Id": "ClassicContextMenu",
    "Category": "Interfaz",
    "Name": "Menú contextual clásico",
    "Description": "Vuelve el clic derecho completo de Windows 10, sin tener que tocar \"Mostrar más opciones\". Reinicia el Explorador (la barra parpadea un instante).",
    "Risk": "Bajo",
    "commands": {
      "apply": "New-Item -Path 'HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\InprocServer32' -Value '' -Force | Out-Null; Stop-Process -Name explorer -Force",
      "undo": "Remove-Item -Path 'HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}' -Recurse -Force -ErrorAction SilentlyContinue; Stop-Process -Name explorer -Force",
      "test": "Test-Path 'HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\InprocServer32'"
    }
  },
  {
    "Id": "EndTaskRightClick",
    "Category": "Interfaz",
    "Name": "Finalizar tarea con clic derecho",
    "Description": "Agrega \"Finalizar tarea\" al clic derecho de los íconos de la barra de tareas. Sirve para cerrar apps trabadas sin abrir el Administrador de tareas.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\\TaskbarDeveloperSettings",
        "Name": "TaskbarEndTask",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      }
    ]
  },
  {
    "Id": "DisableMouseAcceleration",
    "Category": "Interfaz",
    "Name": "Desactivar aceleración del mouse",
    "Description": "El puntero responde siempre igual a tu movimiento (ideal para juegos y diseño). Se aplica al volver a iniciar sesión.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Control Panel\\Mouse",
        "Name": "MouseSpeed",
        "Type": "String",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Control Panel\\Mouse",
        "Name": "MouseThreshold1",
        "Type": "String",
        "Value": "0",
        "OriginalValue": "6"
      },
      {
        "Path": "HKCU:\\Control Panel\\Mouse",
        "Name": "MouseThreshold2",
        "Type": "String",
        "Value": "0",
        "OriginalValue": "10"
      }
    ]
  },
  {
    "Id": "ShowFileExtensions",
    "Category": "Interfaz",
    "Name": "Mostrar extensiones de archivo",
    "Description": "Muestra .exe, .pdf, etc. en el Explorador. Mejora la seguridad.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
        "Name": "HideFileExt",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      }
    ]
  },
  {
    "Id": "ShowHiddenFiles",
    "Category": "Interfaz",
    "Name": "Mostrar archivos ocultos",
    "Description": "Muestra archivos y carpetas ocultos en el Explorador.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
        "Name": "Hidden",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "2"
      }
    ]
  },
  {
    "Id": "CleanTempFiles",
    "Kind": "action",
    "Category": "Limpieza",
    "Name": "Limpiar archivos temporales",
    "Description": "Borra los temporales del usuario y de Windows y te dice cuánto espacio liberó. Los archivos en uso se saltean.",
    "Risk": "Bajo",
    "commands": {
      "apply": "Clear-TempFiles"
    }
  },
  {
    "Id": "RemoveBloatApps",
    "Kind": "action",
    "Category": "Limpieza",
    "Name": "Quitar apps preinstaladas innecesarias",
    "Description": "Desinstala Noticias, Clima, Obtener ayuda, Consejos, Solitario, Feedback Hub, Clipchamp, Office Hub, Contactos, Power Automate, To Do y Cortana. No toca la Store, Xbox, Fotos ni la Calculadora.",
    "Risk": "Medio",
    "Confirm": "Se van a desinstalar las apps preinstaladas de la lista para todos los usuarios.\n\nSe pueden volver a instalar desde la Microsoft Store, pero este botón no las restaura.\n\n¿Continuar?",
    "appx": [
      "Microsoft.BingNews",
      "Microsoft.BingWeather",
      "Microsoft.GetHelp",
      "Microsoft.Getstarted",
      "Microsoft.MicrosoftSolitaireCollection",
      "Microsoft.WindowsFeedbackHub",
      "Clipchamp.Clipchamp",
      "Microsoft.MicrosoftOfficeHub",
      "Microsoft.People",
      "Microsoft.PowerAutomateDesktop",
      "Microsoft.Todos",
      "Microsoft.549981C3F5F10"
    ]
  },
  {
    "Id": "RepairSystem",
    "Kind": "action",
    "Category": "Reparación",
    "Name": "Reparar archivos del sistema (DISM + SFC)",
    "Description": "Repara la imagen de Windows y verifica los archivos del sistema. Abre una ventana aparte y puede tardar 10 a 20 minutos.",
    "Risk": "Bajo",
    "commands": {
      "apply": "Start-Process powershell -ArgumentList '-NoExit','-Command','DISM /Online /Cleanup-Image /RestoreHealth; sfc /scannow'"
    }
  },
  {
    "Id": "ResetNetwork",
    "Kind": "action",
    "Category": "Reparación",
    "Name": "Reiniciar la red",
    "Description": "Limpia la caché DNS y restablece Winsock y la pila TCP/IP. Soluciona problemas de conexión. Requiere reiniciar la PC y puede borrar una IP fija configurada.",
    "Risk": "Medio",
    "Confirm": "Se va a restablecer la pila de red (DNS, Winsock y TCP/IP).\n\nSi usás IP fija, tendrás que configurarla de nuevo. Después hay que reiniciar la PC.\n\n¿Continuar?",
    "commands": {
      "apply": "ipconfig /flushdns | Out-Null; netsh winsock reset | Out-Null; netsh int ip reset | Out-Null; Write-Log '  Reiniciá la PC para completar el reseteo de red.'"
    }
  },
  {
    "Id": "CleanTaskbar",
    "Category": "Barra de tareas",
    "Name": "Barra de tareas limpia",
    "Description": "Oculta la búsqueda, la vista de tareas, los widgets y el chat. Deja la barra solo con tus apps. Reinicia el Explorador (la barra parpadea un instante).",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search",
        "Name": "SearchboxTaskbarMode",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
        "Name": "ShowTaskViewButton",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Dsh",
        "Name": "AllowNewsAndInterests",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Chat",
        "Name": "ChatIcon",
        "Type": "DWord",
        "Value": "3",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "commands": {
      "apply": "Stop-Process -Name explorer -Force",
      "undo": "Stop-Process -Name explorer -Force"
    }
  },
  {
    "Id": "UnpinTaskbarApps",
    "Kind": "action",
    "Category": "Barra de tareas",
    "Name": "Desanclar todas las apps de la barra",
    "Description": "Saca de la barra de tareas todo lo que viene anclado (Edge, Store, Correo, etc.) para que la armes a tu gusto. Después podés volver a anclar lo que quieras.",
    "Risk": "Bajo",
    "Confirm": "Se van a desanclar TODAS las apps de la barra de tareas de este usuario.\n\nEl Explorador se reinicia y la barra parpadea un instante. Podés volver a anclar apps cuando quieras.\n\n¿Continuar?",
    "commands": {
      "apply": "Remove-Item -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Taskband' -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path (Join-Path $env:APPDATA 'Microsoft\\Internet Explorer\\Quick Launch\\User Pinned\\TaskBar\\*') -Force -ErrorAction SilentlyContinue; Stop-Process -Name explorer -Force"
    }
  },
  {
    "Id": "DisableUselessServices",
    "Category": "Servicios",
    "Name": "Desactivar servicios innecesarios",
    "Description": "Desactiva servicios que casi nadie usa: archivos sin conexión (CscService), mapas descargados (MapsBroker), modo demo de tienda (RetailDemo), informe de errores (WerSvc), WAP Push (dmwappushservice), modo quiosco (AssignedAccessManagerSvc), bloqueo de diálogos (DialogBlockingService), control parental (WpcMonSvc), Insider (wisvc) y uso compartido de Media Player (WMPNetworkSvc). Pone el servicio de almacenamiento (StorSvc) en Manual. No lo uses en PCs de empresa ni si estás en el programa Insider.",
    "Risk": "Bajo",
    "service": [
      {
        "Name": "CscService",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "MapsBroker",
        "StartupType": "Disabled",
        "OriginalType": "Automatic"
      },
      {
        "Name": "RetailDemo",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "WerSvc",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "dmwappushservice",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "AssignedAccessManagerSvc",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "DialogBlockingService",
        "StartupType": "Disabled",
        "OriginalType": "Disabled"
      },
      {
        "Name": "WpcMonSvc",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "wisvc",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "WMPNetworkSvc",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "StorSvc",
        "StartupType": "Manual",
        "OriginalType": "Automatic"
      }
    ]
  },
  {
    "Id": "DisableXboxServices",
    "Category": "Servicios",
    "Name": "Desactivar servicios de Xbox",
    "Description": "Apaga los servicios de Xbox Live (XblAuthManager, XblGameSave, XboxNetApiSvc, XboxGipSvc). No lo actives si usás Game Pass, la app de Xbox o juegos que piden iniciar sesión con Xbox.",
    "Risk": "Medio",
    "service": [
      {
        "Name": "XblAuthManager",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "XblGameSave",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "XboxNetApiSvc",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "XboxGipSvc",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      }
    ]
  },
  {
    "Id": "DisableSysMain",
    "Category": "Servicios",
    "Name": "Desactivar SysMain (Superfetch)",
    "Description": "Deja de precargar apps en memoria. Tiene sentido si tu Windows está en un SSD. En un disco mecánico (HDD) puede empeorar la velocidad, así que no lo actives.",
    "Risk": "Medio",
    "service": [
      {
        "Name": "SysMain",
        "StartupType": "Disabled",
        "OriginalType": "Automatic"
      }
    ]
  },
  {
    "Id": "DisablePrintSpooler",
    "Category": "Servicios",
    "Name": "Desactivar servicio de impresión",
    "Description": "Apaga la cola de impresión. Solo si no imprimís nunca: sin este servicio tampoco funciona \"Microsoft Print to PDF\".",
    "Risk": "Medio",
    "service": [
      {
        "Name": "Spooler",
        "StartupType": "Disabled",
        "OriginalType": "Automatic"
      }
    ]
  }
]
'@ | ConvertFrom-Json

$script:Xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="NurOptimizador" Width="1060" Height="700"
        WindowStartupLocation="CenterScreen" WindowStyle="None" ResizeMode="CanMinimize"
        Background="Transparent" Foreground="White"
        FontFamily="Segoe UI Variable Text, Segoe UI" FontSize="13">
  <Window.Resources>

    <!-- Fondo con tinte translúcido (sobre acrílico) y versión opaca de respaldo -->
    <LinearGradientBrush x:Key="GlassTint" StartPoint="0,0" EndPoint="1,1">
      <GradientStop Color="#D01E1458" Offset="0"/>
      <GradientStop Color="#D00C2457" Offset="0.55"/>
      <GradientStop Color="#D0081426" Offset="1"/>
    </LinearGradientBrush>
    <LinearGradientBrush x:Key="FallbackBg" StartPoint="0,0" EndPoint="1,1">
      <GradientStop Color="#FF1E1458" Offset="0"/>
      <GradientStop Color="#FF0C2457" Offset="0.55"/>
      <GradientStop Color="#FF081426" Offset="1"/>
    </LinearGradientBrush>

    <!-- Tarjeta de vidrio -->
    <Style x:Key="GlassCard" TargetType="Border">
      <Setter Property="CornerRadius" Value="16"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="Background">
        <Setter.Value>
          <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#2EFFFFFF" Offset="0"/>
            <GradientStop Color="#0DFFFFFF" Offset="1"/>
          </LinearGradientBrush>
        </Setter.Value>
      </Setter>
      <Setter Property="BorderBrush">
        <Setter.Value>
          <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
            <GradientStop Color="#70FFFFFF" Offset="0"/>
            <GradientStop Color="#14FFFFFF" Offset="1"/>
          </LinearGradientBrush>
        </Setter.Value>
      </Setter>
      <Setter Property="Effect">
        <Setter.Value>
          <DropShadowEffect BlurRadius="28" ShadowDepth="8" Direction="270" Opacity="0.3" Color="Black"/>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Interruptor estilo Winhance -->
    <Style x:Key="Switch" TargetType="ToggleButton">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ToggleButton">
            <Grid Width="48" Height="26" Background="Transparent">
              <Border x:Name="Track" CornerRadius="13" Background="#33FFFFFF" BorderBrush="#66FFFFFF" BorderThickness="1"/>
              <Ellipse x:Name="Knob" Width="18" Height="18" Fill="White" HorizontalAlignment="Left" Margin="4,0,0,0"/>
            </Grid>
            <ControlTemplate.Triggers>
              <Trigger Property="IsChecked" Value="True">
                <Setter TargetName="Track" Property="Background">
                  <Setter.Value>
                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                      <GradientStop Color="#FF8B7CFF" Offset="0"/>
                      <GradientStop Color="#FF38BDF8" Offset="1"/>
                    </LinearGradientBrush>
                  </Setter.Value>
                </Setter>
                <Setter TargetName="Track" Property="BorderBrush" Value="#88FFFFFF"/>
                <Setter TargetName="Knob" Property="HorizontalAlignment" Value="Right"/>
                <Setter TargetName="Knob" Property="Margin" Value="0,0,4,0"/>
              </Trigger>
              <Trigger Property="IsEnabled" Value="False">
                <Setter Property="Opacity" Value="0.5"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Item de navegación lateral -->
    <Style x:Key="NavItem" TargetType="RadioButton">
      <Setter Property="Foreground" Value="#CCFFFFFF"/>
      <Setter Property="Margin" Value="0,3"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="RadioButton">
            <Border x:Name="Bd" CornerRadius="10" Padding="12,10" Background="Transparent"
                    BorderThickness="1" BorderBrush="Transparent">
              <StackPanel Orientation="Horizontal">
                <TextBlock Text="{Binding Tag, RelativeSource={RelativeSource TemplatedParent}}"
                           FontFamily="Segoe Fluent Icons, Segoe MDL2 Assets" FontSize="16"
                           Width="28" VerticalAlignment="Center"/>
                <ContentPresenter VerticalAlignment="Center"/>
              </StackPanel>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#1FFFFFFF"/>
              </Trigger>
              <Trigger Property="IsChecked" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#38FFFFFF"/>
                <Setter TargetName="Bd" Property="BorderBrush" Value="#66FFFFFF"/>
                <Setter Property="Foreground" Value="White"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Botones de la barra de título -->
    <Style x:Key="TitleBtn" TargetType="Button">
      <Setter Property="Width" Value="42"/>
      <Setter Property="Height" Value="30"/>
      <Setter Property="Foreground" Value="White"/>
      <Setter Property="FontFamily" Value="Segoe Fluent Icons, Segoe MDL2 Assets"/>
      <Setter Property="FontSize" Value="11"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="Transparent" CornerRadius="8">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#33FFFFFF"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Botón de vidrio -->
    <Style x:Key="GlassButton" TargetType="Button">
      <Setter Property="Foreground" Value="White"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" CornerRadius="10" Padding="14,9" Background="#26FFFFFF"
                    BorderBrush="#55FFFFFF" BorderThickness="1">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#40FFFFFF"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Barra de scroll fina -->
    <Style TargetType="ScrollBar">
      <Setter Property="Width" Value="8"/>
      <Setter Property="Background" Value="Transparent"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ScrollBar">
            <Track x:Name="PART_Track" IsDirectionReversed="True">
              <Track.Thumb>
                <Thumb>
                  <Thumb.Template>
                    <ControlTemplate TargetType="Thumb">
                      <Border CornerRadius="4" Background="#55FFFFFF" Margin="1"/>
                    </ControlTemplate>
                  </Thumb.Template>
                </Thumb>
              </Track.Thumb>
            </Track>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>

  <Border x:Name="Tint" Background="{StaticResource GlassTint}" ClipToBounds="True">
    <Grid>
      <!-- Manchas de color: le dan al vidrio algo que "refractar" -->
      <Ellipse Width="460" Height="460" Fill="#997C5CFF" HorizontalAlignment="Left" VerticalAlignment="Top" Margin="-120,-140,0,0" IsHitTestVisible="False">
        <Ellipse.Effect><BlurEffect Radius="110"/></Ellipse.Effect>
      </Ellipse>
      <Ellipse Width="420" Height="420" Fill="#7700C2FF" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="0,0,-110,-140" IsHitTestVisible="False">
        <Ellipse.Effect><BlurEffect Radius="110"/></Ellipse.Effect>
      </Ellipse>
      <Ellipse Width="300" Height="300" Fill="#55FF4DA6" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,-60,140,0" IsHitTestVisible="False">
        <Ellipse.Effect><BlurEffect Radius="100"/></Ellipse.Effect>
      </Ellipse>

      <Grid>
        <Grid.RowDefinitions>
          <RowDefinition Height="42"/>
          <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="250"/>
          <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <!-- Barra de título -->
        <Grid x:Name="TitleBar" Grid.Row="0" Grid.ColumnSpan="2" Background="Transparent">
          <TextBlock Text="NurOptimizador" Foreground="#B3FFFFFF" FontSize="12" VerticalAlignment="Center" Margin="20,0,0,0"/>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,6,10,0" VerticalAlignment="Top">
            <Button x:Name="BtnMin" Style="{StaticResource TitleBtn}" Content="&#xE921;"/>
            <Button x:Name="BtnClose" Style="{StaticResource TitleBtn}" Content="&#xE8BB;"/>
          </StackPanel>
        </Grid>

        <!-- Barra lateral -->
        <Border Grid.Row="1" Grid.Column="0" Style="{StaticResource GlassCard}" Margin="16,0,12,16" Padding="14">
          <DockPanel>
            <StackPanel DockPanel.Dock="Bottom">
              <Grid Margin="4,0,0,12">
                <Grid.ColumnDefinitions>
                  <ColumnDefinition Width="*"/>
                  <ColumnDefinition Width="Auto"/>
                </Grid.ColumnDefinitions>
                <TextBlock Text="Crear punto de restauración antes de cambiar" TextWrapping="Wrap"
                           Foreground="#CCFFFFFF" FontSize="12" VerticalAlignment="Center"/>
                <ToggleButton x:Name="RestoreSwitch" Grid.Column="1" Style="{StaticResource Switch}"
                              IsChecked="True" Margin="10,0,0,0" VerticalAlignment="Center"/>
              </Grid>
              <Button x:Name="BtnRestore" Style="{StaticResource GlassButton}" Content="Crear punto ahora"/>
            </StackPanel>
            <StackPanel DockPanel.Dock="Top" Margin="6,6,0,22">
              <TextBlock FontSize="22"><Run FontWeight="Bold" Text="Nur"/><Run FontWeight="Light" Text="Optimizador"/></TextBlock>
              <TextBlock Text="Windows 11" Foreground="#99FFFFFF" FontSize="12" Margin="1,2,0,0"/>
            </StackPanel>
            <StackPanel>
              <RadioButton x:Name="NavOptimizar" Style="{StaticResource NavItem}" Tag="&#xE945;" Content="Optimizar" IsChecked="True" GroupName="nav"/>
              <RadioButton x:Name="NavPersonalizar" Style="{StaticResource NavItem}" Tag="&#xE771;" Content="Personalizar" GroupName="nav"/>
              <RadioButton x:Name="NavMantenimiento" Style="{StaticResource NavItem}" Tag="&#xE713;" Content="Mantenimiento" GroupName="nav"/>
              <RadioButton x:Name="NavRegistro" Style="{StaticResource NavItem}" Tag="&#xE8A5;" Content="Registro" GroupName="nav"/>
            </StackPanel>
          </DockPanel>
        </Border>

        <!-- Contenido -->
        <Grid Grid.Row="1" Grid.Column="1" Margin="0,0,16,16">
          <Grid.RowDefinitions>
            <RowDefinition Height="Auto"/>
            <RowDefinition Height="*"/>
          </Grid.RowDefinitions>

          <Grid Grid.Row="0" Margin="6,0,0,14">
            <StackPanel VerticalAlignment="Center">
              <TextBlock x:Name="PageTitle" FontSize="26" FontWeight="SemiBold" Text="Optimizar"/>
              <TextBlock x:Name="PageSub" Foreground="#B3FFFFFF" FontSize="12.5" Margin="1,2,0,0"/>
            </StackPanel>
            <Border x:Name="SearchBorder" Style="{StaticResource GlassCard}" CornerRadius="12"
                    Width="270" Height="38" HorizontalAlignment="Right" VerticalAlignment="Center">
              <Grid>
                <TextBlock x:Name="SearchHint" Text="Buscar ajustes" Foreground="#99FFFFFF"
                           Margin="14,0,0,0" VerticalAlignment="Center" IsHitTestVisible="False"/>
                <TextBox x:Name="SearchBox" Background="Transparent" BorderThickness="0" Foreground="White"
                         CaretBrush="White" VerticalContentAlignment="Center" Padding="10,0"/>
              </Grid>
            </Border>
          </Grid>

          <Grid Grid.Row="1">
            <ScrollViewer x:Name="PageOptimizar" VerticalScrollBarVisibility="Auto">
              <StackPanel x:Name="PanelOptimizar" Margin="0,0,10,0"/>
            </ScrollViewer>
            <ScrollViewer x:Name="PagePersonalizar" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
              <StackPanel x:Name="PanelPersonalizar" Margin="0,0,10,0"/>
            </ScrollViewer>
            <ScrollViewer x:Name="PageMantenimiento" VerticalScrollBarVisibility="Auto" Visibility="Collapsed">
              <StackPanel x:Name="PanelMantenimiento" Margin="0,0,10,0"/>
            </ScrollViewer>
            <Border x:Name="PageRegistro" Style="{StaticResource GlassCard}" Visibility="Collapsed" Padding="14">
              <TextBox x:Name="LogBox" IsReadOnly="True" Background="Transparent" BorderThickness="0"
                       Foreground="#A6E3A1" FontFamily="Consolas" FontSize="12.5"
                       VerticalScrollBarVisibility="Auto" TextWrapping="Wrap"/>
            </Border>
          </Grid>
        </Grid>
      </Grid>
    </Grid>
  </Border>
</Window>

'@

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
            if ("$($p.($r.Name))" -ne "$($r.Value)") { return $false }
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
$script:RestoreSwitch = $script:window.FindName('RestoreSwitch')

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
    'Interfaz'   = 'Personalizar'; 'Barra de tareas' = 'Personalizar'
    'Limpieza'   = 'Mantenimiento'; 'Reparación' = 'Mantenimiento'
}
$script:CurrentPage  = 'Optimizar'
$script:RestoreDone  = $false
$script:Sections     = New-Object System.Collections.ArrayList

# ---------- Helpers ----------
function Get-Brush([string]$Hex) {
    (New-Object System.Windows.Media.BrushConverter).ConvertFromString($Hex)
}

function Update-UI {
    $script:window.Dispatcher.Invoke([Action]{}, [Windows.Threading.DispatcherPriority]::Render)
}

function Initialize-RestorePoint {
    if ($script:RestoreDone) { return }
    Write-Log 'Creando punto de restauración (puede tardar unos segundos)...'
    Update-UI
    New-RestorePoint
    $script:RestoreDone = $true
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
            if ($want -and $script:RestoreSwitch.IsChecked) { Initialize-RestorePoint }
            $res = if ($want) { Invoke-Tweak -Tweak $t } else { Invoke-Tweak -Tweak $t -Undo }
            $ok = [bool]($res | Select-Object -Last 1)
            if (-not $ok) { $sender.IsChecked = -not $want }   # volver atrás si falló
        })
    }

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

$script:UiReady = $true
Show-Page 'Optimizar'
Write-Log 'Listo. Cada interruptor aplica o revierte el ajuste al instante.'
[void]$script:window.ShowDialog()
