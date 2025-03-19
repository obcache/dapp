#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)){
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

restoreWin(*) {
	if !cfg.topDockEnabled {
		ui.mainGui.show()
		ui.gameSettingsGui.show()
		ui.gameTabGui.show()
		guiVis(ui.mainGui,true)
		guiVis(ui.gameSettingsGui,true)
		guiVis(ui.gameTabGui,true)
		
		tabsChanged()
		;ui.mainGui.opt("-toolWindow")
	}
}

hideGui(*) {
	winGetPos(&GuiX,&GuiY,,,ui.MainGui.hwnd)
	cfg.guix := guiX
	cfg.guiy := guiy
	;ui.mainGui.opt("toolWindow")
	guiVis(ui.mainGui,false)
	guiVis(ui.gameSettingsGui,false)
	guiVis(ui.gameTabGui,false)
}

initTrayMenu(*) {
	A_TrayMenu.Delete
	A_TrayMenu.Add
	A_TrayMenu.Add("Show Window", restoreWin)
	A_TrayMenu.Add("Hide Window", HideGui)
	A_TrayMenu.Add("Reset Window Position", ResetWindowPosition)
	A_TrayMenu.Add()
	A_TrayMenu.Add("Exit App"
	, KillMe)
	A_TrayMenu.Default := "Show Window"
	Try
		installLog("Tray Initialized")
}

cfgLoad(&cfg, &ui) {
	global
	cfg.dbFileName := A_ScriptDir . "\dapp.DB"
	data.queryResult		:= array()
	ui.guiH					:= 220  	;430 for Console Mode
	cfg.dockbarMon			:= 1
	ui.incursionNoticeHwnd	:= ""
	ui.exitMenuGui := gui()
	ui.gameWindowsList 		:= array()
	cfg.gameWindowsList 	:= array()
	ui.d2FlyEnabled		:= true
	ui.d2AlwaysSprintPaused 	:= false
	ui.d2IsSprinting			:= false
	ui.d2IsSliding				:= false
	ui.d2IsReloading			:= false
	ui.d2ToggleWalkEnabled	:= false
	ui.clockTimerStarted 	:= false
	ui.clockMode			:= "Clock"
	ui.autoFire1Enabled		:= false
	ui.autoFire2Enabled		:= false
	ui.antiIdle1_enabled 	:= false
	ui.antiIdle2_enabled 	:= false
	ui.antiIdle_enabled 	:= false
	ui.antiIdleInterval		:= 900000
	ui.autoClickerEnabled 	:= false
	ui.previousTab			:= ""
	ui.activeTab			:= ""
	ui.lastWindowHwnd		:= 0
	ui.colorChanged 		:= false 
	ui.guiCollapsed			:= false
	ui.afkDocked 			:= false
	ui.afkAnchoredToGui 	:= true
	ui.afkEnabled 			:= false
	ui.towerEnabled 		:= false
	ui.helpActive			:= false
	ui.dockApp_enabled		:= false
	ui.themeResetScheduled 	:= false
	ui.win1Hwnd				:= ""
	ui.win2Hwnd				:= ""
	ui.pipEnabled			:= false
	ui.pauseAlwaysRun		:= false
	ui.inGameChat			:= false
	ui.reloading			:= false
	ui.gameWindowFound		:= false
	ui.profileList				:= array()
	ui.profileListStr			:= ""
	ui.waitingForPrompt			:= true
	ui.notifyResponse			:= false
	ui.fastShutdown				:= false
	win1afk 					:= object()
	win2afk						:= object()
	win1afk.steps				:= array()
	win2afk.steps				:= array()
	win1afk.nextStep			:= ""
	win2afk.nextStep 			:= ""
	win1afk.waits 				:= array()
	win2afk.waits				:= array()
	win1afk.nextWait			:= ""
	win2afk.nextWait			:= ""
	win1afk.waiting				:= false
	win2afk.waiting				:= false
	win1afk.currStepNum			:= ""
	win2afk.currStepNum 		:= ""
	ui.clearClockAlert			:= false
	ui.themeEditorVisible		:= false
	cfg.forcedTooltipControls	:= "Win1,Win2,Win3"
		this2:=object()
	this.gameWin:="ahk_exe " setting.gameExe
	this.page:=0
	this.row:=1
	this.col:=1
	this.x:=0
	this.y:=1
	this.locked:=true
	this.exotic:=false
	this.wasMax:=false
	this.maxRange:=100
	this.state:=false
	this.itemNum:=1
	this.YOffset:=748
	this.restartQueued:=false
	this.elapsedSec:=1
	cfg.gameModuleList			:= strSplit(iniRead(cfg.file,"Game","GameModuleList"," Gameplay  , Vault Cleaner ,InfoGFX"),",")
	cfg.gameList				:= StrSplit(IniRead(cfg.file,"Game","GameList","Roblox,Rocket League"),",")
	cfg.mainTabList				:= strSplit(IniRead(cfg.file,"Interface","MainTabList","1_GAME,2_SETUP"),",")
	cfg.mainGui					:= IniRead(cfg.file,"System","MainGui","MainGui")
	cfg.autoStartEnabled 		:= iniRead(cfg.file,"System","AutoStartEnabled",false)
	cfg.confirmExitEnabled		:= iniRead(cfg.file,"System","ConfirmExit",false)
	cfg.excludedApps			:= IniRead(cfg.file,"System","ExcludedApps","Windows10Universal.exe,explorer.exe,RobloxPlayerInstaller.exe,RobloxPlayerLauncher.exe,Chrome.exe,msedge.exe")
	cfg.MainGui					:= IniRead(cfg.file,"System","MainGui","MainGui")
	cfg.MainScriptName			:= IniRead(cfg.file,"System","MainScriptName", "dapp")
	cfg.debugEnabled			:= IniRead(cfg.file,"System","DebugEnabled",false)
	cfg.consoleVisible			:= IniRead(cfg.file,"System","consoleVisible",false)
	cfg.ToolTipsEnabled 		:= IniRead(cfg.file,"System","ToolTipsEnabled",true)
	cfg.monitorRes				:= IniRead(cfg.file,"System","MonitorResolution","Auto")
	cfg.disabledTabs 			:= iniRead(cfg.file,"System","DisabledTabs","Audio,Editor")
	cfg.listDataFile			:= iniRead(cfg.file,"System","ListDataFile","./listData.ini")
	cfg.toggleOn				:= IniRead(cfg.file,"Interface","ToggleOnImage","./Img/toggle_on.png")
	cfg.toggleOff				:= IniRead(cfg.file,"Interface","ToggleOffImage","./Img/toggle_off.png")
	cfg.activeMainTab			:= IniRead(cfg.file,"Interface","activeMainTab",1)
	cfg.activeGameTab  			:= IniRead(cfg.file,"Interface","ActiveGameTab",1)
	cfg.activeEditorTab			:= iniRead(cfg.file,"Interface","ActiveEditorTab",1)
	cfg.AlwaysOnTopEnabled		:= IniRead(cfg.file,"Interface","AlwaysOnTopEnabled",true)
	cfg.AnimationsEnabled		:= IniRead(cfg.file,"Interface","AnimationsEnabled",true)
	cfg.ColorPickerEnabled 		:= IniRead(cfg.file,"Interface","ColorPickerEnabled",true)
	cfg.GuiX 					:= IniRead(cfg.file,"Interface","GuiX",PrimaryWorkAreaLeft + 200)
	cfg.GuiY 					:= IniRead(cfg.file,"Interface","GuiY",PrimaryWorkAreaTop + 200)
	cfg.GuiW					:= IniRead(cfg.file,"Interface","GuiW",545)
	cfg.GuiH					:= IniRead(cfg.file,"Interface","GuiH",210)
	cfg.pushNotificationsEnabled := iniRead(cfg.file,"Toggles","PushNotificationsEnabled",false)
	cfg.AfkX					:= IniRead(cfg.file,"Interface","AfkX",cfg.GuiX+10)
	cfg.AfkY					:= IniRead(cfg.file,"Interface","AfkY",cfg.GuiY+35)
	cfg.AfkSnapEnabled			:= IniRead(cfg.file,"Interface","AfkSnapEnabled",false)
	cfg.GuiSnapEnabled			:= IniRead(cfg.file,"Interface","GuiSnapEnabled",true)
	cfg.topDockEnabled 			:= iniRead(cfg.file,"Interface","TopDockEnabled",false)
	cfg.displaySizeAuto			:= iniRead(cfg.file,"Game","DisplaySizeAuto",true)
	cfg.AutoDetectGame			:= IniRead(cfg.file,"Game","AutoDetectGame",true)
	cfg.excludedProcesses		:= IniRead(cfg.file,"Game","ExcludedProcesses",true)
	cfg.game					:= IniRead(cfg.file,"Game","Game","2")
	cfg.HwndSwapEnabled			:= IniRead(cfg.file,"Game","HwndSwapEnabled",false)
	ui.win1enabled 				:= IniRead(cfg.file,"Game","Win1Enabled",true)
	ui.win2enabled 				:= IniRead(cfg.file,"Game","Win2Enabled",true)	
	cfg.win1Disabled 			:= IniRead(cfg.file,"Game","win1disabled",false)
	cfg.win2Disabled 			:= IniRead(cfg.file,"Game","win2disabled",false)
	cfg.w0DualPerkSwapEnabled	:= IniRead(cfg.file,"Game","w0DualPerkSwap",true)
	cfg.AfkDataFile				:= IniRead(cfg.file,"AFK","AfkDataFile","./AfkData.csv")
	cfg.Profile					:= IniRead(cfg.file,"AFK","Profile","1")
	cfg.win1Class				:= IniRead(cfg.file,"AFK","Win1Class",1)
	cfg.win2Class				:= IniRead(cfg.file,"AFK","Win2Class",1)
	cfg.antiIdleWin1Cmd			:= IniRead(cfg.file,"AFK","AntiIdleWin1Cmd","5")
	cfg.antiIdleWin2Cmd			:= IniRead(cfg.file,"AFK","AntiIdleWin2Cmd","5")
	cfg.towerInterval			:= iniRead(cfg.file,"AFK","TowerInterval","270000")
	cfg.antiIdleInterval		:= IniRead(cfg.file,"AFK","AntiIdleInterval","1250")
	cfg.SilentIdleEnabled 		:= IniRead(cfg.file,"AFK","SilentIdleEnabled",true)
	cfg.AutoClickerSpeed 		:= IniRead(cfg.file,"AFK","AutoClickerSpeed",50)
	cfg.CelestialTowerEnabled	:= IniRead(cfg.file,"AFK","CelestialTowerEnabled",false)
	cfg.AppDockMonitor 			:= IniRead(cfg.file,"AppDock","AppDockMonitor","1")	
	if cfg.appDockMonitor > monitorGetCount()
		cfg.appDockMonitor := 1
	cfg.app1filename			:= IniRead(cfg.file,"AppDock","app1filename","")
	cfg.app1path				:= IniRead(cfg.file,"AppDock","app1path","")
	cfg.app2filename			:= IniRead(cfg.file,"AppDock","app2filename","")
	cfg.app2path				:= IniRead(cfg.file,"AppDock","app2path","")
	cfg.DockHeight 				:= IniRead(cfg.file,"AppDock","DockHeight","240")
	cfg.DockMarginSize 			:= IniRead(cfg.file,"AppDock","DockMarginSize","8")
	cfg.UndockedX 				:= IniRead(cfg.file,"AppDock","UndockedX","150")
	cfg.UndockedY 				:= IniRead(cfg.file,"AppDock","UndockedY","150")
	cfg.UndockedW 				:= IniRead(cfg.file,"AppDock","UndockedW","1600")
	cfg.UndockedH 				:= IniRead(cfg.file,"AppDock","UndockedH","1000")
	cfg.allowedAudioDevices		:= iniRead(cfg.file,"Audio","AllowedAudioOutput","")
	cfg.gameAudioEnabled		:= IniRead(cfg.file,"audio","gameAudioEnabled","false")
	cfg.MicName					:= IniRead(cfg.file,"audio","MicName","Yeti")
	cfg.SpeakerName				:= IniRead(cfg.file,"audio","SpeakerName","S2MASTER")
	cfg.HeadsetName				:= IniRead(cfg.file,"audio","HeadsetName","G432")
	cfg.MicVolume				:= IniRead(cfg.file,"audio","MicVolume",".80")
	cfg.SpeakerVolume	 		:= IniRead(cfg.file,"audio","SpeakerVolume",".50")
	cfg.HeadsetVolume			:= IniRead(cfg.file,"audio","HeadsetVolume",".80")
	cfg.Mode					:= IniRead(cfg.file,"audio","Mode","1")
	cfg.Theme					:= IniRead(cfg.file,"Interface","Theme","Modern Class")
	cfg.ThemeList				:= StrSplit(IniRead(cfg.themeFile,"Interface","ThemeList","Modern Class,Cold Steel,Militarized,Custom"),",")
	cfg.baseColor	:= IniRead(cfg.themeFile,cfg.Theme,"baseColor","414141")
	cfg.fontColor1			:= IniRead(cfg.themeFile,cfg.Theme,"fontColor1","1FFFF0")
	cfg.fontColor2			:= IniRead(cfg.themeFile,cfg.Theme,"fontColor2","FBD58E")
	cfg.fontColor3			:= IniRead(cfg.themeFile,cfg.Theme,"fontColor3","1FFFF0")
	cfg.fontColor4			:= IniRead(cfg.themeFile,cfg.Theme,"fontColor4","FBD58E")
	cfg.accentColor4		:= IniRead(cfg.themeFile,cfg.Theme,"accentColor4","C0C0C0")
	cfg.accentColor3		:= IniRead(cfg.themeFile,cfg.Theme,"accentColor3","FFFFFF")
	cfg.accentColor2			:= IniRead(cfg.themeFile,cfg.Theme,"accentColor2","C0C0C0")
	cfg.accentColor1			:= IniRead(cfg.themeFile,cfg.Theme,"accentColor1","FFFFFF")
	cfg.outlineColor1	:= IniRead(cfg.themeFile,cfg.Theme,"outlineColor1","888888")
	cfg.outlineColor2	:= IniRead(cfg.themeFile,cfg.Theme,"outlineColor2","333333")
	cfg.bgColor1		:= IniRead(cfg.themeFile,cfg.Theme,"bgColor1","204040")
	cfg.bgColor2		:= IniRead(cfg.themeFile,cfg.Theme,"bgColor2","804001")
	cfg.trimColor1		:= IniRead(cfg.themeFile,cfg.Theme,"trimColor1","204040")
	cfg.bgColor3		:= IniRead(cfg.themeFile,cfg.Theme,"bgColor3","804001")
	cfg.trimColor6		:= IniRead(cfg.themeFile,cfg.Theme,"trimColor6","292929")
	cfg.trimColor5		:= IniRead(cfg.themeFile,cfg.Theme,"trimColor5","292929")
	cfg.bgColor0		:= IniRead(cfg.themeFile,cfg.Theme,"bgColor0","212121")
	cfg.trimColor4	:= IniRead(cfg.themeFile,cfg.Theme,"trimColor4","3C3C3C")
	cfg.trimColor3		:= IniRead(cfg.themeFile,cfg.Theme,"trimColor3","FF01FF")
	cfg.trimColor2	:= IniRead(cfg.themeFile,cfg.Theme,"trimColor2","1FFFF0")
	cfg.titlebarImage		:= iniRead(cfg.themeFile,cfg.Theme,"ThemeTitlebarImage","./img/dapp_titlebar.png")
	cfg.holdToCrouchEnabled 	:= IniRead(cfg.file,"game","HoldToCrouch",true)
	cfg.cs2HoldToScopeEnabled	:= IniRead(cfg.file,"game","cs2HoldToScopeEnabled",true)
	cfg.dappPauseKey			:= iniRead(cfg.file,"Game","dappPauseKey","<UNSET>")
	cfg.dappPaused				:= iniRead(cfg.file,"Game","dappPaused",false)
	cfg.d2AlwaysRunEnabled		:= iniRead(cfg.file,"Game","d2AlwaysRunEnabled",false)
	cfg.dappSwordFlyKey		:= iniRead(cfg.file,"Game","dappSwordFlyKey","<UNSET>")
	cfg.dappLoadoutKey			:= IniRead(cfg.file,"Game","dappLoadoutKey","<UNSET>")
	cfg.dappLoadoutMultiplier	:= iniRead(cfg.file,"Game","dappLoadoutMultiplier",1)
	cfg.dappToggleSprintKey	:= IniRead(cfg.file,"Game","dappToggleSprintKey","<UNSET>")
	cfg.dappReloadKey			:= IniRead(cfg.file,"Game","dappReloadKey","<UNSET>")
	cfg.dappHoldToCrouchKey	:= IniRead(cfg.file,"Game","dappHoldToCrouchKey","<UNSET>")
	cfg.d2GameHoldToCrouchKey	:= iniRead(cfg.file,"Game","d2GameHoldToCrouchKey","LControl")
	cfg.d2GameToggleSprintKey	:= IniRead(cfg.file,"Game","d2GameToggleSprintKey","<UNSET>")
	cfg.d2GameReloadKey			:= IniRead(cfg.file,"Game","d2GameReloadKey","<UNSET>")
	cfg.d2GameGrenadeKey		:= IniRead(cfg.file,"Game","d2GameGrenadeKey","<UNSET>")
	cfg.d2GameSuperKey			:= IniRead(cfg.file,"Game","d2GameSuperKey","<UNSET>")
	cfg.d2CharacterClass		:= iniRead(cfg.file,"Game","d2CharacterClass","1")
	cfg.d2AutoGameConfigEnabled := iniRead(cfg.file,"Game","d2AutoGameConfigEnabled",true)
	cfg.SLBHopKey				:= iniRead(cfg.file,"Game","ShatterLineBunnyHopKey","<UNSET>")
	cfg.d2GameMouseLeftButtonKey := iniRead(cfg.file,"Mouse","MouseLeftButton","LButton")
	cfg.d2GameMouseRightButtonKey := iniRead(cfg.file,"Mouse","MouseRightButton","LButton")
	cfg.d2GameMouseMiddleButtonKey := iniRead(cfg.file,"Mouse","MouseMiddleButton","LButton")
	cfg.d2GameMouseBackButtonKey := iniRead(cfg.file,"Mouse","MouseBackButton","LButton")
	cfg.d2GameMouseForwardButtonKey := iniRead(cfg.file,"Mouse","MouseForwardButton","LButton")
	cfg.titleBarImage			:= iniRead(cfg.file,"Interface","TitlebarImage","./img/dapp_titlebar.png")
	
	runWait("./redist/mouseSC_x64.exe /verticalScroll:1",,"hide")
}

initProgress(progressAmount:=5,*) {
		ui.loadingProgress.value += progressAmount
}

WriteConfig() {
	Global
	tmpGameList := ""
	iniWrite(cfg.d2GameMouseLeftButtonKey,cfg.file,"Mouse","MouseLeftButton")
	iniWrite(cfg.d2GameMouseRightButtonKey,cfg.file,"Mouse","MouseRightButton")
	iniWrite(cfg.d2GameMouseMiddleButtonKey,cfg.file,"Mouse","MouseMiddleButton")
	iniWrite(cfg.d2GameMouseBackButtonKey,cfg.file,"Mouse","MouseBackButton")
	iniWrite(cfg.d2GameMouseForwardButtonKey,cfg.file,"Mouse","MouseForwardButton")
	
	iniWrite(cfg.displaySizeAuto,cfg.file,"Game","DisplaySizeAuto")
	iniWrite(cfg.excludedProcesses,cfg.file,"Game","ExcludedProcesses")
	IniWrite(cfg.autoDetectGame,cfg.file,"Game","AutoDetectGame")
	iniWrite(cfg.excludedApps,cfg.file,"System","ExcludedApps")
	IniWrite(cfg.game,cfg.file,"Game","Game")
	iniWrite(cfg.listDataFile,cfg.file,"System","ListDataFile")
	IniWrite(cfg.mainScriptName,cfg.file,"System","ScriptName")
	IniWrite(cfg.mainGui,cfg.file,"System","MainGui")
	iniWrite(cfg.disabledTabs,cfg.file,"System","DisabledTabs")
	iniWrite(cfg.confirmExitEnabled,cfg.file,"System","ConfirmExit")
	IniWrite(ui.monitorResDDL.value,cfg.file,"System","MonitorResolution")
	IniWrite(arr2str(cfg.gameModuleList),cfg.file,"Game","GameModuleList")
	IniWrite(arr2str(cfg.gameList),cfg.file,"Game","GameList")
	IniWrite(ui.win1enabled,cfg.file,"Game","Win1Enabled")
	IniWrite(ui.win2enabled,cfg.file,"Game","Win2Enabled")	
	IniWrite(cfg.win1disabled,cfg.file,"Game","win1disabled")
	IniWrite(cfg.win2disabled,cfg.file,"Game","win2disabled")
	IniWrite(cfg.hwndSwapEnabled,cfg.file,"Game","HwndSwapEnabled")
	IniWrite(cfg.cs2HoldToScopeEnabled,cfg.file,"Game","cs2HoldToScope")
	IniWrite(cfg.AppDockMonitor,cfg.file,"AppDock","AppDockMonitor")
	IniWrite(cfg.dockHeight,cfg.file,"AppDock","DockHeight")
	IniWrite(cfg.dockMarginSize,cfg.file,"AppDock","DockMarginSize")
	iniWrite(cfg.pushNotificationsEnabled,cfg.file,"Toggles","PushNotificationsEnabled")
	IniWrite(cfg.undockedX,cfg.file,"AppDock","UndockedX")
	IniWrite(cfg.undockedY,cfg.file,"AppDock","UndockedY")
	IniWrite(cfg.undockedW,cfg.file,"AppDock","UndockedW")
	IniWrite(cfg.undockedH,cfg.file,"AppDock","UndockedH")
	IniWrite(cfg.gameAudioEnabled,cfg.file,"Audio","gameAudioEnabled")
	IniWrite(cfg.micName,cfg.file,"Audio","Mic")
	IniWrite(cfg.speakerName,cfg.file,"Audio","Speaker")
	IniWrite(cfg.headsetName,cfg.file,"Audio","Headset")
	IniWrite(cfg.micVolume,cfg.file,"Audio","MicVolume")
	IniWrite(cfg.speakerVolume,cfg.file,"Audio","SpeakerVolume")
	IniWrite(cfg.headsetVolume,cfg.file,"Audio","HeadsetVolume")
	IniWrite(cfg.mode,cfg.file,"Audio","Mode")
	if (ui.themeResetScheduled) {
		FileDelete(cfg.themeFile)
		FileAppend(ui.defaultThemes,cfg.themeFile)
		ui.themeResetSchedule := false
	} else {
		IniWrite(ui.themeDDL.text,cfg.file,"Interface","Theme")
		IniWrite(arr2str(cfg.themeList),cfg.themeFile,"Interface","ThemeList")
		IniWrite(cfg.accentColor4,cfg.themeFile,"Custom","accentColor4")
		IniWrite(cfg.accentColor3,cfg.themeFile,"Custom","accentColor3")
		IniWrite(cfg.accentColor2,cfg.themeFile,"Custom","accentColor2")
		IniWrite(cfg.accentColor1,cfg.themeFile,"Custom","accentColor1")
		IniWrite(cfg.outlineColor2,cfg.themeFile,"Custom","outlineColor2")
		IniWrite(cfg.outlineColor1,cfg.themeFile,"Custom","outlineColor1")
		IniWrite(cfg.baseColor,cfg.themeFile,"Custom","baseColor")
		IniWrite(cfg.fontColor1,cfg.themeFile,"Custom","fontColor1")
		IniWrite(cfg.fontColor2,cfg.themeFile,"Custom","fontColor2")
		IniWrite(cfg.fontColor3,cfg.themeFile,"Custom","fontColor3")
		IniWrite(cfg.fontColor4,cfg.themeFile,"Custom","fontColor4")
		IniWrite(cfg.bgColor1,cfg.themeFile,"Custom","bgColor1")
		IniWrite(cfg.trimColor1,cfg.themeFile,"Custom","trimColor1")
		IniWrite(cfg.bgColor2,cfg.themeFile,"Custom","bgColor2")
		IniWrite(cfg.bgColor3,cfg.themeFile,"Custom","bgColor3")
		IniWrite(cfg.trimColor6,cfg.themeFile,"Custom","trimColor6")
		IniWrite(cfg.trimColor5,cfg.themeFile,"Custom","trimColor5")
		IniWrite(cfg.bgColor0,cfg.themeFile,"Custom","bgColor0")
		IniWrite(cfg.trimColor3,cfg.themeFile,"Custom","trimColor3")
		IniWrite(cfg.trimColor2,cfg.themeFile,"Custom","trimColor2")
		IniWrite(cfg.trimColor4,cfg.themeFile,"Custom","trimColor4")
		iniWrite(cfg.titlebarImage,cfg.themeFile,"Custom","ThemeTitlebarImage")
		IniWrite(ui.mainGuiTabs.value,cfg.file,"Interface","ActiveMainTab")
		IniWrite(ui.gameTabs.value,cfg.file,"Interface","ActiveGameTab")
		iniWrite(cfg.activeEditorTab,cfg.file,"Interface","ActiveEditorTab")
		iniWrite(cfg.topDockEnabled,cfg.file,"Interface","TopDockEnabled")
		iniWrite(cfg.dappPauseKey,cfg.file,"Game","dappPauseKey")
		iniWrite(cfg.dappPaused,cfg.file,"Game","dappPaused")
		IniWrite(cfg.dappHoldToCrouchKey,cfg.file,"Game","dappHoldToCrouchKey")
		IniWrite(cfg.dappLoadoutKey,cfg.file,"Game","dappLoadoutKey")
		iniWrite(cfg.dappSwordFlyKey,cfg.file,"Game","dappSwordFlyKey")
		iniWrite(cfg.dappLoadoutMultiplier,cfg.file,"Game","dappLoadoutMultiplier")
		IniWrite(cfg.dappToggleSprintKey,cfg.file,"Game","dappToggleSprintKey")
		IniWrite(cfg.dappReloadKey,cfg.file,"Game","dappReloadKey")
		IniWrite(cfg.dappHoldToCrouchKey,cfg.file,"Game","dappHoldToCrouchKey")
		IniWrite(cfg.d2GameToggleSprintKey,cfg.file,"Game","d2GameToggleSprintKey")
		IniWrite(cfg.d2GameReloadKey,cfg.file,"Game","d2GameReloadKey")
		IniWrite(cfg.d2GameGrenadeKey,cfg.file,"Game","d2GameGrenadeKey")
		IniWrite(cfg.d2GameSuperKey,cfg.file,"Game","d2GameSuperKey")
		iniWrite(cfg.d2CharacterClass,cfg.file,"Game","d2CharacterClass")
		iniWrite(cfg.d2AutoGameConfigEnabled,cfg.file,"Game","d2AutoGameConfigEnabled")
		d2LoadoutCoordsStr := ""
		loop cfg.d2LoadoutCoords.length {
			d2LoadoutCoordsStr .= cfg.d2LoadoutCoords1920x1080[a_index] ","
		}
		iniWrite(rtrim(d2LoadoutCoordsStr,","),cfg.file,"Game","d2LoadoutCoords1920x1080")
		d2LoadoutCoordsStr := ""
		loop cfg.d2LoadoutCoords.length {
			d2LoadoutCoordsStr .= cfg.d2LoadoutCoords3440x1440[a_index] ","
		}		
		iniWrite(rtrim(d2LoadoutCoordsStr,","),cfg.file,"Game","d2LoadoutCoords3440x1440")
		d2LoadoutCoordsStr := ""
		loop cfg.d2LoadoutCoords.length {
			d2LoadoutCoordsStr .= cfg.d2LoadoutCoords1920x1200[a_index] ","
		}
		iniWrite(rtrim(d2LoadoutCoordsStr,","),cfg.file,"Game","d2LoadoutCoords1920x1200")
		d2LoadoutCoordsStr := ""
		loop cfg.d2LoadoutCoords.length {
			d2LoadoutCoordsStr .= cfg.d2LoadoutCoords2560x1440[a_index] ","
		}		
		iniWrite(rtrim(d2LoadoutCoordsStr,","),cfg.file,"Game","d2LoadoutCoords2560x1440")
		ui.mainTabListString := ""
		loop cfg.mainTabList.length {
			ui.mainTabListString .= cfg.mainTabList[a_index] ','
		}
		IniWrite(rtrim(ui.mainTabListString,","),cfg.file,"Interface","MainTabList")
	}
	if (ui.AfkDocked) {
		cfg.GuiX := ui.GuiPrevX
		cfg.GuiY := ui.GuiPrevY
	} 
	try {
		winGetPos(&guiX,&guiY,,,ui.mainGui.hwnd)
		cfg.guiX := guiX
		cfg.guiY := GuiY
	} catch {
		cfg.GuiX := 200
		cfg.GuiY := 200
	}
	IniWrite(cfg.GuiX,cfg.file,"Interface","GuiX")
	IniWrite(cfg.GuiY,cfg.file,"Interface","GuiY")
	IniWrite(cfg.AfkX,cfg.file,"Interface","AfkX")
	IniWrite(cfg.AfkY,cfg.file,"Interface","AfkY")
	IniWrite(cfg.AfkSnapEnabled,cfg.file,"Interface","AfkSnapEnabled")
	IniWrite(cfg.GuiSnapEnabled,cfg.file,"Interface","GuiSnapEnabled")
	IniWrite(cfg.toggleOn,cfg.file,"Interface","ToggleOnImage")
	IniWrite(cfg.toggleOff,cfg.file,"Interface","ToggleOffImage")
	IniWrite(cfg.ConsoleVisible,cfg.file,"System","ConsoleVisible")
	IniWrite(cfg.consoleVisible,cfg.file,"System","consoleVisible")
	IniWrite(cfg.AlwaysOnTopEnabled,cfg.file,"Interface","AlwaysOnTopEnabled")
	IniWrite(cfg.ColorPickerEnabled,cfg.file,"Interface","ColorPickerEnabled")
	iniWrite(cfg.autoStartEnabled,cfg.file,"System","AutoStartEnabled")
	IniWrite(cfg.AfkDataFile,cfg.file,"AFK","AfkDataFile")
	IniWrite(cfg.SilentIdleEnabled,cfg.file,"AFK","SilentIdleEnabled")
	iniWrite(cfg.towerInterval,cfg.file,"AFK","TowerInterval")
	iniWrite(cfg.CelestialTowerEnabled,cfg.file,"AFK","CelestialTowerEnabled")
	IniWrite(ui.AutoClickerSpeedSlider.Value,cfg.file,"AFK","AutoClickerSpeed")
	ui.MainGui.Destroy()
	BlockInput("Off")
}

adjustPos(*) {
	cfg.guiX := iniRead(cfg.file,"interface","GuiX",200)
	cfg.guiY := iniRead(cfg.file,"interface","GuiY",200)
	lowestHorz := 0
	highestHorz := 0
	lowestVert :=0
	highestVert := 0
	loop monitorGetCount() {
		monitorGet(a_index,&ml,&mt,&mr,&mb)
		if lowestHorz > ml
			lowestHorz := ml
		if highestHorz < mr
			highestHorz := mr
		if lowestVert > mt
			lowestVert := mt
		if highestVert < mb
			highestVert := mb
	}		
	if (cfg.GuiX < lowestHorz) || (cfg.guiX+550 > highestHorz) {
		cfg.GuiX := 200
		cfg.GuiY := 200
	}
	if (cfg.GuiY < lowestVert) || (cfg.guiY+220 > highestVert) {
		cfg.GuiX := 200
		cfg.GuiY := 200
	}
	iniWrite(cfg.GuiX,cfg.file,"interface","GuiX")
	iniWrite(cfg.GuiY,cfg.file,"interface","GuiY")
}

runApp(appName) {
	global
	For app in ComObject('Shell.Application').NameSpace('shell:AppsFolder').Items
	(app.Name = appName) && RunWait('explorer shell:appsFolder\' app.Path,,,&appPID)
}

getClick(&clickX,&clickY,&activeWindow) {
	DialogBox("Click to get information about a pixel")
	Sleep(750)
	CoordMode("Mouse","Client")
	MonitorSelectStatus := KeyWait("LButton", "D T15")
	DialogBoxClose()
	if (MonitorSelectStatus = 0) {	
		MsgBox("A monitor was not selected in time.`nPlease try again.")
		Return
	} else {
		MouseGetPos(&clickX,&clickY,&pixelColor,&activeWindow)
		pixelColor := PixelGetColor(clickX,clickY)
		activeWindow := winWait("A")
		fileAppend("Window: [" activeWindow "] " WinGetTitle("ahk_id " activeWindow) " `nx: " clickX " y: " clickY "`nColor: " pixelColor "`n`n", "./capturedPixels.txt")
		debugLog("Window: [" activeWindow "] " WinGetTitle("ahk_id " activeWindow) ", x: " clickX " y: " clickY ", Color: " pixelColor)
	}
}

GetWinNumber() {
	 Try {
		debugLog("GetWinNumber Comparing " ui.Win1Hwnd " and " ui.Win2Hwnd " to " WinExist("A"))
		Return (ui.Win1Hwnd == WinExist("A")) ? 1 : (ui.Win2Hwnd == WinExist("A") ? 2 : 0)
	 } Catch {
		 Return 0
	 }
}

debugLog(LogMsg) {
	Global
	ui.gvConsole.Add([A_YYYY A_MM A_DD " [" A_Hour ":" A_Min ":" A_Sec "] " LogMsg])
	PostMessage("0x115",7,,,"ahk_id " ui.gvConsole.hwnd) 
}

DialogBox(Msg,Alignment := "Center") {
	Global
	if !InStr("LeftRightCenter",Alignment)
		Alignment := "Left"
	Transparent := 250
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Notify"
	ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow +Owner" ui.mainGui.hwnd)  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := cfg.bgColor1  ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.setFont("q5 s16")  ; Set a large font size (32-point).
	ui.notifyMsg := ui.notifyGui.AddText("c" cfg.fontColor1 " " Alignment " BackgroundTrans",Msg)  ; XX & YY serve to 00auto-size the window.
	ui.notifyGui.AddText("xs hidden")
	WinSetTransparent(0,ui.notifyGui)
	ui.notifyGui.Show("NoActivate Autosize")  ; NoActivate avoids deactivating the currently active window.
	ui.notifyGui.GetPos(&x,&y,&w,&h)
	winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui.hwnd)
	ui.notifyGui.Show("x" (GuiX+(GuiW/2)-(w/2)) " y" GuiY+(100-(h/2)) " NoActivate")
	drawOutlineNotifyGui(1,1,w,h,cfg.outlineColor2,cfg.outlineColor1,1)
	drawOutlineNotifyGui(2,2,w-2,h-2,cfg.accentColor4,cfg.accentColor4,1)
	Transparency := 0
	guiVis("all",false)	
	While Transparency < 253 {
		Transparency += 5
		WinSetTransparent(Round(Transparency),ui.notifyGui)
	}
}

DialogBoxClose(*)
{
	Global
	Try
		ui.notifyGui.Destroy()
	guiVis("all",true)
	tabsChanged()
}

NotifyOSD(NotifyMsg,Duration := 2000,guiName:=ui.mainGui,Alignment := "Left",YN := "")
{
	if !InStr("LeftRightCenter",Alignment)
		Alignment := "Left"
	Transparent := 250
	try
		ui.notifyGui.Destroy()
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Notify"
	ui.notifyGui.Opt(" -Caption +ToolWindow +Owner" guiName.hwnd)  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := cfg.bgColor1  ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.setFont("q5 s16")  ; Set a large font size (32-point).
	ui.notifyGui.AddText("c" cfg.fontColor1 " " Alignment " BackgroundTrans",NotifyMsg)  ; XX & YY serve to 00auto-size the window.
	ui.notifyGui.AddText("xs hidden")
	WinSetTransparent(0,ui.notifyGui)
	ui.notifyGui.Show("NoActivate Autosize")  ; NoActivate avoids deactivating the currently active window.
	ui.notifyGui.GetPos(&x,&y,&w,&h)
	winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui.hwnd)
	ui.notifyGui.Show("x" (GuiX+(GuiW/2)-(w/2)) " y" GuiY+(100-(h/2)) )
	guiVis(ui.notifyGui,true)
	drawOutlineNotifyGui(1,1,w,h,cfg.outlineColor2,cfg.outlineColor1,1)
	drawOutlineNotifyGui(2,2,w-2,h-2,cfg.accentColor4,cfg.accentColor4,1)
	if (YN) {
		ui.notifyGui.AddText("xs hidden")
		ui.notifyYesButton := ui.notifyGui.AddPicture("ys x30 y30","./Img/button_yes.png")
		ui.notifyYesButton.OnEvent("Click",notifyConfirm)
		ui.notifyNoButton := ui.notifyGui.AddPicture("ys","/Img/button_no.png")
		ui.notifyNoButton.OnEvent("Click",notifyCancel)
		SetTimer(waitOSD,-10000)
	} else {
		ui.Transparent := 250
		try {
			WinSetTransparent(ui.Transparent,ui.notifyGui)
			setTimer () => (sleep(duration),fadeOSD()),-100
		}
	}
	waitOSD() {
		ui.notifyGui.destroy()
		notifyOSD("Timed out waiting for response.`nPlease try your action again",-1000)
	}
}

fadeOSD() {
	ui.transparent := 250
	While ui.Transparent > 10 { 	
		try
			WinSetTransparent(ui.Transparent,ui.notifyGui)
		ui.Transparent -= 3
		Sleep(1)
	}
	try
		guiVis(ui.notifyGui,false)
	ui.Transparent := 0
}

loadScreen(visible := true,NotifyMsg := "dapp Loading",Duration := 10) {
	if (visible) {
		Transparent := 0
		ui.notifyGui			:= Gui()
		ui.notifyGui.Title 		:= "dapp Loading"
		ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
		ui.notifyGui.BackColor := "c0c0c0" ; Can be any RGB color (it will be made transparent below).
		ui.notifyGui.setFont("q5 s22")  ; Set a large font size (32-point).
		ui.notifyGui.addText("section x1 y1 w238 h92 background353535")
		ui.notifyGui.addPicture("y1 x2 w237 h92 backgroundTrans","./img/dapp_logo.png")
		ui.loadingProgress := ui.notifyGui.addProgress("smooth x2 y94 w236 h21 caaaaaa background353535")
		ui.notifyGui.AddText("xs hidden")
		tmpX := iniRead(cfg.file,"Interface","GuiX",200)
		tmpY := iniRead(cfg.file,"Interface","GuiY",200)
		winGetPos(&x,&y,&w,&h,ui.notifyGui.hwnd)
		winSetTransparent(0,ui.notifyGui)
		ui.notifyGui.show("w240 h116 x" (tmpX+100)-(w/2) " y" (tmpY+50)-(h/2))
		while transparent < 245 {
			winSetTransparent(transparent,ui.notifyGui.hwnd)
			transparent += 8
			sleep(10)
		} 
		winSetTransparent("Off",ui.notifyGui.hwnd)
	} else {
		transparent := 255
		while transparent > 10 {
			winSetTransparent(transparent,ui.notifyGui.hwnd)
			transparent -= 1
			sleep(20)
		}
		ui.notifyGui.hide()
		ui.notifyGui.destroy()
	}
}

hasVal(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

killMe(*) {
	ExitApp
}

resetWindowPosition(*) {
	try {
		guiVis(ui.dockBarGui,false)
		guiVis(ui.mainGui,true)
		tabsChanged()
		ui.MainGui.Move(PrimaryWorkAreaLeft+200,PrimaryWorkAreaTop+200,,)
	}
}

exitFunc(ExitReason,ExitCode) {
	ui.MainGui.Opt("-AlwaysOnTop")
	If  !ui.fastShutdown && (cfg.confirmExitEnabled) && !InStr("Logoff Shutdown Reload Single Close",ExitReason)
	{
		Result := MsgBox("Are you sure you want to`nTERMINATE dapp?",,4)
		if Result = "No" {
			if cfg.AlwaysOnTopEnabled
				ui.mainGui.opt("AlwaysOnTop")
			Return 1
		}
	}
	guiVis(ui.gameSettingsGui,false)
	guiVis(ui.mainGui,false)
	try {
		guiVis(ui.gameTabGui,false)
	}
	winGetPos(&winX,&winY,,,ui.mainGui.hwnd)
	cfg.guiX := winX
	cfg.guiY := winY
	WriteConfig()
}

restartApp(*) {
	reload()
}

arr2str(arrayName) {
	loop arrayName.Length
	{
		stringFromArray .= arrayName[a_index] ","
	}
	return rtrim(stringFromArray,",")
}

resetKeyStates() {
	Loop 0xFF {
		if getKeyState(key := format("vk{:x}",a_index))
		sendInput("{%key% up}")
	}	
	setCapslockState(false)
	
}

appChangeTrans(transLevel) {
	try
		winSetTransparent(transLevel,ui.dockBarGui.hwnd)
}

