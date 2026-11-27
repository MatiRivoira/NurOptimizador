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
    "Id": "DisableSecurityHealthTray",
    "Category": "Rendimiento",
    "Quick": true,
    "Risk": "Bajo",
    "Name": "Quitar SecurityHealthSystray.exe del arranque",
    "Description": "Evita que el ícono de Seguridad de Windows (SecurityHealthSystray.exe) se cargue al iniciar sesión. Un proceso menos al arrancar. La protección de Windows sigue activa; lo que perdés es el ícono de la bandeja y sus avisos.",
    "registry": [
      {
        "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\StartupApproved\\Run",
        "Name": "SecurityHealth",
        "Type": "Binary",
        "Value": "03,00,00,00,00,00,00,00,00,00,00,00",
        "OriginalValue": "02,00,00,00,00,00,00,00,00,00,00,00"
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
    "OptionalGroup": "Servicios",
    "OptionalPage": "Optimizar"
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
    "OptionalGroup": "Servicios",
    "OptionalPage": "Optimizar"
  },
  {
    "Id": "DisablePrintSpooler",
    "Category": "Servicios",
    "Name": "Desactivar servicios de impresión",
    "Description": "Apaga la cola de impresión, las extensiones y notificaciones de impresora, la configuración de dispositivos de impresión y el intermediario de impresión y escaneo. Solo si no imprimís nunca: sin esto tampoco funciona \"Microsoft Print to PDF\".",
    "Risk": "Medio",
    "service": [
      {
        "Name": "Spooler",
        "StartupType": "Disabled",
        "OriginalType": "Automatic"
      },
      {
        "Name": "PrintNotify",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "PrintDeviceConfigurationService",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "PrintScanBrokerService",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      }
    ],
    "Optional": true,
    "OptionalGroup": "Servicios",
    "OptionalPage": "Optimizar"
  },
  {
    "Id": "DisableExtraServices",
    "Category": "Servicios",
    "Quick": true,
    "Risk": "Medio",
    "Name": "Desactivar servicios extra (ubicación, tarjeta inteligente y Hyper-V de invitado)",
    "Description": "Desactiva Geolocalización, Tarjeta inteligente y su directiva de extracción, y los servicios de integración de Hyper-V para máquinas virtuales invitadas (instantáneas de volumen, PowerShell Direct, virtualización de escritorio remoto, sincronización de hora, latido, intercambio de datos, cierre de invitado) más el servicio Host HV. No lo uses si corrés Windows dentro de una máquina virtual de Hyper-V ni si usás tarjetas inteligentes (token USB, DNI electrónico).",
    "service": [
      {
        "Name": "lfsvc",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "SCardSvr",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "SCPolicySvc",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "vmicvss",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "vmicvmsession",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "vmicrdv",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "vmictimesync",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "vmicheartbeat",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "vmickvpexchange",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "vmicshutdown",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "HvHost",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      }
    ]
  },
  {
    "Id": "DisableConnectivityServices",
    "Category": "Servicios",
    "Quick": true,
    "Risk": "Medio",
    "Name": "Desactivar Escritorio remoto, zona móvil y administración de radio",
    "Description": "Desactiva los servicios de Escritorio remoto (Servicios y Configuración), la zona con cobertura inalámbrica móvil y la administración de radio. Ojo: sin la administración de radio se pierde el modo avión y el interruptor de Bluetooth; sin la zona móvil no podés compartir tu conexión. No lo uses si te conectás a esta PC por Escritorio remoto.",
    "service": [
      {
        "Name": "TermService",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "SessionEnv",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "icssvc",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "RmSvc",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      }
    ]
  },
  {
    "Id": "DisableEdgeUpdate",
    "Category": "Servicios",
    "Risk": "Medio",
    "Name": "Desactivar las actualizaciones de Microsoft Edge",
    "Description": "Apaga los servicios y las tareas programadas de actualización de Edge (edgeupdate, edgeupdatem y el servicio de elevación). Edge dejará de actualizarse solo y puede quedar con fallas de seguridad sin corregir: solo conviene si no lo usás.",
    "service": [
      {
        "Name": "edgeupdate",
        "StartupType": "Disabled",
        "OriginalType": "Automatic"
      },
      {
        "Name": "edgeupdatem",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      },
      {
        "Name": "MicrosoftEdgeElevationService",
        "StartupType": "Disabled",
        "OriginalType": "Manual"
      }
    ],
    "registry": [
      {
        "Path": "HKLM:\\SOFTWARE\\Policies\\Microsoft\\EdgeUpdate",
        "Name": "Update{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "<RemoveEntry>"
      }
    ],
    "commands": {
      "apply": "Disable-EdgeUpdateTasks",
      "undo": "Enable-EdgeUpdateTasks"
    }
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
    "OptionalGroup": "Personalización",
    "OptionalPage": "Personalizar"
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
    "Description": "Saca la flechita que aparece sobre los íconos de accesos directos, con un ícono transparente propio guardado en C:\\Windows\\blank.ico. Limpia la caché de íconos y reinicia el Explorador. A veces hace falta cerrar sesión para que se vea bien.",
    "Risk": "Bajo",
    "commands": {
      "apply": "Hide-ShortcutArrow",
      "undo": "Show-ShortcutArrow",
      "test": "Test-ShortcutArrowHidden"
    },
    "Optional": true,
    "OptionalGroup": "Personalización",
    "SignOutHint": true,
    "OptionalPage": "Personalizar"
  },
  {
    "Id": "HideSleepOption",
    "Category": "Interfaz",
    "Name": "Quitar \"Suspender\" del menú de apagado",
    "Description": "Saca la opción Suspender del menú de energía del Inicio, de Win+X, de Alt+F4 y de Ctrl+Alt+Supr. No desactiva la suspensión de la PC: solo la oculta de esos menús. Si no se ve el cambio enseguida, cerrá sesión.",
    "Risk": "Bajo",
    "Optional": true,
    "OptionalGroup": "Personalización",
    "registry": [
      {
        "Path": "HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\FlyoutMenuSettings",
        "Name": "ShowSleepOption",
        "Type": "DWord",
        "Value": "0",
        "OriginalValue": "1"
      },
      {
        "Path": "HKLM:\\SOFTWARE\\Microsoft\\PolicyManager\\default\\Start\\HideSleep",
        "Name": "value",
        "Type": "DWord",
        "Value": "1",
        "OriginalValue": "0"
      }
    ],
    "commands": {
      "apply": "Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue",
      "undo": "Stop-Process -Name StartMenuExperienceHost -Force -ErrorAction SilentlyContinue"
    },
    "OptionalPage": "Personalizar"
  },
  {
    "Id": "CleanTaskbar",
    "Category": "Barra de tareas",
    "Name": "Barra de tareas limpia",
    "Description": "Oculta la búsqueda y la vista de tareas, y quita Widgets (desinstala su paquete). Deja la barra solo con tus apps. Reinicia el Explorador (la barra parpadea un instante).",
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
      "apply": "Remove-Widgets; Restart-Explorer",
      "undo": "Restore-Widgets; Restart-Explorer"
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
    "Description": "Desinstala Noticias, Clima, Obtener ayuda, Consejos, Solitario, Feedback Hub, Clipchamp, Office Hub, Contactos, Power Automate, To Do, Cortana, Cámara, Reloj, Family Safety, Teams, Outlook nuevo, Phone Link, Quick Assist, Grabadora de sonido y Notas rápidas. No toca la Store, Xbox, Fotos ni la Calculadora.",
    "Risk": "Medio",
    "Confirm": "Se van a desinstalar las apps preinstaladas de la lista (incluidas Cámara, Reloj, Teams, Outlook nuevo, Phone Link, Quick Assist, Grabadora y Notas rápidas) para todos los usuarios.\n\nSe pueden volver a instalar desde la Microsoft Store, pero este botón no las restaura.\n\n¿Continuar?",
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
      "Microsoft.549981C3F5F10",
      "Microsoft.WindowsCamera",
      "Microsoft.WindowsAlarms",
      "MicrosoftCorporationII.MicrosoftFamily",
      "MSTeams",
      "MicrosoftTeams",
      "Microsoft.OutlookForWindows",
      "Microsoft.YourPhone",
      "MicrosoftCorporationII.QuickAssist",
      "Microsoft.WindowsSoundRecorder",
      "Microsoft.MicrosoftStickyNotes"
    ],
    "Quick": true,
    "capabilities": [
      "App.Support.QuickAssist"
    ]
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
    "Id": "RemoveGameBar",
    "Kind": "action",
    "Category": "Limpieza",
    "Risk": "Medio",
    "Optional": true,
    "OptionalPage": "Optimizar",
    "OptionalGroup": "Aplicaciones",
    "Name": "Desinstalar Xbox Game Bar",
    "Description": "Desinstala Game Bar (Win+G) y desactiva su integración con juegos y mandos, para que Windows no muestre los avisos de \"ms-gamebar\" y \"ms-gamingoverlay\". Ojo: con procesadores AMD Ryzen X3D, Windows usa Game Bar para decidir qué núcleos usar en juegos, y el atajo Win+Alt+B (HDR) también depende de él.",
    "Confirm": "Se va a desinstalar Xbox Game Bar y desactivar su integración.\n\nSi tenés un procesador AMD Ryzen X3D o usás Win+Alt+B para el HDR, conviene dejarlo.\n\n¿Continuar?",
    "appx": [
      "Microsoft.XboxGamingOverlay",
      "Microsoft.XboxGameOverlay"
    ],
    "commands": {
      "apply": "Disable-GameBarIntegration"
    }
  },
  {
    "Id": "RemoveEdge",
    "Kind": "action",
    "Category": "Limpieza",
    "Risk": "Alto",
    "Name": "Quitar Microsoft Edge",
    "Description": "Intenta desinstalar Edge con 4 métodos, del más suave al más fuerte: el desinstalador propio, el truco del Edge heredado, la política de Edge Update y la política regional de Windows (la que habilita la desinstalación en la Unión Europea; toca temporalmente un archivo protegido del sistema, con copia de seguridad, y lo restaura). Si ninguno funciona, no cambia nada.",
    "Confirm": "Se va a intentar desinstalar Microsoft Edge con varios métodos.\n\nEl último modifica temporalmente un archivo protegido de Windows (con copia de seguridad) y lo restaura al terminar. Algunas funciones de Windows (enlaces de ayuda, resultados web) abren Edge, así que asegurate de tener otro navegador.\n\n¿Continuar?",
    "commands": {
      "apply": "Remove-Edge"
    }
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
      <GradientStop Color="#CC2B2B2B" Offset="0"/>
      <GradientStop Color="#CC232323" Offset="0.5"/>
      <GradientStop Color="#CC171717" Offset="1"/>
    </LinearGradientBrush>
    <LinearGradientBrush x:Key="FallbackBg" StartPoint="0,0" EndPoint="1,1">
      <GradientStop Color="#FF2B2B2B" Offset="0"/>
      <GradientStop Color="#FF232323" Offset="0.5"/>
      <GradientStop Color="#FF151515" Offset="1"/>
    </LinearGradientBrush>
    <!-- Borde finísimo de la ventana: más claro arriba, casi invisible abajo -->
    <LinearGradientBrush x:Key="EdgeBrush" StartPoint="0,0" EndPoint="0,1">
      <GradientStop Color="#55FFFFFF" Offset="0"/>
      <GradientStop Color="#18FFFFFF" Offset="0.4"/>
      <GradientStop Color="#0DFFFFFF" Offset="1"/>
    </LinearGradientBrush>
    <!-- Tarjeta de vidrio esmerilado oscuro -->
    <Style x:Key="GlassCard" TargetType="Border">
      <Setter Property="CornerRadius" Value="20"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="Background">
        <Setter.Value>
          <LinearGradientBrush StartPoint="0,0" EndPoint="0.8,1">
            <GradientStop Color="#26FFFFFF" Offset="0"/>
            <GradientStop Color="#0EFFFFFF" Offset="1"/>
          </LinearGradientBrush>
        </Setter.Value>
      </Setter>
      <Setter Property="BorderBrush">
        <Setter.Value>
          <LinearGradientBrush StartPoint="0,0" EndPoint="0,1">
            <GradientStop Color="#48FFFFFF" Offset="0"/>
            <GradientStop Color="#14FFFFFF" Offset="0.5"/>
            <GradientStop Color="#0AFFFFFF" Offset="1"/>
          </LinearGradientBrush>
        </Setter.Value>
      </Setter>
      <Setter Property="Effect">
        <Setter.Value>
          <DropShadowEffect BlurRadius="34" ShadowDepth="10" Direction="270" Opacity="0.45" Color="Black"/>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Interruptor: perla cuando está encendido -->
    <Style x:Key="Switch" TargetType="ToggleButton">
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ToggleButton">
            <Grid Width="48" Height="26" Background="Transparent">
              <Border x:Name="Track" CornerRadius="13" Background="#1FFFFFFF" BorderBrush="#55FFFFFF" BorderThickness="1"/>
              <Ellipse x:Name="Knob" Width="18" Height="18" Fill="#FFD2D2D2" HorizontalAlignment="Left" Margin="4,0,0,0"/>
            </Grid>
            <ControlTemplate.Triggers>
              <Trigger Property="IsChecked" Value="True">
                <Setter TargetName="Track" Property="Background">
                  <Setter.Value>
                    <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                      <GradientStop Color="#FFF7F7F7" Offset="0"/>
                      <GradientStop Color="#FFBFC4CC" Offset="1"/>
                    </LinearGradientBrush>
                  </Setter.Value>
                </Setter>
                <Setter TargetName="Track" Property="BorderBrush" Value="#99FFFFFF"/>
                <Setter TargetName="Knob" Property="Fill" Value="#FF202020"/>
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
      <Setter Property="Foreground" Value="#B3FFFFFF"/>
      <Setter Property="Margin" Value="0,3"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="RadioButton">
            <Border x:Name="Bd" CornerRadius="12" Padding="12,10" Background="Transparent"
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
                <Setter TargetName="Bd" Property="Background" Value="#14FFFFFF"/>
              </Trigger>
              <Trigger Property="IsChecked" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#26FFFFFF"/>
                <Setter TargetName="Bd" Property="BorderBrush" Value="#40FFFFFF"/>
                <Setter Property="Foreground" Value="White"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Botones de ventana estilo Windows: minimizar y cerrar -->
    <Style x:Key="CaptionBtn" TargetType="Button">
      <Setter Property="Width" Value="46"/>
      <Setter Property="Height" Value="36"/>
      <Setter Property="Foreground" Value="White"/>
      <Setter Property="FontFamily" Value="Segoe Fluent Icons, Segoe MDL2 Assets"/>
      <Setter Property="FontSize" Value="10"/>
      <Setter Property="Cursor" Value="Arrow"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="Transparent">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#26FFFFFF"/>
              </Trigger>
              <Trigger Property="IsPressed" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#14FFFFFF"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="CloseBtn" TargetType="Button" BasedOn="{StaticResource CaptionBtn}">
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" Background="Transparent">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#FFC42B1C"/>
              </Trigger>
              <Trigger Property="IsPressed" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#FF9E1F14"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>

    <!-- Botón de vidrio (borde fino, como las etiquetas 4K / PSD de la referencia) -->
    <Style x:Key="GlassButton" TargetType="Button">
      <Setter Property="Foreground" Value="White"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border x:Name="Bd" CornerRadius="12" Padding="14,9" Background="#1AFFFFFF"
                    BorderBrush="#4DFFFFFF" BorderThickness="1">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Bd" Property="Background" Value="#33FFFFFF"/>
                <Setter TargetName="Bd" Property="BorderBrush" Value="#80FFFFFF"/>
              </Trigger>
              <Trigger Property="IsEnabled" Value="False">
                <Setter Property="Opacity" Value="0.5"/>
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
                    <GradientStop Color="#FFF4F4F4" Offset="0"/>
                    <GradientStop Color="#FFB7BDC8" Offset="1"/>
                  </LinearGradientBrush>
                </Border.Background>
              </Border>
            </Grid>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
  </Window.Resources>

  <Border x:Name="Tint" Background="{StaticResource GlassTint}" BorderBrush="{StaticResource EdgeBrush}" BorderThickness="1" ClipToBounds="True">
    <Grid>
      <!-- Reflejos difusos (como los objetos cromados detrás del vidrio): perla, gris azulado y un toque dorado -->
      <Ellipse Width="400" Height="400" Fill="#66E4EAF6" HorizontalAlignment="Right" VerticalAlignment="Top" Margin="0,-170,-110,0" IsHitTestVisible="False">
        <Ellipse.Effect><BlurEffect Radius="110"/></Ellipse.Effect>
      </Ellipse>
      <Ellipse Width="320" Height="320" Fill="#55B9C4DA" HorizontalAlignment="Left" VerticalAlignment="Center" Margin="-170,160,0,0" IsHitTestVisible="False">
        <Ellipse.Effect><BlurEffect Radius="100"/></Ellipse.Effect>
      </Ellipse>
      <Ellipse Width="560" Height="300" Fill="#55E2E8F2" HorizontalAlignment="Right" VerticalAlignment="Bottom" Margin="0,0,120,-170" IsHitTestVisible="False">
        <Ellipse.Effect><BlurEffect Radius="120"/></Ellipse.Effect>
      </Ellipse>
      <Ellipse Width="240" Height="240" Fill="#44D8C98F" HorizontalAlignment="Left" VerticalAlignment="Bottom" Margin="40,0,0,-130" IsHitTestVisible="False">
        <Ellipse.Effect><BlurEffect Radius="90"/></Ellipse.Effect>
      </Ellipse>

      <Grid>
        <Grid.RowDefinitions>
          <RowDefinition Height="36"/>
          <RowDefinition Height="*"/>
        </Grid.RowDefinitions>
        <Grid.ColumnDefinitions>
          <ColumnDefinition Width="250"/>
          <ColumnDefinition Width="*"/>
        </Grid.ColumnDefinitions>

        <!-- Barra de título: solo los botones de ventana, a la derecha como en Windows -->
        <Border x:Name="TitleBar" Grid.Row="0" Grid.ColumnSpan="2" Background="Transparent">
          <StackPanel Orientation="Horizontal" HorizontalAlignment="Right" VerticalAlignment="Top">
            <Button x:Name="BtnMin" Style="{StaticResource CaptionBtn}" Content="&#xE921;" ToolTip="Minimizar"/>
            <Button x:Name="BtnClose" Style="{StaticResource CloseBtn}" Content="&#xE8BB;" ToolTip="Cerrar"/>
          </StackPanel>
        </Border>

        <!-- Barra lateral -->
        <Border x:Name="Sidebar" Visibility="Collapsed" Grid.Row="1" Grid.Column="0" Style="{StaticResource GlassCard}" Margin="16,0,12,16" Padding="14">
          <DockPanel>
            <StackPanel DockPanel.Dock="Bottom">
              <Button x:Name="BtnRestore" Style="{StaticResource GlassButton}" Content="Crear punto ahora"/>
            </StackPanel>
            <StackPanel DockPanel.Dock="Top" Margin="6,6,0,22">
              <TextBlock FontSize="22"><Run FontWeight="Bold" Foreground="#8E8E8E" Text="Nur"/><Run FontWeight="Light" Foreground="#F2F2F2" Text="Optimizador"/></TextBlock>
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
                       Foreground="#CFCFCF" FontFamily="Consolas" FontSize="12.5"
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
                <TextBlock x:Name="WzRestoreBusy" Visibility="Collapsed" Foreground="#CFCFCF" FontSize="14" TextWrapping="Wrap"
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
                <TextBlock x:Name="WzOptTitle" Text="Ajustes opcionales" FontSize="28" FontWeight="SemiBold"/>
                <TextBlock x:Name="WzOptSub" Text="Estos no se aplican solos porque dependen de cómo uses tu PC. Marcá los que quieras."
                           TextWrapping="Wrap" Foreground="#CCFFFFFF" FontSize="14" Margin="0,10,0,16"/>
                <ScrollViewer MaxHeight="330" VerticalScrollBarVisibility="Auto">
                  <StackPanel x:Name="WzOptList" Margin="0,0,10,0"/>
                </ScrollViewer>
                <StackPanel Orientation="Horizontal" Margin="0,22,0,0">
                  <Button x:Name="WzOptApply" Style="{StaticResource GlassButton}" Content="Aplicar los marcados" MinWidth="190" Margin="0,0,12,0"/>
                  <Button x:Name="WzOptSkip" Style="{StaticResource GlassButton}" Content="Omitir" MinWidth="120"/>
                </StackPanel>
              </StackPanel>

              <StackPanel x:Name="WzEdge" Visibility="Collapsed">
                <TextBlock Text="Microsoft Edge" FontSize="28" FontWeight="SemiBold"/>
                <TextBlock Text="¿Querés eliminar Microsoft Edge de tu PC?" TextWrapping="Wrap" Foreground="#CCFFFFFF" FontSize="15" Margin="0,10,0,10"/>
                <TextBlock TextWrapping="Wrap" Foreground="#99FFFFFF" FontSize="12.5" Margin="0,0,0,24"
                           Text="Windows protege Edge, así que la app prueba 4 métodos; el último modifica temporalmente un archivo protegido del sistema (con copia de seguridad) y lo restaura. Si ninguno funciona, no se cambia nada y te ofrezco desactivar sus actualizaciones. Algunas funciones de Windows (enlaces de ayuda, resultados web) abren Edge. Si lo quitás y no tenés otro navegador, te ofrezco instalar Chrome."/>
                <StackPanel Orientation="Horizontal">
                  <Button x:Name="WzEdgeYes" Style="{StaticResource GlassButton}" Content="Sí, eliminar Edge" MinWidth="190" Margin="0,0,12,0"/>
                  <Button x:Name="WzEdgeNo" Style="{StaticResource GlassButton}" Content="No, mantenerlo" MinWidth="170"/>
                </StackPanel>
              </StackPanel>

              <StackPanel x:Name="WzEdgeUpd" Visibility="Collapsed">
                <TextBlock Text="Actualizaciones de Edge" FontSize="28" FontWeight="SemiBold"/>
                <TextBlock x:Name="WzEdgeUpdNote" TextWrapping="Wrap" Foreground="#FFEBC66E" FontSize="13" Margin="0,10,0,0"/>
                <TextBlock Text="¿Querés desactivar los servicios y tareas de actualización de Edge?" TextWrapping="Wrap" Foreground="#CCFFFFFF" FontSize="15" Margin="0,10,0,10"/>
                <TextBlock TextWrapping="Wrap" Foreground="#99FFFFFF" FontSize="12.5" Margin="0,0,0,24"
                           Text="Edge dejará de actualizarse solo y puede quedar con fallas de seguridad sin corregir. Solo conviene si no lo usás."/>
                <StackPanel Orientation="Horizontal">
                  <Button x:Name="WzEdgeUpdYes" Style="{StaticResource GlassButton}" Content="Sí, desactivar" MinWidth="170" Margin="0,0,12,0"/>
                  <Button x:Name="WzEdgeUpdNo" Style="{StaticResource GlassButton}" Content="No, dejarlas" MinWidth="170"/>
                </StackPanel>
              </StackPanel>

              <StackPanel x:Name="WzChrome" Visibility="Collapsed">
                <TextBlock Text="Instalar un navegador" FontSize="28" FontWeight="SemiBold"/>
                <TextBlock TextWrapping="Wrap" Foreground="#CCFFFFFF" FontSize="14" Margin="0,10,0,26"
                           Text="Quitaste Edge y no se detectó Google Chrome en tu PC. Sin un navegador no vas a poder abrir páginas web. ¿Querés instalar Chrome ahora?"/>
                <StackPanel x:Name="WzChromeButtons" Orientation="Horizontal">
                  <Button x:Name="WzChromeInstall" Style="{StaticResource GlassButton}" Content="Instalar Google Chrome" MinWidth="200" Margin="0,0,12,0"/>
                  <Button x:Name="WzChromeSkip" Style="{StaticResource GlassButton}" Content="Ahora no" MinWidth="130"/>
                </StackPanel>
                <TextBlock x:Name="WzChromeBusy" Visibility="Collapsed" Foreground="#CFCFCF" FontSize="14" TextWrapping="Wrap"
                           Text="Instalando Chrome... descarga unos 140 MB y puede tardar unos minutos. No cierres la ventana."/>
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
            <TextBlock FontSize="22"><Run FontWeight="Bold" Foreground="#8E8E8E" Text="Nur"/><Run FontWeight="Light" Foreground="#F2F2F2" Text="Optimizador"/></TextBlock>
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
$script:AppVersion = '1.2.3'   # se sube con cada cambio, así se ve si la app se actualizó
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
    elseif (Test-WingetWorks) {
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
    if (Test-WingetWorks) {
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

# Comando de desinstalación de Edge: el que Windows guarda en el registro (lleva --msedge --channel=stable) o, si no está, el setup.exe de la carpeta
function Get-EdgeUninstallCommand {
    $k  = 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge'
    $us = (Get-ItemProperty -Path $k -Name UninstallString -ErrorAction SilentlyContinue).UninstallString
    if ($us) { return $us }
    $roots = @("${env:ProgramFiles(x86)}\Microsoft\Edge\Application", "$env:ProgramFiles\Microsoft\Edge\Application") | Where-Object { Test-Path $_ }
    $st = @($roots | ForEach-Object { Get-ChildItem $_ -Recurse -Filter setup.exe -ErrorAction SilentlyContinue | Where-Object { $_.DirectoryName -like '*\Installer' } }) |
          Sort-Object FullName -Descending | Select-Object -First 1
    if ($st) { return ('"{0}" --uninstall --msedge --channel=stable --system-level --verbose-logging' -f $st.FullName) }
    return $null
}

# Corre el desinstalador con --force-uninstall y devuelve su código de salida
function Invoke-EdgeSetup {
    $cmd = Get-EdgeUninstallCommand
    if (-not $cmd) { Write-Log '    No encontré el desinstalador de Edge.'; return -1 }
    if ($cmd -notmatch '--force-uninstall') { $cmd += ' --force-uninstall' }
    $p = Start-Process -FilePath (Join-Path $env:SystemRoot 'System32\cmd.exe') -ArgumentList '/c', ('"' + $cmd + '"') -Wait -PassThru -WindowStyle Hidden
    Start-Sleep -Seconds 2
    Write-Log "    El desinstalador terminó con código $($p.ExitCode)."
    return $p.ExitCode
}

# Truco conocido: el desinstalador de Edge se deja usar si existe el viejo MicrosoftEdge.exe en SystemApps
function Invoke-EdgeSetupWithLegacyStub {
    $dir  = Join-Path $env:SystemRoot 'SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe'
    $exe  = Join-Path $dir 'MicrosoftEdge.exe'
    $made = -not (Test-Path $dir)
    try {
        if ($made) { New-Item -Path $dir -ItemType Directory -Force -ErrorAction Stop | Out-Null }
        if (-not (Test-Path $exe)) { New-Item -Path $exe -ItemType File -Force -ErrorAction Stop | Out-Null }
        [void](Invoke-EdgeSetup)
    }
    finally {
        Remove-Item $exe -Force -ErrorAction SilentlyContinue
        if ($made) { Remove-Item $dir -Force -ErrorAction SilentlyContinue }
    }
}

# Política regional de Windows: es la que habilita "Desinstalar Edge" en la Unión Europea.
# Es un archivo protegido del sistema: se hace copia de seguridad y SIEMPRE se restaura después.
function Get-EdgeRegionPolicyFile { return (Join-Path $env:SystemRoot 'System32\IntegratedServicesRegionPolicySet.json') }

function Enable-EdgeUninstallRegionPolicy {
    $f = Get-EdgeRegionPolicyFile
    if (-not (Test-Path $f)) { Write-Log '    Este Windows no tiene IntegratedServicesRegionPolicySet.json.'; return $false }
    $bkDir = Join-Path $env:ProgramData 'NurOptimizador'
    New-Item $bkDir -ItemType Directory -Force | Out-Null
    $bk = Join-Path $bkDir 'IntegratedServicesRegionPolicySet.json.bak'
    & takeown.exe /f $f 2>&1 | Out-Null
    & icacls.exe $f /grant '*S-1-5-32-544:(F)' 2>&1 | Out-Null     # grupo Administradores por SID: funciona en cualquier idioma de Windows
    if (-not (Test-Path $bk)) { Copy-Item $f $bk -Force }
    $json   = (Get-Content $f -Raw -Encoding UTF8) | ConvertFrom-Json
    $region = (Get-ItemProperty 'HKCU:\Control Panel\International\Geo' -ErrorAction SilentlyContinue).Name
    $changed = $false
    foreach ($pol in $json.policies) {
        $label = "$($pol.'$comment') $($pol.name)"
        if ($label -match 'Edge' -and $label -match 'uninstall') {
            $pol.defaultState = 'enabled'
            if ($region -and $pol.conditions.region.enabled -and ($pol.conditions.region.enabled -notcontains $region)) {
                $pol.conditions.region.enabled += $region
            }
            $changed = $true
        }
    }
    if (-not $changed) { Write-Log '    No encontré la política "Edge is uninstallable" (Windows cambió el formato del archivo).'; return $false }
    [System.IO.File]::WriteAllText($f, ($json | ConvertTo-Json -Depth 32), (New-Object System.Text.UTF8Encoding $false))   # sin BOM
    Write-Log '    Política regional habilitada (se restaura al terminar).'
    return $true
}

function Restore-EdgeRegionPolicy {
    $f  = Get-EdgeRegionPolicyFile
    $bk = Join-Path $env:ProgramData 'NurOptimizador\IntegratedServicesRegionPolicySet.json.bak'
    if (Test-Path $bk) { Copy-Item $bk $f -Force -ErrorAction SilentlyContinue }
    & icacls.exe $f /setowner 'NT SERVICE\TrustedInstaller' 2>&1 | Out-Null
    & icacls.exe $f /reset 2>&1 | Out-Null
    Write-Log '    Archivo de política regional restaurado.'
}

function Remove-Edge {
    if (-not (Test-EdgeInstalled)) { Write-Log '  Edge no está instalado.'; return }
    $guid = '{56EB18F8-B008-4CBD-B6D2-8C97FE7E9062}'          # Microsoft Edge (canal estable)
    $pol  = 'HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate'
    Write-Log '  Cerrando Edge (incluido el arranque anticipado)...'
    Get-Process -Name msedge, MicrosoftEdgeUpdate -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

    Write-Log '  Intento 1: desinstalador de Edge...'
    [void](Invoke-EdgeSetup)

    if (Test-EdgeInstalled) {
        Write-Log '  Intento 2: truco del Edge heredado...'
        try { Invoke-EdgeSetupWithLegacyStub } catch { Write-Log "    No se pudo preparar el truco: $($_.Exception.Message)" }
    }

    if (Test-EdgeInstalled) {
        Write-Log '  Intento 3: política de Edge Update...'
        if (-not (Test-Path $pol)) { New-Item -Path $pol -Force | Out-Null }
        Set-ItemProperty -Path $pol -Name "Uninstall$guid" -Value 1 -Type DWord -Force
        $mu = "${env:ProgramFiles(x86)}\Microsoft\EdgeUpdate\MicrosoftEdgeUpdate.exe"
        if (Test-Path $mu) { Start-Process -FilePath $mu -ArgumentList '/ua', '/installsource', 'scheduler' -Wait -WindowStyle Hidden; Start-Sleep -Seconds 5 }
        Remove-ItemProperty -Path $pol -Name "Uninstall$guid" -ErrorAction SilentlyContinue
    }

    if (Test-EdgeInstalled) {
        Write-Log '  Intento 4: política regional de Windows (la de la Unión Europea)...'
        $patched = $false
        try { $patched = [bool](Enable-EdgeUninstallRegionPolicy | Select-Object -Last 1) }
        catch { Write-Log "    No se pudo preparar la política regional: $($_.Exception.Message)" }
        if ($patched) {
            try {
                Set-ItemProperty -Path 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\Microsoft Edge' -Name NoRemove -Value 0 -Type DWord -ErrorAction SilentlyContinue
                Get-Process -Name msedge -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                [void](Invoke-EdgeSetup)
                if ((Test-EdgeInstalled) -and (Test-WingetWorks)) {
                    Write-Log '    Probando también con winget...'
                    winget uninstall --id Microsoft.Edge --silent --force --accept-source-agreements | Out-Null
                    Start-Sleep -Seconds 3
                }
            }
            finally { Restore-EdgeRegionPolicy }
        }
    }

    if (Test-EdgeInstalled) {
        throw 'Windows protege Edge y no dejó quitarlo con ninguno de los 4 métodos (mirá los códigos en el Registro).'
    }

    # Quitado: que no vuelva solo. No se toca InstallDefault para no bloquear el runtime de WebView2.
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

# winget puede existir como acceso directo y aun así no arrancar ("no se puede iniciar la aplicación")
function Test-WingetWorks {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { return $false }
    try { $null = & winget --version 2>&1; return ($LASTEXITCODE -eq 0) }
    catch { return $false }
}

# Descarga un archivo mostrando avance y sin congelar la ventana
function Save-WebFile([string]$Url, [string]$Path) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Remove-Item $Path -Force -ErrorAction SilentlyContinue
    $wc = New-Object System.Net.WebClient
    try {
        $task = $wc.DownloadFileTaskAsync($Url, $Path)
        $last = 0
        while (-not $task.IsCompleted) {
            Start-Sleep -Milliseconds 400
            if ($script:UiReady) { Update-UI }
            if (Test-Path $Path) {
                $mb = [int]((Get-Item $Path).Length / 1MB)
                if ($mb -ge ($last + 20)) { Write-Log "    Descargado: $mb MB"; $last = $mb }
            }
        }
        if ($task.IsFaulted) { throw $task.Exception.InnerException }
    }
    finally { $wc.Dispose() }
}

function Install-Chrome {
    Write-Log 'Instalando Google Chrome...'

    # 1) winget, solo si de verdad funciona
    if (Test-WingetWorks) {
        try {
            Write-Log '  Probando con winget...'
            winget install -e --id Google.Chrome --silent --accept-package-agreements --accept-source-agreements | Out-Null
            if ($LASTEXITCODE -eq 0 -and (Test-ChromeInstalled)) { Write-Log '  Chrome instalado (winget).'; return $true }
            Write-Log "    winget no pudo instalarlo (código $LASTEXITCODE)."
        }
        catch { Write-Log "    winget falló: $($_.Exception.Message)" }
    }
    else { Write-Log '  winget no está disponible o no arranca en este equipo: se usa la descarga directa de Google.' }

    # 2) Instalador MSI de Google (el recomendado por Google para instalaciones silenciosas)
    try {
        $msi = Join-Path $env:TEMP 'googlechromestandaloneenterprise64.msi'
        Write-Log '  Descargando el instalador de Google (unos 140 MB)...'
        Save-WebFile 'https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi' $msi
        Write-Log '  Instalando Chrome...'
        $p = Start-Process -FilePath (Join-Path $env:SystemRoot 'System32\msiexec.exe') -ArgumentList '/i', ('"' + $msi + '"'), 'ALLUSERS=1', 'NOGOOGLEUPDATEPING=1', '/qn', '/norestart' -Wait -PassThru
        Remove-Item $msi -Force -ErrorAction SilentlyContinue
        Write-Log "    El instalador terminó con código $($p.ExitCode)."
        if (Test-ChromeInstalled) { Write-Log '  Chrome instalado.'; return $true }
    }
    catch { Write-Log "    La instalación con MSI falló: $($_.Exception.Message)" }

    # 3) Instalador EXE de Google
    try {
        $exe = Join-Path $env:TEMP 'ChromeStandaloneSetup64.exe'
        Write-Log '  Probando con el instalador EXE de Google...'
        Save-WebFile 'https://dl.google.com/chrome/direct/ChromeStandaloneSetup64.exe' $exe
        $p = Start-Process -FilePath $exe -ArgumentList '/silent', '/install' -Wait -PassThru
        Remove-Item $exe -Force -ErrorAction SilentlyContinue
        Write-Log "    El instalador terminó con código $($p.ExitCode)."
        if (Test-ChromeInstalled) { Write-Log '  Chrome instalado.'; return $true }
    }
    catch { Write-Log "    La instalación con EXE falló: $($_.Exception.Message)" }

    Write-Log '  ERROR: no se pudo instalar Chrome. Descargalo desde google.com/chrome.'
    return $false
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

# ---------- Ícono de la aplicación (barra de tareas) ----------
# Se dibuja acá mismo, así no hace falta un archivo aparte.
function New-AppIcon {
    $S = 256
    $dv = New-Object System.Windows.Media.DrawingVisual
    $dc = $dv.RenderOpen()

    $body = New-Object System.Windows.Media.LinearGradientBrush
    $body.StartPoint = [Windows.Point]::new(0, 0); $body.EndPoint = [Windows.Point]::new(1, 1)
    [void]$body.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromRgb(0x46, 0x46, 0x4A), 0))
    [void]$body.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromRgb(0x1A, 0x1A, 0x1C), 1))

    $edge = New-Object System.Windows.Media.LinearGradientBrush
    $edge.StartPoint = [Windows.Point]::new(0, 0); $edge.EndPoint = [Windows.Point]::new(0, 1)
    [void]$edge.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(0xCC, 255, 255, 255), 0))
    [void]$edge.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(0x22, 255, 255, 255), 1))
    $pen = New-Object System.Windows.Media.Pen($edge, 6)
    $dc.DrawRoundedRectangle($body, $pen, [Windows.Rect]::new(10, 10, 236, 236), 60, 60)

    # brillo de vidrio en la mitad de arriba
    $gloss = New-Object System.Windows.Media.LinearGradientBrush
    $gloss.StartPoint = [Windows.Point]::new(0, 0); $gloss.EndPoint = [Windows.Point]::new(0, 1)
    [void]$gloss.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(0x40, 255, 255, 255), 0))
    [void]$gloss.GradientStops.Add([System.Windows.Media.GradientStop]::new([System.Windows.Media.Color]::FromArgb(0x00, 255, 255, 255), 1))
    $dc.DrawRoundedRectangle($gloss, $null, [Windows.Rect]::new(10, 10, 236, 120), 60, 60)

    # la "N"
    $face = New-Object System.Windows.Media.FontFamily('Segoe UI')
    $tf = New-Object System.Windows.Media.Typeface($face, [Windows.FontStyles]::Normal, [Windows.FontWeights]::Bold, [Windows.FontStretches]::Normal)
    $ft = New-Object System.Windows.Media.FormattedText('N', [System.Globalization.CultureInfo]::InvariantCulture, [Windows.FlowDirection]::LeftToRight, $tf, 176, [Windows.Media.Brushes]::White)
    $dc.DrawText($ft, [Windows.Point]::new(($S - $ft.Width) / 2, ($S - $ft.Height) / 2))
    $dc.Close()

    $bmp = New-Object System.Windows.Media.Imaging.RenderTargetBitmap($S, $S, 96, 96, [System.Windows.Media.PixelFormats]::Pbgra32)
    $bmp.Render($dv)
    $bmp.Freeze()
    return $bmp
}

# Identidad propia: sin esto Windows agrupa la ventana con PowerShell y muestra el ícono de PowerShell en la barra de tareas
if (-not ('NurShell' -as [type])) {
    Add-Type -TypeDefinition @'
using System.Runtime.InteropServices;
public static class NurShell {
    [DllImport("shell32.dll", CharSet = CharSet.Unicode)]
    public static extern int SetCurrentProcessExplicitAppUserModelID(string appId);
}
'@
}
try { [void][NurShell]::SetCurrentProcessExplicitAppUserModelID('MatiRivoira.NurOptimizador') } catch { }

$reader = New-Object System.Xml.XmlNodeReader ([xml]$script:Xaml)
$script:window = [Windows.Markup.XamlReader]::Load($reader)
try { $script:window.Icon = New-AppIcon } catch { }

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
        'Bajo'  { $chipBg = '#1AFFFFFF'; $chipFg = '#FFD0D0D0' }
        'Medio' { $chipBg = '#33D9A441'; $chipFg = '#FFEBC66E' }
        default { $chipBg = '#33E05555'; $chipFg = '#FFF29A9A' }
    }
    $chip = New-Object Windows.Controls.Border
    $chip.CornerRadius = [Windows.CornerRadius]::new(8)
    $chip.Padding = [Windows.Thickness]::new(8, 2, 8, 2)
    $chip.Margin = [Windows.Thickness]::new(0, 8, 0, 0)
    $chip.HorizontalAlignment = 'Left'
    $chip.Background = Get-Brush $chipBg
    $chip.BorderBrush = Get-Brush '#33FFFFFF'
    $chip.BorderThickness = [Windows.Thickness]::new(1)
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
            elseif ($t.SignOutHint) {
                $ans = [Windows.MessageBox]::Show("Para que se vea bien este cambio a veces hace falta cerrar sesión (o reiniciar).`n`n¿Cerrar sesión ahora?", 'NurOptimizador', 'YesNo', 'Question')
                if ($ans -eq 'Yes') { shutdown.exe /l }
            }
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
$script:SignOutNeeded = $false

$script:Wizard      = $script:window.FindName('Wizard')
$script:WzProgBar   = $script:window.FindName('WzProgBar')
$script:WzProgText  = $script:window.FindName('WzProgText')
$script:WzProgCount = $script:window.FindName('WzProgCount')
$script:WzProgTitle = $script:window.FindName('WzProgTitle')
$script:WzOptList   = $script:window.FindName('WzOptList')
$script:WzOptTitle  = $script:window.FindName('WzOptTitle')
$script:WzOptSub    = $script:window.FindName('WzOptSub')
$script:WzEdgeUpdNote = $script:window.FindName('WzEdgeUpdNote')
$script:OptStage    = 'Optimizar'
$script:WzDoneText  = $script:window.FindName('WzDoneText')
$script:WzPages = @{}
foreach ($n in 'Restore', 'Mode', 'Progress', 'Optional', 'Edge', 'EdgeUpd', 'Chrome', 'Done') { $script:WzPages[$n] = $script:window.FindName("Wz$n") }

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
            if ($t.SignOutHint) { $script:SignOutNeeded = $true }
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
    if ($script:SignOutNeeded) { $txt += "`n`nPara que se vea bien la flecha de los accesos directos, cerrá sesión y volvé a entrar." }
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

# Etapas del final del modo rápido: Optimización opcional -> Personalización opcional -> pregunta de Edge
function Show-OptionalPage([string]$Stage) {
    $script:OptStage = $Stage
    $opt = @($script:Tweaks | Where-Object { $_.Optional -and $_.OptionalPage -eq $Stage })
    if ($opt.Count -eq 0) { Complete-OptionalStage; return }
    if ($Stage -eq 'Optimizar') {
        $script:WzOptTitle.Text = 'Optimización opcional'
        $script:WzOptSub.Text   = 'Estos ajustes dependen de cómo uses tu PC, por eso no se aplicaron solos. Marcá los que quieras.'
    }
    else {
        $script:WzOptTitle.Text = 'Personalización opcional'
        $script:WzOptSub.Text   = 'Cambios de aspecto y de comportamiento que son cuestión de gusto. Marcá los que quieras.'
    }
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

function Complete-OptionalStage {
    if ($script:OptStage -eq 'Optimizar') { Show-OptionalPage 'Personalizar' }
    else { Show-EdgeQuestion }
}

function Show-EdgeQuestion {
    if (Test-EdgeInstalled) { Show-WizardPage 'Edge' } else { Show-Done }
}

function Start-QuickMode {
    $ids = @($script:Tweaks | Where-Object { $_.Quick } | ForEach-Object { $_.Id })
    $msg = "El modo rápido va a aplicar $($ids.Count) ajustes, entre ellos:`n`n" +
           "  - Quitar OneDrive, apps preinstaladas y características heredadas`n" +
           "  - Quitar IA de Windows, Edge y Office`n" +
           "  - Desanclar todo de la barra de tareas y del menú Inicio, y quitar Widgets`n" +
           "  - Desactivar servicios como Escritorio remoto, zona móvil y administración de radio (modo avión)`n`n" +
           "Casi todo se puede revertir desde el modo avanzado, pero quitar apps y OneDrive no.`n`n¿Continuar?"
    $ans = [Windows.MessageBox]::Show($msg, 'NurOptimizador', 'YesNo', 'Question')
    if ($ans -ne 'Yes') { return }
    $script:WzProgTitle.Text = 'Optimizando tu PC...'
    Show-WizardPage 'Progress'
    Update-UI
    Start-Batch $ids
    Show-OptionalPage 'Optimizar'
}

$quickCount = @($script:Tweaks | Where-Object { $_.Quick }).Count
$script:window.FindName('WzQuickDesc').Text = "Aplica $quickCount ajustes recomendados de una vez, con una barra de progreso. Al final te pregunta por los opcionales y por Edge."
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
    Complete-OptionalStage
})
$script:window.FindName('WzOptSkip').Add_Click({ Complete-OptionalStage })

# Edge: si se elige quitarlo no se pregunta por sus actualizaciones (salvo que Windows no lo deje quitar)
$script:window.FindName('WzEdgeYes').Add_Click({
    $script:WzProgTitle.Text = 'Quitando Microsoft Edge...'
    Show-WizardPage 'Progress'
    Update-UI
    Start-Batch @('RemoveEdge')
    if (Test-EdgeInstalled) {
        $script:WzEdgeUpdNote.Text = 'No se pudo quitar Edge: Windows lo protege en esta versión.'
        $script:WzEdgeUpdNote.Visibility = 'Visible'
        Show-WizardPage 'EdgeUpd'
    }
    elseif (-not (Test-ChromeInstalled)) { Show-WizardPage 'Chrome' }
    else { Show-Done }
})
$script:window.FindName('WzEdgeNo').Add_Click({
    $script:WzEdgeUpdNote.Text = ''
    $script:WzEdgeUpdNote.Visibility = 'Collapsed'
    Show-WizardPage 'EdgeUpd'
})
$script:window.FindName('WzEdgeUpdYes').Add_Click({
    $script:WzProgTitle.Text = 'Desactivando las actualizaciones de Edge...'
    Show-WizardPage 'Progress'
    Update-UI
    Start-Batch @('DisableEdgeUpdate')
    Show-Done
})
$script:window.FindName('WzEdgeUpdNo').Add_Click({ Show-Done })

# Chrome: solo aparece si se quitó Edge y no se detecta Chrome
$script:window.FindName('WzChromeInstall').Add_Click({
    $script:window.FindName('WzChromeButtons').Visibility = 'Collapsed'
    $script:window.FindName('WzChromeBusy').Visibility = 'Visible'
    Update-UI
    $res = Install-Chrome
    if ([bool]($res | Select-Object -Last 1)) { $script:BatchOk++ } else { [void]$script:BatchFail.Add('Instalar Google Chrome') }
    Show-Done
})
$script:window.FindName('WzChromeSkip').Add_Click({ Show-Done })
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
