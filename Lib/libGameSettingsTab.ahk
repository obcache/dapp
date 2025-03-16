#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) { ;run main app
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

;setStoreCapslockMode(0)
inputHookAllowedKeys := "{All}{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{Left}{Right}{Up}{Down}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}{Tab}{Enter}{ScrollLock}{LButton}{MButton}{RButton}"	

ui.d2FlashingIncursionNotice := false
ui.d2ShowingIncursionNotice := false
ui.incursionDebug := false
ui.d2FlyEnabled := false

GuiGameTab() {
	global	
	loop cfg.gameModuleList.length {
		if fileExist("./lib/lib" cfg.gameModuleList[A_Index])
			runWait("./lib/lib" cfg.gameModuleList[A_Index])
	}
	try
		ui.gameSettingsGui.destroy()
		
	ui.gameSettingsGui := Gui()
	ui.gameSettingsGui.Name := "dapp"
	ui.gameSettingsGui.BackColor := cfg.themePanel2Color
	ui.gameSettingsGui.Color := cfg.themePanel2Color
	ui.gameSettingsGui.MarginX := 5
	ui.gameSettingsGui.Opt("-Caption -Border +AlwaysOnTop +Owner" ui.MainGui.Hwnd)
	ui.gameSettingsGui.SetFont("s14 c" cfg.ThemeFont1Color,"calibri")
	ui.gameTabs := ui.gameSettingsGui.addTab3("x0 y-5 h194 0x400 bottom c" cfg.themeFont1Color " choose" cfg.activeGameTab,cfg.gameModuleList)

	ui.gameTabs.choose(cfg.gameModuleList[cfg.activeGameTab])
	ui.gameTabs.setFont("s16")
	ui.gameTabs.onEvent("Change",gameTabChanged)
	ui.MainGui.GetPos(&winX,&winY,,)
	winSetRegion("2-0 w600 h250",ui.gameSettingsGui)
	Loop cfg.gameList.length {
		try {
			runWait("./lib/lib" cfg.gameList[a_index])
			ui.gameTabs.value([cfg.gameList[a_index]])
			ui.gameTabs.useTab(cfg.gameList[a_index])
		}
	}
	d2drawUi()
	drawGameTabs(cfg.activeGameTab)
}	 

d2DrawUi(*) { 
	ui.gameTabs.useTab("Gameplay") 
	ui.d2Sliding := false
	ui.d2HoldingRun := false         
	ui.d2cleanupNeeded := false
	ui.gameSettingsGui.setFont("s10")
	d2drawTopPanel()
	d2drawPanel1()
	d2drawPanel3()
	d2drawPanel4()
	if d2ActivePanel == 1 
		d2ChangeKeybindPanelTab(1)
	else
		d2ChangeKeybindPanelTab(2)	
}


d2drawPanel1(*) {
	guiName := ui.gameSettingsGui
	ui.d2KeybindWidth := 60
	labelX := 280
	labelY := 44
	labelW := 68
	labelH := 20
	backColor := cfg.themePanel2Color
	fontColor := cfg.themeFont2Color
	outlineColor := cfg.themeDark2Color
	labelText := "Keybinds"
	ui.d2keybindAppTab1 := guiName.addText("x" labelX " y" labelY+labelH/2 " w" labelW " h" labelH/2+3 " background" outlineColor,"")
		     
	labelX := 356
	labelY := 44
	labelW := 98
	labelH := 20
	backColor := cfg.themePanel2Color
	fontColor := cfg.themeFont4Color
	outlineColor := cfg.themeBright1Color
	labelText := "Game Settings"	
	
	
	ui.d2keybindGameTab1 := guiName.addText("x" labelX " y" labelY+labelH/2 " w" labelW " h" labelH/2+3 " background" outlineColor,"")
	ui.d2Panel1Tab1Bg := ui.gameSettingsGui.addText("x45 y9 w440 h44 background" cfg.themeBright1Color,"")
	ui.d2Panel1Tab1Bg2 := ui.gameSettingsGui.addText("x44 y10 w440 h42 background" cfg.themePanel2color " c" cfg.themeFont4color,"")	
	ui.d2Panel1Tab1Bg3 := ui.gameSettingsGui.addText("x44 y11 w440 h40 background" cfg.themeDark1Color,"")
	ui.d2Panel1Tab1Bg4 := ui.gameSettingsGui.addText("x44 y12 w440 h40 background" cfg.themePanel2Color,"")
	
	ui.d2Panel1Tab2Bg := ui.gameSettingsGui.addText("hidden x19 y10 w410 h43 background" cfg.themeBright1Color,"")
	ui.d2Panel1Tab2Bg2 := ui.gameSettingsGui.addText("hidden x19 y10 w437 h42 background" cfg.themePanel2color " c" cfg.themeFont4color,"")	
	ui.d2Panel1Tab2Bg3 := ui.gameSettingsGui.addText("hidden x21 y11 w434 h40 background" cfg.themeDark1Color,"")
	ui.d2Panel1Tab2Bg4 := ui.gameSettingsGui.addText("hidden x20 y12 w434 h40 background" cfg.themePanel2Color,"")
	
	;ui.d2Panel1Tab2Bg := ui.gameSettingsGui.addText("x42 y10 w406 h42 background" cfg.themePanel2color " c" cfg.themeFont4color,"")	
	;drawOutlineNamed("gameSettings",ui.gameSettingsGui,43,11,404,42,cfg.themeDark1Color,cfg.themeBright1Color,1)
	ui.currKey := cfg.dappPauseKey
	ui.dappPauseKey		:= ui.gameSettingsGui.addPicture("x50 y17 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappPauseKeyData 	:= ui.gameSettingsGui.addText("xs+0 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.dappPauseKey),1,8))
	ui.dappPauseKeyLabel	:= ui.gameSettingsGui.addText("xs+1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h20 center c" cfg.themeFont1Color " backgroundTrans","Pause")
	
	ui.keybindSpacer	:= ui.gameSettingsGui.addText("x+2 y13 w1 h40 background" cfg.themeBright2Color)		
	ui.keybindSpacer2	:= ui.gameSettingsGui.addText("x+-2 y12 w1 h40 background" cfg.themeBorderLightColor)

	
	ui.currKey := cfg.dappToggleSprintKey
	ui.dappToggleSprintKey			:= ui.gameSettingsGui.addPicture("x+4 y17 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappToggleSprintKeyData 	:= ui.gameSettingsGui.addText("xs-2 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.dappToggleSprintKey),1,8))
	ui.dappToggleSprintKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h20 center c" cfg.themeFont1Color " backgroundTrans","Sprint")
	
	ui.currKey := cfg.dappHoldToCrouchKey
	ui.dappHoldToCrouchKey					:= ui.gameSettingsGui.AddPicture("x+5 ys w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappHoldToCrouchKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.dappHoldToCrouchKey),1,8))
	ui.dappHoldToCrouchKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h20 center c" cfg.themeFont1Color " backgroundTrans","Crouch")

	ui.currKey := cfg.dappReloadKey
	ui.dappReloadKey						:= ui.gameSettingsGui.addPicture("x+5 ys w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappReloadKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		" h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.dappReloadKey),1,8))
	ui.dappReloadKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
	" h20 center c" cfg.themeFont1Color " backgroundTrans","Reload")

	ui.currKey := cfg.dappLoadoutKey
	ui.dappLoadoutKey				:= ui.gameSettingsGui.addPicture("x+5 ys w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		"  h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappLoadoutKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		"  h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.dappLoadoutKey),1,8))
	ui.dappLoadoutKeyLabel 		:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) 
		"  h20 center c" cfg.themeFont1Color " backgroundTrans","Loadout")
	
	ui.currKey 					:= cfg.dappSwordFlyKey
	ui.dappSwordFlyKey			:= ui.gameSettingsGui.addPicture("x+11 ys w36 h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappSwordFlyKeyData 	:= ui.gameSettingsGui.addText("xs+0 y+-24 w36 h21 center c" cfg.themeButtonAlertColor " backgroundTrans"
		,subStr(strUpper(cfg.dappSwordFlyKey),1,8))
	ui.dappSwordFlyKeyLabel 	:= ui.gameSettingsGui.addText("xs+0 y+-34 w40 h20 center c" cfg.themeFont1Color " backgroundTrans","Fly")
	ui.d2ClassSelectOutline		:= ui.gameSettingsGui.addText("xs+42 y+-15 w39 h39 background" cfg.themeDark2Color)
	ui.d2ClassSelectOutline2	:= ui.gameSettingsGui.addText("xs+43 y+-41 w38 h38 background" cfg.themeBright1Color)
	ui.d2ClassSelectBg			:= ui.gameSettingsGui.addText("x442 y+-41 w42 h43 background" cfg.themePanel2Color)
	;ui.d2ClassSelectBg2			:= ui.gameSettingsGui.addText("xs+35 y+-14 w56 h16 background" cfg.themeDark1Color)
	ui.d2ClassSelectBgLine		:= ui.gameSettingsGui.addText("hidden x442 y+-15 w42 h1 background" cfg.themeBright2Color)
	ui.d2ClassSelectBgLine2		:= ui.gameSettingsGui.addText("hidden x442 y+13 w42 h1 background" cfg.themeBright2Color)
	ui.d2ClassSelectBg3			:= ui.gameSettingsGui.addText("hidden xs+44 y+-17 w41 h16 background" cfg.themePanel2Color)
	ui.d2ClassIcon				:= ui.gameSettingsGui.addPicture("x442 y10 w42 h28 center backgroundTrans","")
	ui.d2ClassIconDown			:= ui.gameSettingsGui.addText("x445 y37 w18 h13 center backgroundTrans c" cfg.themeButtonOnColor,"←")
	ui.d2ClassIconUp			:= ui.gameSettingsGui.addText("x464 y37 w19 h13 center backgroundTrans c" cfg.themeButtonOnColor,"→")
	ui.d2ClassSelectSpacer 		:= ui.gameSettingsGui.addText("hidden x463 y36 w1 h15 background" cfg.themeBright2Color)
	ui.d2KeyBindHelpMsg			:= ui.gameSettingsGui.addText("x47 y52 w350 h12 backgroundTrans c" cfg.themeFont1Color,"")
	ui.d2ClassIcon.toolTip 		:= "Click to Enable/Disable the Fly Macro"
	ui.d2ClassIconDown.tooltip 	:= "Click to switch between character classes for the Fly Macro"
	ui.d2ClassIconUp.tooltip 	:= "Click to switch between character classes for the Fly Macro"
	ui.keybindSpacer3			:= ui.gameSettingsGui.addText("x441 y11 w1 h42 background" cfg.themeBright2Color)		
	ui.keybindSpacer4			:= ui.gameSettingsGui.addText("x442 y11 w1 h42 background" cfg.themeBorderLightColor)	
	ui.d2ClassIconSpacer		:= ui.gameSettingsGui.addText("x391 y11 w1 h41 background" cfg.themeBright2Color,"")
	ui.d2ClassIconSpacer2		:= ui.gameSettingsGui.addText("x392 y11 w1 h41 background" cfg.themeBorderLightColor,"")
	ui.d2ClassIconDown.setFont("s9")
	ui.d2ClassIconDown.onEvent("click",d2ClassIconDownChanged)
	ui.d2ClassIconUp.setFont("s9")
	ui.d2ClassIconUp.onEvent("click",d2ClassIconUpChanged)
	ui.d2KeyBindHelpMsg.setFont("s8")
	ui.d2ClassIcon.onEvent("click",d2ToggleFly)


	d2ToggleFly()
	d2ToggleFly(*) {
		(ui.d2FlyEnabled := !ui.d2FlyEnabled)

		switch cfg.d2CharacterClass {
			case 1: 
				(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_on.png",ui.d2ClassSelectBg.opt("background" cfg.themePanel3Color))
					: (ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_off.png",ui.d2ClassSelectBg.opt("background" cfg.themeFont3Color))
			case 2:
				(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img/d2ClassIconHunter_on.png",ui.d2ClassSelectBg.opt("background" cfg.themePanel3Color))
					: (ui.d2ClassIcon.value := "./img/d2ClassIconHunter_off.png",ui.d2ClassSelectBg.opt("background" cfg.themeFont3Color))
			case 3:
			(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img/d2ClassIconTitan_on.png",ui.d2ClassSelectBg.opt("background" cfg.themePanel3Color))
					: (ui.d2ClassIcon.value := "./img/d2ClassIconTitan_off.png",ui.d2ClassSelectBg.opt("background" cfg.themeFont3Color))
			default:
		}
	}

	switch cfg.d2CharacterClass { 
		case 1:
		case 2:
		hotif(d2ReadyToSwordFly)
			hotkey("*" cfg.dappSwordFlyKey,d2SwordFly)
		hotif()
		case 3:
		hotif(d2ReadyToSwordFly)
			hotkey("*" cfg.dappSwordFlyKey,d2MorgethWarlock)
		hotif()
		default:
	}
	
	d2ClassIconUpChanged()

	ui.dappPauseKey.ToolTip 				:= "Click to Assign"
	ui.dappHoldToCrouchKey.ToolTip 		:= "Click to Assign"
	ui.dappHoldToCrouchKeyData.ToolTip 	:= "Click to Assign"
	ui.dappHoldToCrouchKeyLabel.ToolTip	:= "Click to Assign"
	ui.dappLoadoutKey.ToolTip				:= "Click to Assign"
	ui.dappLoadoutKeyData.ToolTip  		:= "Click to Assign"
	ui.dappLoadoutKeyLabel.ToolTip			:= "Click to Assign"
	ui.dappToggleSprintKey.ToolTip			:= "Click to Assign"
	ui.dappToggleSprintKeyData.ToolTip  	:= "Click to Assign"
	ui.dappToggleSprintKeyLabel.ToolTip	:= "Click to Assign"
	ui.dappHoldToCrouchKey.ToolTip			:= "Click to Assign"
	ui.dappHoldToCrouchKeyData.ToolTip  	:= "Click to Assign"
	ui.dappHoldToCrouchKeyLabel.ToolTip	:= "Click to Assign"
	ui.dappReloadKey.ToolTip				:= "Click to Assign"
	ui.dappReloadKeyData.ToolTip  			:= "Click to Assign"
	ui.dappReloadKeyLabel.ToolTip			:= "Click to Assign"

	ui.dappLoadoutKeyData.setFont("s13")
	ui.dappPauseKeyData.setFont("s13")
	ui.dappPauseKeyLabel.setFont("s9")
	ui.dappReloadKeyData.setFont("s13")
	ui.dappReloadKeyLabel.setFont("s9")
	ui.dappHoldToCrouchKeyData.setFont("s13")
	ui.dappToggleSprintKeyData.setFont("s13")
	ui.dappHoldToCrouchKeyLabel.setFont("s9")
	ui.dappLoadoutKeyLabel.setFont("s9")
	ui.dappToggleSprintKeyLabel.setFont("s9")
	ui.dappSwordFlyKeyData.setFont("s13")
	ui.dappSwordFlyKeyLabel.setFont("s9")

	ui.dappPauseKey.onEvent("click",dappPauseKeyClicked)
	ui.dappHoldToCrouchKey.onEvent("click",dappHoldToCrouchKeyClicked)
	ui.dappHoldToCrouchKeyData.onEvent("click",dappHoldToCrouchKeyClicked)
	ui.dappSwordFlyKey.onEvent("click",dappSwordFlyKeyClicked)
	ui.dappSwordFlyKeyData.onEvent("click",dappSwordFlyKeyClicked)
	ui.dappReloadKey.onEvent("click",dappReloadKeyClicked)
	ui.dappReloadKeyData.onEvent("click",dappReloadKeyClicked)
	ui.dappReloadKey.onEvent("click",dappReloadKeyClicked)
	
	ui.currKey := cfg.d2GameToggleSprintKey
	ui.currKeyLabel := "Toggle Sprint"
	
	ui.d2GameToggleSprintKey				:= ui.gameSettingsGui.AddPicture("x25 y17 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameToggleSprintKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameToggleSprintKey),1,8))
	ui.d2GameToggleSprintKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.themeFont1Color " backgroundTrans","Toggle Sprint")
	
	ui.currKey := cfg.d2GameHoldToCrouchKey
	ui.currKeyLabel := "Hold Crouch"
	ui.d2GameHoldToCrouchKey					:= ui.gameSettingsGui.AddPicture("x+2 ys w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameHoldToCrouchKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameHoldToCrouchKey),1,8))
	ui.d2GameHoldToCrouchKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h20 center c" cfg.themeFont1Color " backgroundTrans","Hold Crouch")

	ui.currKey := cfg.d2GameReloadKey
	ui.currKeyLabel := "Reload"
	ui.d2GameReloadKey						:= ui.gameSettingsGui.addPicture("x+2 ys w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameReloadKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameReloadKey),1,8))
	ui.d2GameReloadKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.themeFont1Color " backgroundTrans","Reload")		
	
	ui.currKey := cfg.d2GameGrenadeKey
	ui.currKeyLabel := "Reload"
	ui.d2GameGrenadeKey						:= ui.gameSettingsGui.addPicture("x+2 ys w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameGrenadeKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameGrenadeKey),1,8))
	ui.d2GameGrenadeKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.themeFont1Color " backgroundTrans","Grenade")		
	
	ui.currKey := cfg.d2GameSuperKey
	ui.currKeyLabel := "Super"
	ui.d2GameSuperKey						:= ui.gameSettingsGui.addPicture("x+2 ys w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameSuperKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.themeButtonAlertColor " backgroundTrans",subStr(strUpper(cfg.d2GameSuperKey),1,8))
	ui.d2GameSuperKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.themeFont1Color " backgroundTrans","Super")		
	
	;cfg.d2AutoGameConfigEnabled := true
	ui.d2ToggleAutoGameConfig := ui.gameSettingsGui.addPicture("x463 y10 w20 h35 section "
	((cfg.d2AutoGameConfigEnabled) 
		? ("Background" cfg.ThemeButtonOnColor) 
			: ("Background" cfg.themeButtonReadyColor)),
	((cfg.d2AutoGameConfigEnabled) 
		? ("./img/toggle_vertical_trans_on.png") 
			: ("./img/toggle_vertical_trans_off.png")))
	ui.d2ToggleAutoGameConfig.toolTip := "Enable to attempt to automatically`nImport your game settings."
	ui.d2ToggleAutoGameConfigOutline := ui.gameSettingsGui.addText("ys+3 x+0 w1 h30 background" cfg.themeDark2Color)
	ui.d2ToggleAutoGameConfigLabel := ui.gameSettingsGui.addText("xs-1 y+0 w28 h10 backgroundTrans","Auto")
	ui.d2ToggleAutoGameConfigLabel.setFont("s8")
	ui.d2gameToggleSprintKey.onEvent("click",d2gameToggleSprintKeyClicked)
	ui.d2gameToggleSprintKeyData.onEvent("click",d2gameToggleSprintKeyClicked)
	ui.d2GameReloadKey.onEvent("click",d2GameReloadKeyClicked)
	ui.d2GameReloadKeyData.onEvent("click",d2GameReloadKeyClicked)
	ui.d2GameSuperKey.onEvent("click",d2GameSuperKeyClicked)
	ui.d2GameSuperKeyData.onEvent("click",d2GameSuperKeyClicked)
	ui.d2GameGrenadeKey.onEvent("click",d2GameGrenadeKeyClicked)
	ui.d2GameGrenadeKeyData.onEvent("click",d2GameGrenadeKeyClicked)
	ui.d2GameHoldToCrouchKey.onEvent("click",d2GameHoldToCrouchKeyClicked)
	ui.d2GameHoldToCrouchKeyData.onEvent("click",d2GameHoldToCrouchKeyClicked)

	ui.d2gameToggleSprintKey.ToolTip		:= "Click to Assign"
	ui.d2gameToggleSprintKeyData.ToolTip  	:= "Click to Assign"
	ui.d2gameToggleSprintKeyLabel.ToolTip	:= "Click to Assign"
	ui.d2GameReloadKey.ToolTip				:= "Click to Assign"
	ui.d2GameReloadKeyData.ToolTip  		:= "Click to Assign"
	ui.d2GameReloadKeyLabel.ToolTip			:= "Click to Assign"
	ui.d2GameSuperKey.ToolTip				:= "Click to Assign"
	ui.d2GameSuperKeyData.ToolTip  		:= "Click to Assign"
	ui.d2GameSuperKeyLabel.ToolTip			:= "Click to Assign"
	ui.d2GameGrenadeKey.ToolTip				:= "Click to Assign"
	ui.d2GameGrenadeKeyData.ToolTip  		:= "Click to Assign"
	ui.d2GameGrenadeKeyLabel.ToolTip			:= "Click to Assign"
	ui.d2GameHoldToCrouchKey.ToolTip		:= "Click to Assign"
	ui.d2GameHoldToCrouchKeyData.ToolTip  	:= "Click to Assign"
	ui.d2GameHoldToCrouchKeyLabel.ToolTip	:= "Click to Assign"

	ui.d2gameToggleSprintKeyLabel.setFont("s9")
	ui.d2gameToggleSprintKeyData.setFont("s9")
	ui.d2GameReloadKeyData.setFont("s9")
	ui.d2GameReloadKeylabel.setFont("s9")
	ui.d2GameSuperKeyData.setFont("s9")
	ui.d2GameSuperKeylabel.setFont("s9")
	ui.d2GameGrenadeKeyData.setFont("s9")
	ui.d2GameGrenadeKeylabel.setFont("s9")
	ui.d2GameHoldToCrouchKeyData.setFont("s9")
	ui.d2GameHoldToCrouchKeyLabel.setFont("s9")

	labelX := 280
	labelY := 44
	labelW := 66
	labelH := 23
	backColor := cfg.themePanel4Color
	fontColor := cfg.themeFont4Color
	outlineColor := cfg.themeDark1Color
	labelText := "Keybinds"
	
	ui.d2keybindAppTab2 := guiName.addText("x" labelX+1 " y" labelY+8 " w" labelW-2 " h" labelH-1 " background" backColor " center c" fontColor) 
	ui.d2keybindAppTab3 := guiName.addText("x" labelX+1 " y" labelY+8 " w" labelW-2 " h" labelH " backgroundTrans center c" fontColor, labelText) 
	ui.d2keybindAppTab3.setFont("s10","thin")

	labelX := 346
	labelY := 44
	labelW := 96
	labelH := 23
	backColor := cfg.themePanel2Color
	fontColor := cfg.themeFont1Color
	outlineColor := cfg.themeBright2Color
	labelText := "Game Settings"
	ui.d2keybindGameTab2 := guiName.addText("x" labelX+1 " y" labelY+8 " w" labelW-2 " h" labelH " background" backColor " center c" fontColor) 
	ui.d2keybindGameTab3 := guiName.addText("x" labelX+1 " y" labelY+8 " w" labelW-2 " backgroundTrans center c" fontColor, labelText) 
	ui.d2keybindGameTab3.setFont("s10","bold")

	ui.d2keybindAppTab1.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindAppTab2.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindAppTab3.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindGameTab1.onEvent("click",d2keybindGameTabClicked)
	ui.d2keybindGameTab2.onEvent("click",d2keybindGameTabClicked)
	ui.d2keybindGameTab3.onEvent("click",d2keybindGameTabClicked)
	ui.dappFunctionsEnabled := true
	ui.d2ToggleAppFunctions := ui.gameSettingsGui.addPicture("x17 y10 w20 h35 section "
	((ui.dappFunctionsEnabled) 
		? ("Background" cfg.ThemeButtonOnColor) 
			: ("Background" cfg.themeButtonReadyColor)),
	((ui.dappFunctionsEnabled) 
		? ("./img/toggle_vertical_trans_on.png") 
			: ("./img/toggle_vertical_trans_off.png")))
	ui.d2ToggleAppFunctionsOutline := ui.gameSettingsGui.addText("ys+3 x+0 w1 h32 background" cfg.themeDark2Color)
	ui.d2ToggleAppFunctionsLabel := ui.gameSettingsGui.addText("xs-5 y+-1 w28 h10 backgroundTrans center","Pause")
	ui.d2ToggleAppFunctionsLabel.setFont("s8")

}



d2AutoGameConfigOverride(*) {
	if (cfg.d2AutoGameConfigEnabled) {
		ui.d2ConfigFile := a_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
		curr_value := "none"
		loop read ui.d2ConfigFile {
			try {
				curr_key := strSplit(a_loopReadline,'"')[2]
				curr_values := strSplit(strSplit(a_loopReadline,'"')[4],"!")
			}
			switch curr_key {
				case "grenade":
					try	{

						loop curr_values.length {
							if curr_values[a_index] != "unused" {
								curr_value := curr_values[a_index]
								if curr_value == "caps lock"
									curr_value := "CapsLock"
									break
							}
						}
						
						if curr_value == "none"
							return
						else {
							;msgBox(curr_value)
							cfg.d2GameGrenadeKey := curr_value
							ui.d2GameGrenadeKeyData.text := strUpper(curr_value)
							ui.d2GameGrenadeKeyData.redraw()
						}
					}
			
				case "super":
					try	{
						curr_key := strSplit(a_loopReadline,'"')[2]
						curr_values := strSplit(strSplit(a_loopReadline,'"')[4],"!")
						loop curr_values.length {
							if curr_values[a_index] != "unused" {
								curr_value := curr_values[a_index]
								if curr_value == "caps lock"
									curr_value := "CapsLock"
								break
							}
						}
						
						if curr_value == "none"
							return
						else {
							cfg.d2GameSuperKey := curr_value
							ui.d2GameSuperKeyData.text := strUpper(curr_value)
							ui.d2GameSuperKeyData.redraw()
						}
					}
				case "hold_crouch":
					try	{
						curr_key := strSplit(a_loopReadline,'"')[2]
						curr_values := strSplit(strSplit(a_loopReadline,'"')[4],"!")
						loop curr_values.length {
							if curr_values[a_index] != "unused" {
								curr_value := curr_values[a_index]
								if curr_value == "caps lock"
									curr_value := "CapsLock"
								break
							}
						}
						
						if curr_value == "none"
							return
						else {
							cfg.d2GameHoldToCrouchKey := curr_value
							ui.d2GameHoldToCrouchKeyData.text := strUpper(curr_value)
							ui.d2GameHoldToCrouchKeyData.redraw()
						}
					}
				case "reload":
					try	{
						curr_key := strSplit(a_loopReadline,'"')[2]
						curr_values := strSplit(strSplit(a_loopReadline,'"')[4],"!")
						loop curr_values.length {
							if curr_values[a_index] != "unused" {
								curr_value := curr_values[a_index]
								if curr_value == "caps lock"
									curr_value := "CapsLock"
								break
							}
						}
						
						if curr_value == "none"
							return
						else {
							cfg.d2GameReloadKey := curr_value
							ui.d2GameReloadKeyData.text := strUpper(curr_value)
							ui.d2GameReloadKeyData.redraw()
						}
					}
				case "toggle_sprint":
					try	{
						curr_key := strSplit(a_loopReadline,'"')[2]
						curr_values := strSplit(strSplit(a_loopReadline,'"')[4],"!")
						loop curr_values.length {
							if curr_values[a_index] != "unused" {
								curr_value := curr_values[a_index]
								if curr_value == "caps lock"
									curr_value := "CapsLock"
								break
							}
						}
						
						if curr_value == "none"
							return
						else {
							cfg.d2GameToggleSprintKey := curr_value
							ui.d2GameToggleSprintKeyData.text := strUpper(curr_value)
							ui.d2GameToggleSprintKeyData.redraw()
						}
					}
				}
			}
	}
}

d2keybindAppTabClicked(*) {
guiName := ui.gameSettingsGui
ui.d2KeyBindHelpMsg.text := "         Assign keys you'd like to use for each function"
		labelX := 280
		labelY := 44
		labelW := 66
		labelH := 23
		ui.d2keybindGameTab1.opt("background" cfg.themeDark2Color)
		ui.d2keybindGameTab2.opt("background" cfg.themePanel4Color) 
		ui.d2keybindGameTab3.setFont("s10 c" cfg.themeFont4Color,"thin")
		ui.d2keybindGameTab1.move(348,labelY+10,92,13)
		ui.d2keybindGameTab2.move(348,labelY+9,90,13)
		ui.d2keybindGameTab3.move(346,labelY+8,,14)

		ui.d2keybindAppTab1.opt("background" cfg.themeBright1Color)
		ui.d2keybindAppTab2.opt("background" cfg.themePanel2Color)
		ui.d2keybindAppTab3.setFont("s10 c" cfg.themeFont1Color,"bold")
		ui.d2keybindAppTab1.move(labelx+0,labelY+6,70,17)
		ui.d2keybindAppTab2.move(labelx+1,labelY+6,66,16)
		ui.d2keybindAppTab3.move(282,labelY+8,,14)
		d2changeKeybindPanelTab(2)
	}


d2keybindGameTabClicked(*) {
guiName := ui.gameSettingsGui
		
		ui.d2KeybindHelpMsg.text := "Configure these to mirror your in-game bindings"
		labelX := 346
		labelY := 44
		labelW := 96
		labelH := 23
		ui.d2keybindAppTab1.opt("background" cfg.themeDark2Color)
		ui.d2keybindAppTab2.opt("background" cfg.themePanel4Color) 
		ui.d2keybindAppTab3.setFont("s10 c" cfg.themeFont4Color,"thin")
		ui.d2keybindAppTab1.move(280,labelY+10,70,13)
		ui.d2keybindAppTab2.move(281,labelY+9,65,13)
		ui.d2keybindAppTab3.move(280,labelY+8,,14)

		ui.d2keybindGameTab1.opt("background" cfg.themeBright1Color)
		ui.d2keybindGameTab2.opt("background" cfg.themePanel2Color)
		ui.d2keybindGameTab3.setFont("s10 c" cfg.themeFont1Color,"bold")
		ui.d2keybindGameTab1.move(labelx+0,labelY+6,92,17)
		ui.d2keybindGameTab2.move(labelx+1,labelY+6,90,16)
		ui.d2keybindGameTab2.redraw()
	
		ui.d2keybindGameTab3.move(,labelY+8,,14)
	d2changeKeybindPanelTab(1)
}


d2changeKeybindPanelTab(panelNum := 2) {
		ui.d2Panel1Objects := [
			ui.dappToggleSprintKey
			,ui.dappToggleSprintKeyData
			,ui.dappToggleSprintKeyLabel
			,ui.dappHoldToCrouchKey
			,ui.dappHoldToCrouchKeyData 
			,ui.dappHoldToCrouchKeyLabel
			,ui.keybindSpacer
			,ui.keybindSpacer2
			,ui.dappLoadoutKey
			,ui.dappLoadoutKeyData
			,ui.dappLoadoutKeyLabel
			,ui.dappSwordFlyKey
			,ui.dappSwordFlyKeyData
			,ui.dappSwordFlyKeyLabel
			,ui.d2ClassSelectBgLine
			,ui.dappReloadKey
			,ui.dappReloadKeyData
			,ui.dappReloadKeyLabel
			,ui.d2ClassSelectBgLine
			,ui.d2ClassSelectBgLine2
			,ui.d2ClassSelectBg
			; ,ui.d2ClassSelectBg2
			,ui.d2ClassIcon
			,ui.d2ClassIconUp
			,ui.d2ClassIconDown
			,ui.d2ClassSelectSpacer
			,ui.d2ClassIconSpacer
			,ui.d2ClassIconSpacer2
			,ui.keybindSpacer3
			,ui.keybindSpacer4
			,ui.dappPauseKey
			,ui.dappPauseKeyData
			,ui.dappPauseKeyLabel
			,ui.d2ToggleAppFunctions
			,ui.d2ClassSelectOutline
			,ui.d2ClassSelectOutline2
			,ui.d2ToggleAppFunctionsLabel
			,ui.d2ToggleAppFunctionsOutline
			,ui.d2Panel1Tab1Bg
			,ui.d2Panel1Tab1Bg2
			,ui.d2Panel1Tab1Bg3
			,ui.d2Panel1Tab1Bg4
			,ui.d2ClassSelectBg3
			]

	ui.d2Panel2Objects := [
			ui.d2GameToggleSprintKey
			,ui.d2GameToggleSprintKeyData
			,ui.d2GameToggleSprintKeyLabel
			,ui.d2GameHoldToCrouchKey
			,ui.d2GameHoldToCrouchKeyData 
			,ui.d2GameHoldToCrouchKeyLabel
			,ui.d2GameReloadKey
			,ui.d2GameReloadKeyData
			,ui.d2GameReloadKeyLabel
			,ui.d2ClassSelectBgLine
			,ui.d2GameGrenadeKey
			,ui.d2GameGrenadeKeyData
			,ui.d2GameGrenadeKeyLabel
			,ui.d2GameSuperKey
			,ui.d2GameSuperKeyData
			,ui.d2GameSuperKeyLabel
			,ui.d2ToggleAutoGameConfig
			,ui.d2ToggleAutoGameConfigLabel
			,ui.d2ToggleAutoGameConfigOutline
			,ui.d2Panel1Tab2Bg
			,ui.d2Panel1Tab2Bg2
			,ui.d2Panel1Tab2Bg3
			,ui.d2Panel1Tab2Bg4
		]

	if panelNum == 1 {
		ui.d2ToggleAppFunctions.opt("-hidden")
		this_panelObjects := ui.d2Panel1Objects
		other_panelObjects := ui.d2Panel2Objects
	} else {
		ui.d2ToggleAppFunctions.opt("hidden")
		this_panelObjects := ui.d2Panel2Objects
		other_panelObjects := ui.d2Panel1Objects
		try {
			ui.labelName1.opt("x215 y46 w100 h17 background" cfg.themePanel4Color)
			ui.labelName3.opt("x320 y46 w80 h19 background" cfg.themePanel2Color)
		}
	}
	
	for panelObj in this_panelObjects {
		panelObj.opt("hidden")
	}
	
	for panelObj in other_panelObjects {
		panelObj.opt("-hidden")
	}
}

d2drawTopPanel(*) {
	ui.d2TopPanelBg := ui.gameSettingsGui.addText("x7 y4 w481 h66 background" cfg.themePanel1Color,"")
	drawOutlineNamed("d2AlwaysRunOutline",ui.gameSettingsGui,6,3,484,69,cfg.themeBright2Color,cfg.themeBright1Color,1)
}


d2drawPanel4(*) {
	tileSize:=90
	
	ui.gameTabs.useTab("InfoGFX")
	ui.gameSettingsGui.addText("x8 y5 w480 h144 background" cfg.themePanel1Color,"")
	ui.gameSettingsGui.addText("x10 y7 w476 h140 c" cfg.themePanel1Color " background" cfg.themePanel4Color)
	drawOutlineNamed("d2linkPanel",ui.gameSettingsGui,8,5,480,144,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1)
	drawOutlineNamed("d2AlwaysRunOutline",ui.gameSettingsGui,10,7,476,140,cfg.themeBorderLightColor,cfg.themeBorderDarkColor,1)
	ui.gameSettingsGui.addText("hidden x19 y21 section")
	ui.d2LaunchGlyphsbuttonBg				:= ui.gameSettingsGui.addText("x+0 y+0 section w" tileSize " h" tileSize " background" cfg.themeBright1Color)
	ui.d2LaunchGlyphsbutton				:= ui.gameSettingsGui.addPicture("x+-" (tileSize) " ys+2 w" tileSize " h" tileSize " backgroundTrans","./img/d2_glyphs_thumb.png")
	ui.d2LaunchRunesButtonBg			:= ui.gameSettingsGui.addText("x+15 ys w" tileSize " h" tileSize " background" cfg.themeBright1Color)
	ui.d2LaunchRunesButton			:= ui.gameSettingsGui.addPicture("x+-" (tileSize) " ys+2 w" tileSize " h" tileSize " backgroundTrans","./img/d2_runes_thumb.png")
	ui.d2LaunchWish3ButtonBg 		:= ui.gameSettingsGui.addText("x+15 ys w" tileSize " h" tileSize " background" cfg.themeBright1Color)
	ui.d2LaunchWish3Button 		:= ui.gameSettingsGui.addPicture("x+-44 ys+2 w" tileSize " h" tileSize " backgroundTrans","./img/d2_wishCodes_thumb.png")
	; ui.d2LaunchWish4ButtonBg 		:= ui.gameSettingsGui.addText("x+15 ys w" tileSize " h" tileSize " background" cfg.themeBright1Color)
	; ui.d2LaunchWish4Button 		:= ui.gameSettingsGui.addPicture("x+-44 ys+2 w" tileSize " h" tileSize " backgroundTrans","./img/d2_numbersOfPowerEmblem_thumb.png")

	; ui.d2LaunchWish1ButtonBg 			:= ui.gameSettingsGui.addText("x+17 ys w" tileSize " h" tileSize " background" cfg.themeBright1Color)
	; ui.d2LaunchWish1Button 			:= ui.gameSettingsGui.addPicture("x+-44 ys+2 w" tileSize " h" tileSize " backgroundTrans","./img/d2_Glyphs.png")
	; ui.d2LaunchWish2ButtonBg 			:= ui.gameSettingsGui.addText("x+15 ys w" tileSize " h" tileSize " background" cfg.themeBright1Color)
	; ui.d2LaunchWish2Button 			:= ui.gameSettingsGui.addPicture("x+-44 ys+2 w" tileSize " h" tileSize " backgroundTrans","./img/d2_MorgethBridge.png")
}

d2drawPanel3(*) {
	static xPos:=15
	static yPos:=82
	
	cfg.button_link1:=["DIM","URL","https://destinyitemmanager.com","./img/button_DIM.png"]
	cfg.button_link2:=["Glyphs","Function","toggleGlyphWindow","./img/d2_glyphs_thumb.png"]
	cfg.button_link3:=["Runes","Function","toggleRuneWindow","./img/d2_runes_thumb.png"]
	cfg.button_link4:=["WishCodes","Function","toggleCodeWindow","./img/d2_wishCodes_thumb.png"]
	cfg.button_link5:=["Vault","Function","toggleVaultMode","./img/d2_button_unbound.png"]
	cfg.button_link6:=["Glyphs","Function","toggleGlyphWindow","./img/d2_button_unbound.png"]
	cfg.button_link7:=["Runes","Function","toggleGlyphWindow","./img/d2_button_unbound.png"]
	cfg.button_link8:=["Vault","Function","toggleVaultMode","./img/d2_button_unbound.png"]
	ui.button_link1:=""
	ui.button_link2:=""
	ui.button_link3:=""
	ui.button_link4:=""
	ui.button_link5:=""
	ui.button_link6:=""
	ui.button_link7:=""
	ui.button_link8:=""
	
	cfg.button_link_size:=54
	ui.gameTabs.useTab("Gameplay")
	ui.gameSettingsGui.addText("x7 y75 w485 h70 background" cfg.themePanel1Color,"")
	ui.gameSettingsGui.addText("x11 y79 w475 h61 c" cfg.themePanel1Color " background" cfg.themePanel2Color)
	drawOutlineNamed("d2linkPanel",ui.gameSettingsGui,12,80,474,60,cfg.themeDark2Color,cfg.themeBright2Color,1)
	drawOutlineNamed("d2linkPanel",ui.gameSettingsGui,6,74,486,72,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,1)
	drawOutlineNamed("d2AlwaysRunOutline",ui.gameSettingsGui,7,75,484,70,cfg.themeBorderLightColor,cfg.themeBorderDarkColor,1)	
	
	loop 8 {
		ui.button_link%a_index%:=ui.gameSettingsGui.addPicture("x" xPos+1 " y" yPos+1 " w" cfg.button_link_size-2 " h" cfg.button_link_size-2 " vbutton_link" a_index " background" cfg.themePanel4Color,cfg.button_link%a_index%[4])
		drawOutline(ui.gameSettingsGui,xPos,yPos,cfg.button_link_size,cfg.button_link_size,cfg.themeDark2Color,cfg.themeDark1Color,1)
		drawOutline(ui.gameSettingsGui,xPos+1,yPos+1,cfg.button_link_size-2,cfg.button_link_size-2,cfg.themeBright2Color,cfg.themeDark2Color,1)
		this_action:=cfg.button_link%a_index%[3]
		if cfg.button_link%a_index%[2]=="URL" {
			ui.button_link%a_index%.onEvent("click",openUrl)
		} else {
			ui.button_link%a_index%.onEvent("click",%this_action%)
		}
		xPos+=cfg.button_link_size+5

	}
	openUrl(this_Url,*) {
		run("chrome.exe " cfg.%this_Url.name%[3])
	}
	
		

	;ui.gameSettingsGui.addText("hidden x219 y21 section")
	; ui.d2LaunchDIMbuttonBg				:= ui.gameSettingsGui.addText("x85 y85 w50 h50 background" cfg.themeButtonReadyColor)
	; ui.d2LaunchDIMbutton				:= ui.gameSettingsGui.addPicture("x81 y81 w56 h56 backgroundTrans","./img/button_DIM.png")
	; drawOutline(ui.gameSettingsGui,85,85,50,50,cfg.themeBright1Color,cfg.themeDark1Color,1)
	; ui.d2Launchd2FoundryButtonBg 			:= ui.gameSettingsGui.addText("x140 y85 w50  h50 background" cfg.themeButtonReadyColor)
	; ui.d2Launchd2FoundryButton 			:= ui.gameSettingsGui.addPicture("x136 y81 w56 h56 backgroundTrans",".\Img\button_glyph.png")
	; drawOutline(ui.gameSettingsGui,140,85,50,50,cfg.themeBright1Color,cfg.themeDark1Color,1)
	; ui.d2LaunchBrayTechButtonBg 			:= ui.gameSettingsGui.addText("x195 y85 w50  h50 vBrayTechButtonBg background" cfg.themeButtonReadyColor)
	; ui.d2LaunchBrayTechButton 			:= ui.gameSettingsGui.addPicture("x191 y81 w56  h56 vBrayTechButton backgroundTrans","./img/button_braytech.png")
	; drawOutline(ui.gameSettingsGui,195,85,50,50,cfg.themeBright1Color,cfg.themeDark1Color,1)
	; ui.d2LaunchVaultCleanerButtonBg			:= ui.gameSettingsGui.addText("x250 y85 w50  h50 background" cfg.themeButtonReadyColor)
	; ui.d2LaunchVaultCleanerButton			:= ui.gameSettingsGui.addPicture("x246 y81 w56 h56 backgroundTrans","./img/button_vault_up.png")
	; drawOutline(ui.gameSettingsGui,250,85,50,50,cfg.themeBright1Color,cfg.themeDark1Color,1)
	; ui.d2LaunchLightGGButtonBg 		:= ui.gameSettingsGui.addText("x305 y85 w50  h50 background" cfg.themeButtonReadyColor)
	; ui.d2LaunchLightGGButton 		:= ui.gameSettingsGui.addPicture("x301 y81 w56  h56 backgroundTrans","./img/button_LightGG.png")
	; drawOutline(ui.gameSettingsGui,305,85,50,50,cfg.themeBright1Color,cfg.themeDark1Color,1)
	; ui.d2LaunchD2CheckListButtonBg 		:= ui.gameSettingsGui.addText("x360 y85 w50  h50 background" cfg.themeButtonReadyColor)
	; ui.d2LaunchD2CheckListButton 		:= ui.gameSettingsGui.addPicture("x356 y81 w56  h56 backgroundTrans","./img/button_d2CheckList.png")
	; drawOutline(ui.gameSettingsGui,360,85,50,50,cfg.themeBright1Color,cfg.themeDark1Color,1)
	; ui.d2LaunchDestinyTrackerButtonBg 	:= ui.gameSettingsGui.addText("hidden x+5 ys w46  h46 background" cfg.themeButtonReadyColor)
	; ui.d2LaunchDestinyTrackerButton 	:= ui.gameSettingsGui.addPicture("hidden x+-50 ys-3 w53  h53 backgroundTrans","./img/button_DestinyTracker.png")
}
	
	



d2KeybindTabChange(this_button,*) {
}
	
drawKeybind(x,y,bindName,labelText := bindName,gui := ui.mainGui,w := 84,h := 30,buttonImage := "./img/keyboard_key_up.png",textJustify := "center",fontColorReady := cfg.themeButtonAlertColor,fontColorOn := cfg.themeButtonOnColor) {
	global
	%bindName%Key := gui.addPicture("x" x " y" y " w" w " h" h " section backgroundTrans",buttonImage)
	%bindName%KeyData := gui.addText("xs-3 y+-24 w" w " h" h-9 " textJustify c" fontColorOn " backgroundTrans",subStr(strUpper(cfg.d2%bindName%Key),1,8))
	%bindName%KeyLabel := gui.addText("xs-1 y+-34 w" w " h" h-10 " textJustify c" fontColorReady " backgroundTrans",labelText)
}
		
	d2ClassIconUpChanged(*) {
		switch cfg.d2CharacterClass {
			case 1:
				cfg.d2CharacterClass := 2
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img/d2ClassIconHunter_on.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconHunter_off.png"
			case 2:
				cfg.d2CharacterClass := 3
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.dappSwordFlyKey,d2SwordFly)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img/d2ClassIconTitan_on.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconTitan_off.png"
			case 3: 
				cfg.d2CharacterClass := 1
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.dappSwordFlyKey,d2MorgethWarlock)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_on.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_off.png"
			default:                                          
		}
	}
	
	d2ClassIconDownChanged(*) {
		switch cfg.d2CharacterClass {
			case 3:
				cfg.d2CharacterClass := 2
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img/d2ClassIconHunter_on.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconHunter_off.png"
			case 1:
				cfg.d2CharacterClass := 3
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.dappSwordFlyKey,d2SwordFly)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img/d2ClassIconTitan_on.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconTitan_off.png"
			case 2: 
				cfg.d2CharacterClass := 1
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.dappSwordFlyKey,d2MorgethWarlock)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_on.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_off.png"
			default:                                          
		}
	}		


gameTabChanged(*) {
	cfg.activeGameTab := ui.gametabs.value
	drawGameTabs(ui.gameTabs.value)
	guiVis(ui.gameTabGui,true)
	;tabsChanged()
}

drawGameTabs(tabNum := 1) {
	ui.gameTabWidth := 0
	try	 
		ui.gameTabGui.destroy()
	ui.gameTabGui := gui()
	ui.gameTabGui.opt("-caption toolWindow alwaysOnTop +E0x20 owner" ui.gameSettingsGui.hwnd)
	ui.gameTabGui.backColor := ui.transparentColor
	ui.gameTabGui.color := ui.transparentColor
	drawOutlineNamed("gameTabOutline",ui.gameTabGui,0,0,495,29
		,cfg.themeBright1Color,cfg.themeBright1Color,2)
	
	winSetTransColor(ui.transparentColor,ui.gameTabGui)
			;drawOutlineNamed("gameTabs",ui.gameTabGui,ui.gameTabWidth-0,0,498-ui.gameTabWidth,32,cfg.themeBright1Color,cfg.themeDark1Color,1)
	ui.gameTabGui.addText("x1 y0 w0 h27 section background" cfg.themeBright1Color,"")
	((tabNum == 1)
		? ui.gameTab1SkinOutline := ui.gameTabGui.addText("section x0 y0 w94 h32 background" cfg.themeBright1Color,"" )
		: ui.gameTab1SkinOutline := ui.gameTabGui.addText("section x0 y2 w94 h30 background" cfg.themeDark2Color,""))
	ui.gameTab1Skin := ui.gameTabGui.addText(
		((tabNum == 1) 
			? "y0 h30" 
			: "y2 h28")
				" x2 w88  background" 
		((tabNum == 1) 
			? cfg.themePanel2Color 
			: cfg.themePanel1Color) 
		" c" ((tabNum == 1) 
			? cfg.themeFont2Color
			: cfg.themeFont1Color)
		,"")
	ui.gameTab1Skin.setFont((tabNum == 1 
		? "s14" 
		: "s12"),"Impact")
	ui.gameTab1Label := ui.gameTabGui.addText(
		((tabNum == 1) 
			? "ys2 h28" 
			: "ys2 h28")
				" x+-90 w90 center backgroundTrans c" 
		((tabNum == 1) 
			? cfg.themeFont1Color 
			: cfg.themeFont4Color)
				,"Gameplay")
	ui.gameTab1Label.setFont((tabNum == 1 
		? "s14" 
		: "s12")
			,"Impact")
	ui.gameTabWidth += 92
	((tabNum == 1 || tabNum == 2)
		? ui.gameTabGui.addText("y0 x90 w2 h34 background" cfg.themeBright1Color,"")
		: ui.gameTabGui.addText("y2 x90 w2 h30 background" cfg.themeDark2Color,""))
	((tabNum == 2)
		? ui.gameTab2SkinOutline := ui.gameTabGui.addText("x92 y0 w122 h32 background" cfg.themeBright1Color,"" )
		: ui.gameTab2SkinOutline := ui.gameTabGui.addText("x92 y2 w122 h30 background" cfg.themeDark2Color,""))
	ui.gameTab2Skin := ui.gameTabGui.addText(
		((tabNum == 2) 
			? "y0 h30" 
			: "y2 h28")
				" x92 w120 center background" 
		((tabNum == 2) 
			? cfg.themePanel2Color 
			: cfg.themePanel1Color)
				" c" ((tabNum == 2)
			? cfg.themeFont1Color 
			: cfg.themeFont4Color)
				,"")
	ui.gameTab2Skin.setFont(
		((tabNum == 2)
			? "s14" 
			: "s12")
			,"Impact")
	ui.gameTab2Label := ui.gameTabGui.addText(
		((tabNum == 2) 
			? "y2 h26" 
			: "y5 h32")
		" x92 w120 center backgroundTrans c" 
		((tabNum == 2)
		? cfg.themeFont1Color 
			: cfg.themeFont4Color)
		,"Vault Cleaner")
	ui.gameTab2Label.setFont(
		((tabNum == 2)
			? "s14" 
			: "s12")
		,"Impact")
	ui.gameTabWidth += 102	
	((tabNum == 2 || tabNum == 3)
		? ui.gameTabGui.addText("y0 x212 w2 h34 background" cfg.themeBright1Color,"")
		: ui.gameTabGui.addText("y2 x212 w2 h30 background" cfg.themeDark2Color,""))
	((tabNum == 3)
		? ui.gameTab3SkinOutline := ui.gameTabGui.addText("x214 y0 w86 h32 background" cfg.themeBright1Color,"" )
		: ui.gameTab3SkinOutline := ui.gameTabGui.addText("x214 y2 w86 h32 background" cfg.themeDark2Color,""))
	ui.gameTab3Skin := ui.gameTabGui.addText(
		((tabNum == 3) 
			? "y0 h30" 
			: "y2 h28")
				" x214 w84 center background" 
		((tabNum == 3) 
			? cfg.themePanel2Color 
			: cfg.themePanel1Color)
				" c" ((tabNum == 3)
			? cfg.themeFont1Color 
			: cfg.themeFont4Color)
				,"")
	ui.gameTab3Skin.setFont(
		((tabNum == 3)
			? "s14" 
			: "s12")
			,"Impact")
	ui.gameTab3Label := ui.gameTabGui.addText(
		((tabNum == 3) 
			? "y2 h28" 
			: "y5 h32")
		" x214 w84 center backgroundTrans c" 
		((tabNum == 3)
		? cfg.themeFont1Color 
			: cfg.themeFont4Color)
		,"Mouse")
	ui.gameTab3Label.setFont(
		((tabNum == 3)
			? "s14" 
			: "s12")
		,"Impact")
	ui.gameTabWidth += 86
	((tabNum == 3 || tabNum == 4)
		? ui.gameTabGui.addText("y0 x298 w2 h34 section background" cfg.themeBright1Color,"")
		: ui.gameTabGui.addText("y2 x298 w2 h30 section background" cfg.themeDark2Color,""))
	((tabNum == 4)
		? ui.gameTab4SkinOutline := ui.gameTabGui.addText("x300 y0 w70 h32 background" cfg.themeBright1Color,"" )
		: ui.gameTab4SkinOutline := ui.gameTabGui.addText("x300 y2 w70 h32 background" cfg.themeDark2Color,""))
	ui.gameTab4Skin := ui.gameTabGui.addText(
		((tabNum == 4) 
			? "y0 h30" 
			: "y2 h28")
				" x300 w70 center background" 
		((tabNum == 4) 
			? cfg.themePanel2Color 
			: cfg.themePanel1Color)
				" c" ((tabNum == 4)
			? cfg.themeFont1Color 
			: cfg.themeFont4Color)
				,"")
	ui.gameTab4Skin.setFont(
		((tabNum == 4)
			? "s14" 
			: "s12")
			,"Impact")
	ui.gameTab4Label := ui.gameTabGui.addText(
		((tabNum == 4) 
			? "y2 h28" 
			: "y5 h32")
		" x300 w68 center backgroundTrans c" 
		((tabNum == 4)
		? cfg.themeFont1Color 
			: cfg.themeFont4Color)
		,"InfoGFX")
	ui.gameTab4Label.setFont(
		((tabNum == 4)
			? "s14" 
			: "s12")
		,"Impact")
	ui.gameTabWidth += 70
	((tabNum == 4)
		? ui.gameTabGui.addText("y0 x370 w2 h34 section background" cfg.themeBright1Color,"")
		: ui.gameTabGui.addText("y2 x370 w2 h30 section background" cfg.themeDark2Color,""))

	
	winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui.hwnd)
		ui.gameTabGui.addText("y2 x372 w" 498-(ui.gameTabWidth+3) " h28 background" cfg.themePanel1Color)
	if !(mainGuiX==0 && mainGuiY==0) {
		ui.gameTabGui.show("w495 h32 noActivate x" mainGuiX+34 " y" mainGuiY+183)
		
	}
	line(ui.gameTabGui,372,30,180,2,cfg.themeDark2Color)

}

MouseRemap(*) {
	 return (winActive("ahk_exe destiny2.exe"))
				?  (cfg.mouseRemapEnabled)
					? 1
					: 0
				: 0
}

; #hotIf MouseRemap()
	;forward&back mappings
 ; LCtrl & LButton::z
 ; XButton1 & LButton::z
 
 ; LCtrl & RButton::y
 ; XButton1 & RButton::y
 
 ; LCtrl & MButton::x
 ; XButton1 & MButton::x
 
 ; XButton2::LAlt
 ; #hotIf


isGameActive(*) {
	if winActive("ahk_exe Destiny2.exe")
		return 1
	else
		return 0
}

; hotIf(isGameActive)
; hotkey("XButton1",XButton1Down)
; hotkey("XButton2",XButton2Down)
; hotkey("LButton",LButtonDown)
; hotkey("RButton",RButtonDown)
; hotkey("MButton",MButtonDown)
; hotIf()

XButton1Down(*) {
	send("{" cfg.d2GameMouseBackButtonKey " down}")
	keywait("XButton1")
	send("{" cfg.d2GameMouseBackButtonKey " up")
}
XButton2Down(*) {
	send("{" cfg.d2GameMouseForwardButtonKey " down}")
	keywait("XButton2")
	send("{" cfg.d2GameMouseForwardButtonKey " up")
}
LButtonDown(*) {
	send("{" cfg.d2GameMouseLeftButtonKey " down}")
	keywait("LButton")
	send("{" cfg.d2GameMouseLeftButtonKey " up")
}
RButtonDown(*) {
	send("{" cfg.d2GameMouseRightButtonKey " down}")
	keywait("RButton")
	send("{" cfg.d2GameMouseRightButtonKey " up")
}
MButtonDown(*) {
	send("{" cfg.d2GameMouseMiddleButtonKey " down}")
	keywait("MButton")
	send("{" cfg.d2GameMouseMiddleButtonKey " up")
}

ui.d2Log									:= ui.gameSettingsGui.addText("x405 y10 w68 h80 hidden background" cfg.themePanel3color " c" cfg.themeFont3color," Destiny 2`n Log Started`n Waiting for Input")
ui.d2Log.setFont("s7","ariel")


toggleCodeWindow(lparam,*) {
	static codeWindowVisible := false
		(codeWindowVisible := !codeWindowVisible)
			? showCodeWindow()
			: hideCodeWindow() 
}
	
showCodeWindow(*) {
	ui.codesArr:=["ShuroChi","MorgethBridge","CorruptedEggs","Glyphs","Runes","NumbersOfPowerEmblem"]
	ui.codeImageSize:=80
	
	;ui.d2LaunchBrayTechButton.value := "./img/button_brayTech_down.png"
	d2wwCodesGuiHwnd := false
	try 
		d2wwCodesGuiHwnd := ui.d2wwCodesGui.hwnd
	
	if !d2wwCodesGuiHwnd {
		ui.d2wwCodesGui := gui()
		ui.d2wwCodesGui.opt("alwaysOnTop -caption toolWindow owner" ui.mainGui.hwnd)
		ui.d2wwCodesGui.backColor := "080203"
		winSetTransColor("080203",ui.d2wwCodesGui)
		numColumns:=3
		tileNum:=1
		;msgBox(tileNum "," ui.codesArr[tileNum])
		ui.%ui.codesArr[tileNum]%Tile:=ui.d2wwCodesGui.addPicture("section x5 y30 w400 h400 v" ui.codesArr[tileNum] " backgroundTrans","./img/d2_" ui.codesArr[tileNum] ".png")
		ui.%ui.codesArr[tileNum]%Tile.onEvent("click",viewCode)
		while tileNum < ui.codesArr.length {
			if mod(tileNum,numColumns)==0 {	
				tileNum+=1				
				;msgBox(tileNum "," ui.codesArr[tileNum])
				ui.%ui.codesArr[tileNum]%Tile:=ui.d2wwCodesGui.addPicture("section xs+0 y+0 w400 h400 v" ui.codesArr[tileNum] " backgroundTrans","./img/d2_" ui.codesArr[tileNum] ".png")
			} else {
				tileNum+=1
				;msgBox(tileNum "," ui.codesArr[tileNum])
				ui.%ui.codesArr[tileNum]%Tile:=ui.d2wwCodesGui.addPicture("x+0 ys+0 w400 h400 v" ui.codesArr[tileNum] " backgroundTrans","./img/d2_" ui.codesArr[tileNum] ".png")
				
			}
			ui.%ui.codesArr[tileNum]%Tile.onEvent("click",viewCode)
		}

				
		
	}
	viewCode(this_code,*) {
		try 
			destroy ui.codeWindow
		ui.codeWindow:=gui()
		ui.codeWindow.opt("-caption -border toolWindow alwaysOnTop")
		ui.codeWindow.backColor:="010203"
		ui.codeWindow.color:="010203"
		;msgBox(this_code.name)
		ui.fullSizedCode:=ui.codeWindow.addPicture("x0 y20 w1200 h-1 v" this_code.name,"./img/d2_" this_code.name ".png")
		ui.fullSizedCode.onEvent("click",closeCode)
		ui.codeWindow.show()
		
		closeCode(this_code,*) {
			try
				ui.codeWindow.destroy()
		}
	}

		
		
	;ui.d2wwCodeImg := ui.d2wwCodesGui.addPicture("x20 y20 w800 h600","./img/d2CodeMorgeth.png")
	ui.d2CodeTitlebar:=ui.d2wwCodesGui.addText("x5 y0 w1200 h30 background" cfg.themeBackgroundColor)
	ui.d2CodeExit := ui.d2wwCodesGui.addPicture("x1175 y0 w30 h30 background" cfg.themePanel3Color,"./img/button_quit.png")
	ui.d2CodeExit.onEvent("click",hideCodeWindow)
	;ui.d2wwCodeImg.onEvent("click",WM_LBUTTONDOWN_callback)
	
	ui.d2wwCodesGui.show()
}																																																																																																																																																																																																																				

hideCodeWindow(*) {
	;ui.d2LaunchBrayTechButton.value := "./img/button_brayTech.png"
	try
		ui.d2wwCodesGui.destroy()
}
	
keyBindDialogBox(Msg,Alignment := "Center") {
	Global
	if !InStr("LeftRightCenter",Alignment)
		Alignment := "Left"
	Transparent := 250
	
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Bind Key"

	ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow +Owner" ui.mainGui.hwnd)  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := cfg.ThemePanel1Color  ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.SetFont("s12")  ; Set a large font size (32-point).
	ui.notifyGui.AddText("c" cfg.ThemeButtonOnColor " " Alignment " BackgroundTrans","Press desired key to use for: ")
	ui.notifyGui.setFont("s14")
	ui.notifyGui.addText("ys-4 x+0 c" cfg.themeButtonAlertColor,Msg)
	ui.notifyGui.setFont("s13 c" cfg.themeButtonOnColor,"Courier Narrow Bold")
	ui.notifyGui.addText("xs y+0","Or click target with desired mouse button")  ; XX & YY serve to 00auto-size the window.
	ui.mouseBindingTarget := ui.notifyGui.addPicture("x+15 y+-18 w25 h25 backgroundTrans",".\img\button_keyBindTarget.png")
	ui.mouseBindingTarget.onEvent("click",keybindMouseButtonClicked)
	ui.mouseBindingTarget.onEvent("doubleClick",keybindMouseButtonClicked)
	ui.notifyGui.AddText("xs hidden")
	
	keybindMouseButtonClicked(obj,msg*) {
		msgBox(obj.id "`n" msg[1])
	}
	WinSetTransparent(0,ui.notifyGui)
	ui.notifyGui.Show("NoActivate Autosize")  ; NoActivate avoids deactivating the currently active window.
	ui.notifyGui.GetPos(&x,&y,&w,&h)
	
	winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui.hwnd)
	ui.notifyGui.Show("x" (GuiX+(GuiW/2)-(w/2)) " y" GuiY+(100-(h/2)) " NoActivate")
	drawOutlineNotifyGui(1,1,w,h,cfg.ThemeBorderDarkColor,cfg.ThemeBorderLightColor,2)
	drawOutlineNotifyGui(2,2,w-4,h-4,cfg.ThemeBright2Color,cfg.ThemeBright2Color,1)
	
	Transparency := 0
	guiVis(ui.mainGui,false)
	guiVis(ui.gameSettingsGui,false)
	guiVis(ui.gameTabGui,false)
	While Transparency < 253 {
		Transparency += 5
		WinSetTransparent(Round(Transparency),ui.notifyGui)
	}
}

keyBindDialogBoxClose(*)
{
	Global
	Try
		ui.notifyGui.Destroy()
	guiVis(ui.mainGui,true)
	guiVis(ui.gameSettingsGui,true)
	guiVis(ui.gameTabGui,true)
}

d2GameHoldToCrouchKeyClicked(*) {
	tmpCrouchKey := ""
	keyBindDialogBox('HoldToCrouch',"Center")
	Sleep(100)
	global d2GameHoldToCrouchKeyInput := InputHook("L1 T6",inputHookAllowedKeys,"+V")
	d2GameHoldToCrouchKeyInput.start()
	d2GameHoldToCrouchKeyInput.wait()
	if (d2GameHoldToCrouchKeyInput.endKey == "" && d2GameHoldToCrouchKeyInput.input =="") {
		keyBindDialogBoxClose()
		notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
	} else {
		if (d2GameHoldToCrouchKeyInput.input)
		{
			tmpCrouchKey := d2GameHoldToCrouchKeyInput.input
		} else {
			tmpCrouchKey := d2GameHoldToCrouchKeyInput.endKey
		}
	}
	keyBindDialogBoxClose()
	cfg.d2GameHoldToCrouchKey := tmpCrouchKey
	ui.d2GameHoldToCrouchKeyData.text := subStr(strUpper(cfg.d2GameHoldToCrouchKey),1,8)
	d2CreateLoadoutKeys()
	d2RedrawUI()
}

	dappHoldToCrouchKeyClicked(*) {
		tmpCrouchKey := ""
		keyBindDialogBox('HoldToCrouch',"Center")
		Sleep(100)
		global dappHoldToCrouchKeyInput := InputHook("L1 T6",inputHookAllowedKeys,"+V")
		dappHoldToCrouchKeyInput.start()
		dappHoldToCrouchKeyInput.wait()
		if (dappHoldToCrouchKeyInput.endKey == "" && dappHoldToCrouchKeyInput.input =="") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (dappHoldToCrouchKeyInput.input)
			{
				tmpCrouchKey := dappHoldToCrouchKeyInput.input
			} else {
				tmpCrouchKey := dappHoldToCrouchKeyInput.endKey
			}
		}
		keyBindDialogBoxClose()
		cfg.dappHoldToCrouchKey := tmpCrouchKey
		ui.dappHoldToCrouchKeyData.text := subStr(strUpper(cfg.dappHoldToCrouchKey),1,8)
		ui.dappHoldToCrouchKey.opt("w" ui.d2KeybindWidth + max(0,(strLen(ui.dappHoldToCrouchKeyData.text)-6))*10)
		ui.dappHoldToCrouchKeyData.opt("w" ui.d2KeybindWidth + max(0,(strLen(ui.dappHoldToCrouchKeyData.text)-6))*10)
		ui.dappHoldToCrouchKeyLabel.opt("w" ui.d2KeybindWidth + max(0,(strLen(ui.dappHoldToCrouchKeyData.text)-6))*10)
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}
	
	dappSwordFlyKeyClicked(*) {
		tmpCrouchKey := ""
		keyBindDialogBox('Fly Macro',"Center")
		Sleep(100)
		global dappSwordFlyKeyInput := InputHook("L1 T6",inputHookAllowedKeys,"+V")
		dappSwordFlyKeyInput.start()
		dappSwordFlyKeyInput.wait()
		if (dappSwordFlyKeyInput.endKey == "" && dappSwordFlyKeyInput.input =="") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (dappSwordFlyKeyInput.input)
			{
				tmpdappSwordFlyKey := dappSwordFlyKeyInput.input
			} else {
				tmpdappSwordFlyKey := dappSwordFlyKeyInput.endKey
			}
		}
		keyBindDialogBoxClose()
		cfg.dappSwordFlyKey := tmpdappSwordFlyKey
		ui.dappSwordFlyKeyData.text := subStr(strUpper(cfg.dappSwordFlyKey),1,8)
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}	
	
	dappReloadKeyClicked(*) {
		tmpdappReloadKey := ""
		keyBindDialogBox('HoldToCrouch',"Center")
		Sleep(100)
		global dappReloadKeyInput := InputHook("L1 T6",inputHookAllowedKeys,"+V")
		dappReloadKeyInput.start()
		dappReloadKeyInput.wait()
		if (dappReloadKeyInput.endKey == "" && dappReloadKeyInput.input =="") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (dappReloadKeyInput.input)
			{
				tmpdappReloadKey := dappReloadKeyInput.input
			} else {
				tmpdappReloadKey := dappReloadKeyInput.endKey
			}
		}
		keyBindDialogBoxClose()
		cfg.dappReloadKey := tmpdappReloadKey
		ui.dappReloadKeyData.text := subStr(strUpper(cfg.dappReloadKey),1,8)
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}

	dappLoadoutKeyClicked(*) {
		keyBindDialogBox('Loadout Modifier',"Center")
		Sleep(100)
		dappLoadoutKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		dappLoadoutKeyInput.start()
		dappLoadoutKeyInput.wait()
		if (dappLoadoutKeyInput.endKey == "" && dappLoadoutKeyInput.input == "") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (dappLoadoutKeyInput.input)
			{
				cfg.dappLoadoutKey := dappLoadoutKeyInput.input
			} else {
				cfg.dappLoadoutKey := dappLoadoutKeyInput.endKey
			}
			ui.dappLoadoutKeyData.text := subStr(strUpper(cfg.dappLoadoutKey),1,8)
		}
		keyBindDialogBoxClose()
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}

	d2GameToggleSprintKeyClicked(*) {
		keyBindDialogBox('Hold to Walk',"Center")
		Sleep(100)
		d2GameToggleSprintKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		d2GameToggleSprintKeyInput.start()
		d2GameToggleSprintKeyInput.wait()
		if (d2GameToggleSprintKeyInput.endKey == "" && d2GameToggleSprintKeyInput.input == "") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2GameToggleSprintKeyInput.input)
			{
				cfg.d2GameToggleSprintKey := d2GameToggleSprintKeyInput.input
			} else {
				cfg.d2GameToggleSprintKey := d2GameToggleSprintKeyInput.endKey
			}
			ui.d2GameToggleSprintKeyData.text := subStr(strUpper(cfg.d2GameToggleSprintKey),1,8)
		}
		keyBindDialogBoxClose()
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}

	dappToggleSprintKeyClicked(*) {
		keyBindDialogBox('Toggle Walk',"Center")
		Sleep(100)
		dappToggleSprintKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		dappToggleSprintKeyInput.start()
		dappToggleSprintKeyInput.wait()
		if (dappToggleSprintKeyInput.endKey == "" && dappToggleSprintKeyInput.input == "") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (dappToggleSprintKeyInput.input)
			{
				cfg.dappToggleSprintKey := dappToggleSprintKeyInput.input
			} else {
				cfg.dappToggleSprintKey := dappToggleSprintKeyInput.endKey
			}
			ui.dappToggleSprintKeyData.text := subStr(strUpper(cfg.dappToggleSprintKey),1,8)
		}
		keyBindDialogBoxClose()
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}

	dappPauseKeyClicked(*) {
		DialogBox('Assign key for: `n"Reload"',"Center")
		Sleep(100)
		dappPauseKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		dappPauseKeyInput.start()
		dappPauseKeyInput.wait()
		if (dappPauseKeyInput.endKey == "" && dappPauseKeyInput.input == "") {
			DialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (dappPauseKeyInput.input)
			{
				cfg.dappPauseKey := dappPauseKeyInput.input
			} else {
				cfg.dappPauseKey := dappPauseKeyInput.endKey
			}
			ui.dappPauseKeyData.text := subStr(strUpper(cfg.dappPauseKey),1,8)
		}
		DialogBoxClose()
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}	
	
	d2GameReloadKeyClicked(*) {
		DialogBox('Assign key for: `n"Reload"',"Center")
		Sleep(100)
		d2GameReloadKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		d2GameReloadKeyInput.start()
		d2GameReloadKeyInput.wait()
		if (d2GameReloadKeyInput.endKey == "" && d2GameReloadKeyInput.input == "") {
			DialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2GameReloadKeyInput.input)
			{
				cfg.d2GameReloadKey := d2GameReloadKeyInput.input
			} else {
				cfg.d2GameReloadKey := d2GameReloadKeyInput.endKey
			}
			ui.d2GameReloadKeyData.text := subStr(strUpper(cfg.d2GameReloadKey),1,8)
		}
		DialogBoxClose()
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}
	
	d2GameGrenadeKeyClicked(*) {
		DialogBox('Assign key for: `n"Grenade"',"Center")
		Sleep(100)
		d2GameGrenadeKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		d2GameGrenadeKeyInput.start()
		d2GameGrenadeKeyInput.wait()
		if (d2GameGrenadeKeyInput.endKey == "" && d2GameGrenadeKeyInput.input == "") {
			DialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2GameGrenadeKeyInput.input)
			{
				cfg.d2GameGrenadeKey := d2GameGrenadeKeyInput.input
			} else {
				cfg.d2GameGrenadeKey := d2GameGrenadeKeyInput.endKey
			}
			ui.d2GameGrenadeKeyData.text := subStr(strUpper(cfg.d2GameGrenadeKey),1,8)
		}
		DialogBoxClose()
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}
	
	d2GameSuperKeyClicked(*) {
		DialogBox('Assign key for: `n"Super"',"Center")
		Sleep(100)
		d2GameSuperKeyInput := InputHook("L1 T6", inputHookAllowedKeys,"+V")
		d2GameSuperKeyInput.start()
		d2GameSuperKeyInput.wait()
		if (d2GameSuperKeyInput.endKey == "" && d2GameSuperKeyInput.input == "") {
			DialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (d2GameSuperKeyInput.input)
			{
				cfg.d2GameSuperKey := d2GameSuperKeyInput.input
			} else {
				cfg.d2GameSuperKey := d2GameSuperKeyInput.endKey
			}
			ui.d2GameSuperKeyData.text := subStr(strUpper(cfg.d2GameSuperKey),1,8)
		}
		DialogBoxClose()
		d2CreateLoadoutKeys()
		d2RedrawUI()
	}

if (cfg.d2AlwaysRunEnabled) {
	d2ToggleAppFunctionsOn()
}

drawInfographic("vod")
drawInfographic(infographicName:="vod",imageWidth := 150,imageHeight := 150, numColumns := 5) {
	imageTypes := "png,jpg,gif,bmp"
	infographicFolder := "./img/infogfx"
	transparentColor := "030405"

	if (cfg.topDockEnabled) {
		infoGuiMon := cfg.dockbarMon
	} else { 
		winGetPos(&infoGuiX,&infoGuiY,,,ui.mainGui)
		infoGuiMon := 1
		loop monitorGetCount() {
			monitorGet(a_index,&monLeft,,&monRight,)
			if infoGuiX > monLeft && infoGuiX < monRight {
				infoGuiMon := a_index
				break
			}
		}
	}

	monitorGet(infoGuiMon,&infoGuiMonL,&infoGuiMonT,&infoGuiMonR,&infoGuiMonB)
	ui.infoGuiBg := gui()
	ui.infoGuiBg.opt("toolWindow alwaysOnTop -caption")
	ui.infoGuiBg.backColor := "454545"
	winSetTransparent(120,ui.infoGuiBg.hwnd)
	ui.infoGui := gui()
	ui.infoGui.opt("toolWindow -caption AlwaysOnTop owner" ui.gameSettingsGui.hwnd)
	ui.infoGui.backColor := transparentColor
	ui.infoGui.color := transparentColor
	;ui.infoGuiBg := ui.infoGui.addText("x0 y0 w800 h600 background" transparentColor,"")
	;ui.infoGui.addText("x0 y0 x1 y1 section background" transparentColor,"")
	winSetTransColor(transparentColor,ui.infoGui.hwnd)

	

	
;	loop files, sort(infographicFolder "/" infographicName "/*.png") {
;		ui.%infographicName%%ui.infoGui.hwnd% := ui.infoGui.addPicture("x0 y30 section w" imageWidth " h" imageHeight,infographicFolder "/" infographicName "/" a_loopFilename )

;	}
	rowNum := 0
	columnNum := 1
	fileList := array()
	
	loop files, infographicFolder "/" infographicName "/*.png" {
		fileList.push(a_loopFilename)
	}

	
	for file in fileList {
		if columnNum == 1 {
			ui.%infographicName%%a_index% := ui.infoGui.addPicture("x0 y" 30+(rowNum*imageHeight) " w" imageWidth " h" imageHeight,infographicFolder "/" infographicName "/" file)
			ui.%infographicName%%a_index%.onEvent("click",d2ClickedGlyph)
			ui.%infographicName%%a_index%.onEvent("doubleclick",d2DoubleClickedGlyph)
			rowNum +=1
		} else {	
			ui.%infographicName%%a_index% := ui.infoGui.addPicture("x" (columnNum*imageWidth)-imageWidth " y" 30+(rowNum*imageHeight)-imageHeight " w" imageWidth " h" imageHeight,infographicFolder "/" infographicName "/" file)
			ui.%infographicName%%a_index%.onEvent("click",d2ClickedGlyph)
			ui.%infographicName%%a_index%.onEvent("doubleclick",d2DoubleClickedGlyph)
		}
		columnNum += 1
		if columnNum > numColumns
			columnNum := 1
	}
	;msgBox(fileListText)
	ui.%infographicName%QuitButton := ui.infoGui.addPicture("x770 y0 w30 h30 backgroundTrans","./img/button_quit.png")
	ui.%infographicName%QuitButton.onEvent("click",closeInfographic)
		
	infoGuiWidth := numColumns*imageWidth
	infoGuiHeight := (rowNum*imageHeight)+30
	ui.infoGuiDragZone := ui.infoGuiBg.addText("x0 y0 w" infoGuiWidth " y" infoGuiHeight " background" transparentColor,"")
	winSetTransparent(0,ui.infoGuiBg.hwnd)
	winSetTransparent(0,ui.infoGui.hwnd)
	ui.infoGuiBg.show("x" ((infoGuiMonL+infoGuiMonR)/2)-(infoGuiWidth/2) " y" ((infoGuiMonT+infoGuiMonB)/2)-(infoGuiHeight/2) " w" infoGuiWidth " h" infoGuiHeight " noActivate")
	ui.infoGui.show("x" ((infoGuiMonL+infoGuiMonR)/2)-(infoGuiWidth/2) " y" ((infoGuiMonT+infoGuiMonB)/2)-(infoGuiHeight/2) " w" infoGuiWidth " h" infoGuiHeight " noActivate")
	ui.infoGui.opt("owner" ui.infoGuiBg.hwnd)
}

closeInfographic(*) {
	try 
		ui.infoGui.hide()
	try
		ui.infoGuiBg.hide()
	try
		ui.infoGui.destroy()
	try	
		ui.infoGuiBg.destroy()
}

toggleGlyphWindow(*) {
	static glyphWindowVisible := false
	(glyphWindowVisible := !glyphWindowVisible)
		? showGlyphWindow()		
		: hideGlyphWindow()
}

showGlyphWindow(*) {
	ui.glyphGui:=gui()
	ui.glyphGui.opt("-caption -border alwaysOnTop")
	ui.glyphGui.backColor:="010203"
	winSetTransColor("010203",ui.glyphGui)
	ui.glyphGuiContent:=ui.glyphGui.addPicture("","./img/d2_glyphs.png")
	ui.glyphGui.show()
	ui.glyphGuiContent.onEvent("click",toggleGlyphWindow)
}

hideGlyphWindow(*) {
	ui.glyphGui.hide()
}

toggleRuneWindow(*) {
	static runeWindowVisible := false
	(runeWindowVisible := !runeWindowVisible)
		? showruneWindow()		
		: hideruneWindow()
}

showRuneWindow(*) {
	ui.runeGui:=gui()
	ui.runeGui.opt("-caption -border alwaysOnTop")
	ui.runeGui.backColor:="010203"
	winSetTransColor("010203",ui.runeGui)
	ui.runeGuiContent:=ui.runeGui.addPicture("","./img/d2_runes.png")
	ui.runeGui.show()
	ui.runeGuiContent.onEvent("click",toggleRuneWindow)
}

hideRuneWindow(*) {
	ui.runeGui.hide()
	;ui.infoGui.hide(), ui.infoGuiBg.hide(),ui.d2Launchd2FoundryButton.value := "./img/button_glyph.png"
}

d2DoubleClickedGlyph(lparam,wparam*) {
	winActivate("ahk_exe destiny2.exe")
	d2ClickedGlyph(lparam,wparam)
	winActivate("ahk_exe destiny2.exe")
	send("{Enter}")
	sleep(500)
	send("glyph: " A_Clipboard)
	sleep(250)
	send("{Enter}")
	Sleep(500)
	send("{t}")
	sleep(500)
;	d2Launchd2FoundryButtonClicked()
}	

d2ClickedGlyph(lparam,wparam*) {
	buttonHoldTimerStart := a_now
	WM_LBUTTONDOWN_callback(lparam,wparam)
	keyWait("LButton")
	if a_now-buttonHoldTimerStart > 400
		return
	
	A_Clipboard := (subStr(strSplit(lparam.value,"/")[5],-99,-4))
	TrayTip("Copied glyph name: " a_clipboard " to clipboard")
}


drawPanelLabel(guiName,labelX,labelY,labelW := 100,labelH := 20,labelText := "needs value",backColor := "gray",outlineColor := "white",fontColor := "white") {
		guiName.setFont("s9")
		guiName.addText("x" labelX " y" labelY " w" labelW " h" labelH " background" outlineColor,"")
		guiName.setFont("s10")
		guiName.addText("x" labelX+1 " y" labelY+1 " w" labelW-2 " h" labelH-2 " background" backColor " center c" fontColor)  
		guiName.addText("x" labelX+1 " y" labelY+1 " w" labelW-2 " h" labelH " backgroundTrans center c" fontColor, labelText) 
}

ui.gametabs.useTab("222Vault Cleaner222")
	ui.gameSettingsGui.addText("x5 y3 w488 h146 background" cfg.themePanel1Color)
	drawOutlineNamed("vaultStats",ui.gameSettingsGui,9,8,480,66,cfg.themeBorderLightColor,cfg.themeBorderDarkColor,2)
	;ui.gameSettingsGui.addText("x11 y8 w118 h60 background" cfg.themePanel4Color)
	ui.gameSettingsGui.addText("x9 y8 w478 h66 background" cfg.themePanel2Color)
ui.gameSettingsGui.addText("x12 y11 w473 h18 background" cfg.themePanel2Color)
	ui.gameSettingsGui.addText("x11 y30 w475 h23 background" cfg.themePanel3Color)
	drawOutline(ui.gameSettingsGui,10,9,478,64,cfg.themeDark1Color,cfg.themeDark1Color,2)
	this.mainButtonBg:=ui.gameSettingsGui.addText("x13 y12 w46 h17 background" cfg.themeDark1Color)
	this.mainButton:=ui.gameSettingsGui.addText("section center x13 y12 w74 h17 background" cfg.themeDark1Color " c" cfg.themeFont2Color,"")
	this.mainButtonTextBg:=ui.gameSettingsGui.addText("section left x87 y12 w398 h17 background" cfg.themeBackgroundColor)
	this.mainButtonText:=ui.gameSettingsGui.addText("section center x12 y10 w74 h17 backgroundTrans","Start")
	this.mainButtonText.setFont("s13 q5 c" cfg.themeFont4Color,"Ubuntu Mono")
	;this.mainButtonHotkey:=ui.gameSettingsGui.addText("left x40 y10 background" cfg.themePanel1Color " c" cfg.themeFont3Color " h17 w67")
	this.mainButtonHotkeyText:=ui.gameSettingsGui.addText("left x93 y11 backgroundTrans c" cfg.themePanel3Color " h19 w280","Press [Del] to START")
	this.mainButtonHotkeyText.setFont("s10 c778877 q5","Ubuntu Mono")
	this.mainButton.onEvent("click",cleanVaultStart)
	this.mainButtonText.onEvent("click",cleanVaultStart)
	this.statusText:=ui.gameSettingsGui.addText("x17 y31 w470 h20 backgroundTrans c" cfg.themeFont3Color,"Toggle VAULT MODE to enable START button")
	this.statusText.setFont("s12 q5","Ubuntu Mono")
	toggleButton2(*) {
		(this.state:=!this.state)
			? vaultCleaner()
			: vault_exitFunc()
	}
	ui.gameSettingsGui.setFont("s12")
	drawOutlineNamed("vaultStats",ui.gameSettingsGui,9,78,480,66,cfg.themeBright2Color,cfg.themeBorderDarkColor,2)
	this.statBg:=ui.gameSettingsGui.addText("x11 y80 w476 h62 background" cfg.themeDark2Color)
	ui.gameSettingsGui.addText("x245 y80 w242 h62 background" cfg.themePanel4Color)
	drawOutlineNamed("vaultStats2",ui.gameSettingsGui,245,78,244,66,cfg.themeBright2Color,cfg.themeBorderDarkColor,2)
	this.pageLabel:=ui.gameSettingsGui.addText("right x370 y80 w80 h25 backgroundTrans c00FFFF","Page: ")
	this.pageCount:=ui.gameSettingsGui.addText("x420 y81 right w56 h25 c00FFFF backgroundTrans",format("{:03d}",this.page))
	this.statusHeaderLabel:=ui.gameSettingsGui.addText("x420 y81 w140 left h25 c00FFFF backgroundTrans","")
	this.elapsed:=ui.gameSettingsGui.addText("x340 y100 w80 right h25 c00FFFF backgroundTrans","Elapsed: ")
	this.elapsedTime:=ui.gameSettingsGui.addText("x420 y100 left w80 h25 c00FFFF backgroundTrans","00:00:00")
	this.remaining:=ui.gameSettingsGui.addText("x340 y120 right w80 h25 c00FFFF backgroundTrans","Remaining: ")
	this.remainingtime:=ui.gameSettingsGui.addText("x420 y120 left w80 h25 c00FFFF backgroundTrans","00:00:00")
	this.dismantledHeaderLabel:=ui.gameSettingsGui.addText("x250 y0 w110 right h25 c00FFFF backgroundTrans","")
	this.dismantledLegendaryLabel:=ui.gameSettingsGui.addText("section x255 y80  left h25 c00FFFF backgroundTrans","Legendary: ")
	this.dismantledLegendary:=ui.gameSettingsGui.addText("x+0 ys+1 left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))
	this.dismantledExoticLabel:=ui.gameSettingsGui.addText("section x255 y100 left h25 c00FFFF backgroundTrans","Exotic: ")
	this.dismantledExotics:=ui.gameSettingsGui.addText("x+0 ys+1 left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))
	this.dismantledTotalLabel:=ui.gameSettingsGui.addText("section x255 y120 left h25 c00FFFF backgroundTrans","Total: ")
	this.dismantledTotal:=ui.gameSettingsGui.addText("x+0 ys+1 left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))
	this.vaultProgressLabelBg:=ui.gameSettingsGui.addText("x13 y52 w74 h18 background" cfg.themeBackgroundColor " c151515","")
	this.vaultProgressLabel:=ui.gameSettingsGui.addText("x17 y51 w65 h21 backgroundTrans ccccccc","Progress")
	this.vaultProgressLabel.setFont("s13 c" cfg.themeFont4Color,"Ubuntu Mono")
	this.vaultProgress := ui.gameSettingsGui.addProgress("x87 y52 w398 h18 c" cfg.themeButtonReadyColor " background151515 range1-500")
	this.completeMsg := ui.gameSettingsGui.addText("x33 y61 w500 h30 backgroundTrans c00FFFF","")
	drawOutlineNamed("vaultCleanerButton",ui.gameSettingsGui,13,82,230,58,cfg.themeBorderLightColor,cfg.themeBorderDarkColor,2)
	this.d2LaunchVaultCleanerButton := ui.gameSettingsGui.addPicture("x9 y76 w70  h70 backgroundTrans","./img/button_vault_up.png")
	this.d2LaunchVaultCleanerButton.onEvent("click",toggleVaultMode)
	this.d2LaunchVaultCleanerText:=ui.gameSettingsGui.addText("x60 y91 w180 h50 center backgroundTrans c" cfg.themeFont1Color,'Vault Mode: Off`nClick to Toggle.')
	this.d2LaunchVaultCleanerText.setFont("s12 c" cfg.themeFont1Color " bold","Arial")
	
	isWindowedFullscreen(*) {
		static tx:=""
		static ty:=""
		static tw:=""
		static th:=""
		if !winExist(this.gameWin)
			return
		winGetPos(&tx,&ty,&tw,&th,this.gameWin)
		if winGetMinMax(this.gameWin) == 0 && a_screenwidth==tw  {
			return 1
		} else {
			return 0
		}
	}
	toggleVaultMode(*) {
		static vaultMode:=false
	
		(vaultMode:=!vaultMode) 
			? vaultModeOn()
			: vaultModeOff()
			
	}

	vaultModeOn(*) {
		;if isWindowedFullscreen() {
		if !winExist(this.gameWin) {
			notifyOSD("Game window not found. Vault mode aborted.",2000,ui.gameSettingsGui)
			vaultMode:=!vaultMode
			Return
		}
			; winActivate(this.gameWin)
			this.d2LaunchVaultCleanerButton.value:="./img/button_vault_down.png"
			this.d2LaunchVaultCleanerButton.redraw()
			this.statusText.text :="[Del] to begin clean-up."
			this.d2LaunchVaultCleanerText.text:="Vault Mode: On`nClick to Toggle"
			; winMove((a_screenwidth/2)-640,(a_screenheight/2)-360,1280,720,this.gameWin)
			; winActivate(ui.mainGui)
			vaultCleaner()
			
	;}
	}


	vaultModeOff(*) {
		if !winExist(this.gameWin) {
			notifyOSD("Vault mode not applicable.`nGame window not found.",2000,ui.gameSettingsGui)
			Return
		}
		winActivate(this.gameWin)
		this.mainButtonHotkeyText.text:="Click Vault Icon to Toggle VAULT MODE"
		this.statusText.text:="Cannot START vault cleaning when not in VAULT MODE"
		this.d2LaunchVaultCleanerButton.value:="./img/button_vault_up.png"
		; this.d2LaunchVaultCleanerButton.redraw()
		this.d2LaunchVaultCleanerText.text:="Vault Mode: Off`nClick to Toggle"
		try 
			vaultTopGui.destroy()
		winMove(0,0,a_screenwidth,a_screenHeight,this.gameWin)
		winRestore(this.gameWin)
		winActivate(ui.mainGui)
		
		
	}

	ui.gameTabs.useTab("Mouse")
	cfg.rmbBind:=iniRead(cfg.file,"Game","RButtonBind","RButton")
	cfg.lmbBind:=iniRead(cfg.file,"Game","LButtonBind","LButton")
	cfg.mmbBind:=iniRead(cfg.file,"Game","MButtonBind","MButton")
	cfg.fbBind:=iniRead(cfg.file,"Game","XButton2Bind","XButton2")
	cfg.bbBind:=iniRead(cfg.file,"Game","XButton1Bind","XButton1")
	ui.mouse_lmb:=ui.gameSettingsGui.addPicture("section x15 y10 w65 h-1 vMouseLeftButton backgroundTrans","./img/mouse_lmb.png")
	ui.mouse_rmb:=ui.gameSettingsGui.addPicture("x+35 ys w65 h-1 vMouseRightButton backgroundTrans","./img/mouse_rmb.png")
	ui.mouse_mmb:=ui.gameSettingsGui.addPicture("x+35 ys w65 h-1 vMouseMiddleButton backgroundTrans","./img/mouse_mmb.png")
	ui.mouse_bb:=ui.gameSettingsGui.addPicture("x+35 ys w65 h-1 vMouseBackButton backgroundTrans","./img/mouse_bb.png")
	ui.mouse_fb:=ui.gameSettingsGui.addPicture("x+35 ys w65 h-1 vMouseForwardButton backgroundTrans","./img/mouse_fb.png")
	ui.mouse_lmb.onEvent("click",assignMouse)
	ui.mouse_rmb.onEvent("click",assignMouse)
	ui.mouse_mmb.onEvent("click",assignMouse)
	ui.mouse_bb.onEvent("click",assignMouse)
	ui.mouse_fb.onEvent("click",assignMouse)
	
	assignMouse(this,id,*) {
		tmpMouseLeftButton:=""
		tmpMouseRightButton:=""
		tmpMouseMiddleButton:=""
		tmpMouseBackButton:=""
		tmpMouseForwardButton:=""
	
		keyBindDialogBox(this.name,"Center")
		Sleep(100)
		ih := InputHook("L1 T6",inputHookAllowedKeys,"+V")
		ih.start()
		ih.wait()
		if (ih.endKey == "" && ih.input =="") {
			keyBindDialogBoxClose()
			notifyOSD('No Key Detected.`nPlease Try Again.',2000,"Center")
		} else {
			if (ih.input)
			{
				tmp.%this.name% := ih.input
			} else {
				tmp.%this.name% := ih.endKey
			}
		}
		keyBindDialogBoxClose()
		cfg.d2Game%this.name%Key := tmp.%this.name%
		ui.%this.name%Text.text := subStr(strUpper(cfg.d2Game%this.name%Key),1,8)
	}
	
	ui.MouseLeftButtonText:=ui.gameSettingsGui.addText("section xs-13 w95 center background" cfg.themePanel2Color " c" cfg.themeFont2Color,cfg.d2GameMouseLeftButtonKey)
	ui.MouseRightButtonText:=ui.gameSettingsGui.addText("x+5 ys w95 center background" cfg.themePanel2Color " c" cfg.themeFont2Color,cfg.d2GameMouseRightButtonKey)
	ui.MouseMiddleButtonText:=ui.gameSettingsGui.addText("x+5 ys w95 center background" cfg.themePanel2Color " c" cfg.themeFont2Color,cfg.d2GameMouseMiddleButtonKey)
	ui.MouseBackButtonText:=ui.gameSettingsGui.addText("x+5 ys w95 center background" cfg.themePanel2Color " c" cfg.themeFont2Color,cfg.d2GameMouseBackButtonKey)
	ui.MouseForwardButtonText:=ui.gameSettingsGui.addText("x+5 ys w95 center background" cfg.themePanel2color " c" cfg.themeFont2Color,cfg.d2GameMouseForwardButtonKey)


;line(ui.mainGui,529,0,2,30,cfg.themeDark2Color)
line(ui.gameTabGui,495,2,2,32,cfg.themeDark2Color)
line(ui.mainGui,474,30,55,2,cfg.themePanel2Color)