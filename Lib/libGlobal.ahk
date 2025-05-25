#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)){
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

restoreWin(*) {
	ui.maingui.show()
	if ui.mainGuiTabs.value==1 {
		ui.gameSettingsGui.show()
		ui.gameTabGui.show()
	}
}

resetDefaults(*) {
	iniWrite(true,cfg.file,"Game","ResetFlag")
	reload()
}

checkResetFlag(*) {
	if iniRead(cfg.file,"Game","resetFlag",false) {
		iniWrite(false,cfg.file,"Game","ResetFlag")
		if !dirExist(installDir "/backups")
			dirCreate(installDir "/backups")
		if fileExist(cfg.file)
			fileMove(cfg.file,cfg.file "-" formatTime("T12","yyyyMMddhhmmss"))
		reload
	}
}

guiHide(*) {
	ui.mainGui.hide()
	ui.gameSettingsGui.hide()
	ui.gameTabGui.hide()
}

initTrayMenu(*) {
	A_TrayMenu.Delete
	A_TrayMenu.Add
	A_TrayMenu.Add("Show Window", restoreWin)
	A_TrayMenu.Add("Hide Window", guiHide)
	A_TrayMenu.Add()
	A_TrayMenu.Add("Reset Window Position", ResetWindowPosition)
	A_TrayMenu.Add("Restore Defaults", resetDefaults)
	A_TrayMenu.Add()
	A_TrayMenu.Add("Exit App"
	, KillMe)
	A_TrayMenu.Default := "Show Window"
	Try
		installLog("Tray Initialized")
}

cfgLoad(&cfg, &ui) {
	global
	checkResetFlag()
	cfg.dbFileName := A_ScriptDir . "\dapp.DB"
	data.queryResult		:= array()
	ui.guiH					:= 220  	;430 for Console Mode

	ui.incursionNoticeHwnd	:= ""

	ui.gameWindowsList 		:= array()
	cfg.gameWindowsList 	:= array()
	ui.d2FlyEnabled			:= true
	ui.d2AlwaysSprintPaused := false
	ui.d2IsSprinting		:= false
	ui.d2IsSliding			:= false
	ui.d2IsReloading		:= false

	ui.autoClickerEnabled 	:= false
	ui.previousTab			:= ""
	ui.activeTab			:= ""
	ui.colorChanged 		:= false 

	ui.helpActive			:= false

	ui.themeResetScheduled 	:= false
	ui.pauseAlwaysRun		:= false
	ui.inGameChat			:= false
	ui.reloading			:= false

	ui.profileList				:= array()
	ui.profileListStr			:= ""
	ui.waitingForPrompt			:= true
	ui.notifyResponse			:= false
	ui.fastShutdown				:= false
	ui.wizPanelGuids:=array()
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
	cfg.gameTabList			:= strSplit(iniRead(cfg.file,"Game","gameTabList"," Gameplay  , Vault Cleaner ,InfoGFX"),",")
	cfg.gameList				:= StrSplit(IniRead(cfg.file,"Game","GameList","Roblox,Rocket League"),",")
	cfg.mainTabList				:= strSplit(IniRead(cfg.file,"Interface","MainTabList","1_GAME,2_SETUP"),",")
	cfg.mainGui					:= IniRead(cfg.file,"System","MainGui","MainGui")
	cfg.autoStartEnabled 		:= iniRead(cfg.file,"System","AutoStartEnabled",false)
	cfg.confirmExitEnabled		:= iniRead(cfg.file,"System","ConfirmExit",false)
	cfg.excludedApps			:= IniRead(cfg.file,"System","ExcludedApps","Windows10Universal.exe,explorer.exe,RobloxPlayerInstaller.exe,RobloxPlayerLauncher.exe,Chrome.exe,msedge.exe")
	cfg.MainGui					:= IniRead(cfg.file,"System","MainGui","MainGui")
	cfg.MainScriptName			:= IniRead(cfg.file,"System","MainScriptName", "dapp")
	cfg.debugEnabled			:= IniRead(cfg.file,"System","DebugEnabled",false)
	cfg.ToolTipsEnabled 		:= IniRead(cfg.file,"System","ToolTipsEnabled",true)
	cfg.monitorRes				:= IniRead(cfg.file,"System","MonitorResolution","Auto")
	cfg.disabledTabs 			:= iniRead(cfg.file,"System","DisabledTabs","Audio,Editor")
	cfg.listDataFile			:= iniRead(cfg.file,"System","ListDataFile","./listData.ini")
	cfg.toggleOn				:= IniRead(cfg.file,"Interface","ToggleOnImage","./Img/toggle_on.png")
	cfg.toggleOff				:= IniRead(cfg.file,"Interface","ToggleOffImage","./Img/toggle_off.png")
	cfg.activeMainTab			:= IniRead(cfg.file,"Interface","activeMainTab",1)
	cfg.activeGameTab  			:= IniRead(cfg.file,"Interface","ActiveGameTab",1)
	cfg.AlwaysOnTopEnabled		:= IniRead(cfg.file,"Interface","AlwaysOnTopEnabled",true)
	cfg.AnimationsEnabled		:= IniRead(cfg.file,"Interface","AnimationsEnabled",true)
	cfg.ColorPickerEnabled 		:= IniRead(cfg.file,"Interface","ColorPickerEnabled",true)
	cfg.GuiX 					:= IniRead(cfg.file,"Interface","GuiX",200)
	cfg.GuiY 					:= IniRead(cfg.file,"Interface","GuiY",200)
	cfg.GuiW					:= IniRead(cfg.file,"Interface","GuiW",545)
	cfg.GuiH					:= IniRead(cfg.file,"Interface","GuiH",210)
	cfg.pushNotificationsEnabled := iniRead(cfg.file,"Toggles","PushNotificationsEnabled",false)
	cfg.displaySizeAuto			:= iniRead(cfg.file,"Game","DisplaySizeAuto",true)
	cfg.AutoDetectGame			:= IniRead(cfg.file,"Game","AutoDetectGame",true)
	cfg.excludedProcesses		:= IniRead(cfg.file,"Game","ExcludedProcesses",true)
	cfg.game					:= IniRead(cfg.file,"Game","Game","2")
	cfg.AutoClickerSpeed 		:= IniRead(cfg.file,"AFK","AutoClickerSpeed",50)
	cfg.Mode					:= IniRead(cfg.file,"audio","Mode","1")
	cfg.Theme					:= IniRead(cfg.file,"Interface","Theme","Alien")
	cfg.ThemeList				:= StrSplit(IniRead(cfg.themeFile,"Interface","ThemeList","Light,Dark,Alien,Modern Class,Militarized,Ocean,Neon"),",")
	cfg.baseColor	:= IniRead(cfg.themeFile,cfg.Theme,"baseColor","414141")
	cfg.FontColor1			:= IniRead(cfg.themeFile,cfg.Theme,"FontColor1","1FFFF0")
	cfg.FontColor2			:= IniRead(cfg.themeFile,cfg.Theme,"FontColor2","FBD58E")
	cfg.LabelColor1			:= IniRead(cfg.themeFile,cfg.Theme,"LabelColor1","1FFFF0")
	cfg.fontColor3			:= IniRead(cfg.themeFile,cfg.Theme,"fontColor3","FBD58E")
	cfg.titleFontColor		:= IniRead(cfg.themeFile,cfg.Theme,"titleFontColor","C0C0C0")
	cfg.DisabledColor		:= IniRead(cfg.themeFile,cfg.Theme,"DisabledColor","FFFFFF")
	cfg.TrimColor2			:= IniRead(cfg.themeFile,cfg.Theme,"TrimColor2","C0C0C0")
	cfg.TrimColor1			:= IniRead(cfg.themeFile,cfg.Theme,"TrimColor1","FFFFFF")
	cfg.OutlineColor1	:= IniRead(cfg.themeFile,cfg.Theme,"OutlineColor1","888888")
	cfg.OutlineColor2	:= IniRead(cfg.themeFile,cfg.Theme,"OutlineColor2","333333")
	cfg.TabColor2		:= IniRead(cfg.themeFile,cfg.Theme,"TabColor2","204040")
	cfg.TabColor3		:= IniRead(cfg.themeFile,cfg.Theme,"TabColor3","804001")
	cfg.titleBgColor		:= IniRead(cfg.themeFile,cfg.Theme,"titleBgColor","204040")
	cfg.TileColor		:= IniRead(cfg.themeFile,cfg.Theme,"TileColor","804001")
	cfg.tabColor4		:= IniRead(cfg.themeFile,cfg.Theme,"tabColor4","292929")
	cfg.AuxColor1		:= IniRead(cfg.themeFile,cfg.Theme,"AuxColor1","292929")
	cfg.TabColor1		:= IniRead(cfg.themeFile,cfg.Theme,"TabColor1","212121")
	cfg.AlertColor	:= IniRead(cfg.themeFile,cfg.Theme,"AlertColor","3C3C3C")
	cfg.OnColor		:= IniRead(cfg.themeFile,cfg.Theme,"OnColor","FF01FF")
	cfg.OffColor	:= IniRead(cfg.themeFile,cfg.Theme,"OffColor","1FFFF0")
	cfg.titlebarImage		:= iniRead(cfg.themeFile,cfg.Theme,"ThemeTitlebarImage","./img/dapp_titlebar.png")
	cfg.holdToCrouchEnabled 	:= IniRead(cfg.file,"game","HoldToCrouch",true)
	cfg.dappPauseKey			:= iniRead(cfg.file,"Game","dappPauseKey","Pause")
	cfg.dappPaused				:= iniRead(cfg.file,"Game","dappPaused",false)
	cfg.d2AlwaysRunEnabled		:= iniRead(cfg.file,"Game","d2AlwaysRunEnabled",false)
	cfg.dappSwordFlyKey		:= iniRead(cfg.file,"Game","dappSwordFlyKey","t")
	cfg.dappLoadoutKey			:= IniRead(cfg.file,"Game","dappLoadoutKey","[")
	cfg.dappLoadoutMultiplier	:= iniRead(cfg.file,"Game","dappLoadoutMultiplier",1)
	cfg.dappToggleSprintKey	:= IniRead(cfg.file,"Game","dappToggleSprintKey","capslock")
	cfg.dappReloadKey			:= IniRead(cfg.file,"Game","dappReloadKey","r")
	cfg.dappHoldToCrouchKey	:= IniRead(cfg.file,"Game","dappHoldToCrouchKey","lshift")
	cfg.d2GameHoldToCrouchKey	:= iniRead(cfg.file,"Game","d2GameHoldToCrouchKey","c")
	cfg.d2GameToggleSprintKey	:= IniRead(cfg.file,"Game","d2GameToggleSprintKey","capslock")
	cfg.d2GameReloadKey			:= IniRead(cfg.file,"Game","d2GameReloadKey","r")
	cfg.d2GameGrenadeKey		:= IniRead(cfg.file,"Game","d2GameGrenadeKey","[")
	cfg.d2GameSuperKey			:= IniRead(cfg.file,"Game","d2GameSuperKey","\")
	cfg.d2CharacterClass		:= iniRead(cfg.file,"Game","d2CharacterClass","1")
	cfg.d2AutoGameConfigEnabled := iniRead(cfg.file,"Game","d2AutoGameConfigEnabled",true)
	cfg.titleBarImage			:= iniRead(cfg.themefile,cfg.theme,"TitlebarImage","./img/dapp_titlebar.png")
	cfg.CurveAmount				:= iniRead(cfg.themefile,cfg.theme,"CurveAmount",5)
	runWait("./redist/mouseSC_x64.exe /verticalScroll:1",,"hide")
}

initProgress(progressAmount:=5,*) {
		ui.loadingProgress.value += progressAmount
}

WriteConfig() {
	Global
	tmpGameList := ""
	
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
	IniWrite(arr2str(cfg.gameTabList),cfg.file,"Game","gameTabList")
	IniWrite(arr2str(cfg.gameList),cfg.file,"Game","GameList")



	iniWrite(cfg.pushNotificationsEnabled,cfg.file,"Toggles","PushNotificationsEnabled")
	IniWrite(cfg.theme,cfg.file,"Interface","Theme")
	IniWrite(arr2str(cfg.themeList),cfg.themeFile,"Interface","ThemeList")
	iniWrite(cfg.curveAmount,cfg.themeFile,cfg.theme,"CurveAmount")
	IniWrite(cfg.titleFontColor,cfg.themeFile,"Custom","titleFontColor")
	IniWrite(cfg.DisabledColor,cfg.themeFile,"Custom","DisabledColor")
	IniWrite(cfg.TrimColor2,cfg.themeFile,"Custom","TrimColor2")
	IniWrite(cfg.TrimColor1,cfg.themeFile,"Custom","TrimColor1")
	IniWrite(cfg.OutlineColor2,cfg.themeFile,"Custom","OutlineColor2")
	IniWrite(cfg.OutlineColor1,cfg.themeFile,"Custom","OutlineColor1")
	IniWrite(cfg.baseColor,cfg.themeFile,"Custom","baseColor")
	IniWrite(cfg.FontColor1,cfg.themeFile,"Custom","FontColor1")
	IniWrite(cfg.FontColor2,cfg.themeFile,"Custom","FontColor2")
	IniWrite(cfg.LabelColor1,cfg.themeFile,"Custom","LabelColor1")
	IniWrite(cfg.fontColor3,cfg.themeFile,"Custom","fontColor3")
	IniWrite(cfg.TabColor2,cfg.themeFile,"Custom","TabColor2")
	IniWrite(cfg.titleBgColor,cfg.themeFile,"Custom","titleBgColor")
	IniWrite(cfg.TabColor1,cfg.themeFile,"Custom","TabColor1")
	IniWrite(cfg.TileColor,cfg.themeFile,"Custom","TileColor")
	IniWrite(cfg.tabColor4,cfg.themeFile,"Custom","tabColor4")
	IniWrite(cfg.AuxColor1,cfg.themeFile,"Custom","AuxColor1")
	IniWrite(cfg.TabColor1,cfg.themeFile,"Custom","TabColor1")
	IniWrite(cfg.OnColor,cfg.themeFile,"Custom","OnColor")
	IniWrite(cfg.OffColor,cfg.themeFile,"Custom","OffColor")
	IniWrite(cfg.AlertColor,cfg.themeFile,"Custom","AlertColor")
	iniWrite(cfg.titlebarImage,cfg.themeFile,"Custom","ThemeTitlebarImage")
	IniWrite(ui.mainGuiTabs.value,cfg.file,"Interface","ActiveMainTab")
	iniWrite(cfg.dappPauseKey,cfg.file,"Game","dappPauseKey")
	iniWrite(cfg.dappPaused,cfg.file,"Game","dappPaused")
	IniWrite(cfg.dappHoldToCrouchKey,cfg.file,"Game","dappHoldToCrouchKey")
	IniWrite(cfg.dappLoadoutKey,cfg.file,"Game","dappLoadoutKey")
	iniWrite(cfg.dappSwordFlyKey,cfg.file,"Game","dappSwordFlyKey")
	iniWrite(cfg.dappLoadoutMultiplier,cfg.file,"Game","dappLoadoutMultiplier")
	IniWrite(cfg.dappToggleSprintKey,cfg.file,"Game","dappToggleSprintKey")
	IniWrite(cfg.dappReloadKey,cfg.file,"Game","dappReloadKey")
	IniWrite(cfg.d2GameHoldToCrouchKey,cfg.file,"Game","d2GameHoldToCrouchKey")
	IniWrite(cfg.d2GameToggleSprintKey,cfg.file,"Game","d2GameToggleSprintKey")
	IniWrite(cfg.d2GameReloadKey,cfg.file,"Game","d2GameReloadKey")
	IniWrite(cfg.d2GameGrenadeKey,cfg.file,"Game","d2GameGrenadeKey")
	IniWrite(cfg.d2GameSuperKey,cfg.file,"Game","d2GameSuperKey")
	iniWrite(cfg.d2CharacterClass,cfg.file,"Game","d2CharacterClass")
	iniWrite(cfg.d2AutoGameConfigEnabled,cfg.file,"Game","d2AutoGameConfigEnabled")
		
	iniWrite(arr2str(cfg.d2LoadoutCoords%a_screenWidth%x%a_screenHeight%),cfg.file,"Game","d2LoadoutCoords" a_screenWidth "x" a_screenHeight)		

	IniWrite(arr2str(cfg.mainTabList),cfg.file,"Interface","MainTabList")
;msgBox(cfg.guiX "`t" cfg.guiY)
	
	winGetPos(&tmpX,&tmpY,,,ui.mainGui)
	IniWrite(tmpX,cfg.file,"Interface","GuiX")
	IniWrite(tmpY,cfg.file,"Interface","GuiY")
	IniWrite(cfg.toggleOn,cfg.file,"Interface","ToggleOnImage")
	IniWrite(cfg.toggleOff,cfg.file,"Interface","ToggleOffImage")
	IniWrite(cfg.AlwaysOnTopEnabled,cfg.file,"Interface","AlwaysOnTopEnabled")
	IniWrite(cfg.ColorPickerEnabled,cfg.file,"Interface","ColorPickerEnabled")
	iniWrite(cfg.autoStartEnabled,cfg.file,"System","AutoStartEnabled")
	IniWrite(ui.AutoClickerSpeedSlider.Value,cfg.file,"AFK","AutoClickerSpeed")
	ui.MainGui.Destroy()
}

adjustPos(*) {
	; cfg.guiX := iniRead(cfg.file,"Interface","GuiX",200)
	; cfg.guiY := iniRead(cfg.file,"Interface","GuiY",200)
	; lowestHorz := 0
	; highestHorz := 0
	; lowestVert :=0
	; highestVert := 0
	; loop monitorGetCount() {
		; monitorGet(a_index,&ml,&mt,&mr,&mb)
		; if lowestHorz > ml
			; lowestHorz := ml
		; if highestHorz < mr
			; highestHorz := mr
		; if lowestVert > mt
			; lowestVert := mt
		; if highestVert < mb
			; highestVert := mb
	; }		
	; if (cfg.GuiX < lowestHorz) || (cfg.guiX+550 > highestHorz) {
		; cfg.GuiX := 200
		; cfg.GuiY := 200
	; }
	; if (cfg.GuiY < lowestVert) || (cfg.guiY+220 > highestVert) {
		; cfg.GuiX := 200
		; cfg.GuiY := 200
	; }
	; iniWrite(cfg.GuiX,cfg.file,"Interface","GuiX")
	; iniWrite(cfg.GuiY,cfg.file,"Interface","GuiY")
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
	ui.notifyGui.BackColor := cfg.TabColor2  ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.setFont("q5 s16")  ; Set a large font size (32-point).
	ui.notifyMsg := ui.notifyGui.AddText("c" cfg.FontColor1 " " Alignment " BackgroundTrans",Msg)  ; XX & YY serve to 00auto-size the window.
	ui.notifyGui.AddText("xs hidden")
	WinSetTransparent(0,ui.notifyGui)
	ui.notifyGui.Show("NoActivate Autosize")  ; NoActivate avoids deactivating the currently active window.
	ui.notifyGui.GetPos(&x,&y,&w,&h)
	winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui.hwnd)
	ui.notifyGui.Show("x" (GuiX+(GuiW/2)-(w/2)) " y" GuiY+(100-(h/2)) " NoActivate")
	drawOutlineNotifyGui(1,1,w,h,cfg.OutlineColor2,cfg.OutlineColor1,1)
	drawOutlineNotifyGui(2,2,w-2,h-2,cfg.titleFontColor,cfg.titleFontColor,1)
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
	ui.notifyGui.Opt(" -Caption +ToolWindow alwaysOnTop")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := cfg.TabColor2  ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.setFont("q5 s16")  ; Set a large font size (32-point).
	ui.notifyGui.addText("x3 y3 w494 h212 background" cfg.TrimColor1)
	ui.notifyGui.addText("x5 y5 w490 h208 background" cfg.TabColor1)
	
	ui.notifyGui.AddText("x10 y10 w480 h198 c" cfg.FontColor1 " " Alignment " BackgroundTrans",NotifyMsg)  ; XX & YY serve to 00auto-size the window.

	ui.notifyGui.AddText("xs hidden")
	ui.notifyGui.getPos(&x,&y,&w,&h)
	WinSetTransparent(0,ui.notifyGui)
	winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui.hwnd)
	ui.notifyGui.Show("x" GuiX+34 " y" GuiY " w" guiW-68 " h" guiH+2 " noActivate")
	
	;drawOutline(ui.notifyGUi,2,2,w-2,h-2,cfg.titleFontColor,cfg.titleFontColor,1)
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
	(cfg.alwaysOnTopEnabled) ? ui.notifyGui.opt("+alwaysOnTop") : 0
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
		ui.notifyGui.destroy()
	ui.Transparent := 0
}
	setPos(*) {
		winGetPos(&tmpX,&tmpY,&tmpW,&tmpH,ui.mainGui)
		cfg.guiX:=tmpX
		cfg.guiY:=tmpY
		iniWrite(cfg.guiX,cfg.file,"Interface","GuiX")
		iniWrite(cfg.guiY,cfg.file,"Interface","GuiY")
		;msgBox(cfg.guiX "`t" cfg.guiY)
	}	
	
loadScreen(visible := true,NotifyMsg := "dapp Loading",Duration := 10) {
	if (visible) {
		Transparent := 0
		ui.loadScreenGui			:= Gui()
		ui.loadScreenGui.Title 		:= "dapp Loading"
		ui.loadScreenGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
		ui.loadScreenGui.BackColor := cfg.tabColor1 ; Can be any RGB color (it will be made transparent below).
		ui.loadScreenGui.setFont("q5 s22")  ; Set a large font size (32-point).
		ui.loadScreenGui.addText("section x1 y1 w238 h92 background" cfg.tilecolor)
		ui.loadScreenGui.addPicture("y1 x2 w237 h92 backgroundTrans","./img/dapp_logo.png")
		ui.loadingProgress := ui.loadScreenGui.addProgress("smooth x2 y94 w236 h21 c" cfg.tabColor2 " background" cfg.tabColor1)
		ui.loadScreenGui.AddText("xs hidden")
		cfg.guiX := iniRead(cfg.file,"Interface","GuiX",200)
		cfg.guiY := iniRead(cfg.file,"Interface","GuiY",200)
		winGetPos(&x,&y,&w,&h,ui.loadScreenGui.hwnd)
		winSetTransparent(0,ui.loadScreenGui)
		ui.loadScreenGui.show("w240 h116 x" (cfg.guiX+100)-(w/2) " y" (cfg.guiY+50)-(h/2))
		while transparent < 245 {
			winSetTransparent(transparent,ui.loadScreenGui.hwnd)
			transparent += 8
			sleep(10)
		} 
		winSetTransparent("Off",ui.loadScreenGui.hwnd)
	} else {
		transparent := 255
		while transparent > 10 {
			winSetTransparent(transparent,ui.loadScreenGui.hwnd)
			transparent -= 10
			sleep(20)
		}
		ui.loadScreenGui.hide()
		ui.loadScreenGui.destroy()
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
	ui.MainGui.Move(200,200,,)
	cfg.GuiX := 200
	cfg.GuiY := 200
	iniWrite(cfg.GuiX,cfg.file,"interface","GuiX")
	iniWrite(cfg.GuiY,cfg.file,"interface","GuiY")
	ui.mainGui.show()
	guiVis(ui.mainGui,true)
	if cfg.activeMainTab==1 {
		ui.gameSettingsGui.show()
		guiVis(ui.gameSettingsGui,true)
		ui.gameTabGui.show()
		guiVis(ui.gameTabGui,true)
	}
	tabsChanged()
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
	;setCapslockState(false)
	
}

appChangeTrans(transLevel) {
	try
		winSetTransparent(transLevel,ui.dockBarGui.hwnd)
}

