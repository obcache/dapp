#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

monitorResChanged(*) {
;libGuiSetupTab
	cfg.monitorRes := ui.monitorResDDL.text
	if (ui.monitorAuto.value) {
		ui.monitorResDDL.delete()
		ui.monitorResDDL.add([a_screenWidth "x" a_screenHeight])
		ui.monitorResDDL.text := a_screenWidth "x" a_screenHeight
		}

	d2CreateLoadoutKeys()
}

GuiSetupTab(&ui,&cfg) {
	global
	ui.MainGuiTabs.UseTab("2_Setup____")
	
	drawPanel(ui.mainGui,40,39,218,164,cfg.bgColor1,cfg.outlineColor2,cfg.outlineColor1,1,1,"none",100,"Features","calibri",cfg.fontColor1)
	drawPanel(ui.mainGui,261,39,214,104,cfg.bgColor1,cfg.outlineColor2,cfg.outlineColor1,1,1,"none",100,"Features","calibri",cfg.fontColor1)
	drawPanel(ui.mainGui,261,151,214,53,cfg.bgColor1,cfg.outlineColor2,cfg.outlineColor1,1,1,"none",100,"Features","calibri",cfg.fontColor1)
	drawPanel(ui.mainGui,478,39,42,165,cfg.bgColor1,cfg.outlineColor2,cfg.outlineColor1,1,1,"none",100,"Features","calibri",cfg.fontColor1)
	;line(ui.mainGui,34,0,30,2,cfg.bgColor2)	
	line(ui.mainGui,529,184,29,2,cfg.accentColor1)
	ui.MainGui.setFont("q5 s09")
	;drawOutlineNamed("autoClicker",ui.mainGui,486,45,27,145,cfg.outlineColor2,cfg.outlineColor2,1)
	ui.AutoClickerSpeedSlider := ui.MainGui.AddSlider("x487 y45 w25 h144 Range1-64 Vertical Left TickInterval8 Invert ToolTipTop",cfg.AutoClickerSpeed)
	ui.AutoClickerSpeedSliderLabel2 := ui.MainGui.AddText("x475 y190 w50 r1 Center BackgroundTrans","CPS")
	ui.AutoClickerSpeedSlider.ToolTip := "AutoClicker Speed"
	ui.AutoClickerSpeedSlider.OnEvent("Change",AutoClickerSpeedChanged)

	
	ui.MainGui.setFont("q5 s10 c" cfg.fontColor1)
	drawOutlineMainGui(34,28,497,200,cfg.accentColor3,cfg.accentColor3,2)
	ui.mainGui.addText("hidden section x48 y26")
	cfg.toolTipsEnabled			:= iniRead(cfg.file,"Toggles","ToolTipsEnabled",true)
	ui.toggleToolTips 			:= ui.MainGui.AddPicture("xs y+5 w50 h22 section vToolTips " ((cfg.ToolTipsEnabled) ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2)),((cfg.ToolTipsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.labelToolTips 			:= ui.MainGui.AddText("x+5 ys+2 BackgroundTrans","  ToolTips")
	ui.toggleToolTips.ToolTip 	:= "Toggles ToolTips"
	ui.toggleToolTips.OnEvent("Click", toggleChanged)
	
	
	ToggleAlwaysOnTop(*)
	{
		ui.toggleAlwaysOnTop.Opt((cfg.AlwaysOnTopEnabled := !cfg.AlwaysOnTopEnabled) ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2))
		ui.toggleAlwaysOnTop.Redraw()
	}
	
	ui.mainGui.opt((cfg.AlwaysOnTopEnabled) ? "alwaysOnTop" : "-alwaysOnTop")
	ui.toggleAlwaysOnTop 			:= ui.MainGui.AddPicture("xs y+2 w50 h22 section vAlwaysOnTop " (cfg.AlwaysOnTopEnabled ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2)),((cfg.AlwaysOnTopEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.labelAlwaysOnTop				:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  AlwaysOnTop")	
	ui.toggleAlwaysOnTop.ToolTip 	:= "Keeps this app on top of all other windows."
	ui.toggleAlwaysOnTop.OnEvent("Click", ToggleAlwaysOnTopChanged)
		
	ToggleAlwaysOnTopChanged(*) {
		ui.toggleAlwaysOnTop.value 	:=	((cfg.AlwaysOnTopEnabled := !cfg.AlwaysOnTopEnabled) 
											? (ui.toggleAlwaysOnTop.opt("Background" cfg.trimColor3),cfg.toggleOn) 
											: (ui.toggleAlwaysOnTop.opt("Background" cfg.trimColor2),cfg.toggleOff))
		ui.toggleAlwaysOnTop.Redraw()
		try {
			winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.mainGui)
		}
		try { 
			winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.afkGui)
		}
		try {
			winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.gameSettingsGui)
		}
		try {
			winSetAlwaysOnTop(cfg.AlwaysOnTopEnabled,ui.gameTabGui)
		}
	}
	
	cfg.animationsEnabled := iniRead(cfg.file,"Toggles","AnimationsEnabled",true)
	ui.toggleAnimations := ui.MainGui.AddPicture("xs w50 y+2 h22 section vAnimations " (cfg.AnimationsEnabled ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2)),((cfg.AnimationsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAnimations.OnEvent("Click", toggleChanged)
	ui.toggleAnimations.ToolTip := "Toggles the app's slide and fade animations."
	ui.labelAnimations:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Animations")



	ui.toggleAutoStart := ui.MainGui.AddPicture("xs y+2 w50 h22 section vAutoStart " (cfg.autoStartEnabled ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2)),((cfg.autoStartEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAutoStart.OnEvent("Click", toggleChangedAutoStart)
	ui.toggleAutoStart.ToolTip := "Auto-starts the app on Windows login."
	ui.labelAutoStart:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  AutoStart")
	
	toggleChangedAutoStart(toggleControl,*) {
		toggleControl.value := 
		(cfg.%toggleControl.name%Enabled := !cfg.%toggleControl.name%Enabled)
			? (toggleControl.Opt("Background" cfg.trimColor3),cfg.toggleOn)
			: (toggleControl.Opt("Background" cfg.trimColor2),cfg.toggleOff)

	if cfg.%toggleControl.name%Enabled 
		if !(fileExist(A_StartMenu "\Programs\Startup\dapp.lnk"))
			setAutoStart(1)
	else
		if (fileExist(A_StartMenu "\Programs\Startup\dapp.lnk"))
			setAutoStart(0)
	
}
	setAutoStart(OnOff) {
		if (OnOff == "On" || OnOff == true || OnOff == 1) {
			try {
				fileCreateShortcut(installDir "/dapp.exe", A_StartMenu "\Programs\Startup\dapp.lnk",installDir,,"dapp - Destiny2 Companion",installDir "/img/dapp_icon.ico")
				trayTip("dapp now set to Autostart","dapp Config Change","Iconi Mute")
			} catch {
				trayTip("Failed to set dapp to Autostart","dapp Config Change","Iconi Mute")
				setAutoStart(0)
			}
		} else {
			try {
				fileDelete(A_StartMenu "\Programs\Startup\dapp.lnk")
				trayTip("dapp Autostart Disabled","dapp Config Change","Iconi Mute")
			} catch {
				trayTip("Failed to disable Autostart","dapp Config Change","Iconi Mute")
				setAutoStart(1)
			}
		}
	}
	
	
	ToggleStartMinimized(*)
	{
		ui.toggleStartMinimized.Opt((cfg.StartMinimizedEnabled := !cfg.StartMinimizedEnabled) ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2))
		ui.toggleStartMinimized.Redraw()
		iniWrite(cfg.StartMinimizedEnabled,cfg.file,"System","StartMinimizedEnabled")
	}
	cfg.StartMinimizedEnabled:=iniRead(cfg.file,"Toggles","StartMinimizedEnabled",false)
	ui.toggleStartMinimized := ui.MainGui.AddPicture("xs y+2 w50 h22 section vStartMinimized " (cfg.StartMinimizedEnabled ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2)),((cfg.StartMinimizedEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleStartMinimized.OnEvent("Click", toggleChanged)
	ui.toggleStartMinimized.ToolTip := "Minimizes the app to system tray when started.  Useful when combined with 'Start with Windows'."
	ui.labelStartMinimized:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Start Minimized")
	; cfg.MouseRemapEnabled:=iniRead(cfg.file,"System","MouseRemapEnabled",false)
 	; ui.toggleMouseRemap := ui.MainGui.AddPicture("xs y+2 w50 h22 section vMouseRemap " (cfg.MouseRemapEnabled ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2)),((cfg.MouseRemapEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	; ui.toggleMouseRemap.OnEvent("Click", toggleChanged)
	; ui.toggleMouseRemap.ToolTip := "Enables mouseping (cShift)"
	; ui.labelMouseRemap:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Remap Mouse")
	; ToggleMouseRemap(*)
	; {
		; ui.toggleMouseRemap.Opt((cfg.MouseRemapEnabled := !cfg.MouseRemapEnabled) ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2))
		; ui.toggleMouseRemap.Redraw()
		; iniWrite(cfg.MouseRemapEnabled,cfg.file,"System","MouseRemapEnabled")
	; }
	  
	cfg.confirmExitEnabled:=iniRead(cfg.file,"Toggles","ConfirmExitEnabled",true)
	ui.toggleconfirmExit := ui.MainGui.AddPicture("xs y+2 w50 h22 section vConfirmExit " (cfg.ConfirmExitEnabled ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2)),((cfg.ConfirmExitEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleConfirmExit.OnEvent("Click", toggleChanged)
	ui.toggleConfirmExit.ToolTip := "Produces a confirmation prompt upon exiting the application."
	ui.labelConfirmExit:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Confirm Exit")


	TogglePushNotifications(*)
	{
		ui.togglePushNotifications.Opt((cfg.PushNotificationsEnabled := !cfg.PushNotificationsEnabled) ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2))
		ui.togglePushNotifications.Redraw()
		
	}
	cfg.PushNotificationsEnabled:=iniRead(cfg.file,"Toggles","PushNotificationsEnabled",true)
	ui.togglePushNotifications := ui.MainGui.AddPicture("xs y+2 w50 h22 section vPushNotifications " (cfg.PushNotificationsEnabled ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2)),((cfg.PushNotificationsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.togglePushNotifications.OnEvent("Click", toggleChanged)
	ui.togglePushNotifications.ToolTip := "Enables pop-up notifications regarding in-game events."
	ui.labelPushNotifications:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Notifications")

	ToggleDebug(*)
	{
		ui.toggleDebug.Opt((cfg.DebugEnabled := !cfg.DebugEnabled) ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2))
		ui.toggleDebug.Redraw()
	}
	cfg.DebugEnabled:=iniRead(cfg.file,"Toggles","DebugEnabled",false)
	ui.toggleDebug := ui.MainGui.AddPicture("xs y+2 w50 h22 section vDebug " (cfg.DebugEnabled ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2)),((cfg.DebugEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleDebug.OnEvent("Click", toggleChanged)
	ui.toggleDebug.ToolTip := "Keeps this app on top of all other windows."
	ui.labelDebug:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Debug")

	drawOutlineNamed("toggleBlock",ui.mainGui,48,44,52,155,cfg.accentColor1,cfg.accentColor1,1)
	drawOutlineNamed("toggleBlock",ui.mainGui,48,44,52,155,cfg.accentColor2,cfg.accentColor2,1)
	drawOutlineNamed("toggleBlock",ui.mainGui,48,44,52,155,cfg.outlineColor2,cfg.outlineColor2,1)
	
	ui.mainGui.addText("x270 y45 w198 h62 background" cfg.trimColor1)
	ui.mainGui.addText("x271 y46 w196 h60 background" cfg.outlineColor2)
	ui.mainGui.addText("x272 y47 w194 h58 background" cfg.outlineColor1)
	ui.mainGui.addText("x273 y48 w192 h56 background" cfg.trimColor1)
	;line(ui.mainGui,0,36,155,2,cfg.accentColor3)

	ui.checkForUpdatesLabel := ui.mainGui.addtext("x280 y46 w200 h30 section backgroundTrans c" cfg.fontColor3,"Check For Updates")
	ui.checkForUpdatesLabel.setFont("q5 s12","move-x")
	ui.checkForUpdatesButton := ui.mainGui.addPicture("xs+10 y+-7 w30 h30 section background" cfg.trimColor3,"./img/button_update.png")
	ui.checkForUpdatesButton.onEvent("Click",checkForUpdates)
	ui.checkForUpdatesButton.Tooltip := "Checks to see if a more recent version is available"	
	ui.installedVersionText := ui.mainGui.addText("ys-1 x+17 section w140 h19 backgroundTrans c" cfg.fontColor3 ,"Installed:`t#.#.#.#")
	ui.latestVersionText := ui.mainGui.addText("xs y+-4 w140 backgroundTrans c" cfg.fontColor3,"Available:`t#.#.#.#")
	ui.monitorResList := ["1920x1080","1920x1200","2560x1440","3440x1440","Custom"]

	ui.monitorResDDL := ui.mainGui.AddDDL("xs-66 y+15 w90 r4 choose" cfg.monitorRes " c" cfg.fontColor4 " background" cfg.baseColor,ui.monitorResList)
	ui.monitorResDDL.setFont("c" cfg.fontColor4)
	ui.monitorResDDL.onEvent("change",monitorResChanged)
	ui.monitorResLabel := ui.mainGui.AddText("x+4 y+-25 w65 c" cfg.fontColor1 " backgroundTrans","Screen")	
	ui.monitorResLabel2 := ui.mainGui.AddText("y+-2 w65 c" cfg.fontColor1 " backgroundTrans","Size")
	ui.monitorResLabel.setFont("q5 s9")
	ui.monitorResLabel2.setFont("q5 s9")
	ui.monitorAutoLabel := ui.mainGui.addText("x+-28 y+-12 w25 h12 section c" cfg.fontColor1 " backgroundTrans","Auto")
	ui.monitorAutoLabel.setFont("q5 s8")
	ui.monitorAuto := ui.mainGui.addCheckbox("x+-18 y+-26 w15 h15",cfg.displaySizeAuto)
	ui.monitorAuto.onEvent("Click",toggleAutoDisplaySize)


	ui.macroSpeed := ui.mainGui.addText("x+7 y+-15 w35 h16 center border section")
	ui.macroSpeed := ui.mainGui.addUpDown("vMacroSpeed range1-10",cfg.dappLoadoutMultiplier)
	ui.macroSpeedLabel := ui.mainGui.addText("x+-31 ys+16 w30 backgroundTrans","Delay")
	ui.macroSpeedLabel.setFont("q5 s8")
	ui.macroSpeed.onEvent("change",macroSpeedChanged)
	ui.installedVersionText.setFont("q5 s10")
	ui.latestVersionText.setFont("q5 s10")

	macroSpeedChanged(*) {
		cfg.dappLoadoutMultiplier := ui.macroSpeed.value
	}

	if cfg.displaySizeAuto {
		ui.monitorResDDL.opt("disabled")
		ui.monitorAuto.value := true
	} else {
	ui.monitorResDDL.opt("-disabled")
		ui.monitorAuto.value := false
	}
	
	toggleAutoDisplaySize(*) {
		cfg.displaySizeAuto := ui.monitorAuto.Value
		if cfg.displaySizeAuto {
			ui.monitorResDDL.opt("disabled")
			monitorResChanged()
		} else {
			ui.monitorResDDL.opt("-disabled")
			ui.monitorResDDL.delete()
			ui.monitorResDDL.add(["1920x1080","1920x1200","2560x1440","3440x1440","Custom"])
			ui.monitorResDDL.text := cfg.monitorRes
		}
	}
	ui.themeEditorButton := ui.mainGui.addPicture("x275 y161 w35 h35 section backgroundTrans","./img/color_swatches.png")
	ui.themeEditorLabel := ui.mainGui.addText("x+8 ys+4 w150 h33 section background" cfg.bgColor1,"Theme Editor")
	ui.themeEditorLabel.setFont("q5 s14")
	ui.themeEditorButton.onEvent("click",showThemeEditor)
	
  	AutoClickerSpeedChanged(*) {
	cfg.AutoClickerSpeed := (ui.AutoClickerSpeedSlider.Value/0.128)

}

ui.defaultThemes := "
(
[Interface]
ThemeList=Modern Class,Cold Steel,Militarized,Neon,Ocean
[Modern Class]
outlineColor1=C0C0C0
outlineColor2=333333
accentColor3=1D1D1D
accentColor4=19F9F
baseColor=4A5A60
fontColor1=1FFFF
fontColor2=FCC84B
bgColor1=355051
bgColor2=674704
trimColor1=355051
bgColor3=1D5852
trimColor6=292929
bgColor0=212121
trimColor3=FF01FF
trimColor2=1FFFF
trimColor4=FFCC00
[Cold Steel]
outlineColor1=888888
outlineColor2=333333
accentColor3=313131
accentColor4=C0C0C0
baseColor=414141
fontColor1=1FFFF
fontColor2=FAE7AD
bgColor1=204040
bgColor2=984C01
trimColor1=70D1C8
bgColor3=654901
trimColor6=292929
bgColor0=212121
trimColor3=FF01FF
trimColor2=1FFFF
trimColor4=FFCC00
[Militarized]
outlineColor1=888888
outlineColor2=333333
accentColor3=66B1FE
accentColor4=FEFE98
baseColor=606060
fontColor1=98CBFE
fontColor2=FE8001
bgColor1=202020
bgColor2=984C01
trimColor1=355051
bgColor3=70D1C8
trimColor6=292929
bgColor0=212121
trimColor3=01FE80
trimColor2=CFA645
trimColor4=FFCC00
[Ocean]
outlineColor1=446466
outlineColor2=333333
accentColor3=365154
accentColor4=3C3C3C
baseColor=2C3537
fontColor1=1FFFF
fontColor2=256D65
bgColor1=355051
bgColor2=70D1C8
trimColor1=355051
bgColor3=70D1C8
trimColor6=292929
bgColor0=212121
trimColor3=1FFFF
trimColor2=9D9D9D
trimColor4=FFCC00
[LCD]
baseColor=B0C6B6
outlineColor1=5B8471
outlineColor2=5E5E01
accentColor3=1D1D1D
accentColor4=19F9F
fontColor1=E9F977
fontColor2=303030
bgColor1=6D8B87
bgColor2=73714D
trimColor1=6D8B87
bgColor3=73714D
trimColor6=CEAFD1
bgColor0=212121
trimColor3=FF01FF
trimColor2=D7FF82
trimColor4=FFCC00
[Neon]
baseColor=414141
outlineColor1=888888
outlineColor2=333333
accentColor3=C0C0C0
accentColor4=FFFFFF
fontColor1=1FFFF0
fontColor2=FBD58E
bgColor1=204040
bgColor2=804001
trimColor1=204040
bgColor3=804001
trimColor6=292929
bgColor0=212121
trimColor3=FF01FF
trimColor2=1FFFF0
trimColor4=FFCC00
)"
}