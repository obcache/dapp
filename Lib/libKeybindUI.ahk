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
							return7
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

	ui.d2keybindGameTab1.opt("background" cfg.TrimColor2)
	ui.d2keybindGameTab2.opt("background" cfg.TileColor) 
	ui.d2Panel1Tab1Detail1.value:="./img/custom/lightburst_top_bar_dark.png"
	ui.d2keybindGameTabDetail.move(343,43,89,22)
	ui.d2keybindGameTab1.move(343,55,92,12)
	ui.d2keybindGameTab2.move(343,55,90,11)
	ui.d2keybindGameTab3.move(344,53,90,16)
	ui.d2keybindGameTab3.setFont("s8 q5 c" cfg.FontColor3,"thin")

	ui.d2keybindAppTab1.opt("background" cfg.TrimColor1)
	ui.d2keybindAppTab2.opt("background" cfg.TabColor1)
	ui.d2Panel1Tab2Detail1.value:="./img/custom/lightburst_top_bar_dark.png"
	ui.d2keybindAppTabDetail.move(282,43,60,24)
	ui.d2keybindAppTab1.move(280,50,63,18)
	ui.d2keybindAppTab2.move(281,50,61,17)
	ui.d2keybindAppTab3.move(280,52,63,17)
	ui.d2keybindAppTab3.setFont("s10 c" cfg.FontColor1,"bold")
	
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
	ui.d2KeyBindHelpMsg.text := "     Assign keys you'd like to use for each function"

	ui.d2keybindAppTab1.opt("background" cfg.TrimColor2)
	ui.d2keybindAppTab2.opt("background" cfg.TileColor) 
	ui.d2Panel1Tab2Detail1.value:="./img/custom/lightburst_top_bar_dark.png"
	ui.d2keybindAppTabDetail.move(282,43,60,22)
	ui.d2keybindAppTab1.move(280,53,63,17)
	ui.d2keybindAppTab2.move(281,55,61,11)
	ui.d2keybindAppTab3.move(281,53,63,16)
	ui.d2keybindAppTab3.setFont("s8 q5 c" cfg.FontColor3,"thin")

	ui.d2keybindGameTab1.opt("background" cfg.TrimColor1)
	ui.d2keybindGameTab2.opt("background" cfg.TabColor1)
	ui.d2Panel1Tab1Detail1.value:="./img/custom/lightburst_top_bar_dark.png"
	ui.d2keybindGameTabDetail.move(344,43,90,24)
	ui.d2keybindGameTab1.move(343,50,92,18)
	ui.d2keybindGameTab2.move(344,50,90,17)
	ui.d2keybindGameTab3.move(344,52,90,17)
	ui.d2keybindGameTab3.setFont("s10 c" cfg.FontColor1,"bold")
	
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
		; ui.d2keybindAppTab1.opt("background" cfg.OutlineColor2)
		; ui.d2keybindAppTab2.opt("background" cfg.TabColor2) 
		; ui.d2keybindAppTab3.setFont("s10 c" cfg.FontColor2,"thin")
		; ui.d2keybindAppTab1.move(280,labelY+7,70,15)
		; ui.d2keybindAppTab2.move(281,labelY+7,65,14)
		; ui.d2keybindAppTab3.move(280,labelY+6,,16)

		; ui.d2keybindGameTab1.opt("background" cfg.OutlineColor1)
		; ui.d2keybindGameTab2.opt("background" cfg.TabColor1)
		; ui.d2keybindGameTab3.setFont("s10 c" cfg.FontColor1,"bold")
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
			,ui.keybindSpacer1
			,ui.keybindSpacer2
			,ui.keybindSpacer4
			,ui.keybindSpacer5
			,ui.keybindSpacer7
			,ui.keybindSpacer50
			,ui.keybindSpacer6
			,ui.keybindSpacer70
			,ui.keybindSpacer8
			,ui.keybindSpacer1Detail
			,ui.keybindSpacer2Detail
			,ui.keybindSpacer3Detail
			,ui.keybindSpacer4Detail
			,ui.keybindSpacer5Detail
			,ui.keybindSpacer6Detail
			,ui.keybindSpacer7Detail
			,ui.keybindSpacer8Detail
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
			,ui.d2ClassSelectDetail
			,ui.d2ClassSelectDetail2
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
			;ui.labelName1.opt("x215 y46 w100 h17 background" cfg.TileColor)
			;ui.labelName3.opt("x320 y46 w80 h19 background" cfg.TabColor1)
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

	;ui.d2TopPanelBg := ui.gameSettingsGui.addText("x7 y4 w481 h66 background" cfg.TabColor2,"")
	;ui.d2TopPanelDetail2 := ui.gameSettingsGui.addPicture("x7 y4 w481 h66 backgroundTrans","./img/custom/lightburst_tile.png")

	;ui.d2TopPanelDetail := ui.gameSettingsGui.addPicture("x7 y4 w481 h66 backgroundTrans","./img/custom/lightburst_diag.png")
	;drawOutlineNamed("d2AlwaysRunOutline",ui.gameSettingsGui,6,3,484,69,cfg.OutlineColor2,cfg.OutlineColor2,1)
	

	guiName := ui.gameSettingsGui
	ui.d2KeybindWidth := 60
	labelX := 280
	labelY := 54
	labelW := 66
	labelH := 25
	backColor := cfg.TabColor1
	fontColor := cfg.FontColor1
	outlineColor := cfg.TrimColor1
	labelText := "Keybinds"
	ui.d2keybindAppTab1 := guiName.addText("x" labelX " y" labelY+labelH/2 " w" labelW " h" labelH/2+3 " background" outlineColor,"")
		     
	labelX := 346
	labelY := 54
	labelW := 96
	labelH := 25
	backColor := cfg.TabColor3
	fontColor := cfg.FontColor1
	outlineColor := cfg.TrimColor1
	labelText := "Game Settings"	
	
	
	ui.d2keybindGameTab1 	:= guiName.addText("x" labelX " y" labelY+labelH/2 " w" labelW-4 " h" labelH/2+3 " background" outlineColor,"")
	ui.d2Panel1Tab1Bg 		:= ui.gameSettingsGui.addText("hidden x44 y13 w437 h42 background" cfg.TrimColor1,"")
	ui.d2Panel1Tab1Bg2 		:= ui.gameSettingsGui.addText("hidden x45 y14 w435 h40 background" cfg.TabColor1 " c" cfg.FontColor1,"")
	ui.d2Panel1Tab1Detail1	:= ui.gameSettingsGui.addPicture("x45 y14 w435 h20 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	;ui.d2Panel1Tab1Detail2	:= ui.gameSettingsGui.addPicture("x45 y10 w435 h15 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.d2Panel1Tab1Bg3 		:= ui.gameSettingsGui.addText("hidden x46 y15 w433 h38 background" cfg.TabColor1,"")
	ui.d2Panel1Tab1Bg4 		:= ui.gameSettingsGui.addText("hidden x47 y16 w431 h36 background" cfg.TrimColor3,"")
	
	ui.d2Panel1Tab2Bg 		:= ui.gameSettingsGui.addText("hidden x19 y13 w438 h42 background" cfg.TrimColor1,"")
	ui.d2Panel1Tab2Bg2 		:= ui.gameSettingsGui.addText("hidden x20 y14 w436 h40 background" cfg.TabColor1 " c" cfg.FontColor3,"")	
	ui.d2Panel1Tab2Detail1	:= ui.gameSettingsGui.addPicture("x20 y14 w436 h14 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")	
	;ui.d2Panel1Tab2Detail2	:= ui.gameSettingsGui.addPicture("x20 y10 w450 h15 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")	
	ui.d2Panel1Tab2Bg3 		:= ui.gameSettingsGui.addText("hidden x21 y15 w434 h38 background" cfg.TabColor1,"")
	ui.d2Panel1Tab2Bg4 		:= ui.gameSettingsGui.addText("hidden x22 y16 w432 h36 background" cfg.OffColor,"")
	;ui.d2Panel1Tab2Bg := ui.gameSettingsGui.addText("x42 y10 w406 h42 background" cfg.TabColor1 " c" cfg.FontColor4,"")	
	;drawOutlineNamed("gameSettings",ui.gameSettingsGui,43,11,404,42,cfg.TrimColor1,cfg.titleTrimColor,1)
	ui.currKey 				:= cfg.dappPauseKey
	ui.dappPauseKey			:= ui.gameSettingsGui.addPicture("x50 y22 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappPauseKeyData 	:= ui.gameSettingsGui.addText("xs-1 y+-24 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h21 center c" cfg.OffColor " backgroundTrans",subStr(strUpper(cfg.dappPauseKey),1,8))
	ui.dappPauseKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" (ui.d2KeybindWidth + max(0,(strLen(ui.currKey)-6))*10) " h20 center c" cfg.FontColor3 " backgroundTrans","Pause")
	
	ui.keybindSpacer		:= ui.gameSettingsGui.addText("x112 y13 w1 h42 background" cfg.trimColor1)		
	ui.keybindSpacer1		:= ui.gameSettingsGui.addText("x113 y12 w2 h43 background" cfg.TabColor2)		
	ui.keybindSpacer2		:= ui.gameSettingsGui.addText("x115 y12 w1 h43 background" cfg.TrimColor1)
	;ui.gameSettingsGui.setFont("s11","Arial")
	
	ui.currKey 				:= cfg.dappToggleSprintKey

	ui.dappToggleSprintKey		:= ui.gameSettingsGui.addPicture("x+3 y22 w" 90
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappToggleSprintKeyData 	:= ui.gameSettingsGui.addText("xs-2 y+-24 w" 90 
		" h21 center c" cfg.OffColor " backgroundTrans",subStr(strUpper(cfg.dappToggleSprintKey),1,8))
	ui.dappToggleSprintKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 90 
		" h20 center c" cfg.FontColor3 " backgroundTrans","Sprint")
	
	ui.currKey := cfg.dappHoldToCrouchKey
	ui.dappHoldToCrouchKey		:= ui.gameSettingsGui.AddPicture("x+3 ys w" 60 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappHoldToCrouchKeyData 	:= ui.gameSettingsGui.addText("xs-1 y+-24 w" 60 
		" h21 center c" cfg.OffColor " backgroundTrans",subStr(strUpper(cfg.dappHoldToCrouchKey),1,8))
	ui.dappHoldToCrouchKeyLabel	:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 60 
		" h20 center c" cfg.FontColor3 " backgroundTrans","Crouch")

	ui.currKey := cfg.dappReloadKey
	ui.dappReloadKey			:= ui.gameSettingsGui.addPicture("x+3 ys w" 56 
		" h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappReloadKeyData 		:= ui.gameSettingsGui.addText("xs-1 y+-24 w" 56 
		" h21 center c" cfg.OffColor " backgroundTrans",subStr(strUpper(cfg.dappReloadKey),1,8))
	ui.dappReloadKeyLabel		:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 56 
	" h20 center c" cfg.FontColor3 " backgroundTrans","Reload")

	ui.currKey := cfg.dappLoadoutKey
	ui.dappLoadoutKey			:= ui.gameSettingsGui.addPicture("x+3 ys w" 64 
		"  h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappLoadoutKeyData 		:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 64 
		"  h21 center c" cfg.OffColor " backgroundTrans",subStr(strUpper(cfg.dappLoadoutKey),1,8))
	ui.dappLoadoutKeyLabel 		:= ui.gameSettingsGui.addText("xs+0 y+-34 w" 64 
		"  h20 center c" cfg.FontColor3 " backgroundTrans","Loadout")
	
	ui.currKey 					:= cfg.dappSwordFlyKey
	ui.dappSwordFlyKey			:= ui.gameSettingsGui.addPicture("x+7 ys w35 h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.dappSwordFlyKeyData 	:= ui.gameSettingsGui.addText("xs+0 y+-24 w35 h21 center c" cfg.OffColor " backgroundTrans"
		,subStr(strUpper(cfg.dappSwordFlyKey),1,8))
	ui.dappSwordFlyKeyLabel 	:= ui.gameSettingsGui.addText("xs-2 y+-35 w40 h20 center c" cfg.FontColor3 " backgroundTrans","Fly")
	ui.d2ClassSelectOutline		:= ui.gameSettingsGui.addText("xs+42 y15 w36 h39 background" cfg.TrimColor1)
	ui.d2ClassSelectOutline2	:= ui.gameSettingsGui.addText("xs+43 y15 w35 h38 background" cfg.TileColor)
	ui.d2ClassSelectBg			:= ui.gameSettingsGui.addText("x441 y14 w39 h39 background" cfg.AuxColor3)

	ui.d2ClassSelectBg3			:= ui.gameSettingsGui.addText("hidden xs+41 y+-14 w37 h14 background" cfg.auxColor2)
	ui.d2ClassIcon				:= ui.gameSettingsGui.addPicture("x442 y12 w39 h30 center backgroundTrans","")
	ui.d2ClassIconDown			:= ui.gameSettingsGui.addText("x442 y40 w21 h13 center backgroundTrans c" cfg.OutlineColor1,"←")
	ui.d2ClassIconUp			:= ui.gameSettingsGui.addText("x460 y40 w21 h13 center backgroundTrans c" cfg.OutlineColor1,"→")
	ui.d2ClassSelectSpacer 		:= ui.gameSettingsGui.addText("hidden x461 y40 w1 h13 background" cfg.TrimColor1)
	ui.d2ClassSelectBgLine		:= ui.gameSettingsGui.addText("hidden x442 y14 w0 h0 background" cfg.OutlineColor1)
	ui.d2ClassSelectBgLine1		:= ui.gameSettingsGui.addText("hidden x442 y14 w0 h0 background" cfg.OutlineColor1)
	ui.d2ClassSelectBgLine2		:= ui.gameSettingsGui.addText("hidden x442 y39 w38 h1 background" cfg.TrimColor1)
	ui.d2ClassSelectDetail 		:= ui.gameSettingsGui.addPicture("x441 y43 w40 h12 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.d2ClassSelectDetail2 		:= ui.gameSettingsGui.addPicture("x441 y12 w39 h20 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.d2KeyBindHelpMsg			:= ui.gameSettingsGui.addText("right x34 y54 w240 h12 backgroundTrans c" cfg.FontColor2,"")
	ui.d2ClassIcon.toolTip 		:= "Click to Enable/Disable the Fly Macro"
	ui.d2ClassIconDown.tooltip 	:= "Click to switch between character classes for the Fly Macro"
	ui.d2ClassIconUp.tooltip 	:= "Click to switch between character classes for the Fly Macro"
	
	ui.keybindSpacer70			:= ui.gameSettingsGui.addText("x439 y13 w1 h42 background" cfg.trimColor1)		
	ui.keybindSpacer7			:= ui.gameSettingsGui.addText("x440 y12 w2 h42 background" cfg.TabColor2)		
	ui.keybindSpacer8			:= ui.gameSettingsGui.addText("x442 y13 w1 h42 background" cfg.TrimColor1)	
	ui.keybindSpacer50			:= ui.gameSettingsGui.addText("x394 y13 w1 h42 background" cfg.trimColor1)		
	ui.keybindSpacer5			:= ui.gameSettingsGui.addText("x395 y12 w2 h42 background" cfg.TabColor2)		
	ui.keybindSpacer6			:= ui.gameSettingsGui.addText("x397 y13 w1 h42 background" cfg.TrimColor1)	
	ui.keybindSpacer4			:= ui.gameSettingsGui.addText("x480	y13 w1 h42 background" cfg.TrimColor1)		
	ui.keybindSpacer1Detail	:= ui.gameSettingsGui.addPicture("x112 y12 w4 h43 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.keybindSpacer2Detail	:= ui.gameSettingsGui.addPicture("x112 y12 w4 h43 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.keybindSpacer3Detail	:= ui.gameSettingsGui.addPicture("x394 y12 w4 h42 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.keybindSpacer4Detail	:= ui.gameSettingsGui.addPicture("x394 y12 w4 h42 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.keybindSpacer5Detail	:= ui.gameSettingsGui.addPicture("x439 y12 w4 h43 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.keybindSpacer6Detail	:= ui.gameSettingsGui.addPicture("x439 y12 w4 h43 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.keybindSpacer7Detail	:= ui.gameSettingsGui.addPicture("x480 y12 w1 h44 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.keybindSpacer8Detail	:= ui.gameSettingsGui.addPicture("x480 y12 w1 h44 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")

	ui.d2ClassIconDown.setFont("s9 q5")
	ui.d2ClassIconDown.onEvent("click",d2ClassIconDownChanged)
	ui.d2ClassIconUp.setFont("s9 q5")
	ui.d2ClassIconUp.onEvent("click",d2ClassIconUpChanged)
	ui.d2KeyBindHelpMsg.setFont("s8 q5 c" cfg.FontColor2)
	ui.d2ClassIcon.onEvent("click",d2ToggleFly)


	d2ToggleFly()
	d2ToggleFly(*) {
		(ui.d2FlyEnabled := !ui.d2FlyEnabled)

		switch cfg.d2CharacterClass {
			case 1: 
				(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_on.png",ui.d2ClassSelectBg.opt("background" cfg.AlertColor))
					: (ui.d2ClassIcon.value := "./img/d2ClassIconWarlock_off.png",ui.d2ClassSelectBg.opt("background" cfg.AuxColor1))
			case 2:
				(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img/d2ClassIconHunter_on.png",ui.d2ClassSelectBg.opt("background" cfg.AlertColor))
					: (ui.d2ClassIcon.value := "./img/d2ClassIconHunter_off.png",ui.d2ClassSelectBg.opt("background" cfg.AuxColor1))
			case 3:
			(ui.d2FlyEnabled)
					? (ui.d2ClassIcon.value := "./img/d2ClassIconTitan_on.png",ui.d2ClassSelectBg.opt("background" cfg.AlertColor))
					: (ui.d2ClassIcon.value := "./img/d2ClassIconTitan_off.png",ui.d2ClassSelectBg.opt("background" cfg.AuxColor1))
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

	ui.dappLoadoutKeyData.setFont("s11 q5")
	ui.dappPauseKeyData.setFont("s11 q5")
	ui.dappPauseKeyLabel.setFont("s10 q5")
	ui.dappReloadKeyData.setFont("s12 q5")
	ui.dappReloadKeyLabel.setFont("s10 q5")
	ui.dappHoldToCrouchKeyData.setFont("s11 q5")
	ui.dappToggleSprintKeyData.setFont("s11 q5")
	ui.dappHoldToCrouchKeyLabel.setFont("s10 q5")
	ui.dappLoadoutKeyLabel.setFont("s10 q5")
	ui.dappToggleSprintKeyLabel.setFont("s10 q5")
	ui.dappSwordFlyKeyData.setFont("s11 q5")
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
	
		
	ui.d2GameToggleSprintKey				:= ui.gameSettingsGui.AddPicture("x25 y22 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameToggleSprintKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.OffColor " backgroundTrans",subStr(strUpper(cfg.d2GameToggleSprintKey),1,8))
	ui.d2GameToggleSprintKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 18+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.FontColor1 " backgroundTrans","Toggle Sprint")
	
	ui.currKey := cfg.d2GameHoldToCrouchKey
	ui.currKeyLabel := "Hold Crouch"
	ui.d2GameHoldToCrouchKey					:= ui.gameSettingsGui.AddPicture("x+2 ys w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameHoldToCrouchKeyData 			:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h21 center c" cfg.OffColor " backgroundTrans",subStr(strUpper(cfg.d2GameHoldToCrouchKey),1,8))
	ui.d2GameHoldToCrouchKeyLabel			:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 10+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-8)*5))) " h20 center c" cfg.FontColor1 " backgroundTrans","Hold Crouch")

	ui.currKey := cfg.d2GameReloadKey
	ui.currKeyLabel := "Reload"
	ui.d2GameReloadKey						:= ui.gameSettingsGui.addPicture("x+2 ys w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameReloadKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h21 center c" cfg.OffColor " backgroundTrans",subStr(strUpper(cfg.d2GameReloadKey),1,8))
	ui.d2GameReloadKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w" 20+(ui.d2KeybindWidth + max(max(0,(strLen(ui.currKey)-6))*10,max(0,(strLen(ui.currKeyLabel)-12)*5))) " h20 center c" cfg.FontColor1 " backgroundTrans","Reload")		
	
	ui.currKey := cfg.d2GameGrenadeKey
	ui.currKeyLabel := "Reload"
	ui.d2GameGrenadeKey						:= ui.gameSettingsGui.addPicture("x+2 ys w85 h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameGrenadeKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w85 h21 center c" cfg.OffColor " backgroundTrans",subStr(strUpper(cfg.d2GameGrenadeKey),1,8))
	ui.d2GameGrenadeKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w85 h20 center c" cfg.FontColor1 " backgroundTrans","Grenade")		
	
	ui.currKey := cfg.d2GameSuperKey
	ui.currKeyLabel := "Super"
	ui.d2GameSuperKey						:= ui.gameSettingsGui.addPicture("x+2 ys w70 h30 section backgroundTrans","./img/keyboard_key_up.png")
	ui.d2GameSuperKeyData 					:= ui.gameSettingsGui.addText("xs-3 y+-24 w70 h21 center c" cfg.OffColor " backgroundTrans",subStr(strUpper(cfg.d2GameSuperKey),1,8))
	ui.d2GameSuperKeyLabel					:= ui.gameSettingsGui.addText("xs-1 y+-34 w70 h20 center c" cfg.FontColor1 " backgroundTrans","Super")		
	
	;cfg.d2AutoGameConfigEnabled := true
	ui.d2ToggleAutoGameConfig := ui.gameSettingsGui.addPicture("x462 y13 w20 h35 section "
	((cfg.d2AutoGameConfigEnabled) 
		? ("Background" cfg.OnColor) 
			: ("Background" cfg.OffColor)),
	((cfg.d2AutoGameConfigEnabled) 
		? ("./img/toggle_vertical_trans_on.png") 
			: ("./img/toggle_vertical_trans_off.png")))
	ui.d2ToggleAutoGameConfig.onEvent("click",d2ToggleAutoGameConfig)
	ui.d2ToggleAutoGameConfig.toolTip := "Enable to attempt to automatically`nImport your game settings."
	;ui.d2ToggleAutoGameConfigOutline := ui.gameSettingsGui.addText("ys+3 x+0 w1 h30 background" cfg.TrimColor2)
	ui.d2ToggleAutoGameConfigLabel := ui.gameSettingsGui.addText("xs-2 y+0 w28 h10 backgroundTrans","Auto")
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
	ui.d2gameToggleSprintKeyData.setFont("s11")
	ui.d2GameReloadKeyData.setFont("s11")
	ui.d2GameReloadKeylabel.setFont("s10")
	ui.d2GameSuperKeyData.setFont("s11")
	ui.d2GameSuperKeylabel.setFont("s10")
	ui.d2GameGrenadeKeyData.setFont("s11")
	ui.d2GameGrenadeKeylabel.setFont("s10")
	ui.d2GameHoldToCrouchKeyData.setFont("s11")
	ui.d2GameHoldToCrouchKeyLabel.setFont("s10")

	labelX := 280
	labelY := 54
	labelW := 66
	labelH := 25
	backColor := cfg.TabColor1
	fontColor := cfg.FontColor1
	outlineColor := cfg.TrimColor1
	labelText := "Keybinds"
	
	ui.d2keybindAppTab2 := guiName.addText("x" labelX+1 " y" labelY " w" labelW-2 " h" 18 " background" backColor " center c" fontColor) 
	ui.d2keybindAppTabDetail := guiName.addPicture("x" labelX+1 " y" labelY " w" labelW-2 " h" 12 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png") 
	;ui.d2keybindAppTabDetail2 := guiName.addPicture("hidden x" labelX+3 " y" labelY+10 " w" labelW-3 " h" labelH-11 " backgroundTrans","./img/custom/lightburst_blank.png") 
	ui.d2keybindAppTab3 := guiName.addText("x" labelX+1 " y" labelY " w" labelW-2 " h18 backgroundTrans center c" fontColor, labelText) 
	ui.d2keybindAppTab3.setFont("s10","Bold")

	labelX := 346
	labelY := 54
	labelW := 96
	labelH := 25
	backColor := cfg.TabColor3
	fontColor := cfg.FontColor1
	outlineColor := cfg.TrimColor1
	labelText := "Game Settings"
	ui.d2keybindGameTab2 := guiName.addText("x" labelX+4 " y" labelY " w" labelW-20 " h" 18 " background" backColor " center c" fontColor) 
	ui.d2keybindGameTabDetail := guiName.addPicture("x" labelX+4 " y" labelY+0 " w" labelW-18 " h" 12 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png") 
;	ui.d2keybindGameTabDetail2 := guiName.addPicture("hidden x" labelX+2 " y" labelY+10 " w" labelW-10 " h" labelH-11 " backgroundTrans","./img/custom/lightburst_blank.png") 
	ui.d2keybindGameTab3 := guiName.addText("x" labelX-1 " y" labelY " w" labelW-4 " h18 backgroundTrans center c" fontColor, labelText) 
	ui.d2keybindGameTab3.setFont("s8 q5 c" cfg.FontColor3)

	ui.d2keybindAppTab1.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindAppTab2.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindAppTab3.onEvent("click",d2keybindAppTabClicked)
	ui.d2keybindGameTab1.onEvent("click",d2keybindGameTabClicked)
	ui.d2keybindGameTab2.onEvent("click",d2keybindGameTabClicked)
	ui.d2keybindGameTab3.onEvent("click",d2keybindGameTabClicked)
	ui.dappFunctionsEnabled := true
	ui.d2ToggleAppFunctions := ui.gameSettingsGui.addPicture("x17 y12 w20 h35 section "
	((ui.dappFunctionsEnabled) 
		? ("Background" cfg.OnColor) 
			: ("Background" cfg.OffColor)),
	((ui.dappFunctionsEnabled) 
		? ("./img/toggle_vertical_trans_on.png") 
			: ("./img/toggle_vertical_trans_off.png")))
	ui.d2ToggleAppFunctions.onEvent("click",d2ToggleAppFunctions)
	ui.d2ToggleAppFunctionsOutline := ui.gameSettingsGui.addText("ys+4 x+0 w1 h32 background" cfg.TrimColor2)
	ui.d2ToggleAppFunctionsLabel := ui.gameSettingsGui.addText("xs-5 y+-1 w28 h10 backgroundTrans center","Pause")
	ui.d2ToggleAppFunctionsLabel.setFont("s8")
d2keybindAppTabClicked()

}

keyBindDialogBox(Msg,Alignment := "Center") {
	Global
	if !InStr("LeftRightCenter",Alignment)
		Alignment := "Left"
	Transparent := 250
	
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Bind Key"

	ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow +Owner" ui.mainGui.hwnd)  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := cfg.TabColor2  ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.SetFont("s12")  ; Set a large font size (32-point).
	ui.notifyGui.AddText("c" cfg.OnColor " " Alignment " BackgroundTrans","Press desired key to use for: ")
	ui.notifyGui.setFont("s14")
	ui.notifyGui.addText("ys-4 x+0 c" cfg.AlertColor,Msg)
	ui.notifyGui.setFont("s13 c" cfg.OnColor,"Courier Narrow Bold")
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
	drawOutlineNotifyGui(1,1,w,h,cfg.OutlineColor2,cfg.OutlineColor1,2)
	drawOutlineNotifyGui(2,2,w-4,h-4,cfg.AuxColor3,cfg.AuxColor3,1)
	
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


ui.mapBrowserVisible:=false
toggleMapBrowser(*) {
		(ui.mapBrowserVisible:=!ui.mapBrowserVisible)
			? showMapBrowser()
			: closeMapBrowser()
			
		closeMapBrowser(*) {
			ui.mapBrowserVisible:=false
			ui.mapGui.destroy()
		}
		showMapBrowser(*) {
		winGetPos(&x,&y,,,ui.mainGui)
		cfg.guiX:=x
		cfg.guiY:=y
			try
				mapGui.destroy()
				
			ui.mapGui:=gui()
			ui.mapGui.opt("toolWindow -border -caption alwaysOnTop owner" ui.mainGui.hwnd)
			ui.mapGui.backColor:=cfg.TabColor2
			ui.mapGui.color:="010203"
			winSetTransColor("010203",ui.mapGui)
			
			mapGuiTitle:=ui.mapGui.addText("x0 y0 w1190 h30 background" cfg.TabColor1)
			mapGuiTitle.onEvent("click",WM_LBUTTONDOWN_callback)
			mapGuiTitleText:=ui.mapGui.addText("x5 y2 w200 h30 backgroundTrans c" cfg.FontColor1,"Map Browser")
			mapGuiTitleText.setFont("s16 q5","move-x")
			mapGuiClose:=ui.mapGui.AddText("x1190 y2 w30 h30 center BackgroundTrans","r")
			mapGuiClose.setFont("s18 c" cfg.FontColor2,"Webdings")
			mapGuiClose.onEvent("click",closeMapBrowser)
			
			colNum:=0
			currX:=5
			currY:=35
			loop files, "./img/maps/*.*" {
				colNum+=1
				if colNum > 3 {
					colNum:=0
					currX:=5
					currY+=205
				}
				
				ui.mapThumb%a_index%:=ui.mapGui.addPicture("vmapThumb" a_index " x" currX " y" currY " w400 h200 backgroundTrans","./img/maps/" a_loopFilename)
				ui.mapThumb%a_index%.onEvent("click",showMap)
				activityLabel:=ui.mapGui.addText("center x" currX " y" currY+0 " w400 h25 background" cfg.TabColor1,strSplit(a_loopFilename,"_")[1])
				ui.mapGui.addPicture("x" currX " y" currY " w400 h20 backgroundTrans","./img/custom/lightburst_top_bar_light.png")
				encounterLabel:=ui.mapGui.addText("center x" currX " y" currY+175 " w400 h25 background" cfg.TabColor1,strSplit(strSplit(a_loopFilename,"_")[2],".")[1])
				ui.mapGui.addPicture("x" currX " y" currY+180 " w400 h20 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
				activityLabel.setFont("c" cfg.FontColor1 " s14 q5","move-x")
				encounterLabel.setFont("c" cfg.FontColor1 " s12 q5","move-x")
				drawOutlineNamed("mapThumb" a_index,ui.mapGui,currX, currY,400,200,cfg.TrimColor1,cfg.TrimColor1,1)
				currX+=405
				
			}
			
			ui.mapGui.show("x" cfg.guiX+34 " y" cfg.guiY " w1220")
			winGetPos(&tX,&tY,&tW,&tH,ui.mapGui)
			drawOutlineNamed("mapOutline",ui.mapGui,0,0,tW,tH,cfg.TrimColor2,cfg.TrimColor2,1)
		}
		showMap(this_control,*) {
			showMapGui := gui() 
			showMapGui.opt("-caption toolWindow alwaysOnTop owner" ui.mapGui.hwnd)
			showMapGui.backColor:="010203"
			winSetTransColor("010203",showMapGui)
			fullMap:=showMapGui.addPicture("x0 y2 w1600 h-1 backgroundTrans",this_control.value)
			fullMap.onEvent("click",closeMap)
			winGetPos(&mbX,&mbY,&mbW,&mbH,ui.mapGui)
			showMapGui.show("x" mbX " y" mbY " w1600")
			
			closeMap(*) {
				try 
					showMapGui.destroy()
			}
		}
		
		hideMapBrowser(*) {
			try
				mapGui.destroy()
		}
}

drawLinkBar(*) {
	static xPos:=15
	static yPos:=84
	
	cfg.button_link_1:=["DIM","URL","https://app.destinyitemmanager.com","./img/button_DIM.png","Launches DIM in browser"]
	cfg.button_link_2:=["Join","Function","toggleFireteam","./img/ft_icon.png","Unbound, click to assign"]
	cfg.button_link_3:=["Glyphs","Function","toggleGlyphWindow","./img/d2_glyphs_thumb.png","Shows Glyph callout infographic"]
	cfg.button_link_4:=["Runes","Function","toggleRuneWindow","./img/d2_runes_thumb.png","Shows Rune callout infographic"]
	cfg.button_link_5:=["WishCodes","Function","toggleCodeWindow","./img/d2_wishCodes_thumb.png","Shows codes for Wall of Wishes"]
	cfg.button_link_6:=["Maps","Function","toggleMapBrowser","./img/d2_maps_thumb.png","Shows collection of maps"]

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
	; ui.panel4box3:=ui.gameSettingsGui.addText("x7 y75 w485 h70 background" cfg.TabColor2,"")
	; ui.panel4box4:=ui.gameSettingsGui.addText("x8 y76 w483 h68 c" cfg.TabColor2 " background" cfg.TabColor1)
	; drawOutlineNamed("d2linkPanel",ui.gameSettingsGui,12,76,474,60,cfg.TrimColor2,cfg.AuxColor3,1)
	; drawOutlineNamed("d2linkPanel",ui.gameSettingsGui,6,72,486,72,cfg.OutlineColor2,cfg.OutlineColor1,1)
	; drawOutlineNamed("d2AlwaysRunOutline",ui.gameSettingsGui,7,73,484,70,cfg.OutlineColor1,cfg.OutlineColor2,1)	



	
	loop 8 {
		ui.button_link_%a_index% := object()
		ui.button_link_%a_index%.name:=cfg.button_link_%a_index%[1]
		ui.button_link_%a_index%.type:=cfg.button_link_%a_index%[2]
		ui.button_link_%a_index%.action:=cfg.button_link_%a_index%[3]
		ui.button_link_%a_index%.thumb:=cfg.button_link_%a_index%[4]
		ui.button_link_%a_index%.bg:=ui.gameSettingsGui.addPicture("x" xPos+2 " y" yPos+1 " w" cfg.button_link_size-1 " h-1 vbutton_link_" a_index " background" cfg.tileColor,ui.button_link_%a_index%.thumb)
		ui.button_link_%a_index%.fx:=ui.gameSettingsGui.addPicture("x" xPos+1 " y" yPos-1 " w" cfg.button_link_size-1 " h" 50 " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
		;ui.button_link_%a_index%.fx2:=ui.gameSettingsGui.addPicture("x" xPos+1 " y" yPos+(cfg.button_link_size-cfg.curveAmount) " w" cfg.button_link_size-1 " h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
		ui.button_link_%a_index%.down:=ui.gameSettingsGui.addPicture("x" xPos+1 " y" yPos+1 " w" cfg.button_link_size-1 " h" cfg.button_link_size-1 " hidden backgroundTrans","./img/button_down_layer.png")
		drawOutlineNamed("button_link_" a_index "_outline",ui.gameSettingsGui,xPos,yPos,cfg.button_link_size+1,cfg.button_link_size+1,cfg.OutlineColor1,cfg.OutlineColor2,1)
		;drawOutline(ui.gameSettingsGui,xPos+1,yPos+1,cfg.button_link_size-1,cfg.button_link_size-1,cfg.titleTrimColor,cfg.AuxColor3,1)

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
	static yPos:=84
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
		ui.editLinkGui.color:=cfg.FontColor3
		ui.editLinkBg:=ui.editLinkGui.addText("x0 y0 w300 h80 background" cfg.TabColor1)
		ui.editLinkTitlebar:=ui.editLinkGui.addText("x0 y0 w80 h20 background" cfg.TabColor2)
		ui.editLinkTitlebar.onEvent("click",WM_LBUTTONDOWN_callback)

		ui.thumbPreview:=ui.editLinkGui.addPicture("center x10 y20 w60 h60 backgroundTrans",ui.%lParam.name%.thumb)
		
		ui.linkNameLabel:=ui.editLinkGui.addText("x85 y2 w40 backgroundTrans c" cfg.FontColor1,"Name: ")
		ui.linkNameValue:=ui.editLinkGui.addEdit("x125 y2 w170 background" cfg.TabColor2 " c" cfg.TrimColor3,ui.%lParam.name%.name)
		ui.linkTypeLabel:=ui.editLinkGui.addText("x85 y20 w40 backgroundTrans c" cfg.FontColor1,"Type: ")
		ui.linkTypeValue:=ui.editLinkGui.addEdit("x125 y20 w170 background" cfg.TabColor2 " c" cfg.TrimColor3,ui.%lParam.name%.type)
		ui.linkActionLabel:=ui.editLinkGui.addText("x85 y40 w40 backgroundTrans c" cfg.FontColor1,"Action: ")
		ui.linkActionValue:=ui.editLinkGui.addEdit("x125 y40 w170 background" cfg.TabColor2 " c" cfg.TrimColor3,ui.%lParam.name%.action)
		ui.linkThumbLabel:=ui.editLinkGui.addText("x85 y60 w40 backgroundTrans c" cfg.FontColor1,"Thumb: ")
		ui.linkThumbValue:=ui.editLinkGui.addEdit("x125 y60 w170 background" cfg.TabColor2 " c" cfg.TrimColor3,ui.%lParam.name%.thumb)
		drawOutline(ui.editLinkGui,0,0,80,20,cfg.TrimColor1,cfg.TrimColor1,1)
		;drawOutline(ui.editLinkGui,0,20,80,60,cfg.TrimColor1,cfg.TrimColor1,1)
		drawOutline(ui.editLinkGui,80,0,300,80,cfg.TrimColor1,cfg.TrimColor1,1)
		winGetPos(&elX,&elY,&elW,&elH,ui.gameSettingsGui)
		ui.editLinkGui.show("x" elX " y" elY+elH+10 " w" 300 " h" 80)
	}
}
	
	



d2KeybindTabChange(this_button,*) {
}
	
drawKeybind(x,y,bindName,labelText := bindName,gui := ui.mainGui,w := 84,h := 30,buttonImage := "./img/keyboard_key_up.png",textJustify := "center",fontColorReady := cfg.AlertColor,fontColorOn := cfg.OnColor) {
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
