#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) { ;run main app
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

hotIfWinActive("ahk_exe destiny2.exe")
	hotKey("~*" cfg.dappToggleSprintKey,d2ToggleAlwaysSprint)
	hotKey("~*" cfg.dappPauseKey,d2ToggleAppFunctions)
hotIf()

hotIf(d2RemapCrouchEnabled)
	hotkey("~*$" cfg.dappHoldToCrouchKey,d2HoldToCrouch)
hotIf()

hotIf(d2ReadyToReload)
	hotKey("~*" cfg.dappReloadKey,d2reload)
hotIf()

hotIf(d2ReadyToSprint)
	hotKey("~*w",d2StartSprinting)
hotIf()

hotIf()

togglePrismatic(*) {
	send("{F1}")
	sleep(550)
	mouseGetPos(&mouseX,&mouseY)
	click(1300,315,0)
	sleep(250)
	send("{LButton}")
	click(mouseX,mouseY,0)
	sleep(300)
	send("{F1}")
}

dappPause(*) {
	(cfg.dappPaused := !cfg.dappPaused)
	
}
	
d2RemapCrouchEnabled(*) {
	return ((winActive("ahk_exe destiny2.exe") && !cfg.dappPaused)
		? cfg.d2AlwaysRunEnabled
			? 1
			: 0
		: 0)
}	

d2SwordFly(*) {
	while getKeyState(cfg.dappSwordFlyKey) {
		send("{LButton Down}")
		sleep(100)
		send("{LButton Up}")
		sleep(800)
		send("{space down}")
		sleep(80)
		send("{space up}")
		sleep(80)
		send("{space down}")
		sleep(80)
		send("{space up}")
		sleep(700)
	}
}

d2MorgethWarlock(*) {
	while getKeyState(cfg.dappSwordFlyKey) && getKeyState("w") {
		send("{" cfg.d2GameGrenadeKey " down}")
		sleep(1700)
		send("{" cfg.d2GameGrenadeKey " up}")
		send("{" strLower(cfg.d2GameToggleSprintKey) "}")
		sleep(800)
		send("{space down}{space up}")
		sleep(80)
		send("{space down}{space up}")
		sleep(11000)
		send("{" cfg.d2GameSuperKey " down}")
		sleep(300)
		send("{" cfg.d2GameSuperKey " up}")
		sleep(300)
		send("{" cfg.d2GameSuperKey " down}")
		sleep(300)
		send("{" cfg.d2GameSuperKey " up}")
		sleep(7000)
		loop 110 {
			sleep(100)
			send("{space}")
			sleep(200)
			send("{space}")
		}
	}
}

d2reload(*) {
	startReload()
	stopReload()
	
	startReload() {
		ui.d2GameReloadKeyData.opt("c" cfg.themeButtonOnColor)
		ui.d2GameReloadKeyData.redraw()
		ui.dappReloadKeyData.opt("c" cfg.themeButtonOnColor)
		ui.dappReloadKeyData.redraw()
		ui.d2IsReloading := true
		d2ToggleAppFunctionsOff()
	}
	
	stopReload() {
		; ui.d2IsReloading := false
		; d2ToggleAppFunctionsOn()
		; ui.dappReloadKeyData.opt("c" cfg.themeButtonAlertcolor)
		; ui.d2GameReloadKeyData.opt("c" cfg.themeButtonAlertColor)
		; ui.d2GameReloadKeyData.redraw()
		setTimer () => (ui.d2IsReloading := false
			,d2ToggleAppFunctionsOn()
			,ui.dappReloadKeyData.opt("c" cfg.themeButtonAlertcolor)
			,ui.d2GameReloadKeyData.opt("c" cfg.themeButtonAlertColor)
			,ui.d2GameReloadKeyData.redraw()),-2600
	}
}	

d2HoldToCrouch(*) {
	ui.dappHoldToCrouchKeyData.opt("c" cfg.themeButtonOnColor)
	if (cfg.topDockEnabled) {
		ui.dockBarD2HoldToCrouch.opt("background" cfg.themeButtonAlertColor)
		ui.dockBarD2HoldToCrouch.redraw()
	}
	send("{" cfg.d2gameHoldToCrouchKey " down}")
	keywait(cfg.dappHoldToCrouchKey)
	ui.dappHoldToCrouchKeyData.opt("c" cfg.themeButtonAlertColor)
	if (cfg.topDockEnabled) {
		ui.dockBarD2HoldToCrouch.opt("background" cfg.themeButtonOnColor)
		ui.dockBarD2HoldToCrouch.redraw()
	}
	send("{" cfg.d2gameHoldToCrouchKey " Up}")
}

d2FireButtonClicked(*) {
	send("{LButton Down}")
	keyWait("LButton")

	send("{LButton Up}")
	if ui.d2IsSprinting
		send("{" cfg.d2GameToggleSprintKey "}")
}
d2ReadyToSwordFly(*) {
	if winActive("ahk_exe destiny2.exe") && !cfg.dappPaused && ui.d2FlyEnabled
		return 1
	else
		return 0
}

d2ReadyToReload(*) {
	if winActive("ahk_exe destiny2.exe") && !ui.d2IsReloading && !cfg.dappPaused
		return 1
	else
		return 0	
}

d2ReadyToSprint(*) {
	return (winActive("ahk_exe destiny2.exe")) 
		? (cfg.d2AlwaysRunEnabled)
			? (!cfg.dappPaused)
				? (!getKeyState("RButton")) 
					? (!getKeyState("z"))
						? (!getKeyState("LButton")) 
							? (!getKeyState(cfg.dappHoldToCrouchKey)) 
								? 1
								: 0
							: 0
						: 0
					: 0
				: 0
			: 0
		: 0
}
	
d2startSprinting(*) {
	;msgBox('.')
	;send("{w down}")
	ui.d2IsSprinting := true
	;send("{w down}")
	if (cfg.d2AlwaysRunEnabled) {
		send("{" strLower(cfg.d2GameToggleSprintKey) "}")
	}
	;setCapsLockState("Off")
	keyWait("w","L")
	send("{w up}")
}

cfg.d2LoadoutCoords1920x1080 := strSplit(iniRead(cfg.file,"Game"
,"d2LoadoutCoords1920x1080"
,"145:3e	80,240:380,145:480,240:480,145:580,240:580,145:680,240:680,145:790,240:790,145:910,240:910"),",")
	
cfg.d2LoadoutCoords1920x1200 := strSplit(iniRead(cfg.file,"Game"
,"d2LoadoutCoords1920x1200"
,"145:380,240:380,145:480,240:480,145:580,240:580,145:680,240:680,145:790,240:790,145:890,240:890"),",")
	
cfg.d2LoadoutCoords2560x1440 := strSplit(iniRead(cfg.file,"Game"
,"d2LoadoutCoords2560x1440"
,"190:460,320:460,190:590,320:590,190:720,320:720,190:850,320:850,190:980,320:980,190:1100,320:1100"),",")	

cfg.d2LoadoutCoords3440x1440 := strSplit(iniRead(cfg.file,"Game"
,"d2LoadoutCoords3440x1440"
,"636:460,760:460,636:590,760:590,636:720,760:720,636:850,760:850,636:980,760:980,636:1100,760:1100"),",")	
				
cfg.d2LoadoutCoordsCustom := strSplit(iniRead(cfg.file,"Game"
,"d2LoadoutCoordsCustom"
,"145:380,240:380,145:480,240:480,145:580,240:580,145:680,240:680,145:790,240:790,145:910,240:910"),",")

ui.d2IsReloading := false
ui.d2IsSprinting := false


d2CreateLoadoutKeys(*) {
	try {
		if (ui.monitorAuto == true) {
			cfg.d2LoadoutCoords := cfg.d2LoadoutCoords%a_screenWidth%x%a_screenHeight%
		} else {
			cfg.d2Loadoutcoords := cfg.d2LoadoutCoords%ui.monitorResDDL.text%
		}
		} catch {
		cfg.d2LoadoutCoords := cfg.d2LoadoutCoords1920x1080
	}
	loop cfg.d2LoadoutCoords.length {
		d2LoadOutCoordsStr .= cfg.d2LoadoutCoords[a_index] ","
	}	

	hotIf(dappEnabled)
	hotkey("Joy12",d2controllerLoadoutChange)
	hotkey(cfg.dappLoadoutKey,d2LoadoutModifier)
	loop cfg.d2LoadoutCoords.length {
		if a_index == 10 {
				hotkey(cfg.dappLoadoutKey " & 0",d2LoadoutModifier)
		} else {
					hotKey(cfg.dappLoadoutKey " & " substr(a_index,-1),d2LoadoutModifier)
				}
			}
	hotIf()
}

dappEnabled(*) {
	if !cfg.dappPaused && winActive("ahk_exe destiny2.exe")
		return 1
	else
		return 0
}

d2CreateLoadoutKeys()

d2controllerLoadoutChange(*) {
	osdLog("Controller Loadout Hotkey Pressed")
	joyx := "center"
	joyy := "center"
	while getKeyState("joy12") {
		if getKeyState("JoyX") < 20 
			joyx := "left" 
		if getKeyState("JoyX") > 80
			joyx := "right"
		if getKeyState("JoyX") == 50
			joyx := "center"
		if getKeyState("JoyY") < 35 
			joyy := "up"
		if getKeyState("JoyY") > 75
			joyy := "down"
		if getKeyState("JoyY") == 50
			joyy := "center"
	}
	osdLog("L3 + " joyx " and " joyy " pressed")
	switch {
		case joyy == "up" && joyx == "center":d2LoadoutModifier("prismatic",true)
		case joyx == "right" && joyy == "center":d2LoadoutModifier("`3",true)
		case joyy == "down" && joyx == "center":d2LoadoutModifier("`2",true) 
		case joyx == "left" && joyy == "center":d2LoadoutModifier("`1",true)
		default:return
	}
}

d2LoadoutModifier(hotKeyName,isController := false) {
	d2LoadoutCoordsStr := ""
	if (hotKeyName == "prismatic") {
		cfg.dappLoadoutMultiplier := 1.5
		sleep(550*cfg.dappLoadoutMultiplier)
		keyWait("joy12")
		send("{F1}")
		togglePrismatic()
		return
	} 
	
	if (hotkeyName == "``" ) {
		if (A_PriorHotkey == "``") And (A_TimeSincePriorHotkey < 200) {
			togglePrismatic()
		}
		return
	}
	
	loop cfg.d2LoadoutCoords.length {
		d2LoadoutCoordsStr .= cfg.d2LoadoutCoords[a_index] ","
	}
	d2LoadoutCoordsStr := rtrim(d2LoadoutCoordsStr,",")

	try {
		ui.dockBarLoadouts.opt("background" cfg.themeButtonAlertColor)
		ui.dockBarLoadouts.redraw()
	}
	
	ui.dappLoadoutKeyData.text := cfg.dappLoadoutKey " - " subStr(hotKeyName,-1)
	ui.dappLoadoutKeyData.opt("c" cfg.themeButtonOnColor)
	ui.dappLoadoutKeyData.redraw()
	setTimer () => (ui.dappLoadoutKeyData.text := cfg.dappLoadoutKey,ui.dappLoadoutKeyData.opt("c" cfg.themeButtonAlertColor),ui.dappLoadoutKeyData.redraw()),-1000

	loadoutX := strSplit(cfg.d2LoadoutCoords[subStr(hotKeyName,-1)],":")[1]
	loadoutY := strSplit(cfg.d2LoadoutCoords[subStr(hotKeyName,-1)],":")[2]

	if !(loadoutX || loadoutY)
		return
		
	if isController {
		cfg.dappLoadoutMultiplier := 1.5
		sleep(550*cfg.dappLoadoutMultiplier)
		keyWait("joy12")
	}
	;msgBox('here')
	send("{F1}")
	sleep(550*cfg.dappLoadoutMultiplier)
	send("{Left}")
	sleep(150*cfg.dappLoadoutMultiplier)
	coordMode("mouse","client")
	if isController {
		click(loadoutX+30,loadoutY+30,0)
		click(loadoutX,loadoutY,0)
	} else
		click(loadoutX,loadoutY,0)
	sleep(250*cfg.dappLoadoutMultiplier)
	send("{LButton}")
	sleep(100*cfg.dappLoadoutMultiplier)
	send("{F1}")
	try {
		ui.dockBarLoadouts.opt("background" cfg.themeButtonOnColor)
		ui.dockBarLoadouts.redraw()
	}
}
	
d2ToggleAlwaysSprint(*) {
	(cfg.d2AlwaysRunEnabled := !cfg.d2AlwaysRunEnabled)
		? (ui.dappToggleSprintKeyData.opt("c" cfg.themeButtonOnColor)
			,ui.dappToggleSprintKeyData.redraw()
			,ui.d2GameToggleSprintKeyData.opt("c" cfg.themeButtonOnColor)
			,ui.d2GameToggleSprintKeyData.redraw()
			,SetCapsLockState("Off"))
		: (ui.d2IsSprinting := false
			,SetCapsLockState("Off")
			,ui.dappToggleSprintKeyData.opt("c" cfg.themeButtonAlertColor)
			,ui.dappToggleSprintKeyData.redraw()
			,ui.d2GameToggleSprintKeyData.opt("c" cfg.themebuttonAlertColor)
			,ui.d2GameToggleSprintKeyData.redraw()
			,((ui.d2IsSprinting)
				? send("{" cfg.dappToggleSprintKey "}")
				: 0))
}

d2ToggleAppFunctions(*) {
	(cfg.dappPaused := !cfg.dappPaused)
		? d2ToggleAppFunctionsOff()
		: d2ToggleAppFunctionsOn()
}

d2ToggleAppFunctionsOn() {
	ui.d2ToggleAppFunctions.Opt("Background" cfg.ThemeButtonOnColor)
	ui.d2ToggleAppFunctions.value := "./img/toggle_vertical_trans_on.png"
	try {				
		ui.dockBarD2AlwaysRun.Opt("Background" cfg.ThemeButtonOnColor)
		ui.dockBarD2AlwaysRun.value := "./img/toggle_vertical_trans_on.png"
	}
}

d2ToggleAppFunctionsOff() {
	ui.dappFunctionsEnabled := false
	ui.d2ToggleAppFunctions.opt("background" cfg.ThemeButtonReadyColor)
	ui.d2ToggleAppFunctions.value := "./img/toggle_vertical_trans_off.png"
	ui.d2ToggleAppFunctions.redraw()
	try {
		ui.dockBarD2AlwaysRun.opt("background" cfg.ThemeButtonAlertColor)
		ui.dockBarRunIcon.opt("background" cfg.themeButtonOnColor)
		ui.dockBarRunIcon.redraw()
		ui.dockBarD2AlwaysRun.value := "./img/toggle_vertical_trans_off.png"
	}
}

d2ToggleAutoGameConfig(*) {
	(cfg.d2AutoGameConfigEnabled := !cfg.d2AutoGameConfigEnabled)
		? d2ToggleAutoGameConfigOn()
		: d2ToggleAutoGameConfigOff()
	}
	
	
d2ToggleAutoGameConfigOn() {
	;ui.d2Log.text := " start: SPRINT`n rcvd: " strUpper(subStr(cfg.dappToggleSprintKey,1,8)) "`n" ui.d2Log.text
	ui.d2ToggleAutoGameConfig.Opt("Background" cfg.ThemeButtonOnColor)
	ui.d2ToggleAutoGameConfig.value := "./img/toggle_vertical_trans_on.png"
}

d2ToggleAutoGameConfigOff() {
	ui.d2AutoGameConfigEnabled := false
	ui.d2ToggleAutoGameConfig.opt("background" cfg.ThemeButtonReadyColor)
	ui.d2ToggleAutoGameConfig.value := "./img/toggle_vertical_trans_off.png"
	ui.d2ToggleAutoGameConfig.redraw()
}

if (cfg.d2AlwaysRunEnabled) {
		d2ToggleAppFunctionsOn()
}






