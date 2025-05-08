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
	drawPanel(ui.mainGui,40,33,218,174,cfg.TabColor2,cfg.OutlineColor2,cfg.OutlineColor1,1,1,"none",100,"Features","calibri",cfg.FontColor1)
	drawPanel(ui.mainGui,261,33,214,118,cfg.TabColor2,cfg.OutlineColor2,cfg.OutlineColor1,1,1,"none",100,"Features","calibri",cfg.FontColor1)
	drawPanel(ui.mainGui,261,154,214,53,cfg.TabColor2,cfg.OutlineColor2,cfg.OutlineColor1,1,1,"none",100,"Features","calibri",cfg.FontColor1)
	drawPanel(ui.mainGui,478,33,42,174,cfg.TabColor2,cfg.OutlineColor2,cfg.OutlineColor1,1,1,"none",100,"Features","calibri",cfg.FontColor1)
	line(ui.mainGui,529,184,29,2,cfg.TrimColor1)

	ui.MainGui.setFont("q5 s09")
	ui.AutoClickerSpeedSlider := ui.MainGui.AddSlider("disabled x487 y45 w25 h144 Range1-64 Vertical Left TickInterval8 Invert ToolTipTop",cfg.AutoClickerSpeed)
	ui.AutoClickerSpeedSliderLabel2 := ui.MainGui.AddText("x475 y190 w50 r1 Center BackgroundTrans","CPS")
	ui.AutoClickerSpeedSlider.ToolTip := "AutoClicker Speed"
	ui.AutoClickerSpeedSlider.OnEvent("Change",AutoClickerSpeedChanged)
	
	ui.MainGui.setFont("q5 s10 c" cfg.FontColor1)
	drawOutlineMainGui(34,28,497,200,cfg.DisabledColor,cfg.DisabledColor,2)
	ui.mainGui.addText("hidden section x48 y21")
	cfg.toolTipsEnabled			:= iniRead(cfg.file,"Toggles","ToolTipsEnabled",true)
	ui.toggleToolTips 			:= ui.MainGui.AddPicture("xs y+3 w50 h22 section vToolTips " ((cfg.ToolTipsEnabled) ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor)),((cfg.ToolTipsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.labelToolTips 			:= ui.MainGui.AddText("x+5 ys+2 BackgroundTrans","  ToolTips")
	ui.toggleToolTips.ToolTip 	:= "Toggles ToolTips"
	ui.toggleToolTips.OnEvent("Click", toggleChanged)
	
	ToggleAlwaysOnTop(*)
	{
		ui.toggleAlwaysOnTop.Opt((cfg.AlwaysOnTopEnabled := !cfg.AlwaysOnTopEnabled) ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor))
		ui.toggleAlwaysOnTop.Redraw()
	}
	
	ui.mainGui.opt((cfg.AlwaysOnTopEnabled) ? "alwaysOnTop" : "-alwaysOnTop")
	ui.toggleAlwaysOnTop 			:= ui.MainGui.AddPicture("xs y+2 w50 h22 section vAlwaysOnTop " (cfg.AlwaysOnTopEnabled ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor)),((cfg.AlwaysOnTopEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.labelAlwaysOnTop				:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  AlwaysOnTop")	
	ui.toggleAlwaysOnTop.ToolTip 	:= "Keeps this app on top of all other windows."
	ui.toggleAlwaysOnTop.OnEvent("Click", ToggleAlwaysOnTopChanged)
		
	ToggleAlwaysOnTopChanged(*) {
		ui.toggleAlwaysOnTop.value 	:=	((cfg.AlwaysOnTopEnabled := !cfg.AlwaysOnTopEnabled) 
											? (ui.toggleAlwaysOnTop.opt("Background" cfg.OnColor),cfg.toggleOn) 
											: (ui.toggleAlwaysOnTop.opt("Background" cfg.OffColor),cfg.toggleOff))
		ui.toggleAlwaysOnTop.Redraw()
		
		try {
			winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.mainGui)
		}
		try {
			winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.gameSettingsGui)
		}
		try {
			winSetAlwaysOnTop(cfg.AlwaysOnTopEnabled,ui.gameTabGui)
		}
	}
	
	cfg.animationsEnabled := iniRead(cfg.file,"Toggles","AnimationsEnabled",true)
	ui.toggleAnimations := ui.MainGui.AddPicture("xs w50 y+2 h22 section vAnimations " (cfg.AnimationsEnabled ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor)),((cfg.AnimationsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAnimations.OnEvent("Click", toggleChanged)
	ui.toggleAnimations.ToolTip := "Toggles the app's slide and fade animations."
	ui.labelAnimations:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Animations")

	ui.toggleAutoStart := ui.MainGui.AddPicture("xs y+2 w50 h22 section vAutoStart " (cfg.autoStartEnabled ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor)),((cfg.autoStartEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleAutoStart.OnEvent("Click", toggleChangedAutoStart)
	ui.toggleAutoStart.ToolTip := "Auto-starts the app on Windows login."
	ui.labelAutoStart:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  AutoStart")
	
	toggleChangedAutoStart(toggleControl,*) {
		toggleControl.value := 
		(cfg.%toggleControl.name%Enabled := !cfg.%toggleControl.name%Enabled)
			? (toggleControl.Opt("Background" cfg.OnColor),cfg.toggleOn)
			: (toggleControl.Opt("Background" cfg.OffColor),cfg.toggleOff)

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
		ui.toggleStartMinimized.Opt((cfg.StartMinimizedEnabled := !cfg.StartMinimizedEnabled) ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor))
		ui.toggleStartMinimized.Redraw()
		iniWrite(cfg.StartMinimizedEnabled,cfg.file,"System","StartMinimizedEnabled")
	}
	cfg.StartMinimizedEnabled:=iniRead(cfg.file,"Toggles","StartMinimizedEnabled",false)
	ui.toggleStartMinimized := ui.MainGui.AddPicture("xs y+2 w50 h22 section vStartMinimized " (cfg.StartMinimizedEnabled ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor)),((cfg.StartMinimizedEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleStartMinimized.OnEvent("Click", toggleChanged)
	ui.toggleStartMinimized.ToolTip := "Minimizes the app to system tray when started.  Useful when combined with 'Start with Windows'."
	ui.labelStartMinimized:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Start Minimized")
	; cfg.MouseRemapEnabled:=iniRead(cfg.file,"System","MouseRemapEnabled",false)
 	; ui.toggleMouseRemap := ui.MainGui.AddPicture("xs y+2 w50 h22 section vMouseRemap " (cfg.MouseRemapEnabled ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor)),((cfg.MouseRemapEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	; ui.toggleMouseRemap.OnEvent("Click", toggleChanged)
	; ui.toggleMouseRemap.ToolTip := "Enables mouseping (cShift)"
	; ui.labelMouseRemap:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Remap Mouse")
	; ToggleMouseRemap(*)
	; {
		; ui.toggleMouseRemap.Opt((cfg.MouseRemapEnabled := !cfg.MouseRemapEnabled) ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor))
		; ui.toggleMouseRemap.Redraw()
		; iniWrite(cfg.MouseRemapEnabled,cfg.file,"System","MouseRemapEnabled")
	; }
	  
	cfg.confirmExitEnabled:=iniRead(cfg.file,"Toggles","ConfirmExitEnabled",true)
	ui.toggleconfirmExit := ui.MainGui.AddPicture("xs y+2 w50 h22 section vConfirmExit " (cfg.ConfirmExitEnabled ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor)),((cfg.ConfirmExitEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleConfirmExit.OnEvent("Click", toggleChanged)
	ui.toggleConfirmExit.ToolTip := "Produces a confirmation prompt upon exiting the application."
	ui.labelConfirmExit:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Confirm Exit")


	TogglePushNotifications(*)
	{
		ui.togglePushNotifications.Opt((cfg.PushNotificationsEnabled := !cfg.PushNotificationsEnabled) ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor))
		ui.togglePushNotifications.Redraw()
		
	}
	cfg.PushNotificationsEnabled:=iniRead(cfg.file,"Toggles","PushNotificationsEnabled",true)
	ui.togglePushNotifications := ui.MainGui.AddPicture("xs y+2 w50 h22 section vPushNotifications " (cfg.PushNotificationsEnabled ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor)),((cfg.PushNotificationsEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.togglePushNotifications.OnEvent("Click", toggleChanged)
	ui.togglePushNotifications.ToolTip := "Enables pop-up notifications regarding in-game events."
	ui.labelPushNotifications:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Notifications")

	ToggleDebug(*)
	{
		ui.toggleDebug.Opt((cfg.DebugEnabled := !cfg.DebugEnabled) ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor))
		ui.toggleDebug.Redraw()
	}
	cfg.DebugEnabled:=iniRead(cfg.file,"Toggles","DebugEnabled",false)
	ui.toggleDebug := ui.MainGui.AddPicture("xs y+2 w50 h22 section vDebug " (cfg.DebugEnabled ? ("Background" cfg.OnColor) : ("Background" cfg.OffColor)),((cfg.DebugEnabled) ? (cfg.toggleOn) : (cfg.toggleOff)))
	ui.toggleDebug.OnEvent("Click", toggleChanged)
	ui.toggleDebug.ToolTip := "Keeps this app on top of all other windows."
	ui.labelDebug:= ui.MainGui.AddText("x+5 ys+2 backgroundTrans","  Debug")

	;drawOutlineNamed("toggleBlock",ui.mainGui,48,43,51,157,cfg.AuxColor3,cfg.AuxColor3,1)
	;drawOutlineNamed("toggleBlock",ui.mainGui,47,43,50,157,cfg.TrimColor2,cfg.TrimColor2,1)
	;drawOutlineNamed("toggleBlock",ui.mainGui,48,42,50,157,cfg.OutlineColor2,cfg.OutlineColor2,1)
	
	ui.mainGui.addText("x270 y45 w198 h62 background" cfg.TrimColor3)
	ui.mainGui.addText("x271 y46 w196 h60 background" cfg.OutlineColor2)
	ui.mainGui.addText("x272 y47 w194 h58 background" cfg.OutlineColor1)
	ui.mainGui.addText("x273 y48 w192 h56 background" cfg.TrimColor3)
	;line(ui.mainGui,0,36,155,2,cfg.DisabledColor)

	ui.checkForUpdatesLabel := ui.mainGui.addtext("x280 y46 w200 h30 section backgroundTrans c" cfg.FontColor3,"Check For Updates")
	ui.checkForUpdatesLabel.setFont("q5 s12","move-x")
	ui.checkForUpdatesButton := ui.mainGui.addPicture("xs+10 y+-7 w30 h30 section background" cfg.OnColor,"./img/button_update.png")
	ui.checkForUpdatesButton.onEvent("Click",checkForUpdates)
	ui.checkForUpdatesButton.Tooltip := "Checks to see if a more recent version is available"	
	ui.installedVersionText := ui.mainGui.addText("ys-1 x+17 section w140 h19 backgroundTrans c" cfg.FontColor3 ,"Installed:`t" substr(a_fileVersion,1,1) "." subStr(a_fileVersion,2,1) "." subStr(a_fileVersion,3,1) "." subStr(a_fileVersion,4,1))
	ui.installedVersionText.setFont(,"Calibri")
	ui.latestVersionText := ui.mainGui.addText("xs y+-4 w140 backgroundTrans c" cfg.FontColor3,"Available:`t#.#.#.#")
	ui.latestVersionText.setFont(,"Calibri")
	ui.monitorResList := ["1920x1080","1920x1200","2560x1440","3440x1440","Custom"]
	ui.mainGui.setFont(,"calibri")
	ui.monitorResDDL := ui.mainGui.AddDDL("xs-66 y+2 w90 r4 choose" cfg.monitorRes " c" cfg.FontColor4 " background" cfg.AuxColor2,ui.monitorResList)
	ui.monitorResDDL.setFont("c" cfg.FontColor4)
	ui.monitorResDDL.onEvent("change",monitorResChanged)
	ui.monitorResLabel := ui.mainGui.AddText("x+4 y+-25 w65 c" cfg.FontColor1 " backgroundTrans","Screen")	
	ui.monitorResLabel2 := ui.mainGui.AddText("y+-2 w65 c" cfg.FontColor1 " backgroundTrans","Size")
	ui.monitorResLabel.setFont("q5 s9")
	ui.monitorResLabel2.setFont("q5 s9")
	ui.monitorAutoLabel := ui.mainGui.addText("x+-28 y+-12 w25 h12 section c" cfg.FontColor1 " backgroundTrans","Auto")
	ui.monitorAutoLabel.setFont("q5 s8")
	ui.monitorAuto := ui.mainGui.addCheckbox("x+-18 y+-28 w15 h15",cfg.displaySizeAuto)
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
	ui.themeEditorButton := ui.mainGui.addPicture("x275 y163 w35 h35 section backgroundTrans","./img/color_swatches.png")
	ui.themeEditorLabel := ui.mainGui.addText("x+5 ys+4 w150 h33 section backgroundTrans","Theme Editor")
	ui.themeEditorLabel.setFont("q5 s14","move-x")
	ui.themeEditorButton.onEvent("click",showThemeEditor)

  	AutoClickerSpeedChanged(*) {
		cfg.AutoClickerSpeed := (ui.AutoClickerSpeedSlider.Value/0.128)
	
	}

ui.defaultThemes := "
(
[Interface]
ThemeList=Modern Class,Cold Steel,Militarized,Neon,Ocean
[Modern Class]
OutlineColor1=C0C0C0
OutlineColor2=333333
DisabledColor=1D1D1D
AuxColor3=19F9F
baseColor=4A5A60
FontColor1=1FFFF
FontColor2=FCC84B
TabColor2=355051
TabColor1=674704
TrimColor3=355051
TileColor=1D5852
AuxColor2=292929
TabColor1=212121
OnColor=FF01FF
OffColor=1FFFF
AlertColor=FFCC00
[Cold Steel]
OutlineColor1=888888
OutlineColor2=333333
DisabledColor=313131
AuxColor3=C0C0C0
baseColor=414141
FontColor1=1FFFF
FontColor2=FAE7AD
TabColor2=204040
TabColor1=984C01
TrimColor3=70D1C8
TileColor=654901
AuxColor2=292929
TabColor1=212121
OnColor=FF01FF
OffColor=1FFFF
AlertColor=FFCC00
[Militarized]
OutlineColor1=888888
OutlineColor2=333333
DisabledColor=66B1FE
AuxColor3=FEFE98
baseColor=606060
FontColor1=98CBFE
FontColor2=FE8001
TabColor2=202020
TabColor1=984C01
TrimColor3=355051
TileColor=70D1C8
AuxColor2=292929
TabColor1=212121
OnColor=01FE80
OffColor=CFA645
AlertColor=FFCC00
[Ocean]
OutlineColor1=446466
OutlineColor2=333333
DisabledColor=365154
AuxColor3=3C3C3C
baseColor=2C3537
FontColor1=1FFFF
FontColor2=256D65
TabColor2=355051
TabColor1=70D1C8
TrimColor3=355051
TileColor=70D1C8
AuxColor2=292929
TabColor1=212121
OnColor=1FFFF
OffColor=9D9D9D
AlertColor=FFCC00
[LCD]
baseColor=B0C6B6
OutlineColor1=5B8471
OutlineColor2=5E5E01
DisabledColor=1D1D1D
AuxColor3=19F9F
FontColor1=E9F977
FontColor2=303030
TabColor2=6D8B87
TabColor1=73714D
TrimColor3=6D8B87
TileColor=73714D
AuxColor2=CEAFD1
TabColor1=212121
OnColor=FF01FF
OffColor=D7FF82
AlertColor=FFCC00
[Neon]
baseColor=414141
OutlineColor1=888888
OutlineColor2=333333
DisabledColor=C0C0C0
AuxColor3=FFFFFF
FontColor1=1FFFF0
FontColor2=FBD58E
TabColor2=204040
TabColor1=804001
TrimColor3=204040
TileColor=804001
AuxColor2=292929
TabColor1=212121
OnColor=FF01FF
OffColor=1FFFF0
AlertColor=FFCC00
)"
}