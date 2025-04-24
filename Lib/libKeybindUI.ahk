#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) { ;run main app
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
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
ui.d2KeyBindHelpMsg.text := "     Assign keys you'd like to use for each function"
		labelX := 280
		labelY := 44
		labelW := 66
		labelH := 30
		ui.d2keybindGameTab1.opt("background" cfg.accentColor1)
		ui.d2keybindGameTab2.opt("background" cfg.bgColor3) 
		ui.d2keybindGameTabDetail.move(343,42,84,23)
		ui.d2Panel1Tab1Detail1.value:="./img/custom/lightburst_top_bar_dark.png"
		;ui.d2Panel1Tab1Detail2.value:="./img/custom/lightburst_bottom_bar_light.png"
		ui.d2keybindGameTab3.setFont("s8 c" cfg.fontColor3,"thin")
		ui.d2keybindGameTab1.move(345,labelY+5,89,13)
		ui.d2keybindGameTab2.move(343,labelY+9,85,13)
		ui.d2keybindGameTab3.move(343,labelY+8,84,18)

		ui.d2keybindAppTab1.opt("background" cfg.accentColor1)
		ui.d2keybindAppTab2.opt("background" cfg.bgColor0)
		ui.d2keybindAppTabDetail.move(labelX+1,42,61,23)
		ui.d2Panel1Tab2Detail1.value:="./img/custom/lightburst_top_bar_dark.png"
		;ui.d2Panel1Tab2Detail2.value:="./img/custom/lightburst_bottom_bar_light.png"
		ui.d2keybindAppTab3.setFont("s10 c" cfg.fontColor1,"bold")
		ui.d2keybindAppTab1.move(labelx+0,labelY+6,63,16)
		ui.d2keybindAppTab2.move(labelx+1,labelY+6,61,14)
		ui.d2keybindAppTab3.move(labelx,labelY+6,63,18)
		ui.d2keyBindAppTab1.redraw()
		ui.d2KeybindAppTab2.redraw()
		ui.d2KeybindAppTab3.redraw()
		ui.d2keyBindGameTab1.redraw()
		ui.d2KeybindGameTab2.redraw()
		ui.d2KeybindGameTab3.redraw()
		d2changeKeybindPanelTab(2)
	}
	
d2keybindGameTabClicked(*) {
guiName := ui.gameSettingsGui
ui.d2KeyBindHelpMsg.text := "     Configure these to mirror your in-game bindings"
		labelX := 280
		labelY := 44
		labelW := 66
		labelH := 30
		ui.d2keybindAppTab1.opt("background" cfg.accentColor1)
		ui.d2keybindAppTab2.opt("background" cfg.bgColor3) 
		ui.d2keybindAppTabDetail.move(283,41,62,24)
		ui.d2Panel1Tab1Detail1.value:="./img/custom/lightburst_top_bar_dark.png"
		;ui.d2Panel1Tab1Detail2.value:="./img/custom/lightburst_top_bar_dark.png"
		ui.d2keybindAppTab3.setFont("s8 c" cfg.fontColor3,"thin")
		ui.d2keybindAppTab1.move(281,labelY+5,68,12)
		ui.d2keybindAppTab2.move(282,labelY+9,62,13)
		ui.d2keybindAppTab3.move(283,labelY+8,,18)

		ui.d2keybindGameTab1.opt("background" cfg.accentColor1)
		ui.d2keybindGameTab2.opt("background" cfg.bgColor0)
		ui.d2keybindGameTabDetail.move(346,42,88,23)
		ui.d2Panel1Tab2Detail1.value:="./img/custom/lightburst_top_bar_dark.png"
		;ui.d2Panel1Tab2Detail2.value:="./img/custom/lightburst_top_bar_dark.png"
		
		ui.d2keybindGameTab3.setFont("s10 c" cfg.fontColor1,"bold")
		ui.d2keybindGameTab1.move(345,labelY+6,90,16)
		ui.d2keybindGameTab2.move(346,labelY+6,88,14)
		ui.d2keybindGameTab3.move(346,labelY+6,88,18)
		ui.d2keyBindAppTab1.redraw()
		ui.d2KeybindAppTab2.redraw()
		ui.d2KeybindAppTab3.redraw()
		ui.d2keyBindGameTab1.redraw()
		ui.d2KeybindGameTab2.redraw()
		ui.d2KeybindGameTab3.redraw()
		d2changeKeybindPanelTab(1)
	}


; d2keybindGameTabClicked(*) {
; guiName := ui.gameSettingsGui
		
		; ui.d2KeybindHelpMsg.text := "Configure these to mirror your in-game bindings"
		; labelX := 346
		; labelY := 44
		; labelW := 96
		; labelH := 30
		; ui.d2keybindAppTab1.opt("background" cfg.outlineColor2)
		; ui.d2keybindAppTab2.opt("background" cfg.bgColor1) 
		; ui.d2keybindAppTab3.setFont("s10 c" cfg.fontColor2,"thin")
		; ui.d2keybindAppTab1.move(280,labelY+7,70,15)
		; ui.d2keybindAppTab2.move(281,labelY+7,65,14)
		; ui.d2keybindAppTab3.move(280,labelY+6,,16)

		; ui.d2keybindGameTab1.opt("background" cfg.outlineColor1)
		; ui.d2keybindGameTab2.opt("background" cfg.bgColor0)
		; ui.d2keybindGameTab3.setFont("s10 c" cfg.fontColor1,"bold")
		; ui.d2keybindGameTab1.move(labelx+0,labelY+6,92,17)
		; ui.d2keybindGameTab2.move(labelx+1,labelY+6,90,16)
		; ui.d2keybindGameTab2.redraw()
	
		; ui.d2keybindGameTab3.move(344,labelY+6,,14)
	; d2changeKeybindPanelTab(1)
; }


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
			; ,ui.d2ClassIconSpacer
			; ,ui.d2ClassIconSpacer2
			,ui.keybindSpacer
			,ui.keybindSpacer2
			,ui.keybindSpacer3
			,ui.keybindSpacer4
			,ui.keybindSpacer5
			,ui.keybindSpacer6
			,ui.keybindSpacer7
			,ui.keybindSpacer8
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
			; ,ui.d2Panel1Tab1Bg3
			; ,ui.d2Panel1Tab1Bg4
			,ui.d2ClassSelectBg3
			,ui.d2ToggleAppFunctionsOutline
			,ui.d2Panel1Tab1Detail1
			,ui.d2ClassSelectDetail
			,ui.d2KeybindAppTab1
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
			;,ui.d2ToggleAutoGameConfigOutline
			,ui.d2Panel1Tab2Detail1
			,ui.d2Panel1Tab2Bg
			,ui.d2Panel1Tab2Bg2
			,ui.d2keybindGameTab1
			; ,ui.d2Panel1Tab2Bg3
			; ,ui.d2Panel1Tab2Bg4
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
			ui.labelName1.opt("x215 y46 w100 h17 background" cfg.bgColor3)
			ui.labelName3.opt("x320 y46 w80 h19 background" cfg.bgColor0)
		}
	}
	
	for panelObj in this_panelObjects {
		panelObj.opt("hidden")
	}
	
	for panelObj in other_panelObjects {
		panelObj.opt("-hidden")
	}
}


drawKeybindBar(*) {
	ui.gameTabs.useTab("Gameplay") 

	;ui.d2TopPanelBg := ui.gameSettingsGui.addText("x7 y4 w481 h66 background" cfg.bgColor1,"")
	;ui.d2TopPanelDetail2 := ui.gameSettingsGui.addPicture("x7 y4 w481 h66 backgroundTrans","./img/custom/lightburst_tile.png")

	;ui.d2TopPanelDetail := ui.gameSettingsGui.addPicture("x7 y4 w481 h66 backgroundTrans","./img/custom/lightburst_diag.png")
	;drawOutlineNamed("d2AlwaysRunOutline",ui.gameSettingsGui,6,3,484,69,cfg.outlineColor2,cfg.outlineColor2,1)
	

	guiName := ui.gameSettingsGui
	ui.d2KeybindWidth := 60
	labelX := 270
	labelY := 44
	labelW := 74
	labelH := 30
	backColor := cfg.bgColor3
	fontColor := cfg.fontColor2
	outlineColor := cfg.accentColor1
	labelText := "Keybinds"
	ui.d2keybindAppTab1 := guiName.addText("x" labelX " y" labelY+labelH/2 " w" labelW " h" labelH/2+3 " background" outlineColor,"")
		     
	labelX := 346
	labelY := 44
	labelW := 105
	labelH := 30
	backColor := cfg.bgColor3
	fontColor := cfg.fontColor1
	outlineColor := cfg.accentColor1
	labelText := "Game Settings"	
	
	
	ui.d2keybindGameTab1 	:= guiName.addText("x" labelX " y" labelY+labelH/2 " w" labelW-4 " h" labelH/2+3 " background" outlineColor,"")
	ui.d2Panel1Tab1Bg 		:= ui.gameSettingsGui.addText("hidden x44 y11 w437 h42 background" cfg.accentColor1,"")
	ui.d2Panel1Tab1Bg2 		:= ui.gameSettingsGui.addText("hidden x45 y12 w435 h40 background" cfg.bgColor0 " c" cfg.fontColor1,"")
	ui.d2Panel1Tab1Detail1	:= ui.gameSettingsGui.addPicture("x45 y12 w405 h15 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	;ui.d2Panel1Tab1Detail2	:= ui.gameSettingsGui.addPicture("x45 y10 w435 h15 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.d2Panel1Tab1Bg3 		:= ui.gameSettingsGui.addText("hidden x46 y13 w433 h38 background" cfg.bgColor0,"")
	ui.d2Panel1Tab1Bg4 		:= ui.gameSettingsGui.addText("hidden x47 y14 w431 h36 background" cfg.titleBgColor,"")
	
	ui.d2Panel1Tab2Bg 		:= ui.gameSettingsGui.addText("hidden x19 y11 w438 h42 background" cfg.accentColor1,"")
	ui.d2Panel1Tab2Bg2 		:= ui.gameSettingsGui.addText("hidden x20 y12 w436 h40 background" cfg.bgColor0 " c" cfg.fontColor3,"")	
	ui.d2Panel1Tab2Detail1	:= ui.gameSettingsGui.addPicture("x20 y12 w450 h15 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")	
	;ui.d2Panel1Tab2Detail2	:= ui.gameSettingsGui.addPicture("x20 y10 w450 h15 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")	
	ui.d2Panel1Tab2Bg3 		:= ui.gameSettingsGui.addText("hidden x21 y13 w434 h38 background" cfg.bgColor0,"")
	ui.d2Panel1Tab2Bg4 		:= ui.gameSettingsGui.addText("hidden x22 y14 w432 h36 background" cfg.trimColor2,"")
	;ui.d2Panel1Tab2Bg := ui.gameSettingsGui.addText("x42 y10 w406 h42 background" cfg.bgColor0 " c" cfg.fontColor4,"")	
	;drawOutlineNamed("gameSettings",ui.gameSettingsGui,43,11,404,42,cfg.accentColor1,cfg.disabledColor,1)
	ui.currKey 				:= cfg.dappPauseKey
	ui.dappPauseKey			:= ui.gameSettingsGui.addPicture("x50 y20 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappPauseKeyData 	:= ui.gameSettingsGui.addText("xs-1 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.dappPauseKey),1,8))
	ui.dappPauseKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h20 center c" cfg.fontColor1 " backgroundTrans","Pause")
	
	ui.keybindSpacer		:= ui.gameSettingsGui.addText("x113 y12 w1 h40 background" cfg.bgColor0)		
	ui.keybindSpacer2		:= ui.gameSettingsGui.addText("x114 y12 w1 h40 background" cfg.accentColor1)
	;ui.gameSettingsGui.setFont("s11","Arial")
	
	ui.currKey 				:= cfg.dappToggleSprintKey

	ui.dappToggleSprintKey		:= ui.gameSettingsGui.addPicture("x+3 y20 w" 90
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappToggleSprintKeyData 	:= ui.gameSettingsGui.addText("xs-2 y+-24 w" 90 
		" h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.dappToggleSprintKey),1,8))
	ui.dappToggleSprintKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 90 
		" h20 center c" cfg.fontColor3 " backgroundTrans","Sprint")
	
	ui.currKey := cfg.dappHoldToCrouchKey
	ui.dappHoldToCrouchKey		:= ui.gameSettingsGui.AddPicture("x+3 ys w" 60 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappHoldToCrouchKeyData 	:= ui.gameSettingsGui.addText("xs-1 y+-24 w" 60 
		" h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.dappHoldToCrouchKey),1,8))
	ui.dappHoldToCrouchKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 60 
		" h20 center c" cfg.fontColor3 " backgroundTrans","Crouch")

	ui.currKey := cfg.dappReloadKey
	ui.dappReloadKey			:= ui.gameSettingsGui.addPicture("x+3 ys w" 56 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappReloadKeyData 		:= ui.gameSettingsGui.addText("xs-1 y+-24 w" 56 
		" h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.dappReloadKey),1,8))
	ui.dappReloadKeyLabel		:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 56 
	" h20 center c" cfg.fontColor3 " backgroundTrans","Reload")

	ui.currKey := cfg.dappLoadoutKey
	ui.dappLoadoutKey			:= ui.gameSettingsGui.addPicture("x+3 ys w" 64 
		"  h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappLoadoutKeyData 		:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 64 
		"  h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.dappLoadoutKey),1,8))
	ui.dappLoadoutKeyLabel 		:= ui.gameSettingsGui.addText("xs+0 y+-34 w" 64 
		"  h20 center c" cfg.fontColor3 " backgroundTrans","Loadout")
	
	ui.currKey 					:= cfg.dappSwordFlyKey
	ui.dappSwordFlyKey			:= ui.gameSettingsGui.addPicture("x+7 ys w35 h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappSwordFlyKeyData 	:= ui.gameSettingsGui.addText("xs+0 y+-24 w35 h21 center c" cfg.trimColor4 " backgroundTrans"
		,subStr(strUpper(cfg.dappSwordFlyKey),1,8))
	ui.dappSwordFlyKeyLabel 	:= ui.gameSettingsGui.addText("xs-2 y+-35 w40 h20 center c" cfg.fontColor3 " backgroundTrans","Fly")
	ui.d2ClassSelectOutline		:= ui.gameSettingsGui.addText("xs+42 y13 w37 h39 background" cfg.accentColor1)
	ui.d2ClassSelectOutline2	:= ui.gameSettingsGui.addText("xs+43 y13 w36 h38 background" cfg.bgColor3)
	ui.d2ClassSelectBg			:= ui.gameSettingsGui.addText("x441 y12 w40 h40 background" cfg.disabledColor)
	ui.d2ClassSelectDetail 		:= ui.gameSettingsGui.addPicture("x441 y12 w40 h40 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")

	ui.d2ClassSelectBg3			:= ui.gameSettingsGui.addText("hidden xs+41 y+-14 w38 h14 background" cfg.bgColor2)
	ui.d2ClassIcon				:= ui.gameSettingsGui.addPicture("x441 y9 w40 h30 center backgroundTrans","")
	ui.d2ClassIconDown			:= ui.gameSettingsGui.addText("x442 y37 w19 h13 center backgroundTrans c" cfg.accentColor4,"←")
	ui.d2ClassIconUp			:= ui.gameSettingsGui.addText("x461 y37 w19 h13 center backgroundTrans c" cfg.accentColor4,"→")
	ui.d2ClassSelectSpacer 		:= ui.gameSettingsGui.addText("hidden x461 y37 w1 h15 background" cfg.accentColor4)
	ui.d2ClassSelectBgLine		:= ui.gameSettingsGui.addText("hidden x442 y12 w0 h0 background" cfg.accentColor4)
	ui.d2ClassSelectBgLine1		:= ui.gameSettingsGui.addText("hidden x442 y12 w0 h0 background" cfg.accentColor4)
	ui.d2ClassSelectBgLine2		:= ui.gameSettingsGui.addText("hidden x442 y37 w38 h1 background" cfg.accentColor4)
	ui.d2KeyBindHelpMsg			:= ui.gameSettingsGui.addText("right x34 y52 w240 h12 backgroundTrans c" cfg.fontColor1,"")
	ui.d2ClassIcon.toolTip 		:= "Click to Enable/Disable the Fly Macro"
	ui.d2ClassIconDown.tooltip 	:= "Click to switch between character classes for the Fly Macro"
	ui.d2ClassIconUp.tooltip 	:= "Click to switch between character classes for the Fly Macro"
	
	ui.keybindSpacer7			:= ui.gameSettingsGui.addText("x440 y12 w1 h40 background" cfg.bgColor0)		
	ui.keybindSpacer8			:= ui.gameSettingsGui.addText("x441 y12 w1 h40 background" cfg.accentColor1)	
	ui.keybindSpacer5			:= ui.gameSettingsGui.addText("x395 y12 w1 h40 background" cfg.bgColor0)		
	ui.keybindSpacer6			:= ui.gameSettingsGui.addText("x396 y12 w1 h40 background" cfg.accentColor1)	
	ui.keybindSpacer3			:= ui.gameSettingsGui.addText("x480	y12 w1 h40 background" cfg.bgColor0)		
	ui.keybindSpacer4			:= ui.gameSettingsGui.addText("x480 y12 w1 h40 background" cfg.accentColor1)	

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
					? (ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_on.png",ui.d2ClassSelectBg.opt("background" cfg.trimColor4))
					: (ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_off.png",ui.d2ClassSelectBg.opt("background" cfg.disabledColor))
			case 2:
				(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img/d2ClassIconHunter_on.png",ui.d2ClassSelectBg.opt("background" cfg.trimColor4))
					: (ui.d2ClassIcon.value := "./img/d2ClassIconHunter_off.png",ui.d2ClassSelectBg.opt("background" cfg.disabledColor))
			case 3:
			(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img/d2ClassIconTitan_on.png",ui.d2ClassSelectBg.opt("background" cfg.trimColor4))
					: (ui.d2ClassIcon.value := "./img/d2ClassIconTitan_off.png",ui.d2ClassSelectBg.opt("background" cfg.disabledColor))
			default:
		}
	}

	switch cfg.d2CharacterClass { 
		case 1:
		case 2:
		hotif(d2ReadyToSwordFly)
			if cfg.dappSwordFlyKey != "???"
			hotkey("*" cfg.dappSwordFlyKey,d2SwordFly)
		hotif()
		case 3:
		hotif(d2ReadyToSwordFly)
			if cfg.dappSwordFlyKey != "???"
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

	ui.dappLoadoutKeyData.setFont("s12 q5","calibri")
	ui.dappPauseKeyData.setFont("s12 q5","calibri")
	ui.dappPauseKeyLabel.setFont("s10 q5")
	ui.dappReloadKeyData.setFont("s12 q5","calibri")
	ui.dappReloadKeyLabel.setFont("s10 q5")
	ui.dappHoldToCrouchKeyData.setFont("s12 q5","calibri")
	ui.dappToggleSprintKeyData.setFont("s12 q5","calibri")
	ui.dappHoldToCrouchKeyLabel.setFont("s10 q5")
	ui.dappLoadoutKeyLabel.setFont("s10 q5")
	ui.dappToggleSprintKeyLabel.setFont("s10 q5")
	ui.dappSwordFlyKeyData.setFont("s12 q5","calibri")
	ui.dappSwordFlyKeyLabel.setFont("s10 q5")

	ui.dappPauseKey.onEvent("click",dappPauseKeyClicked)
	ui.dappHoldToCrouchKey.onEvent("click",dappHoldToCrouchKeyClicked)
	ui.dappHoldToCrouchKeyData.onEvent("click",dappHoldToCrouchKeyClicked)
	ui.dappSwordFlyKey.onEvent("click",dappSwordFlyKeyClicked)
	ui.dappToggleSprintKey.onEvent("click",dappToggleSprintKeyClicked)
	ui.dappLoadoutKey.onEvent("click",dappLoadoutKeyClicked)
	ui.dappSwordFlyKeyData.onEvent("click",dappSwordFlyKeyClicked)
	ui.dappReloadKey.onEvent("click",dappReloadKeyClicked)
	ui.dappReloadKeyData.onEvent("click",dappReloadKeyClicked)
	ui.dappReloadKey.onEvent("click",dappReloadKeyClicked)
	
	ui.currKey := cfg.d2GameToggleSprintKey
	ui.currKeyLabel := "Toggle Sprint"
	
		
	ui.d2GameToggleSprintKey				:= ui.gameSettingsGui.AddPicture("x25 y20 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameToggleSprintKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.d2GameToggleSprintKey),1,8))
	ui.d2GameToggleSprintKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.fontColor1 " backgroundTrans","Toggle Sprint")
	
	ui.currKey := cfg.d2GameHoldToCrouchKey
	ui.currKeyLabel := "Hold Crouch"
	ui.d2GameHoldToCrouchKey					:= ui.gameSettingsGui.AddPicture("x+2 ys w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameHoldToCrouchKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.d2GameHoldToCrouchKey),1,8))
	ui.d2GameHoldToCrouchKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h20 center c" cfg.fontColor1 " backgroundTrans","Hold Crouch")

	ui.currKey := cfg.d2GameReloadKey
	ui.currKeyLabel := "Reload"
	ui.d2GameReloadKey						:= ui.gameSettingsGui.addPicture("x+2 ys w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameReloadKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.d2GameReloadKey),1,8))
	ui.d2GameReloadKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.fontColor1 " backgroundTrans","Reload")		
	
	ui.currKey := cfg.d2GameGrenadeKey
	ui.currKeyLabel := "Reload"
	ui.d2GameGrenadeKey						:= ui.gameSettingsGui.addPicture("x+2 ys w85 h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameGrenadeKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w85 h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.d2GameGrenadeKey),1,8))
	ui.d2GameGrenadeKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w85 h20 center c" cfg.fontColor1 " backgroundTrans","Grenade")		
	
	ui.currKey := cfg.d2GameSuperKey
	ui.currKeyLabel := "Super"
	ui.d2GameSuperKey						:= ui.gameSettingsGui.addPicture("x+2 ys w70 h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameSuperKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w70 h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.d2GameSuperKey),1,8))
	ui.d2GameSuperKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w70 h20 center c" cfg.fontColor1 " backgroundTrans","Super")		
	
	;cfg.d2AutoGameConfigEnabled := true
	ui.d2ToggleAutoGameConfig := ui.gameSettingsGui.addPicture("x463 y12 w20 h35 section "
	((cfg.d2AutoGameConfigEnabled) 
		? ("Background" cfg.trimColor3) 
			: ("Background" cfg.trimColor2)),
	((cfg.d2AutoGameConfigEnabled) 
		? ("./img/toggle_vertical_trans_on.png") 
			: ("./img/toggle_vertical_trans_off.png")))
	ui.d2ToggleAutoGameConfig.onEvent("click",d2ToggleAutoGameConfig)
	ui.d2ToggleAutoGameConfig.toolTip := "Enable to attempt to automatically`nImport your game settings."
	;ui.d2ToggleAutoGameConfigOutline := ui.gameSettingsGui.addText("ys+3 x+0 w1 h30 background" cfg.accentColor2)
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

	ui.d2gameToggleSprintKeyLabel.setFont("s10")
	ui.d2gameToggleSprintKeyData.setFont("s12")
	ui.d2GameReloadKeyData.setFont("s12")
	ui.d2GameReloadKeylabel.setFont("s10")
	ui.d2GameSuperKeyData.setFont("s12")
	ui.d2GameSuperKeylabel.setFont("s10")
	ui.d2GameGrenadeKeyData.setFont("s12")
	ui.d2GameGrenadeKeylabel.setFont("s10")
	ui.d2GameHoldToCrouchKeyData.setFont("s12")
	ui.d2GameHoldToCrouchKeyLabel.setFont("s10")

	labelX := 280
	labelY := 41
	labelW := 66
	labelH := 25
	backColor := cfg.bgColor2
	fontColor := cfg.fontColor1
	outlineColor := cfg.accentColor1
	labelText := "Keybinds"
	
	ui.d2keybindAppTab2 := guiName.addText("x" labelX+1 " y" labelY+4 " w" labelW-30 " h" labelH+5 " background" backColor " center c" fontColor) 
	ui.d2keybindAppTabDetail := guiName.addPicture("x" labelX+4 " y" labelY+0 " w" labelW-7 " h" labelH+0 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png") 
	;ui.d2keybindAppTabDetail2 := guiName.addPicture("hidden x" labelX+3 " y" labelY+10 " w" labelW-3 " h" labelH-11 " backgroundTrans","./img/custom/lightburst_blank.png") 
	ui.d2keybindAppTab3 := guiName.addText("x" labelX+1 " y" labelY-6 " w" labelW-2 " h22 backgroundTrans center c" fontColor, labelText) 
	ui.d2keybindAppTab3.setFont("s10","Bold")

	labelX := 346
	labelY := 41
	labelW := 96
	labelH := 25
	backColor := cfg.bgColor2
	fontColor := cfg.fontColor1
	outlineColor := cfg.accentColor1
	labelText := "Game Settings"
	ui.d2keybindGameTab2 := guiName.addText("x" labelX+4 " y" labelY+4 " w" labelW-20 " h" labelH+5 " background" backColor " center c" fontColor) 
	ui.d2keybindGameTabDetail := guiName.addPicture("x" labelX+4 " y" labelY+0 " w" labelW-18 " h" labelH+0 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png") 
;	ui.d2keybindGameTabDetail2 := guiName.addPicture("hidden x" labelX+2 " y" labelY+10 " w" labelW-10 " h" labelH-11 " backgroundTrans","./img/custom/lightburst_blank.png") 
	ui.d2keybindGameTab3 := guiName.addText("x" labelX-1 " y" labelY-6 " w" labelW-4 " h20 backgroundTrans center c" fontColor, labelText) 
	ui.d2keybindGameTab3.setFont("s9","Thin")

	ui.d2keybindAppTab1.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindAppTab2.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindAppTab3.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindGameTab1.onEvent("click",d2keybindGameTabClicked)
	ui.d2keybindGameTab2.onEvent("click",d2keybindGameTabClicked)
	ui.d2keybindGameTab3.onEvent("click",d2keybindGameTabClicked)
	ui.dappFunctionsEnabled := true
	ui.d2ToggleAppFunctions := ui.gameSettingsGui.addPicture("x17 y12 w20 h35 section "
	((ui.dappFunctionsEnabled) 
		? ("Background" cfg.trimColor3) 
			: ("Background" cfg.trimColor2)),
	((ui.dappFunctionsEnabled) 
		? ("./img/toggle_vertical_trans_on.png") 
			: ("./img/toggle_vertical_trans_off.png")))
	ui.d2ToggleAppFunctions.onEvent("click",d2ToggleAppFunctions)
	ui.d2ToggleAppFunctionsOutline := ui.gameSettingsGui.addText("ys+3 x+0 w1 h32 background" cfg.accentColor2)
	ui.d2ToggleAppFunctionsLabel := ui.gameSettingsGui.addText("xs-5 y+-1 w28 h10 backgroundTrans center","Pause")
	ui.d2ToggleAppFunctionsLabel.setFont("s8")

}



drawLinkBar(*) {
	static xPos:=14
	static yPos:=84
	
	cfg.button_link_1:=["DIM","URL","https://app.destinyitemmanager.com","./img/button_DIM.png","Launches DIM in browser"]
	cfg.button_link_2:=["Join","Function","toggleFireteam","./img/ft_icon.png","Unbound, click to assign"]
	cfg.button_link_3:=["Glyphs","Function","toggleGlyphWindow","./img/d2_glyphs_thumb.png","Shows Glyph callout infographic"]
	cfg.button_link_4:=["Runes","Function","toggleRuneWindow","./img/d2_runes_thumb.png","Shows Rune callout infographic"]
	cfg.button_link_5:=["WishCodes","Function","toggleCodeWindow","./img/d2_wishCodes_thumb.png","Shows codes for Wall of Wishes"]
	cfg.button_link_6:=["Vault","Function","toggleVaultMode","./img/d2_maps_thumb.png","Shows collection of maps"]

	cfg.button_link_7:=["Unassigned","Function","editLinkBox","./img/d2_button_unbound.png","Unbound, click to assign"]
	cfg.button_link_8:=["Unassigned","Function","editLinkBox","./img/d2_button_unbound.png","Unbound, Click to assign"]
	ui.button_link_1:=""
	ui.button_link_2:=""
	ui.button_link_3:=""
	ui.button_link_4:=""
	ui.button_link_5:=""
	ui.button_link_6:=""
	ui.button_link_7:=""
	ui.button_link_8:=""
	
	cfg.button_link_size:=54
	ui.gameTabs.useTab("Gameplay")
	; ui.panel4box3:=ui.gameSettingsGui.addText("x7 y75 w485 h70 background" cfg.bgColor1,"")
	; ui.panel4box4:=ui.gameSettingsGui.addText("x8 y76 w483 h68 c" cfg.bgColor1 " background" cfg.bgColor0)
	; drawOutlineNamed("d2linkPanel",ui.gameSettingsGui,12,76,474,60,cfg.accentColor2,cfg.accentColor4,1)
	; drawOutlineNamed("d2linkPanel",ui.gameSettingsGui,6,72,486,72,cfg.outlineColor2,cfg.outlineColor1,1)
	; drawOutlineNamed("d2AlwaysRunOutline",ui.gameSettingsGui,7,73,484,70,cfg.outlineColor1,cfg.outlineColor2,1)	



	
	loop 8 {
		ui.button_link_%a_index% := object()
		ui.button_link_%a_index%.name:=cfg.button_link_%a_index%[1]
		ui.button_link_%a_index%.type:=cfg.button_link_%a_index%[2]
		ui.button_link_%a_index%.action:=cfg.button_link_%a_index%[3]
		ui.button_link_%a_index%.thumb:=cfg.button_link_%a_index%[4]
		ui.button_link_%a_index%.bg:=ui.gameSettingsGui.addPicture("x" xPos+2 " y" yPos+1 " w" cfg.button_link_size-1 " h-1 vbutton_link_" a_index " background" cfg.bgColor3,ui.button_link_%a_index%.thumb)
		ui.button_link_%a_index%.fx:=ui.gameSettingsGui.addPicture("x" xPos+1 " y" yPos+1 " w" cfg.button_link_size-1 " h" cfg.button_link_size-1 " backgroundTrans","./img/custom/lightburst_tile.png")
		ui.button_link_%a_index%.down:=ui.gameSettingsGui.addPicture("x" xPos+1 " y" yPos+1 " w" cfg.button_link_size-1 " h" cfg.button_link_size-1 " hidden backgroundTrans","./img/button_down_layer.png")
		drawOutline(ui.gameSettingsGui,xPos,yPos,cfg.button_link_size+1,cfg.button_link_size+1,cfg.outlineColor2,cfg.outlineColor1,1)
		;drawOutline(ui.gameSettingsGui,xPos+1,yPos+1,cfg.button_link_size-1,cfg.button_link_size-1,cfg.disabledColor,cfg.accentColor4,1)

		this_action:=cfg.button_link_%a_index%[3]
		if cfg.button_link_%a_index%[2]=="URL" {
			ui.button_link_%a_index%.bg.onEvent("click",openUrl)
			ui.button_link_%a_index%.fx.onEvent("click",openUrl)
		} else {
			ui.button_link_%a_index%.bg.onEvent("click",%this_action%)
			ui.button_link_%a_index%.fx.onEvent("click",%this_action%)
		}
		xPos+=cfg.button_link_size+5

	}
	openUrl(this_Url,*) {
		ui.button_link_%strSplit(this_Url.name,"_")[3]%.down.opt("-hidden")
		setTimer () => ui.button_link_%strSplit(this_Url.name,"_")[3]%.down.opt("hidden"),-1000
		run("chrome.exe " cfg.%this_Url.name%[3])
	}
	
	static xPos:=15
	static yPos:=82
	loop 8 {
		(ui.button_link_%a_index%.thumb=="./img/d2_button_unbound.png")
		? (ui.button_link_%a_index%.edit:=ui.gameSettingsGui.addPicture("x" xPos-1 " y" yPos+cfg.button_link_size-16 " backgroundTrans w18 h19 vbutton_link_edit" a_index,"./img/button_edit.png")
		, ui.button_link_%a_index%.edit.onEvent("click",editLinkBox)) : 0
		xPos+=cfg.button_link_size+5
	}

	editLinkBox(lParam, ID, *) {
	;	msgBox(lParam.name)
		ui.linkName:=ui.%lParam.name%.Name
		ui.linkType:=ui.%lParam.name%.type
		ui.linkAction:=ui.%lParam.name%.action
		ui.linkThumb:=ui.%lParam.name%.thumb
		
		ui.editLinkGui:=gui()
		ui.editLinkGui.opt("-caption -border toolWindow alwaysOnTop")
		ui.editLinkGui.backColor:="010203"
		winSetTransColor("010203",ui.editLinkGui)
		ui.editLinkGui.color:=cfg.fontColor3
		ui.editLinkBg:=ui.editLinkGui.addText("x0 y0 w300 h80 background" cfg.bgColor0)
		ui.editLinkTitlebar:=ui.editLinkGui.addText("x0 y0 w80 h20 background" cfg.bgColor1)
		ui.editLinkTitlebar.onEvent("click",WM_LBUTTONDOWN_callback)

		ui.thumbPreview:=ui.editLinkGui.addPicture("center x10 y20 w60 h60 backgroundTrans",ui.%lParam.name%.thumb)
		
		ui.linkNameLabel:=ui.editLinkGui.addText("x85 y2 w40 backgroundTrans c" cfg.fontColor1,"Name: ")
		ui.linkNameValue:=ui.editLinkGui.addEdit("x125 y2 w170 background" cfg.bgColor1 " c" cfg.titleBgColor,ui.%lParam.name%.name)
		ui.linkTypeLabel:=ui.editLinkGui.addText("x85 y20 w40 backgroundTrans c" cfg.fontColor1,"Type: ")
		ui.linkTypeValue:=ui.editLinkGui.addEdit("x125 y20 w170 background" cfg.bgColor1 " c" cfg.titleBgColor,ui.%lParam.name%.type)
		ui.linkActionLabel:=ui.editLinkGui.addText("x85 y40 w40 backgroundTrans c" cfg.fontColor1,"Action: ")
		ui.linkActionValue:=ui.editLinkGui.addEdit("x125 y40 w170 background" cfg.bgColor1 " c" cfg.titleBgColor,ui.%lParam.name%.action)
		ui.linkThumbLabel:=ui.editLinkGui.addText("x85 y60 w40 backgroundTrans c" cfg.fontColor1,"Thumb: ")
		ui.linkThumbValue:=ui.editLinkGui.addEdit("x125 y60 w170 background" cfg.bgColor1 " c" cfg.titleBgColor,ui.%lParam.name%.thumb)
		drawOutline(ui.editLinkGui,0,0,80,20,cfg.accentColor1,cfg.accentColor1,1)
		;drawOutline(ui.editLinkGui,0,20,80,60,cfg.accentColor1,cfg.accentColor1,1)
		drawOutline(ui.editLinkGui,80,0,300,80,cfg.accentColor1,cfg.accentColor1,1)
		winGetPos(&elX,&elY,&elW,&elH,ui.gameSettingsGui)
		ui.editLinkGui.show("x" elX " y" elY+elH+10 " w" 300 " h" 80)
	}
}
	
	



d2KeybindTabChange(this_button,*) {
}
	
drawKeybind(x,y,bindName,labelText := bindName,gui := ui.mainGui,w := 84,h := 30,buttonImage := "./img/keyboard_key_up.png",textJustify := "center",fontColorReady := cfg.trimColor4,fontColorOn := cfg.trimColor3) {
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
					? ui.d2ClassIcon.value := "./img/d2ClassIconHunter_off.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconHunter_on.png"
			case 2:
				cfg.d2CharacterClass := 3
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.dappSwordFlyKey,d2SwordFly)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img/d2ClassIconTitan_off.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconTitan_on.png"
			case 3: 
				cfg.d2CharacterClass := 1
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.dappSwordFlyKey,d2MorgethWarlock)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_off.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_on.png"
			default:                                          
		}
	}
	
	d2ClassIconDownChanged(*) {
		switch cfg.d2CharacterClass {
			case 3:
				cfg.d2CharacterClass := 2
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img/d2ClassIconHunter_off.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconHunter_on.png"
			case 1:
				cfg.d2CharacterClass := 3
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.dappSwordFlyKey,d2SwordFly)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img/d2ClassIconTitan_off.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconTitan_on.png"
			case 2: 
				cfg.d2CharacterClass := 1
				hotIf(d2ReadyToSwordFly)
					hotkey("~*" cfg.dappSwordFlyKey,d2MorgethWarlock)
				hotIf()
				(ui.d2FlyEnabled)
					? ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_off.png"
					: ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_on.png"
			default:                                          
		}
	}		
