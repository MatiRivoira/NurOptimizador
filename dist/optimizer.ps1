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
    ],
    "Quick": true
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
    ],
    "Quick": true
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
    ],
    "Quick": true
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
    ],
    "Quick": true
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
    ],
    "Quick": true
  },
  {
    "Id": "DisableTelemetryTasks",
    "Category": "Privacidad",
    "Name": "Desactivar tareas programadas de telemetría",
    "Description": "Apaga las tareas que recolectan y envían datos de diagnóstico: Compatibility Appraiser, programa de experiencia del cliente, informe de errores, diagnóstico de disco y comentarios. Puede demorar que Windows Update te ofrezca actualizaciones de versión.",
    "Risk": "Bajo",
    "task": [
      {
        "Path": "\\Microsoft\\Windows\\Application Experience\\",
        "Name": "Microsoft Compatibility Appraiser"
      },
      {
        "Path": "\\Microsoft\\Windows\\Application Experience\\",
        "Name": "ProgramDataUpdater"
      },
      {
        "Path": "\\Microsoft\\Windows\\Application Experience\\",
        "Name": "MareBackup"
      },
      {
        "Path": "\\Microsoft\\Windows\\Customer Experience Improvement Program\\",
        "Name": "Consolidator"
      },
      {
        "Path": "\\Microsoft\\Windows\\Customer Experience Improvement Program\\",
        "Name": "UsbCeip"
      },
      {
        "Path": "\\Microsoft\\Windows\\Customer Experience Improvement Program\\",
        "Name": "KernelCeipTask"
      },
      {
        "Path": "\\Microsoft\\Windows\\DiskDiagnostic\\",
        "Name": "Microsoft-Windows-DiskDiagnosticDataCollector"
      },
      {
        "Path": "\\Microsoft\\Windows\\Feedback\\Siuf\\",
        "Name": "DmClient"
      },
      {
        "Path": "\\Microsoft\\Windows\\Feedback\\Siuf\\",
        "Name": "DmClientOnScenarioDownload"
      },
      {
        "Path": "\\Microsoft\\Windows\\Windows Error Reporting\\",
        "Name": "QueueReporting"
      },
      {
        "Path": "\\Microsoft\\Windows\\Autochk\\",
        "Name": "Proxy"
      }
    ],
    "Quick": true
  },
  {
    "Id": "DisableTipsAndAds",
    "Category": "Privacidad",
    "Name": "Quitar consejos, sugerencias y publicidad",
    "Description": "Apaga las sugerencias de Configuración, los consejos y trucos de la pantalla de bloqueo, las apps sugeridas que se instalan solas, los avisos de \"terminá de configurar tu dispositivo\" y las promociones de OneDrive en el Explorador.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "SubscribedContent-338387Enabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "SubscribedContent-338388Enabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "SubscribedContent-338389Enabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "SubscribedContent-338393Enabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "SubscribedContent-353694Enabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "SubscribedContent-353696Enabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "SubscribedContent-353698Enabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "SubscribedContent-310093Enabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "SystemPaneSuggestionsEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "SoftLandingEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "RotatingLockScreenOverlayEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "ContentDeliveryAllowed",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "FeatureManagementEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "OemPreInstalledAppsEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "PreInstalledAppsEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "PreInstalledAppsEverEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
        "Name": "SilentInstalledAppsEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\UserProfileEngagement",
        "Name": "ScoobeSystemSettingEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
        "Name": "ShowSyncProviderNotifications",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\CloudContent",
        "Name": "DisableSoftLanding",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "Quick": true
  },
  {
    "Id": "DisableDeliveryOptimization",
    "Category": "Privacidad",
    "Name": "Desactivar Delivery Optimization",
    "Description": "Windows deja de compartir las actualizaciones descargadas con otras PCs (en tu red o en Internet). Descarga solo desde Microsoft y ahorra ancho de banda de subida.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\DeliveryOptimization",
        "Name": "DODownloadMode",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "Quick": true
  },
  {
    "Id": "DisableStoreSearch",
    "Category": "Privacidad",
    "Name": "Quitar sugerencias de la Store en la búsqueda",
    "Description": "Saca las apps sugeridas de la Microsoft Store de los resultados de búsqueda de Windows. Es la opción nativa de Configuración, que ya viene en 24H2, 25H2 y 26H2 si estás al día.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\SearchSettings",
        "Name": "IsStoreSuggestionsEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      }
    ],
    "Quick": true
  },
  {
    "Id": "DisableEdgeAI",
    "Category": "IA",
    "Name": "Desactivar IA en Microsoft Edge",
    "Description": "Por política: oculta el Copilot lateral y el ícono de Copilot, bloquea Copilot en la página de nueva pestaña y el acceso al contenido de la página, la escritura asistida (Rewrite), los temas generados con IA y la descarga del modelo de IA local.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "HubsSidebarEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "CopilotPageContext",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "CopilotNewTabPageEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "Microsoft365CopilotChatIconEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "ComposeInlineEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "AIGenThemesEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "GenAILocalFoundationalModelSettings",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "NewTabPageBingChatEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "Quick": true
  },
  {
    "Id": "DisableOfficeAI",
    "Category": "IA",
    "Name": "Desactivar IA en Microsoft Office",
    "Description": "Desactiva las \"experiencias conectadas que analizan tu contenido\" de Office, que es lo que habilita Copilot en Word, Excel, PowerPoint y OneNote. Ojo: también apaga otras funciones en la nube que leen tu documento, como Diseñador o sugerencias de Editor.",
    "Risk": "Medio",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Policies\\Microsoft\\office\\16.0\\common\\privacy",
        "Name": "usercontentdisabled",
        "Type": "DWord",
        "Value": "2",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "Quick": true
  },
  {
    "Id": "RemoveWindowsAI",
    "Kind": "action",
    "Category": "IA",
    "Name": "Quitar IA de Windows (apps, servicio y Recall)",
    "Description": "Desinstala las apps de Copilot, apaga el servicio WSAIFabricSvc (AI Fabric), quita la característica Recall (solo existe en PCs Copilot+) y desactiva las tareas programadas de IA. Puede requerir reiniciar.",
    "Risk": "Medio",
    "Confirm": "Se van a desinstalar las apps de Copilot, apagar el servicio de IA de Windows y quitar Recall.\n\nLas apps se pueden reinstalar desde la Microsoft Store, pero este botón no las restaura.\n\n¿Continuar?",
    "appx": [
      "Microsoft.Copilot",
      "MicrosoftWindows.Client.CoPilot",
      "Microsoft.Windows.Ai.Copilot.Provider"
    ],
    "commands": {
      "apply": "Set-Service -Name WSAIFabricSvc -StartupType Disabled -ErrorAction SilentlyContinue; Stop-Service -Name WSAIFabricSvc -Force -ErrorAction SilentlyContinue; Disable-WindowsOptionalFeature -FeatureName Recall -Online -NoRestart -ErrorAction SilentlyContinue | Out-Null; Get-ScheduledTask -TaskPath '\\Microsoft\\Windows\\WindowsAI\\*' -ErrorAction SilentlyContinue | Disable-ScheduledTask -ErrorAction SilentlyContinue | Out-Null"
    },
    "Quick": true
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
    ],
    "Quick": true
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
    ],
    "Quick": true
  },
  {
    "Id": "EdgeDebloat",
    "Category": "Debloat",
    "Name": "Debloat de Microsoft Edge",
    "Description": "Por política: sin pantalla de bienvenida, sin arranque anticipado ni ejecución en segundo plano, sin asistente de compras, sin widget web, sin recomendaciones, sin promos del canal Insider, sin acceso directo nuevo en el escritorio en cada actualización y sin envío de comentarios ni datos de personalización.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "HideFirstRunExperience",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "StartupBoostEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "BackgroundModeEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "EdgeShoppingAssistantEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "WebWidgetAllowed",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "ShowRecommendationsEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "SpotlightExperiencesAndRecommendationsEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "MicrosoftEdgeInsiderPromotionEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "DefaultBrowserSettingsCampaignEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "UserFeedbackAllowed",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "PersonalizationReportingEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Edge",
        "Name": "InAppSupportEnabled",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\EdgeUpdate",
        "Name": "CreateDesktopShortcutDefault",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "Quick": true
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
    ],
    "Quick": true
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
    },
    "Quick": true
  },
  {
    "Id": "VisualEffectsPerformance",
    "Category": "Rendimiento",
    "Name": "Efectos visuales: solo lo esencial",
    "Description": "Deja la ventana de Opciones de rendimiento exactamente así: solo activados \"Mostrar el contenido de la ventana mientras se arrastra\", \"Mostrar el rectángulo de selección translúcido\", \"Mostrar vistas en miniatura en lugar de iconos\" y \"Suavizar bordes para las fuentes de pantalla\". Todo lo demás (animaciones, sombras, Peek, vistas previas de la barra) queda apagado y las transparencias también. Se aplica al instante y reinicia el Explorador (la barra parpadea).",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\VisualEffects",
        "Name": "VisualFXSetting",
        "Type": "DWord",
        "Value": "3",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Control Panel\\Desktop",
        "Name": "UserPreferencesMask",
        "Type": "Binary",
        "Value": "90,12,03,80,10,00,00,00",
        "OriginalValue": "9e,3e,07,80,12,00,00,00"
      },
      {
        "Path": "HKCU:\\Control Panel\\Desktop",
        "Name": "DragFullWindows",
        "Type": "String",
        "Value": "1",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
        "Name": "ListviewAlphaSelect",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
        "Name": "IconsOnly",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "0"
      },
      {
        "Path": "HKCU:\\Control Panel\\Desktop",
        "Name": "FontSmoothing",
        "Type": "String",
        "Value": "2",
        "OriginalValue": "2"
      },
      {
        "Path": "HKCU:\\Control Panel\\Desktop\\WindowMetrics",
        "Name": "MinAnimate",
        "Type": "String",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
        "Name": "TaskbarAnimations",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
        "Name": "ListviewShadow",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\DWM",
        "Name": "EnableAeroPeek",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\DWM",
        "Name": "AlwaysHibernateThumbnails",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
        "Name": "EnableTransparency",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      }
    ],
    "commands": {
      "apply": "Update-VisualEffectsLive",
      "undo": "Update-VisualEffectsLive",
      "test": "Test-VisualEffects"
    },
    "Quick": true
  },
  {
    "Id": "EnableHAGS",
    "Category": "Rendimiento",
    "Name": "Programación de GPU acelerada por hardware (HAGS)",
    "Description": "Deja que la placa de video administre su propia memoria y cola de trabajo. Puede mejorar la fluidez en placas modernas y empeorarla en viejas. Requiere driver compatible y reiniciar.",
    "Risk": "Medio",
    "registry": [
      {
        "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\GraphicsDrivers",
        "Name": "HwSchMode",
        "Type": "DWord",
        "Value": "2",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "Quick": true
  },
  {
    "Id": "EnableLongPaths",
    "Category": "Rendimiento",
    "Name": "Habilitar rutas largas",
    "Description": "Permite rutas de más de 260 caracteres. Evita errores en herramientas de desarrollo, node_modules y copias de carpetas muy anidadas.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKLM:\\SYSTEM\\CurrentControlSet\\Control\\FileSystem",
        "Name": "LongPathsEnabled",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "0"
      }
    ]
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
    ],
    "Quick": true
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
    ],
    "Optional": true,
    "OptionalGroup": "Servicios"
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
    ],
    "Optional": true,
    "OptionalGroup": "Servicios"
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
    ],
    "Optional": true,
    "OptionalGroup": "Servicios"
  },
  {
    "Id": "ClassicContextMenu",
    "Category": "Interfaz",
    "Name": "Menú contextual clásico",
    "Description": "Vuelve el clic derecho completo de Windows 10, sin tener que tocar \"Mostrar más opciones\". Reinicia el Explorador (la barra parpadea un instante).",
    "Risk": "Bajo",
    "commands": {
      "apply": "New-Item -Path 'HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\InprocServer32' -Value '' -Force | Out-Null; Restart-Explorer",
      "undo": "Remove-Item -Path 'HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}' -Recurse -Force -ErrorAction SilentlyContinue; Restart-Explorer",
      "test": "Test-Path 'HKCU:\\Software\\Classes\\CLSID\\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\\InprocServer32'"
    },
    "Optional": true,
    "OptionalGroup": "Personalización"
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
    ],
    "Quick": true
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
    ],
    "Quick": true
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
    ],
    "Quick": true
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
    ],
    "Quick": true
  },
  {
    "Id": "HideGallery",
    "Category": "Interfaz",
    "Name": "Quitar Galería del Explorador",
    "Description": "Oculta Galería del panel de navegación del Explorador de archivos. No toca Inicio. Reinicia el Explorador (parpadea un instante).",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Classes\\CLSID\\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}",
        "Name": "System.IsPinnedToNameSpaceTree",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "commands": {
      "apply": "Restart-Explorer",
      "undo": "Restart-Explorer"
    },
    "Quick": true
  },
  {
    "Id": "DisableStickyKeys",
    "Category": "Interfaz",
    "Name": "Desactivar atajos de Sticky Keys y Filter Keys",
    "Description": "Se terminan los popups al apretar Shift 5 veces (Sticky Keys), mantener Shift 8 segundos (Filter Keys) o Num Lock 5 segundos (Toggle Keys). Muy útil si jugás.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Control Panel\\Accessibility\\StickyKeys",
        "Name": "Flags",
        "Type": "String",
        "Value": "506",
        "OriginalValue": "510"
      },
      {
        "Path": "HKCU:\\Control Panel\\Accessibility\\Keyboard Response",
        "Name": "Flags",
        "Type": "String",
        "Value": "122",
        "OriginalValue": "126"
      },
      {
        "Path": "HKCU:\\Control Panel\\Accessibility\\ToggleKeys",
        "Name": "Flags",
        "Type": "String",
        "Value": "58",
        "OriginalValue": "62"
      }
    ],
    "Quick": true
  },
  {
    "Id": "HideShortcutArrow",
    "Category": "Interfaz",
    "Name": "Quitar flecha de los accesos directos",
    "Description": "Saca la flechita que aparece sobre los íconos de accesos directos, usando un ícono transparente propio. Limpia la caché de íconos y reinicia el Explorador (parpadea la barra). Se aplica a todos los usuarios de la PC.",
    "Risk": "Bajo",
    "commands": {
      "apply": "Hide-ShortcutArrow",
      "undo": "Show-ShortcutArrow",
      "test": "Test-ShortcutArrowHidden"
    },
    "Optional": true,
    "OptionalGroup": "Personalización"
  },
  {
    "Id": "CleanTaskbar",
    "Category": "Barra de tareas",
    "Name": "Barra de tareas limpia",
    "Description": "Oculta la búsqueda, la vista de tareas y los widgets. Deja la barra solo con tus apps. Reinicia el Explorador (la barra parpadea un instante).",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Search",
        "Name": "SearchboxTaskbarMode",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "3"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
        "Name": "ShowTaskViewButton",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKCU:\\Software\\Policies\\Microsoft\\Dsh",
        "Name": "AllowNewsAndInterests",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "commands": {
      "apply": "Restart-Explorer",
      "undo": "Restart-Explorer"
    },
    "Quick": true
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
      "apply": "Remove-Item -Path 'HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Taskband' -Recurse -Force -ErrorAction SilentlyContinue; Remove-Item -Path (Join-Path $env:APPDATA 'Microsoft\\Internet Explorer\\Quick Launch\\User Pinned\\TaskBar\\*') -Force -ErrorAction SilentlyContinue; Restart-Explorer"
    },
    "Quick": true
  },
  {
    "Id": "CleanStartMenu",
    "Category": "Menú Inicio",
    "Name": "Menú Inicio limpio",
    "Description": "Quita todo lo anclado de tu menú Inicio y aplica una lista de anclados vacía para usuarios nuevos. Guarda una copia de tus anclados para poder revertir. En Windows Home la política puede ser ignorada.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer",
        "Name": "ConfigureStartPins",
        "Type": "String",
        "Value": "{\"pinnedList\":[]}",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "commands": {
      "apply": "Clear-StartMenuPins",
      "undo": "Restore-StartMenuPins"
    },
    "Quick": true
  },
  {
    "Id": "HideStartRecommendations",
    "Category": "Menú Inicio",
    "Name": "Ocultar recomendaciones del menú Inicio",
    "Description": "Esconde la sección Recomendados y las sugerencias de apps y sitios. En Windows Home la sección queda visible pero vacía. 26H2 también deja ocultar secciones desde Configuración.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Policies\\Microsoft\\Windows\\Explorer",
        "Name": "HideRecommendedSection",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
        "Name": "Start_IrisRecommendations",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      }
    ],
    "Quick": true
  },
  {
    "Id": "SoundTweaks",
    "Category": "Sonido",
    "Name": "Sonido: sin ducking en llamadas y sin sonido de inicio",
    "Description": "Windows deja de bajar el volumen de lo que escuchás cuando detecta una llamada (Discord, Teams, etc.) y se silencia el sonido de arranque.",
    "Risk": "Bajo",
    "registry": [
      {
        "Path": "HKCU:\\Software\\Microsoft\\Multimedia\\Audio",
        "Name": "UserDuckingPreference",
        "Type": "DWord",
        "Value": "3",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Authentication\\LogonUI\\BootAnimation",
        "Name": "DisableStartupSound",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System",
        "Name": "DisableStartupSound",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "Quick": true
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
    ],
    "Quick": true
  },
  {
    "Id": "RemoveOneDrive",
    "Kind": "action",
    "Category": "Limpieza",
    "Name": "Quitar Microsoft OneDrive",
    "Description": "Cierra y desinstala OneDrive. Revisá antes que no tengas archivos sin sincronizar. Se puede volver a instalar desde la web de Microsoft o con winget.",
    "Risk": "Medio",
    "Confirm": "Se va a desinstalar OneDrive.\n\nSi tenés archivos sin terminar de sincronizar, revisalos antes. Los archivos ya descargados en tu PC no se borran.\n\n¿Continuar?",
    "commands": {
      "apply": "Remove-OneDrive"
    },
    "Quick": true
  },
  {
    "Id": "RemoveLegacyFeatures",
    "Kind": "action",
    "Category": "Limpieza",
    "Name": "Quitar características heredadas (lista segura)",
    "Description": "Quita componentes viejos que casi nadie usa: Grabador de pasos, Panel de entrada matemática, Fax y Escáner, Windows Media Player clásico, PowerShell 2.0, SMB1, Work Folders y XPS Services. Solo toca lo que esté instalado. Puede tardar un par de minutos.",
    "Risk": "Medio",
    "Confirm": "Se van a quitar componentes heredados de Windows (Grabador de pasos, Fax y Escáner, Media Player clásico, PowerShell 2.0, SMB1, Work Folders, XPS Services).\n\nPuede tardar un par de minutos y no se revierte con este botón.\n\n¿Continuar?",
    "commands": {
      "apply": "Remove-LegacyFeatures"
    },
    "Quick": true
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

    <!-- Barra de progreso de vidrio -->
    <Style x:Key="GlassProgress" TargetType="ProgressBar">
      <Setter Property="Height" Value="14"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ProgressBar">
            <Grid>
              <Border x:Name="PART_Track" CornerRadius="7" Background="#26FFFFFF" BorderBrush="#66FFFFFF" BorderThickness="1"/>
              <Border x:Name="PART_Indicator" CornerRadius="7" HorizontalAlignment="Left">
                <Border.Background>
                  <LinearGradientBrush StartPoint="0,0" EndPoint="1,0">
                    <GradientStop Color="#FF8B7CFF" Offset="0"/>
                    <GradientStop Color="#FF38BDF8" Offset="1"/>
                  </LinearGradientBrush>
                </Border.Background>
              </Border>
            </Grid>
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
          <TextBlock x:Name="TitleText" Text="NurOptimizador" Foreground="#B3FFFFFF" FontSize="12" VerticalAlignment="Center" Margin="20,0,0,0"/>
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" Margin="0,6,10,0" VerticalAlignment="Top">
            <Button x:Name="BtnMin" Style="{StaticResource TitleBtn}" Content="&#xE921;"/>
            <Button x:Name="BtnClose" Style="{StaticResource TitleBtn}" Content="&#xE8BB;"/>
          </StackPanel>
        </Grid>

        <!-- Barra lateral -->
        <Border x:Name="Sidebar" Visibility="Collapsed" Grid.Row="1" Grid.Column="0" Style="{StaticResource GlassCard}" Margin="16,0,12,16" Padding="14">
          <DockPanel>
            <StackPanel DockPanel.Dock="Bottom">
              <Button x:Name="BtnRestore" Style="{StaticResource GlassButton}" Content="Crear punto ahora"/>
            </StackPanel>
            <StackPanel DockPanel.Dock="Top" Margin="6,6,0,22">
              <TextBlock FontSize="22"><Run FontWeight="Bold" Text="Nur"/><Run FontWeight="Light" Text="Optimizador"/></TextBlock>
              <TextBlock x:Name="SideVersion" Foreground="#99FFFFFF" FontSize="12" Margin="1,2,0,0"/>
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
        <Grid x:Name="ContentArea" Visibility="Collapsed" Grid.Row="1" Grid.Column="1" Margin="0,0,16,16">
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

        <!-- Asistente de inicio -->
        <Grid x:Name="Wizard" Grid.Row="1" Grid.ColumnSpan="2" Margin="16,0,16,16">
          <Border Style="{StaticResource GlassCard}" Width="660" MaxHeight="610" HorizontalAlignment="Center" VerticalAlignment="Center" Padding="34">
            <Grid>

              <StackPanel x:Name="WzRestore">
                <TextBlock Text="Antes de comenzar" FontSize="28" FontWeight="SemiBold"/>
                <TextBlock Text="¿Querés hacer un punto de restauración? Si algo no te gusta, podés volver a cómo estaba tu PC."
                           TextWrapping="Wrap" Foreground="#CCFFFFFF" FontSize="14" Margin="0,10,0,26"/>
                <StackPanel x:Name="WzRestoreButtons" Orientation="Horizontal">
                  <Button x:Name="WzRestoreYes" Style="{StaticResource GlassButton}" Content="Sí, crear punto" MinWidth="170" Margin="0,0,12,0"/>
                  <Button x:Name="WzRestoreNo" Style="{StaticResource GlassButton}" Content="No, continuar" MinWidth="170"/>
                </StackPanel>
                <TextBlock x:Name="WzRestoreBusy" Visibility="Collapsed" Foreground="#A6E3A1" FontSize="14" TextWrapping="Wrap"
                           Text="Creando el punto de restauración... puede tardar unos segundos."/>
              </StackPanel>

              <StackPanel x:Name="WzMode" Visibility="Collapsed">
                <TextBlock Text="Elegí cómo querés optimizar" FontSize="28" FontWeight="SemiBold"/>
                <TextBlock Text="Podés dejar que la app aplique todo lo recomendado, o elegir ajuste por ajuste."
                           TextWrapping="Wrap" Foreground="#CCFFFFFF" FontSize="14" Margin="0,10,0,24"/>
                <Grid>
                  <Grid.ColumnDefinitions>
                    <ColumnDefinition Width="*"/>
                    <ColumnDefinition Width="14"/>
                    <ColumnDefinition Width="*"/>
                  </Grid.ColumnDefinitions>
                  <Button x:Name="WzQuick" Grid.Column="0" Style="{StaticResource GlassButton}" Height="180">
                    <StackPanel>
                      <TextBlock Text="Modo rápido" FontSize="21" FontWeight="SemiBold" HorizontalAlignment="Center"/>
                      <TextBlock x:Name="WzQuickDesc" TextWrapping="Wrap" TextAlignment="Center" Foreground="#CCFFFFFF" FontSize="12.5" Margin="0,12,0,0"/>
                    </StackPanel>
                  </Button>
                  <Button x:Name="WzAdvanced" Grid.Column="2" Style="{StaticResource GlassButton}" Height="180">
                    <StackPanel>
                      <TextBlock Text="Modo avanzado" FontSize="21" FontWeight="SemiBold" HorizontalAlignment="Center"/>
                      <TextBlock x:Name="WzAdvDesc" TextWrapping="Wrap" TextAlignment="Center" Foreground="#CCFFFFFF" FontSize="12.5" Margin="0,12,0,0"/>
                    </StackPanel>
                  </Button>
                </Grid>
              </StackPanel>

              <StackPanel x:Name="WzProgress" Visibility="Collapsed">
                <TextBlock x:Name="WzProgTitle" Text="Optimizando tu PC..." FontSize="28" FontWeight="SemiBold"/>
                <TextBlock Text="No cierres la ventana. Algunos pasos tardan un rato y la ventana puede quedar quieta unos segundos."
                           TextWrapping="Wrap" Foreground="#CCFFFFFF" FontSize="13" Margin="0,8,0,26"/>
                <ProgressBar x:Name="WzProgBar" Style="{StaticResource GlassProgress}" Minimum="0" Maximum="100" Value="0"/>
                <Grid Margin="0,12,0,0">
                  <TextBlock x:Name="WzProgText" Foreground="White" FontSize="14" TextTrimming="CharacterEllipsis" Margin="0,0,90,0"/>
                  <TextBlock x:Name="WzProgCount" Foreground="#B3FFFFFF" FontSize="13" HorizontalAlignment="Right"/>
                </Grid>
              </StackPanel>

              <StackPanel x:Name="WzOptional" Visibility="Collapsed">
                <TextBlock Text="Ajustes opcionales" FontSize="28" FontWeight="SemiBold"/>
                <TextBlock Text="Estos no se aplican solos porque dependen de cómo uses tu PC. Marcá los que quieras."
                           TextWrapping="Wrap" Foreground="#CCFFFFFF" FontSize="14" Margin="0,10,0,16"/>
                <ScrollViewer MaxHeight="330" VerticalScrollBarVisibility="Auto">
                  <StackPanel x:Name="WzOptList" Margin="0,0,10,0"/>
                </ScrollViewer>
                <StackPanel Orientation="Horizontal" Margin="0,22,0,0">
                  <Button x:Name="WzOptApply" Style="{StaticResource GlassButton}" Content="Aplicar los marcados" MinWidth="190" Margin="0,0,12,0"/>
                  <Button x:Name="WzOptSkip" Style="{StaticResource GlassButton}" Content="Omitir" MinWidth="120"/>
                </StackPanel>
              </StackPanel>

              <StackPanel x:Name="WzDone" Visibility="Collapsed">
                <TextBlock Text="Listo" FontSize="28" FontWeight="SemiBold"/>
                <TextBlock x:Name="WzDoneText" TextWrapping="Wrap" Foreground="#CCFFFFFF" FontSize="14" Margin="0,10,0,26"/>
                <StackPanel Orientation="Horizontal">
                  <Button x:Name="WzDoneAdvanced" Style="{StaticResource GlassButton}" Content="Abrir modo avanzado" MinWidth="190" Margin="0,0,12,0"/>
                  <Button x:Name="WzDoneClose" Style="{StaticResource GlassButton}" Content="Cerrar" MinWidth="120"/>
                </StackPanel>
              </StackPanel>

            </Grid>
          </Border>
          <StackPanel HorizontalAlignment="Left" VerticalAlignment="Top" Margin="6,0,0,0">
            <TextBlock FontSize="22"><Run FontWeight="Bold" Text="Nur"/><Run FontWeight="Light" Text="Optimizador"/></TextBlock>
            <TextBlock x:Name="WzVersion" Foreground="#99FFFFFF" FontSize="12" Margin="1,2,0,0"/>
          </StackPanel>
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
$script:AppVersion = '1.0.2'   # se sube con cada cambio, así se ve si la app se actualizó
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

# Flecha de accesos directos: se reemplaza por un ícono 100% transparente propio.
# Mismo enfoque que usa Winhance: un .ico multitamaño con imágenes PNG transparentes, guardado en C:\Windows\blank.ico.
# (Un ícono de un solo tamaño, no transparente o sacado de shell32.dll deja un cuadrado negro sobre los accesos directos.)
function New-BlankIcon([string]$Path) {
    Add-Type -AssemblyName System.Drawing
    $sizes = 16, 24, 32, 48, 64, 128, 256
    $pngs  = @()
    foreach ($sz in $sizes) {
        $bmp = New-Object System.Drawing.Bitmap($sz, $sz, [System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.Clear([System.Drawing.Color]::Transparent)
        $g.Dispose()
        $ms = New-Object System.IO.MemoryStream
        $bmp.Save($ms, [System.Drawing.Imaging.ImageFormat]::Png)
        $pngs += ,($ms.ToArray())
        $ms.Dispose(); $bmp.Dispose()
    }
    $out = New-Object System.IO.MemoryStream
    $bw  = New-Object System.IO.BinaryWriter($out)
    $bw.Write([uint16]0); $bw.Write([uint16]1); $bw.Write([uint16]$sizes.Count)           # cabecera ICO
    $offset = 6 + 16 * $sizes.Count
    for ($i = 0; $i -lt $sizes.Count; $i++) {
        $dim = if ($sizes[$i] -ge 256) { 0 } else { $sizes[$i] }                           # 0 significa 256
        $bw.Write([byte]$dim); $bw.Write([byte]$dim); $bw.Write([byte]0); $bw.Write([byte]0)
        $bw.Write([uint16]1); $bw.Write([uint16]32)
        $bw.Write([uint32]$pngs[$i].Length); $bw.Write([uint32]$offset)
        $offset += $pngs[$i].Length
    }
    foreach ($png in $pngs) { $bw.Write([byte[]]$png) }
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
        if ($b[$off] -ne 0x89 -or $b[$off + 1] -ne 0x50 -or $b[$off + 2] -ne 0x4E -or $b[$off + 3] -ne 0x47) { return $false }  # firma PNG
        $ms  = [System.IO.MemoryStream]::new($b, $off, $len)
        $img = [System.Drawing.Image]::FromStream($ms)
        $bmp = New-Object System.Drawing.Bitmap($img)
        $a   = $bmp.GetPixel([int]($bmp.Width / 2), [int]($bmp.Height / 2)).A
        $bmp.Dispose(); $img.Dispose(); $ms.Dispose()
        if ($a -ne 0) { return $false }                                                                       # tiene que ser transparente
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
}

function Restart-Explorer {
    param([switch]$ClearIconCache)
    if ($ClearIconCache) { $script:IconCachePending = $true }
    if ($script:DeferExplorer) { $script:ExplorerPending = $true; return }
    Invoke-ExplorerRestart
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

# Versión visible: debajo del nombre (barra lateral y pantalla de inicio) y en el Registro
function Set-AppText([string]$Name, [string]$Text) {
    $el = $script:window.FindName($Name)
    if ($el) { $el.Text = $Text }
}
Set-AppText 'SideVersion' "v$($script:AppVersion)"
Set-AppText 'WzVersion'   "v$($script:AppVersion)"
Write-Log "NurOptimizador v$($script:AppVersion)"

$script:UiReady = $true
Show-Page 'Optimizar'
Write-Log 'Listo. Cada interruptor aplica o revierte el ajuste al instante.'
[void]$script:window.ShowDialog()
