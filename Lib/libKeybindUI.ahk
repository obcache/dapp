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
		ui.d2keybindGameTab1.opt("background" cfg.accentColor2)
		ui.d2keybindGameTab2.opt("background" cfg.bgColor1) 
		ui.d2keybindGameTabDetail.move(,48)
		ui.d2keybindGameTabDetail.value:="./img/custom/lightburst_bottom_bar_light.png"
		ui.d2keybindGameTabDetail2.value:="./img/custom/lightburst_blank.png"
		ui.d2keybindGameTab3.setFont("s8 c" cfg.fontColor2,"thin")
		ui.d2keybindGameTab1.move(347,labelY+7,88,11)
		ui.d2keybindGameTab2.move(347,labelY+7,87,10)
		ui.d2keybindGameTab3.move(345,labelY+5,,10)

		ui.d2keybindAppTab1.opt("background" cfg.accentColor1)
		ui.d2keybindAppTab2.opt("background" cfg.bgColor0)
		ui.d2keybindAppTabDetail.move(,48)
		ui.d2keybindAppTabDetail.value:="./img/custom/lightburst_bottom_bar_light.png"
		ui.d2keybindAppTabDetail2.value:="./img/custom/lightburst_blank.png"
		ui.d2keybindAppTab3.setFont("s10 c" cfg.fontColor1,"bold")
		ui.d2keybindAppTab1.move(labelx+2,labelY+6,65,13)
		ui.d2keybindAppTab2.move(labelx+3,labelY+6,63,12)
		ui.d2keybindAppTab3.move(283,labelY+2,,12)
		ui.d2keyBindAppTab1.redraw()
		ui.d2KeybindAppTab2.redraw()
		ui.d2KeybindAppTab3.redraw()
		ui.d2KeybindAppTabDetail.redraw()
		ui.d2keyBindGameTab1.redraw()
		ui.d2KeybindGameTab2.redraw()
		ui.d2KeybindGameTab3.redraw()
		ui.d2KeybindGameTabDetail.redraw()
		d2changeKeybindPanelTab(2)
	}
	
d2keybindGameTabClicked(*) {
guiName := ui.gameSettingsGui
ui.d2KeyBindHelpMsg.text := "     Configure these to mirror your in-game bindings"
		labelX := 280
		labelY := 44
		labelW := 66
		labelH := 30
		ui.d2keybindAppTab1.opt("background" cfg.accentColor2)
		ui.d2keybindAppTab2.opt("background" cfg.bgColor1) 
		ui.d2keybindAppTabDetail.move(,49)
		ui.d2keybindAppTabDetail.value:="./img/custom/lightburst_bottom_bar_light.png"
		ui.d2keybindAppTabDetail2.value:="./img/custom/lightburst_blank.png"
		ui.d2keybindAppTab3.setFont("s8 c" cfg.fontColor2,"thin")
		ui.d2keybindAppTab1.move(labelx+2,labelY+7,65,12)
		ui.d2keybindAppTab2.move(labelx+3,labelY+7,63,11)
		ui.d2keybindAppTab3.move(283,labelY+5,,11)
		ui.d2keybindAppTabDetail.opt("y" labelY+10)

		ui.d2keybindGameTab1.opt("background" cfg.accentColor1)
		ui.d2keybindGameTab2.opt("background" cfg.bgColor0)
		ui.d2keybindGameTabDetail.move(,50)
		ui.d2keybindGameTabDetail.value:="./img/custom/lightburst_bottom_bar_light.png"
		ui.d2keybindGameTabDetail2.value:="./img/custom/lightburst_blank.png"
		
		ui.d2keybindGameTab3.setFont("s10 c" cfg.fontColor1,"bold")
		ui.d2keybindGameTab1.move(347,labelY+6,89,14)
		ui.d2keybindGameTab2.move(347,labelY+6,87,13)
		ui.d2keybindGameTab3.move(343,labelY+2,,13)
				ui.d2keyBindAppTab1.redraw()
		ui.d2KeybindAppTab2.redraw()
		ui.d2KeybindAppTab3.redraw()
		ui.d2KeybindAppTabDetail.redraw()
		ui.d2keyBindGameTab1.redraw()
		ui.d2KeybindGameTab2.redraw()
		ui.d2KeybindGameTab3.redraw()
		ui.d2KeybindGameTabDetail.redraw()
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
			,ui.d2Panel1Tab1Detail
			,ui.d2ClassSelectDetail
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
			,ui.d2Panel1Tab2Bg
			,ui.d2Panel1Tab2Bg2
			,ui.d2Panel1Tab2Detail
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
	
	ui.d2TopPanelOutline:=ui.gameSettingsGui.addText("x8 y5 w480 h66 background" cfg.outlineColor1)
	ui.d2TopPanelBg:=ui.gameSettingsGui.addText("x9 y6 w478 h65 background" cfg.bgColor1)
	ui.d2TopPanelDetail2:=ui.gameSettingsGui.addPicture("x9 y6 w478 h65 backgroundTrans","./img/custom/lightburst_tile.png")

	guiName := ui.gameSettingsGui
	ui.d2KeybindWidth := 60
	labelX := 270
	labelY := 44
	labelW := 74
	labelH := 30
	backColor := cfg.bgColor2
	fontColor := cfg.fontColor2
	outlineColor := cfg.outlineColor1
	labelText := "Keybinds"
	ui.d2keybindAppTab1 := guiName.addText("x" labelX " y" labelY+labelH/2 " w" labelW " h" labelH/2+3 " background" outlineColor,"")
		     
	labelX := 346
	labelY := 44
	labelW := 105
	labelH := 30
	backColor := cfg.bgColor2
	fontColor := cfg.fontColor1
	outlineColor := cfg.outlineColor2
	labelText := "Game Settings"	
	
	
	ui.d2keybindGameTab1 	:= guiName.addText("x" labelX " y" labelY+labelH/2 " w" labelW-4 " h" labelH/2+3 " background" outlineColor,"")
	ui.d2Panel1Tab1Bg 		:= ui.gameSettingsGui.addText("hidden x44 y9 w437 h42 background" cfg.accentColor1,"")
	ui.d2Panel1Tab1Bg2 		:= ui.gameSettingsGui.addText("hidden x45 y10 w435 h40 background" cfg.bgColor0 " c" cfg.fontColor1,"")
	ui.d2Panel1Tab1Detail	:= ui.gameSettingsGui.addPicture("x45 y10 w435 h40 backgroundTrans","./img/custom/lightburst_top_bar_light.png")
	ui.d2Panel1Tab1Detail2	:= ui.gameSettingsGui.addPicture("x45 y10 w435 h40 backgroundTrans","./img/custom/lightburst_top_bar_light.png")
	ui.d2Panel1Tab1Bg3 		:= ui.gameSettingsGui.addText("hidden x46 y11 w433 h38 background" cfg.bgColor0,"")
	ui.d2Panel1Tab1Bg4 		:= ui.gameSettingsGui.addText("hidden x47 y12 w431 h36 background" cfg.trimColor1,"")
	
	ui.d2Panel1Tab2Bg 		:= ui.gameSettingsGui.addText("hidden x19 y9 w438 h42 background" cfg.accentColor2,"")
	ui.d2Panel1Tab2Bg2 		:= ui.gameSettingsGui.addText("hidden x20 y10 w436 h40 background" cfg.bgColor0 " c" cfg.fontColor2,"")	
	ui.d2Panel1Tab2Detail	:= ui.gameSettingsGui.addPicture("x20 y10 w450 h40 backgroundTrans","./img/custom/lightburst_top_bar_light.png")	
	ui.d2Panel1Tab2Detail2	:= ui.gameSettingsGui.addPicture("x20 y10 w450 h40 backgroundTrans","./img/custom/lightburst_top_bar_light.png")	
	ui.d2Panel1Tab2Bg3 		:= ui.gameSettingsGui.addText("hidden x21 y11 w434 h38 background" cfg.bgColor0,"")
	ui.d2Panel1Tab2Bg4 		:= ui.gameSettingsGui.addText("hidden x22 y12 w432 h36 background" cfg.trimColor2,"")
	;ui.d2Panel1Tab2Bg := ui.gameSettingsGui.addText("x42 y10 w406 h42 background" cfg.bgColor0 " c" cfg.fontColor4,"")	
	;drawOutlineNamed("gameSettings",ui.gameSettingsGui,43,11,404,42,cfg.accentColor1,cfg.accentColor3,1)
	ui.currKey 				:= cfg.dappPauseKey
	ui.dappPauseKey			:= ui.gameSettingsGui.addPicture("x50 y16 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappPauseKeyData 	:= ui.gameSettingsGui.addText("xs-1 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.dappPauseKey),1,8))
	ui.dappPauseKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h20 center c" cfg.fontColor1 " backgroundTrans","Pause")
	
	ui.keybindSpacer		:= ui.gameSettingsGui.addText("x113 y10 w1 h40 background" cfg.outlineColor1)		
	ui.keybindSpacer2		:= ui.gameSettingsGui.addText("x114 y10 w1 h40 background" cfg.accentColor1)
	;ui.gameSettingsGui.setFont("s11","Arial")
	
	ui.currKey 				:= cfg.dappToggleSprintKey

	ui.dappToggleSprintKey		:= ui.gameSettingsGui.addPicture("x+3 y16 w" 90
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappToggleSprintKeyData 	:= ui.gameSettingsGui.addText("xs-2 y+-24 w" 90 
		" h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.dappToggleSprintKey),1,8))
	ui.dappToggleSprintKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 90 
		" h20 center c" cfg.fontColor1 " backgroundTrans","Sprint")
	
	ui.currKey := cfg.dappHoldToCrouchKey
	ui.dappHoldToCrouchKey		:= ui.gameSettingsGui.AddPicture("x+3 ys w" 60 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappHoldToCrouchKeyData 	:= ui.gameSettingsGui.addText("xs-1 y+-24 w" 60 
		" h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.dappHoldToCrouchKey),1,8))
	ui.dappHoldToCrouchKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 60 
		" h20 center c" cfg.fontColor1 " backgroundTrans","Crouch")

	ui.currKey := cfg.dappReloadKey
	ui.dappReloadKey			:= ui.gameSettingsGui.addPicture("x+3 ys w" 56 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappReloadKeyData 		:= ui.gameSettingsGui.addText("xs-1 y+-24 w" 56 
		" h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.dappReloadKey),1,8))
	ui.dappReloadKeyLabel		:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 56 
	" h20 center c" cfg.fontColor1 " backgroundTrans","Reload")

	ui.currKey := cfg.dappLoadoutKey
	ui.dappLoadoutKey			:= ui.gameSettingsGui.addPicture("x+3 ys w" 64 
		"  h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappLoadoutKeyData 		:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 64 
		"  h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.dappLoadoutKey),1,8))
	ui.dappLoadoutKeyLabel 		:= ui.gameSettingsGui.addText("xs+0 y+-34 w" 64 
		"  h20 center c" cfg.fontColor1 " backgroundTrans","Loadout")
	
	ui.currKey 					:= cfg.dappSwordFlyKey
	ui.dappSwordFlyKey			:= ui.gameSettingsGui.addPicture("x+7 ys w35 h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappSwordFlyKeyData 	:= ui.gameSettingsGui.addText("xs+0 y+-24 w35 h21 center c" cfg.trimColor4 " backgroundTrans"
		,subStr(strUpper(cfg.dappSwordFlyKey),1,8))
	ui.dappSwordFlyKeyLabel 	:= ui.gameSettingsGui.addText("xs-2 y+-35 w40 h20 center c" cfg.fontColor1 " backgroundTrans","Fly")
	ui.d2ClassSelectOutline		:= ui.gameSettingsGui.addText("xs+42 y11 w37 h39 background" cfg.accentColor2)
	ui.d2ClassSelectOutline2	:= ui.gameSettingsGui.addText("xs+43 y11 w36 h38 background" cfg.bgColor3)
	ui.d2ClassSelectBg			:= ui.gameSettingsGui.addText("x441 y10 w40 h40 background" cfg.accentColor4)
	ui.d2ClassSelectDetail 		:= ui.gameSettingsGui.addPicture("x441 y10 w40 h40 backgroundTrans","./img/custom/lightburst_tile.png")

	ui.d2ClassSelectBg3			:= ui.gameSettingsGui.addText("hidden xs+41 y+-15 w38 h14 background" cfg.bgColor2)
	ui.d2ClassIcon				:= ui.gameSettingsGui.addPicture("x441 y7 w40 h30 center backgroundTrans","")
	ui.d2ClassIconDown			:= ui.gameSettingsGui.addText("x442 y35 w19 h13 center backgroundTrans c" cfg.outlineColor1,"←")
	ui.d2ClassIconUp			:= ui.gameSettingsGui.addText("x461 y35 w19 h13 center backgroundTrans c" cfg.outlineColor1,"→")
	ui.d2ClassSelectSpacer 		:= ui.gameSettingsGui.addText("hidden x461 y35 w1 h15 background" cfg.outlineColor1)
	ui.d2ClassSelectBgLine		:= ui.gameSettingsGui.addText("hidden x442 y10 w0 h0 background" cfg.outlineColor1)
	ui.d2ClassSelectBgLine1		:= ui.gameSettingsGui.addText("hidden x442 y10 w0 h0 background" cfg.outlineColor1)
	ui.d2ClassSelectBgLine2		:= ui.gameSettingsGui.addText("hidden x442 y34 w38 h1 background" cfg.outlineColor1)
	ui.d2KeyBindHelpMsg			:= ui.gameSettingsGui.addText("x47 y52 w350 h12 backgroundTrans c" cfg.fontColor1,"")
	ui.d2ClassIcon.toolTip 		:= "Click to Enable/Disable the Fly Macro"
	ui.d2ClassIconDown.tooltip 	:= "Click to switch between character classes for the Fly Macro"
	ui.d2ClassIconUp.tooltip 	:= "Click to switch between character classes for the Fly Macro"
	
	ui.keybindSpacer7			:= ui.gameSettingsGui.addText("x440 y10 w1 h40 background" cfg.outlineColor1)		
	ui.keybindSpacer8			:= ui.gameSettingsGui.addText("x441 y10 w1 h40 background" cfg.accentColor1)	
	ui.keybindSpacer5			:= ui.gameSettingsGui.addText("x395 y10 w1 h40 background" cfg.outlineColor1)		
	ui.keybindSpacer6			:= ui.gameSettingsGui.addText("x396 y10 w1 h40 background" cfg.accentColor1)	
	ui.keybindSpacer3			:= ui.gameSettingsGui.addText("x480	y10 w1 h40 background" cfg.outlineColor1)		
	ui.keybindSpacer4			:= ui.gameSettingsGui.addText("x480 y10 w1 h40 background" cfg.accentColor1)	

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
					: (ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_off.png",ui.d2ClassSelectBg.opt("background" cfg.trimColor5))
			case 2:
				(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img/d2ClassIconHunter_on.png",ui.d2ClassSelectBg.opt("background" cfg.trimColor4))
					: (ui.d2ClassIcon.value := "./img/d2ClassIconHunter_off.png",ui.d2ClassSelectBg.opt("background" cfg.trimColor5))
			case 3:
			(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img/d2ClassIconTitan_on.png",ui.d2ClassSelectBg.opt("background" cfg.trimColor4))
					: (ui.d2ClassIcon.value := "./img/d2ClassIconTitan_off.png",ui.d2ClassSelectBg.opt("background" cfg.trimColor5))
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
	
		
	ui.d2GameToggleSprintKey				:= ui.gameSettingsGui.AddPicture("x25 y16 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
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
	ui.d2GameGrenadeKey						:= ui.gameSettingsGui.addPicture("x+2 ys w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameGrenadeKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.d2GameGrenadeKey),1,8))
	ui.d2GameGrenadeKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.fontColor1 " backgroundTrans","Grenade")		
	
	ui.currKey := cfg.d2GameSuperKey
	ui.currKeyLabel := "Super"
	ui.d2GameSuperKey						:= ui.gameSettingsGui.addPicture("x+2 ys w" (ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameSuperKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" (ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.trimColor4 " backgroundTrans",subStr(strUpper(cfg.d2GameSuperKey),1,8))
	ui.d2GameSuperKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.fontColor1 " backgroundTrans","Super")		
	
	;cfg.d2AutoGameConfigEnabled := true
	ui.d2ToggleAutoGameConfig := ui.gameSettingsGui.addPicture("x463 y10 w20 h35 section "
	((cfg.d2AutoGameConfigEnabled) 
		? ("Background" cfg.trimColor3) 
			: ("Background" cfg.trimColor2)),
	((cfg.d2AutoGameConfigEnabled) 
		? ("./img/toggle_vertical_trans_on.png") 
			: ("./img/toggle_vertical_trans_off.png")))
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
	
	ui.d2keybindAppTab2 := guiName.addText("x" labelX+1 " y" labelY+4 " w" labelW-4 " h" labelH+4 " background" backColor " center c" fontColor) 
	ui.d2keybindAppTabDetail := guiName.addPicture("x" labelX+3 " y" labelY+10 " w" labelW-3 " h" labelH-11 " backgroundTrans","./img/custom/lightburst_tile.png") 
	ui.d2keybindAppTabDetail2 := guiName.addPicture("hidden x" labelX+3 " y" labelY+10 " w" labelW-3 " h" labelH-11 " backgroundTrans","./img/custom/lightburst_blank.png") 
	ui.d2keybindAppTab3 := guiName.addText("x" labelX+1 " y" labelY-6 " w" labelW-2 " backgroundTrans center c" fontColor, labelText) 
	ui.d2keybindAppTab3.setFont("s10","Bold")

	labelX := 346
	labelY := 41
	labelW := 96
	labelH := 25
	backColor := cfg.bgColor2
	fontColor := cfg.fontColor1
	outlineColor := cfg.accentColor1
	labelText := "Game Settings"
	ui.d2keybindGameTab2 := guiName.addText("x" labelX+3 " y" labelY+4 " w" labelW-16 " h" labelH+4 " background" backColor " center c" fontColor) 
	ui.d2keybindGameTabDetail := guiName.addPicture("x" labelX+2 " y" labelY+10 " w" labelW-10 " h" labelH-11 " backgroundTrans","./img/custom/lightburst_tile.png") 
	ui.d2keybindGameTabDetail2 := guiName.addPicture("hidden x" labelX+2 " y" labelY+10 " w" labelW-10 " h" labelH-11 " backgroundTrans","./img/custom/lightburst_blank.png") 
	ui.d2keybindGameTab3 := guiName.addText("x" labelX-1 " y" labelY-6 " w" labelW-2 " backgroundTrans center c" fontColor, labelText) 
	ui.d2keybindGameTab3.setFont("s9","Thin")

	ui.d2keybindAppTab1.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindAppTab2.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindAppTab3.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindGameTab1.onEvent("click",d2keybindGameTabClicked)
	ui.d2keybindGameTab2.onEvent("click",d2keybindGameTabClicked)
	ui.d2keybindGameTab3.onEvent("click",d2keybindGameTabClicked)
	ui.dappFunctionsEnabled := true
	ui.d2ToggleAppFunctions := ui.gameSettingsGui.addPicture("x17 y10 w20 h35 section "
	((ui.dappFunctionsEnabled) 
		? ("Background" cfg.trimColor3) 
			: ("Background" cfg.trimColor2)),
	((ui.dappFunctionsEnabled) 
		? ("./img/toggle_vertical_trans_on.png") 
			: ("./img/toggle_vertical_trans_off.png")))
	ui.d2ToggleAppFunctionsOutline := ui.gameSettingsGui.addText("ys+3 x+0 w1 h32 background" cfg.accentColor2)
	ui.d2ToggleAppFunctionsLabel := ui.gameSettingsGui.addText("xs-5 y+-1 w28 h10 backgroundTrans center","Pause")
	ui.d2ToggleAppFunctionsLabel.setFont("s8")

}

