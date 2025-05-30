 #SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	; ExitApp
	Return
}




{ ;Primary Action Interface Functions
	toggleAutoFire(*) {
		try {
			WinNumber := GetWinNumber()
		} catch {
			debugLog("Couldn't get Window Number")
		}
		
		if (WinNumber) 
		{
			; (ui.AutoFire%WinNumber%Enabled := !ui.AutoFire%WinNumber%Enabled)
			
			; if (ui.AutoFire%WinNumber%Enabled)
			; {
				; NotifyOSD("Win" WinNumber ": AutoFire Started",10)
			; }
			
		AutoFire(WinNumber)
		}
		debugLog("AutoFire Win" WinNumber)
	}

	toggleAutoClicker(*) {

		ui.AutoClickerEnabled := !ui.AutoClickerEnabled

		if (ui.AutoClickerEnabled)
		{
			ui.buttonAutoClicker.Opt("Background" cfg.ThemeButtonOnColor)
			ui.buttonAutoClicker.Value := "./Img/button_autoClicker_on.png"
		}
		
		While (ui.AutoClickerEnabled)
		{
			if (A_TimeIdlePhysical > 1500 && A_TimeIdleMouse > 1500)
			{
				Send("{LButton}")
				Sleep(cfg.AutoClickerSpeed*7.8125)
		}
			} 	
		ui.buttonAutoClicker.Opt("Background" cfg.ThemeButtonReadyColor)
		ui.buttonAutoClicker.Value := "./Img/button_autoClicker_ready.png"
	}


	toggleAntiIdle1(*) {
		(ui.AntiIdle1_enabled := !ui.AntiIdle1_enabled) ? AntiIdle1On() : AntiIdle1Off()
		
		antiIdle1On() {
			;SetTimer(AntiIdle,1080000)
			;SetTimer(UpdateTimer,4000)
			SetTimer () => antiIdle(1),120000
			SetTimer () => updateTimer(),400			
			SetTimer () => updateTimerWin1(),400			
			SetTimer () => updateTimerWin2(),400			
			ui.afkProgress.value := 0
			ui.OpsProgress1.value := 0
			;ui.buttonAntiIdle1.value := "./Img/button_on.png"
			ui.buttonTower.OnEvent("Click",ToggleTower,False)
			ui.AfkStatus1.value := "./Img/label_anti_idle_timer.png"
			ui.OpsStatus1.value := "./Img/label_anti_idle_timer.png"
			ui.afkStatus1.opt("Background" cfg.ThemeButtonOnColor)
			ui.opsStatus1.opt("Background" cfg.ThemeButtonOnColor)
			ui.OpsAntiIdle1Button.Value := "./Img/button_antiIdle_on.png"
			ui.OpsAntiIdle1Button.Opt("Background" cfg.ThemeButtonOnColor)
			ui.buttonAntiIdle1.Value := "./Img/button_antiIdle_on.png"
			ui.buttonAntiIdle1.Opt("Background" cfg.ThemeButtonOnColor)
			ui.buttonTower.ToolTip := "Tower timer disabled while AntiIdle is running."
			AntiIdle(1)
		}

antiIdle1Off() {
			SetTimer(AntiIdle,0)
			SetTimer(UpdateTimer,0)
			SetTimer2(UpdateTimer,0)
			SetTimer1(UpdateTimer,0)
			ui.buttonTower.ToolTip := "Starts Infinte Tower"
			ui.AfkStatus1.value := "./Img/label_timer_off.png"
			ui.OpsStatus1.value := "./Img/label_timer_off.png"
			ui.OpsAntiIdle1Button.Opt("Background" cfg.ThemeButtonReadyColor)
			ui.OpsAntiIdle1Button.Redraw()
			ui.buttonAntiIdle1.Value := "./Img/button_antiIdle_ready.png"
			ui.buttonAntiIdle1.Opt("Background" cfg.ThemeButtonReadyColor)
			ui.buttonAntiIdle1.Redraw()
			ui.buttonTower.OnEvent("Click",ToggleTower)
			ui.afkProgress.value := 0
			ui.opsProgress1.value := 0
		}
	}	

	toggleAntiIdle2(*) {
		(ui.AntiIdle2_enabled := !ui.AntiIdle2_enabled) ? AntiIdle2On() : AntiIdle2Off()
			debugLog("win2 isn't prepared for another afk step")

		antiIdle2On() {
			;SetTimer(AntiIdle2,1080000)
			;SetTimer(UpdateTimer,4000)
			SetTimer () => antiIdle(2),120000
			SetTimer () => updateTimer(),400
			ui.afkProgress.value := 0
			ui.OpsProgress2.value := 0
			;ui.buttonAntiIdle2.value := "./Img/button_on.png"
			ui.buttonTower.OnEvent("Click",ToggleTower,False)
			ui.AfkStatus2.value := "./Img/label_anti_idle_timer.png"
			
			ui.OpsStatus2.value := "./Img/label_anti_idle_timer.png"
			ui.afkStatus2.opt("Background" cfg.ThemeButtonOnColor)
			ui.OpsStatus2.opt("Background" cfg.ThemeButtonOnColor)
			ui.OpsAntiIdle2Button.Value := "./Img/button_antiIdle_on.png"
			ui.OpsAntiIdle2Button.Opt("Background" cfg.ThemeButtonOnColor)
			ui.OpsAntiIdle2Button.Redraw()
			ui.buttonAntiIdle2.Value := "./Img/button_antiIdle_on.png"
			ui.buttonAntiIdle2.Opt("Background" cfg.ThemeButtonOnColor)
			ui.buttonAntiIdle2.Redraw()
			ui.buttonTower.ToolTip := "Tower timer disabled while AntiIdle is running."
			AntiIdle(2)
		}		

		antiIdle2Off() {
			SetTimer(AntiIdle,0)
			SetTimer(UpdateTimer,0)
			ui.buttonTower.ToolTip := "Starts Infinte Tower"
			ui.AfkStatus1.value := "./Img/label_timer_off.png"
			ui.OpsStatus1.value := "./Img/label_timer_off.png"
			ui.OpsAntiIdle1Button.Opt("Background" cfg.ThemeButtonReadyColor)
			ui.OpsAntiIdle1Button.Redraw()
			ui.buttonAntiIdle1.Value := "./Img/button_antiIdle_ready.png"
			ui.buttonAntiIdle1.Opt("Background" cfg.ThemeButtonReadyColor)
			ui.buttonAntiIdle1.Redraw()
			ui.buttonTower.OnEvent("Click",ToggleTower)
			ui.afkProgress.value := 0
			ui.Opsprogress.value := 0
		}
	}	

	antiIdle(WinNumber := 0) {
		global
		try {
			ui.CurrWin := WinExist("A")
		}
		
		CoordMode("Mouse","Client")
		MouseGetPos(&mouseX,&mouseY)
		
		Loop 2 {
			if (winExist("ahk_id " ui.win%a_index%hwnd)) && (cfg.Win%A_Index%Enabled) && ((WinNumber == A_Index) || (WinNumber == 0)) {
				WinActivate("ahk_id " ui.Win%A_Index%Hwnd)
				autoFire()
				
				if (cfg.SilentIdleEnabled)
				{
					WinMinimize("ahk_id " ui.Win%A_Index%Hwnd)
				}
			}
		}
		
		if winExist("ahk_id " ui.currWin)
			WinActivate("ahk_id " ui.CurrWin)
		Sleep(150)
		MouseMove(mouseX,mouseY)
	}
	

	toggleAntiIdleBoth(*) {
		(ui.AntiIdle_enabled := !ui.AntiIdle_enabled) ? AntiIdleBothOn() : AntiIdleBothOff()
	
		antiIdleBothOff() {
			SetTimer(AntiIdle,0)
			SetTimer(UpdateTimer,0)
			ui.buttonTower.ToolTip := "Starts Infinte Tower"
			ui.AfkStatus1.value := "./Img/label_timer_off.png"
			ui.OpsStatus1.value := "./Img/label_timer_off.png"
			ui.OpsAntiIdle1Button.Opt("Background" cfg.ThemeButtonReadyColor)
			ui.OpsAntiIdle1Button.Redraw()
			ui.buttonAntiIdle1.Value := "./Img/button_antiIdle_ready.png"
			ui.buttonAntiIdle1.Opt("Background" cfg.ThemeButtonReadyColor)
			ui.buttonAntiIdle1.Redraw()
			ui.buttonTower.OnEvent("Click",ToggleTower)
			ui.afkProgress.value := 0
			ui.Opsprogress1.value := 0
			ui.opsProgress2.vaule := 0
		}

		antiIdleBothOn() {
			;SetTimer(AntiIdle,1080000)
			;SetTimer(UpdateTimer,4000)
			SetTimer(AntiIdle,120000)
			SetTimer(UpdateTimer,400)
			ui.afkProgress.value := 0
			ui.OpsProgress1.value := 0
			ui.OpsProgress2.value := 0
			;ui.buttonAntiIdle1.value := "./Img/button_on.png"
			ui.AfkStatus1.value := "./Img/label_anti_idle_timer.png"
			ui.OpsStatus1.value := "./Img/label_anti_idle_timer.png"
			ui.OpsStatus2.value := "./Img/label_anti_idle_timer.png"
			ui.OpsAntiIdle1Button.Value := "./Img/button_antiIdle_on.png"
			ui.OpsAntiIdle1Button.Opt("Background" cfg.ThemeButtonOnColor)
			ui.OpsAntiIdle1Button.Redraw()
			ui.buttonAntiIdle1.Value := "./Img/button_antiIdle_on.png"
			ui.buttonAntiIdle1.Opt("Background" cfg.ThemeButtonOnColor)
			ui.buttonAntiIdle1.Redraw()
			ui.buttonTower.ToolTip := "Tower timer disabled while AntiIdle is running."
			;ui.buttonAntiIdle2.value := "./Img/button_on.png"
			ui.buttonTower.OnEvent("Click",ToggleTower,False)
			ui.AfkStatus1.value := "./Img/label_anti_idle_timer.png"
			ui.OpsStatus1.value := "./Img/label_anti_idle_timer.png"
			ui.OpsStatus2.value := "./Img/label_anti_idle_timer.png"
			ui.OpsAntiIdle2Button.Value := "./Img/button_antiIdle_on.png"
			ui.OpsAntiIdle2Button.Opt("Background" cfg.ThemeButtonOnColor)
			ui.OpsAntiIdle2Button.Redraw()
			ui.buttonTower.ToolTip := "Tower timer disabled while AntiIdle is running."
			AntiIdle(0)
		}
	}



} ;End Primary Action Interface Functions

 ;Primary AFK Action Function

toggleTower(*) {
	global
	if (ui.gameDDL.text != "World//Zero") {
		notifyOSD("You must be playing World//Zero`nto use this feature",2000,"Center")
		return
	}
	((!cfg.win1disabled && WinExist("ahk_id " ui.win1Hwnd)) 
	|| (!cfg.win2disabled && WinExist("ahk_id " ui.win2Hwnd)) 
	|| (ui.towerEnabled))
		? (ui.towerEnabled := ! ui.towerEnabled)
			? ((cfg.celestialTowerEnabled)
				? (
					ui.afkStatus1.value 	:= "./Img/label_celestial_tower.png"
					,ui.opsStatus1.value 	:= "./Img/label_celestial_tower.png"
					,ui.opsStatus2.value 	:= "./Img/label_celestial_tower.png"
					,ui.opsTowerButton.Opt("background" cfg.themeButtonOnColor)
					,ui.opsTowerButton.value := "./img/button_tower_on.png"
					,ui.buttonTower.opt("Background" cfg.ThemeButtonOnColor)
					,ui.buttonTower.value := "./img/button_tower_on.png"
					,(cfg.topDockEnabled) 
						? (ui.dockBarTowerButton) 
							? ui.dockBarTowerButton.opt("background" cfg.themeButtonOnColor)
							: 0 
						: 0
					,(cfg.topDockEnabled) 
						? (ui.dockBarTowerbutton) 
							? ui.dockBarTowerButton.value := "./img/button_tower_on.png" 
							: 0
						: 0 
					,restartTower()
				) : (
					ui.afkStatus1.value		:= "./Img/label_infinite_tower.png"
					,ui.opsStatus1.value 	:= "./Img/label_infinite_tower.png"
					,ui.opsStatus2.value 	:= "./Img/label_infinite_tower.png"
					,ui.opsTowerButton.Opt("background" cfg.themeButtonOnColor)
					,ui.opsTowerButton.value := "./img/button_tower_on.png"
					,ui.buttonTower.opt("background" cfg.themeButtonOnColor)
					,ui.buttonTower.value		:= "./img/button_tower_on.png"
					,ui.opsTowerButton.opt("Background" cfg.ThemeButtonOnColor)
					,ui.buttonTower.Opt("Background" cfg.ThemeButtonOnColor)
					,(cfg.topDockEnabled) 
						? (ui.dockBarTowerButton)
							? ui.dockBarTowerButton.opt("background" cfg.themeButtonOnColor) 
							: 0
						: 0
					,(cfg.topDockEnabled) 
						? (ui.dockBarTowerbutton)
							? ui.dockBarTowerButton.value := "./img/button_tower_on.png" 
							: 0
						: 0
					,restartTower()
				)			
			) : (
				ui.afkProgress.value 		:= 0
				,ui.opsProgress1.value 		:= 0
				,ui.opsProgress2.value 		:= 0
				,ui.opsTowerButton.opt("background" cfg.themeButtonReadyColor)
				,ui.buttonTower.opt("background" cfg.themeButtonReadyColor)
				,ui.afkStatus1.value 		:= "./Img/label_timer_off.png"
				,ui.opsStatus1.value 		:= "./Img/label_timer_off.png"
				,ui.opsStatus2.value 		:= "./Img/label_timer_off.png"
				,ui.opsTowerButton.Value	:= "./img/button_tower_ready.png"
				,ui.buttonTower.Value		:= "./img/button_tower_ready.png"
				,(cfg.topDockEnabled) ? ui.dockBarTowerButton.opt("background" cfg.themeButtonReadyColor) : 0
				,(cfg.topDockEnabled) ? ui.dockBarTowerButton.value := "./img/button_tower_ready.png" : 0
		) : (
			ui.afkProgress.value 		:= 0
			,ui.opsProgress1.value 		:= 0
			,ui.opsProgress2.value 		:= 0
			,ui.opsTowerButton.opt("background" cfg.themeButtonReadyColor)
			,ui.buttonTower.opt("background" cfg.themeButtonReadyColor)
			,ui.afkStatus1.value 		:= "./Img/label_timer_off.png"
			,ui.opsStatus1.value 		:= "./Img/label_timer_off.png"
			,ui.opsStatus2.value 		:= "./Img/label_timer_off.png"
			,ui.opsTowerButton.Value	:= "./img/button_tower_ready.png"
			,ui.buttonTower.Value		:= "./img/button_tower_ready.png"				
			,(cfg.topDockEnabled) 
				? (ui.dockBarTowerButton)
					? ui.dockBarTowerButton.opt("background" cfg.themeButtonReadyColor) 
					: 0
				: 0
			,(cfg.topDockEnabled) ? ui.dockBarTowerButton.value := "./img/button_tower_ready.png" : 0			
			,debugLog("AutoTower: Failed to start. No game windows found.")
			,notifyOSD("AutoTower Failed: No valid game windows found.",3000)
		)

}


restartTower(*) {
	global
	
	if (!cfg.win1disabled && WinExist("ahk_id " ui.win1Hwnd)) || (!cfg.win2disabled && !WinExist("ahk_id " ui.win2Hwnd)) {	
		stopAfk()
		ui.afkProgress.value := 0
		ui.opsProgress1.value := 0
		ui.opsProgress2.value := 0
		Loop 2
		{
			if (ui.win%A_Index%Enabled) && winExist(this_window := "ahk_id " ui.win%a_index%hwnd)
			{
				winActivate(this_window)
			
				CoordMode("Mouse","Client")
				WinGetPos(&WinX,&WinY,&WinW,&WinH,this_window)
				InfTowerButtonX := (WinW*.6)
				InfTowerButtonY := (WinH*.675)
				CelestialTowerX := (WinW*.5)
				CelestialTowerY := (WinH*.675)
				
				; StartButtonX 	:= (WinW/2)+240
				; StartButtonY 	:= (WinH/2)+130
							
				StartButtonX 	:= (WinW*.5)
				StartButtonY 	:= (WinH*.72)
				
				if (WinGetProcessName(this_window) == "ApplicationFrameHost.exe")
				{
					InfTowerButtonY += 35
					CelestialTowerY += 35
					StartButtonY 	+= 35
				}
			
				Sleep(250)
				Send("{V}")
				Sleep(1200)
				if (cfg.celestialTowerEnabled)
				{
					Mouse(CelestialTowerX,CelestialTowerY)
				} else {
					Mouse(InfTowerButtonX,InfTowerButtonY)
				}
				Sleep(1000)
				Mouse(StartButtonX,StartButtonY)
				Sleep(1500)
				Send("{V}")
				Sleep(1000)
			}
		}
	startAFK()
	} else {
		debugLog("AutoTower: Failed to start. No game windows found.")
		notifyOSD("AutoTower Failed: No valid game windows found.",3000)
		Return
	}
}

toggleAFK(*) {
	if (!cfg.win1disabled && WinExist("ahk_id " ui.win1Hwnd)) || (!cfg.win2disabled && !WinExist("ahk_id " ui.win2Hwnd)) {	
		(ui.afkEnabled := !ui.afkEnabled) ? StartAFK() : StopAFK()
	} else {
		debugLog("AFK Failed to start. No game windows found.")
		notifyOSD("AFK Failed: No valid game windows found.",3000)
		Return
	}
}


startAFK(*) {
	global
	ui.afkEnabled := true
	debugLog("Starting AFK")
	ui.OpsAfkButton.Opt("Background" cfg.ThemeButtonOnColor)
	ui.opsAfkButton.Value := "./Img/button_afk_on.png"
	ui.buttonStartAFK.Opt("Background" cfg.ThemeButtonOnColor)
	ui.buttonStartAfk.value := "./Img/button_afk_on.png"
	try {
		ui.dockBarAfkButton.Opt("Background" cfg.ThemeButtonOnColor)
		ui.dockBarAfkButton.value := "./Img/button_afk_on.png"
	} 	
	if ui.profileList[cfg.win1class] == "AFK: Pale Heart" {
		winActivate("ahk_exe destiny2.exe")
		sleep(300)
		startD2PhAfk()
		debugLog("Starting: Pale Heart AFK")
		return
	}
; ui.OpsAfkButton.Redraw()
	; ui.buttonStartAFK.Redraw()	
	setTimer(afkBeta,-100)
	; SetTimer(runAfkRoutine,4000)
	; runAfkRoutine()
}	

stopAFK(*) {
	ui.afkEnabled := false
	debugLog("Stopping AFK")
	; SetTimer(runAfkRoutine,0)
	ui.OpsAfkButton.Opt("Background" cfg.ThemeDisabledColor)
	ui.opsAfkButton.Value := "./img/button_afk_ready.png"
	ui.buttonStartAFK.Opt("Background" cfg.ThemeDisabledColor)
	ui.buttonStartAfk.value := "./img/button_afk_ready.png"
	try {
		ui.dockBarAfkButton.Opt("Background" cfg.ThemeButtonReadyColor)
		ui.dockBarAfkButton.value := "./img/button_afk_ready.png"
	}
	ui.OpsAfkButton.Redraw()
	ui.buttonStartAFK.Redraw()
	
	if ui.profileList[cfg.win1class] == "AFK: Pale Heart" {
		winActivate("ahk_exe destiny2.exe")
		sleep(300)
		stopD2PhAfk()
		send("{w up}")
		send("{d up}")
		send("{LButton up}")
		return
	}
	SendEvent("{LButton Up}")
	
	ui.Win1AfkIcon.value := "./Img/sleep_icon.png"
	ui.Win1AfkStatus.text := ""
	ui.Win2AfkIcon.value := "./Img/sleep_icon.png"
	ui.Win2AfkStatus.text := ""

	ui.opsWin1AfkIcon.value := "./Img/sleep_icon.png"
	ui.opsWin1AfkStatus.text := ""
	ui.opsWin2AfkIcon.value := "./Img/sleep_icon.png"
	ui.opsWin2AfkStatus.text := ""
}
	

runAfkRoutine(*) {
	afkStart("autoFireEnabled")
}

afkStart(autoFireEnabled := "") {
	global
	if !(ui.afkEnabled) 
		return
	
	stepCount :=  (ui.win1steps.length > ui.win2steps.length) ? ui.win1steps.length : ui.win2steps.length
	
	static win1stepNum := 0
	static win2stepNum := 0
	
	loop {
		if ui.win1steps.length < win1stepNum {
			win1stepNum := 0
		}
		
		if WinExist("ahk_id " ui.win1Hwnd) && (ui.afkEnabled) {	
			if (autoFireEnabled)
				attackWin(1,StrSplit(ui.win1steps[win1stepNum],',')[3])
			else {
				winActivate("ahk_id " ui.win1hwnd)
				send("{" strSplit(ui.win1steps[win1stepNum],',')[3] "}")
			}
			sleep(strSplit(ui.win1steps[win1stepNum],',')[4])
		} else {
			return 
		}
			
		if ui.win2steps.length < win2stepNum {
			win2steps.length := 0
		}
		
		if WinExist("ahk_id " ui.win2Hwnd) && (ui.afkEnabled) {
			if (autoFireEnabled)
				attackWin(2,strSplit(ui.win2steps[win2stepNum],',')[3])
			else {
				winActivate("ahk_id " ui.win2hwnd)
				send("{" strSplit(ui.win2steps[win2stepNum],',')[3] "}")
			}
			sleep(strSplit(ui.win2steps[win2stepNum],',')[4])
		} else {
			return
		}
	}	
}

autoFire(initWinNumber := GetWinNumber()) {
	if (initWinNumber == 0) {
		loopCount := 2
	} else {
		loopCount := 1
	}
	
	loop loopCount {
		if initWinNumber == 0
			winNumber := A_Index
		else
			winNumber := initWinNumber
			

			ui.autoFireWin%WinNumber%Button.Opt("Background" cfg.ThemeButtonOnColor)
			ui.autoFireWin%WinNumber%Button.Value := "./Img/button_autoFire" WinNumber "_on.png"

			SetTimer(ResetAutoFireStatus,-2500)
			CoordMode("Mouse","Client")
			WinGetPos(&WinX,&WinY,&WinW,&WinH,"ahk_id " ui.Win%WinNumber%Hwnd)
			MouseMove(WinW-50,WinH-120)
			MouseClick("Left",WinW-50,WinH-120)
			if winExist("ahk_id " ui.win%winNumber%hwnd)	
				if (WinGetProcessName("ahk_id " ui.Win%WinNumber%Hwnd) == "RobloxPlayerBeta.exe")
				{	
					MouseClick("Left",WinW-50,WinH-120)
					Sleep(250)
					Send("{LButton Down}")
					Sleep(250)
					Send("!{Tab}")
					Sleep(250)
					Send("{LButton Up}")
					Sleep(250)
					Send("!{Tab}")	
				} else {
					Sleep(250)
					Sleep(250)
					MouseClickDrag("Left",WinW-50,WinH-120,WinW+50,WinH-120,5)
				}
			if (winExist("ahk_id " ui.win%winNumber%hwnd))
				WinActivate("ahk_id " ui.Win%WinNumber%Hwnd)
		
	}
}
 ;End Primary AFK Action Functions

{ ;Primary Action Helper Functions
	attackWin(WinNumber,Command,duration := 150) {
		CoordMode("Mouse","Client")

		ui.Win%WinNumber%AfkStatus.SetFont("s14 c"  cfg.themeFont2Color,"Calibri")
		ui.Win%WinNumber%AfkIcon.value := "./Img/sleep_icon.png"
		ui.Win%WinNumber%AfkStatus.text := ""		
		ui.opsWin%WinNumber%AfkIcon.value := "./Img/sleep_icon.png"
		ui.opsWin%WinNumber%AfkStatus.text := ""

		if (A_TimeIdlePhysical > 2500 and A_TimeIdleMouse > 2500) 
		&& (ui.afkEnabled)
		&& !(cfg.win%winNumber%disabled)
		&& WinExist("ahk_id " ui.win%winNumber%hwnd) 		
		{
			ui.Win%WinNumber%AfkIcon.value 		:= "./Img/attack_icon.png"
			ui.dockBarWin%winNumber%Icon.Value	:= "./img/attack_icon.png"
			ui.dockBarWin%winNumber%cmd.text 	:= " " Command
			ui.dockBarWin%winNumber%cmd.setFont("c" cfg.themeFont2Color)
			ui.Win%WinNumber%AfkStatus.SetFont("c" cfg.ThemeFont2Color)
			ui.Win%WinNumber%AfkStatus.text := "  " Command
			ui.opsWin%WinNumber%AfkIcon.value := "./Img/attack_icon.png"
			ui.opsWin%WinNumber%AfkStatus.SetFont("c" cfg.ThemeFont2Color)
			ui.opsWin%WinNumber%AfkStatus.text := "  " Command

			WinActivate("ahk_id " ui.win%winNumber%hwnd)
			WinGetPos(&WinX,&WinY,&WinW,&WinH,"ahk_id " ui.win%winNumber%hwnd)
			if (WinGetProcessName("ahk_id " ui.win%winNumber%hwnd) == "RobloxPlayerBeta.exe") {
				MouseClick("Left",WinW-50,WinH-120,3)
			} else {
				MouseClick("Left",WinW-50,WinH-120,2)
			}
			;debugLog("activating win: " winNumber)
			Sleep(350)
			;debugLog("sending: " command " to win: " winNumber)
			SendEvent("{" Command " Down}")
			sleep(duration)
			SendEvent("{" Command " Up}")

			if InStr("mage of shadows,spirit archer,summoner",substr(ui.Win%WinNumber%ClassDDL.Text,5,3))
			{
				AutoFire(WinNumber)
			}	
		}
	}

	resetAutoFireStatus(*) {
		ui.buttonAutoFire.Opt("Background" cfg.ThemeButtonReadyColor)
		ui.buttonAutoFire.Value := "./Img/button_autoFire_ready.png"
		ui.buttonAutoFire.Redraw()		
		ui.AutoFireWin1button.Opt("Background" cfg.ThemeButtonReadyColor)
		ui.AutoFireWin1button.Value := "./Img/button_autoFire_ready.png"
		ui.AutoFireWin2button.Redraw()		
		ui.AutoFireWin1button.Opt("Background" cfg.ThemeButtonReadyColor)
		ui.AutoFireWin2button.Value := "./Img/button_autoFire_ready.png"
		ui.AutoFireWin2button.Redraw()
	}
}

updateTimer() {
	if (ui.towerEnabled) {
		if (ui.afkProgress.value = (cfg.towerInterval)) {
			restartTower()
		} else {
			ui.afkProgress.value += 1
			ui.opsProgress1.value += 1
			ui.opsProgress2.value += 1
		}
	}
	if (ui.antiIdle_Enabled) {
		ui.afkProgress.value += 10
		ui.opsProgress1.value += 10
		ui.opsProgress2.value += 10
	}
}


inputWatcher() {
	if (A_TimeIdlePhysical < 2000) or (A_TimeIdleMouse < 2000) and (ui.afkEnabled) and (A_PriorKey = "Delete")
	{	
		StopAFK()
	}
}

mouse(clickX,clickY,clickButton := "Left", ClickDirection := "") {
	SendEvent("{Click " clickX " " clickY " " clickButton " " clickDirection "}")
	Sleep(150)
}	


afkBeta(*) {
	global
	win1LoopFinished := false
	win2LoopFinished := false
	ui.currStepNum := 0
	
	debugLog("afk loop starting")
	while (ui.afkEnabled) {
			ui.currStepNum += 1
			;debugLog("afk step: " ui.currStepNum)
			if (ui.currStepNum <= win1afk.steps.length) && !cfg.win1disabled && ui.win1enabled && winExist("ahk_id " ui.win1hwnd) {
				debugStep := (win1afk.steps.length >= ui.currStepNum) ? (win1afk.steps[ui.currStepNum]) : ("--")
				debugWait := (win1afk.waits.length >= ui.currStepNum) ? (win1afk.waits[ui.currStepNum]) : ("--")
				debugLog("| win: 1 | step: " ui.currStepNum " | Action: " debugStep " | wait: " debugWait " |")
				attackWin(1,win1afk.steps[ui.currStepNum],win1afk.waits[ui.currStepNum])
				win1LoopFinished := false
			} else {
				win1LoopFinished := true
			}
			
			
			if (ui.currStepNum <= win2afk.steps.length) && !cfg.win2disabled && ui.win2enabled && winExist("ahk_id " ui.win2hwnd) {
				debugStep := (win2afk.steps.length >= ui.currStepNum) ? (win2afk.steps[ui.currStepNum]) : ("--")
				debugWait := (win2afk.waits.length >= ui.currStepNum) ? (win2afk.waits[ui.currStepNum]) : ("--")
				debugLog("| win: 2 | step: " ui.currStepNum " | Action: " debugStep " | wait: " debugWait " |")
				attackWin(2,win2afk.steps[ui.currStepNum],win2afk.waits[ui.currStepNum])
				win2LoopFinished := false
			} else
				win2LoopFinished := true

			if (win1LoopFinished && win2LoopFinished) {
				updateTimer()
				win1LoopFinished := false
				win2LoopFinished := false
				ui.currStepNum := 0
			}
	}
}

afkWin1ClassChange(*) {
	global
	cfg.win1class			:= ui.afkWin1classDDL.value
	ui.win1ClassDDL.text 	:= ui.afkWin1ClassDDL.text
	controlFocus(ui.buttonStartAfk,ui.mainGui)
	refreshAfkRoutine()	
}

afkWin2ClassChange(*) {
	global
	cfg.win2class	:= ui.afkWin2ClassDDL.value
	ui.win2classDDL.text := ui.afkWin2ClassDDL.text
		controlFocus(ui.buttonStartAfk,ui.mainGui)
	refreshAfkRoutine()
}

opsWin1ClassChange(*) {
	global
	cfg.win1class	:= ui.win1ClassDDL.value
	ui.afkWin1ClassDDL.text := ui.win1classDDL.text
		controlFocus(ui.win1name,ui.mainGui)
	refreshAfkRoutine()
}

opsWin2ClassChange(*) {
	global
	cfg.win2class	:= ui.win2classDDL.value
	ui.afkWin2classDDL.text := ui.win2classDDL.text
		controlFocus(ui.win2name,ui.mainGui)
	RefreshAfkRoutine()
}
