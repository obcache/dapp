#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) { ;run main app
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}


inputHookAllowedKeys := "{All}{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{Left}{Right}{Up}{Down}{BS}{CapsLock}{NumLock}{PrintScreen}{Pause}{Tab}{Enter}{ScrollLock}{LButton}{MButton}{RButton}"	

ui.d2FlashingIncursionNotice := false
ui.d2ShowingIncursionNotice := false
ui.incursionDebug := false
ui.d2FlyEnabled := false

GuiGameTab() {
	global	

	loop cfg.gameTabList.length {
		if fileExist("./lib/lib" cfg.gameTabList[A_Index])
			runWait("./lib/lib" cfg.gameTabList[A_Index])
	}
	try
		ui.gameSettingsGui.destroy()
		
	ui.gameSettingsGui := Gui()
	ui.gameSettingsGui.Name := "dapp"
	ui.gameSettingsGui.BackColor := cfg.TabColor1
	ui.gameSettingsGui.Color := cfg.TabColor1
	ui.gameSettingsGui.MarginX := 5
	ui.gameSettingsGui.Opt("-Caption -Border +AlwaysOnTop owner" ui.mainGui.hwnd)
	ui.gameSettingsGui.SetFont("s14 c" cfg.FontColor1,"calibri")
	ui.gameTabs := ui.gameSettingsGui.addTab3("-redraw x0 y-5 h194 0x400 bottom c" cfg.TabColor2 " choose" cfg.activeGameTab,["Gameplay","Vault Cleaner"])

	ui.gameTabs.value:=cfg.activeGameTab
	ui.gameTabs.onEvent("Change",gameTabChanged)
	ui.mainGui.GetPos(&winX,&winY,,)
	winSetRegion("2-0 w495 h190",ui.gameSettingsGui)
	
	ui.d2Sliding := false
	ui.d2HoldingRun := false         
	ui.d2cleanupNeeded := false
	ui.gameSettingsGui.setFont("s12 bold","calibri")

	ui.d2TopPanelOutline:=ui.gameSettingsGui.addText("x8 y8 w480 h66 background" cfg.AuxColor1)
	ui.d2TopPanelBg:=ui.gameSettingsGui.addText("x9 y9 w478 h65 background" cfg.TabColor2)
	ui.d2TopPanelDetail1:=ui.gameSettingsGui.addPicture("x9 y8 w478 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_light.png")
	ui.d2TopPanelDetail2:=ui.gameSettingsGui.addPicture("x9 y" 9+(65-cfg.curveAmount) " w478 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.bottomPanelOutline:=ui.gameSettingsGui.addText("x8 y82 w480 h62 background" cfg.AuxColor1)
	ui.bottomPanelBg:=ui.gameSettingsGui.addText("x9 y83 w478 h61 background" cfg.TabColor2)
	ui.bottomPanelDetail2:=ui.gameSettingsGui.addPicture("x9 y81 w478 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_light.png")
	ui.bottomPanelDetail2:=ui.gameSettingsGui.addPicture("x9 y" 84+(60-cfg.curveAmount) " w478 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")

	drawKeybindBar()
	drawLinkBar()

	;d2drawPanel4()
	if d2ActivePanel == 1 
		d2keybindAppTabClicked()
	else
		d2keybindGameTabClicked()	
	
	drawGameTabs(cfg.activeGameTab)
;d2keybindAppTabClicked()
}	 



drawGameTabs(tabNum := 1) {
	ui.gameTabWidth := 0
	; try	 
	; ui.gameTabGui.destroy()
	ui.gameTabGui := gui()
	ui.gameTabGui.opt("-caption toolWindow alwaysOnTop +E0x20 owner" ui.gameSettingsGui.hwnd)
	ui.gameTabGui.backColor := ui.transparentColor
	ui.gameTabGui.color := ui.transparentColor
	ui.gameTabGui.setFont("s7 c" cfg.FontColor2,"small font")
	drawOutlineNamed("gameTabOutline",ui.gameTabGui,0,0,498,2
		,cfg.TrimColor1,cfg.TrimColor1,2)

	winSetTransColor(ui.transparentColor,ui.gameTabGui)

	((tabNum == 1)
		? ui.gameTab1SkinOutline := ui.gameTabGui.addText("section x0 y0 w110 h32 background" cfg.TrimColor1,"" )
		: ui.gameTab1SkinOutline := ui.gameTabGui.addText("section x0 y2 w110 h30 background" cfg.TrimColor2,""))
	
	ui.gameTab1Skin := ui.gameTabGui.addText(
		((tabNum == 1) 
			? "y0 h30" 
			: "y2 h28")
				" x2 w108  background" 
		((tabNum == 1) 
			? cfg.TabColor1
			: cfg.TabColor2) 
		" c" ((tabNum == 1) 
			? cfg.FontColor1
			: cfg.FontColor2)
		,"")
	ui.gameTab1Skin.setFont((tabNum == 1 
		? "s14" 
		: "s12"),"Impact")
	ui.gameTab1Label := ui.gameTabGui.addText(
		((tabNum == 1) 
			? "ys2 h28" 
			: "ys2 h28")
				" x2 w108 center backgroundTrans c" 
		((tabNum == 1) 
			? cfg.FontColor1 
			: cfg.FontColor2)
			,"Gameplay")
	ui.gameTab1Label.setFont((tabNum == 1 
		? "s14" 
		: "s12")
			,"Impact")
	ui.gameTabWidth += 110
	((tabNum == 1 || tabNum == 2)
		? ui.gameTab1Divider:=ui.gameTabGui.addText("y0 x108 w2 h34 background" cfg.TrimColor1,"")
		: ui.gameTab1Divider:=ui.gameTabGui.addText("y2 x108 w2 h30 background" cfg.TrimColor2,""))
	((tabNum == 2)
		? ui.gameTab2SkinOutline := ui.gameTabGui.addText("x110 y0 w130 h34 background" cfg.TrimColor1,"" )
		: ui.gameTab2SkinOutline := ui.gameTabGui.addText("x110 y2 w130 h30 background" cfg.TrimColor2,""))

	
	ui.gameTab2Skin := ui.gameTabGui.addText(
		((tabNum == 2) 
			? "y0 h30" 
			: "y2 h28")
				" x110 w130 center background" 
		((tabNum == 2) 
			? cfg.TabColor1 
			: cfg.TabColor2)
				" c" ((tabNum == 2)
			? cfg.FontColor1 
			: cfg.FontColor2)
				,"")
	ui.gameTab2Skin.setFont(
		((tabNum == 2)
			? "s14" 
			: "s12")
			,"Impact")
	ui.gameTab2Label := ui.gameTabGui.addText(
		((tabNum == 2) 
			? "y3 h26" 
			: "y5 h32")
		" x110 w130 center backgroundTrans c" 
		((tabNum == 2)
		? cfg.FontColor1 
			: cfg.FontColor2)
		,"Vault Cleaner")
	ui.gameTab2Label.setFont(
		((tabNum == 2)
			? "s14" 
			: "s12")
		,"Impact")
	ui.gameTabWidth += 130	
	((tabNum == 2 || tabNum == 3)
		? ui.gameTab2Divider:=ui.gameTabGui.addText("y0 x238 w2 h34 background" cfg.TrimColor1,"")
		: ui.gameTab2Divider:=ui.gameTabGui.addText("y2 x238 w2 h30 background" cfg.TrimColor2,""))

	ui.gameTabDetail1:=ui.gameTabGui.addPicture(((tabNum==1) ? "-hidden " : "-hidden ") "x0 y" ((tabNum==1) ? 2 : 2)+30-cfg.curveAmount " w110 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.gameTabDetail2:=ui.gameTabGui.addPicture(((tabNum==2) ? "-hidden " : "-hidden ") "x110 y" ((tabNum==1) ? 2 : 2)+30-cfg.curveAmount " w130 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")	 
	ui.gameTabDetail3:=ui.gameTabGui.addPicture(((tabNum==2) ? "-hidden " : "hidden ") "x0 y" 2 " w108 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.gameTabDetail4:=ui.gameTabGui.addPicture(((tabNum==1) ? "hidden " : "-hidden ") "x" 108-(cfg.curveAmount/3) " y" 2 " w" cfg.curveAmount/3 " h" 28 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")	 
 	ui.gameTabDetail6:=ui.gameTabGui.addPicture(((tabNum==2) ? "hidden " : "-hidden ") "x112 y" 2 " w130 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.gameTabDetail5:=ui.gameTabGui.addPicture(((tabNum==1) ? "-hidden " : "hidden ") "x110 y" 2 " w" cfg.curveAmount/3 " h" 28 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")	
	
	ui.gameTab1SkinOutline.redraw()
	ui.gameTab1Skin.redraw()
	ui.gameTab1Label.redraw()
	ui.gameTab1Divider.redraw()
	ui.gameTab2SkinOutline.redraw()
	ui.gameTab2Skin.redraw()
	ui.gameTab2Label.redraw()
	ui.gameTab2Divider.redraw()
	;ui.gameTabDetail0.redraw()
	ui.gameTabDetail1.redraw()
	ui.gameTabDetail2.redraw()
	ui.gameTabDetail3.redraw()
	ui.gameTabDetail4.redraw()
	ui.gameTabDetail5.redraw()
	ui.gameTabDetail6.redraw()
	
	
	winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui.hwnd)
	ui.gameTabSpacer:=ui.gameTabGui.addText("y2 x240 w" 490-(ui.gameTabWidth) " h29 background" cfg.titleBgColor)
	ui.gameTabSpacer.onEvent("click",WM_LBUTTONDOWN_callback)
	ui.buildNumber:=ui.gameTabGui.addText("x298 y16 w160 h29 right backgroundTrans","v" a_fileVersion)
	ui.buildNumber.setFont("q5 s9 c" cfg.titleFontColor,"move-x")	

	ui.statusBarText:=ui.gameTabGui.addText("hidden x250 y9 w240 h26 backgroundTrans")
	ui.statusBarText.text:="     "
	ui.statusBarText.setFont("s10 q5 c" cfg.titleFontColor,"calibri")
	
	ui.gameTabSpacerDetail2:=ui.gameTabGui.addPicture("y" 2 " x240 w" 250 " h" cfg.curveAmount-2 " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.gameTabSpacerDetail2.onEvent("click",WM_LBUTTONDOWN_callback)
	ui.gameTabSpacerDetail:=ui.gameTabGui.addPicture("y" 28-cfg.curveAmount+6 " x240 w" 250 " h" cfg.curveAmount-2 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.gameTabSpacerDetail.onEvent("click",WM_LBUTTONDOWN_callback)
	ui.gameTabGui.addPicture("x1240 y" 2 " w" cfg.curveAmount/3 " h" 29 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
	ui.gameTabGui.addPicture("x" 1466-(cfg.curveAmount/3) " y" 2 " w" cfg.curveAmount/3 " h" 29 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")	
	ui.gameTabGui.addPicture("x1240 y" 2 " w250 h29 backgroundTrans",(fileExist(subStr(cfg.titleBarImage,1,(strLen(cfg.titleBarImage)-4)) "_flipped.png")) ? subStr(cfg.titleBarImage,1,(strLen(cfg.titleBarImage)-4)) "_flipped.png" : cfg.titleBarImage)
	; if !fileExist(cfg.titleBarImage)
		; cfg.titleBarImage:="./img/custom/lightburst_bottom_light.png"





	if !(mainGuiX==0 && mainGuiY==0) {
		ui.gameTabGui.show("w498 h32 noActivate x" mainGuiX+34 " y" mainGuiY+183)
		
	}
	
	createShading(objGui,objX,objY,objW,objH) {
		objGui.addPicture("x" objX " y" objY " w" objW " h" min(cfg.curveAmount,(objH/2)))
		objGui.addPicture("x" objX " y" objH-(min(cfg.curveAmount,(objH/2))) " w" objW " h" min(cfg.curveAmount,(objH/2)))
	}
	
	line(ui.gameTabGui,240,31,500,1,"010203")
	line(ui.gameTabGui,495,2,28,1,cfg.TrimColor1,"VERT")
	ui.gameTabGui.addText("x464 y2 w31 h29 background" cfg.TabColor2)
	ui.helpIcon := ui.gameTabGui.addPicture("x470 y3 w-1 h26 backgroundTrans","./img/icon_help.png")

	drawOutlineNamed("helpOutline",ui.gameTabGui,463,0,34,32,cfg.TrimColor1,cfg.TrimColor1,2)
	ui.gameTabGui.addPicture("x465 y" 2 " w30 h" 16-(15-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.gameTabGui.addPicture("x463 y" 15+(15-cfg.curveAmount) " w37 h" 17-(15-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")


}

gameTabChanged(*) { 
	cfg.activeGameTab := ui.gametabs.value
	refreshGameTabs(ui.gameTabs.value)
	; if ui.gameTabs.value=="2" {
		; sbUpdate("Vault Cleaner Mode: Off")
	; } else {
		; sbUpdate("Ready...")
	; }
	;guiVis(ui.gameTabGui,true)
	
;	tabsChanged()
}

refreshGameTabs(tabNum := 1) {
	drawOutlineNamed("gameTabOutline",ui.gameTabGui,0,0,498,2
		,cfg.TrimColor1,cfg.TrimColor1,2)

	ui.gameTabWidth := 0
		ui.gameTab1SkinOutline:=""
	ui.gameTab1Skin:=""
	ui.gameTab1Label:=""
	ui.gameTab1Divider:=""
	ui.gameTab2SkinOutline:=""
	ui.gameTab2Skin:=""
	ui.gameTab2Label:=""
	ui.gameTab2Divider:=""
	((tabNum == 1)
		? ui.gameTab1SkinOutline := ui.gameTabGui.addText("section x0 y0 w110 h32 background" cfg.TrimColor1,"" )
		: ui.gameTab1SkinOutline := ui.gameTabGui.addText("section x0 y2 w110 h30 background" cfg.TrimColor2,""))
	
	ui.gameTab1Skin := ui.gameTabGui.addText(
		((tabNum == 1) 
			? "y0 h30" 
			: "y2 h28")
				" x2 w108  background" 
		((tabNum == 1) 
			? cfg.TabColor1
			: cfg.TabColor2) 
		" c" ((tabNum == 1) 
			? cfg.FontColor1
			: cfg.FontColor2)
		,"")
	ui.gameTab1Skin.setFont((tabNum == 1 
		? "s14" 
		: "s12"),"Impact")
	ui.gameTab1Label := ui.gameTabGui.addText(
		((tabNum == 1) 
			? "ys2 h28" 
			: "ys2 h28")
				" x2 w108 center backgroundTrans c" 
		((tabNum == 1) 
			? cfg.FontColor1 
			: cfg.FontColor2)
			,"Gameplay")
	ui.gameTab1Label.setFont((tabNum == 1 
		? "s14" 
		: "s12")
			,"Impact")
	ui.gameTabWidth += 110
	((tabNum == 1 || tabNum == 2)
		? ui.gameTab1Divider:=ui.gameTabGui.addText("y0 x108 w2 h34 background" cfg.TrimColor1,"")
		: ui.gameTab1Divider:=ui.gameTabGui.addText("y2 x108 w2 h30 background" cfg.TrimColor2,""))
	((tabNum == 2)
		? ui.gameTab2SkinOutline := ui.gameTabGui.addText("x110 y0 w130 h34 background" cfg.TrimColor1,"" )
		: ui.gameTab2SkinOutline := ui.gameTabGui.addText("x110 y2 w130 h30 background" cfg.TrimColor2,""))

	
	ui.gameTab2Skin := ui.gameTabGui.addText(
		((tabNum == 2) 
			? "y0 h30" 
			: "y2 h28")
				" x110 w130 center background" 
		((tabNum == 2) 
			? cfg.TabColor1 
			: cfg.TabColor2)
				" c" ((tabNum == 2)
			? cfg.FontColor1 
			: cfg.FontColor2)
				,"")
	ui.gameTab2Skin.setFont(
		((tabNum == 2)
			? "s14" 
			: "s12")
			,"Impact")
	ui.gameTab2Label := ui.gameTabGui.addText(
		((tabNum == 2) 
			? "y3 h26" 
			: "y5 h32")
		" x110 w130 center backgroundTrans c" 
		((tabNum == 2)
		? cfg.FontColor1 
			: cfg.FontColor2)
		,"Vault Cleaner")
	ui.gameTab2Label.setFont(
		((tabNum == 2)
			? "s14" 
			: "s12")
		,"Impact")
	ui.gameTabWidth += 130	
	((tabNum == 2 || tabNum == 3)
		? ui.gameTab2Divider:=ui.gameTabGui.addText("y0 x238 w2 h34 background" cfg.TrimColor1,"")
		: ui.gameTab2Divider:=ui.gameTabGui.addText("y2 x238 w2 h30 background" cfg.TrimColor2,""))

	ui.gameTabDetail1:= ""
	ui.gameTabDetail2:= ""
	ui.gameTabDetail3:= ""
	ui.gameTabDetail4:= ""
	ui.gameTabDetail5:= ""
	ui.gameTabDetail6:= ""
	ui.gameTabDetail1:=ui.gameTabGui.addPicture(((tabNum==1) ? "-hidden " : "-hidden ") "x0 y" ((tabNum==1) ? 2 : 2)+30-cfg.curveAmount " w110 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.gameTabDetail2:=ui.gameTabGui.addPicture(((tabNum==2) ? "-hidden " : "-hidden ") "x110 y" ((tabNum==1) ? 2 : 2)+30-cfg.curveAmount " w130 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")	 
	ui.gameTabDetail3:=ui.gameTabGui.addPicture(((tabNum==2) ? "-hidden " : "hidden ") "x0 y" 2 " w108 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.gameTabDetail4:=ui.gameTabGui.addPicture(((tabNum==1) ? "hidden " : "-hidden ") "x" 109-(cfg.curveAmount/3) " y" 2 " w" cfg.curveAmount/3 " h" 30 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")	 
 	ui.gameTabDetail6:=ui.gameTabGui.addPicture(((tabNum==2) ? "hidden " : "-hidden ") "x112 y" 2 " w130 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.gameTabDetail5:=ui.gameTabGui.addPicture(((tabNum==1) ? "-hidden " : "hidden ") "x110 y" 2 " w" cfg.curveAmount/3 " h" 28 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")	
	
	ui.gameTab1SkinOutline.redraw()
	ui.gameTab1Skin.redraw()
	ui.gameTab1Label.redraw()
	ui.gameTab1Divider.redraw()
	ui.gameTab2SkinOutline.redraw()
	ui.gameTab2Skin.redraw()
	ui.gameTab2Label.redraw()
	ui.gameTab2Divider.redraw()
	;ui.gameTabDetail0.redraw()
	ui.gameTabDetail1.redraw()
	ui.gameTabDetail2.redraw()
	ui.gameTabDetail3.redraw()
	ui.gameTabDetail4.redraw()
	ui.gameTabDetail5.redraw()
	ui.gameTabDetail6.redraw()
}



;ui.gameRunningHeaderLabel:=ui.gameTabGui.addText("hidden section x300 y5 w200 h15 backgroundTrans","Attached Game Window")

;ui.gameLinkLabel:=ui.gameTabGui.addText("x325 y6 w180 h20 backgroundTrans","Game Status")
;ui.gameLinkLabel.setFont("s14 c" cfg.FontColor1,"move-x")

ui.gameHwnd:=0

setTimer(isGameRunning,2000)
isGameRunning(*) {
	try {
		return ui.gameHwnd := (winExist("ahk_exe destiny2.exe")) ? gameActive() : gameInactive()
		
		gameActive(*) {
			ui.gameLink.value:="./img/toggle_button_on.png"
			ui.gameLink.toolTip:="Destiny 2 Running at PID " winGet("PID","ahk_exe destiny2.exe")
			ui.gameLink.onEvent("click",killDestiny)
		}
		
		gameInactive(*) {
			ui.gameLink.value:="./img/toggle_button_off.png"
			ui.gameLink.toolTip:="Click button to launch Destiny 2"
			ui.gameLink.onEvent("click",launchDestiny)
		}
	}		  
	return 0
}

killDestiny(*) {
	winKill("ahk_exe destiny2.exe")
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

sbUpdate(msg) {
	ui.statusBarText.text:=(msg)		
}


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

ui.d2Log:= ui.gameSettingsGui.addText("x405 y10 w68 h80 hidden background" cfg.titleBgColor " c" cfg.LabelColor1," Destiny 2`n Log Started`n Waiting for Input")
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
	ui.d2CodeTitlebar:=ui.d2wwCodesGui.addText("x5 y0 w1200 h30 background" cfg.tabColor4)
	ui.d2CodeExit := ui.d2wwCodesGui.addPicture("x1175 y0 w30 h30 background" cfg.titleBgColor,"./img/button_quit.png")
	ui.d2CodeExit.onEvent("click",hideCodeWindow)
	;ui.d2wwCodeImg.onEvent("click",WM_LBUTTONDOWN_callback)
	
	ui.d2wwCodesGui.show()
}																																																																																																																																																																																																																				

hideCodeWindow(*) {
	;ui.d2LaunchBrayTechButton.value := "./img/button_brayTech.png"
	try
		ui.d2wwCodesGui.destroy()
}
	

drawInfographic("vod")
drawInfographic(infographicName:="vod",imageWidth := 150,imageHeight := 150, numColumns := 5) {
	imageTypes := "png,jpg,gif,bmp"
	infographicFolder := "./img/infogfx"
	transparentColor := "030405"

	winGetPos(&infoGuiX,&infoGuiY,,,ui.mainGui)
	infoGuiMon := 1
	loop monitorGetCount() {
		monitorGet(a_index,&monLeft,,&monRight,)
		if infoGuiX > monLeft && infoGuiX < monRight {
			infoGuiMon := a_index
			break
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


toggleGlyphWindow(this_button,*) {
	closeThis()
	static glyphWindowVisible := false
	(glyphWindowVisible := !glyphWindowVisible)
		? (ui.button_link_%strSplit(this_button.name,"_")[3]%.down.opt("-hidden"),showGlyphWindow())		
		: (ui.button_link_%strSplit(this_button.name,"_")[3]%.down.opt("hidden"),-1000,hideGlyphWindow())
}

showGlyphWindow(*) {
displayInfoGfx("./img/d2_glyphs.png")
}

hideGlyphWindow(*) {
	closeThis()
}

toggleRuneWindow(this_button,*) {
	closeThis()
	static runeWindowVisible := false
	(runeWindowVisible := !runeWindowVisible)
		? (ui.button_link_%strSplit(this_button.name,"_")[3]%.down.opt("-hidden"),showRuneWindow())		
		: (ui.button_link_%strSplit(this_button.name,"_")[3]%.down.opt("hidden"),-1000,hideRuneWindow())
}

displayInfoGfx(imageFilename) {
	ui.infoGfxGui:=gui()
	ui.infoGfxGui.opt("-caption toolWindow owner" ui.mainGui.hwnd)
	ui.infoGfxGui.backColor:="010203"
	winSetTransColor("010203",ui.infoGfxGui)

	winGetPos(&tmpX,&tmpY,,,ui.mainGui)
	ui.infoGfxMon:=object()
	
	loop monitorGetCount() {
		monitorGetWorkArea(a_index,&l,&t,&r,&b)
		if (tmpX >= l && tmpX <=r) && (tmpY >= t && tmpY <= b) {
			ui.infoGfxMon.l:=l
			ui.infoGfxMon.t:=t 
			ui.infoGfxMon.r:=r
			ui.infoGfxMon.b:=b
		}
	}
	
	ui.infoGfxImage:=ui.infoGfxGui.addPicture("h" ui.infoGfxMon.b-ui.infoGfxMon.t " w-1 backgroundTrans",imageFilename)
	ui.infoGfxImage.onEvent("DoubleClick",closeThis)
	ui.infoGfxImage.onEvent("click",WM_LBUTTONDOWN_callback)
	ui.infoGfxImage.getPos(,,&imgW)
	
	ui.infoGfxGui.show("x" (ui.infoGfxMon.l+((ui.infoGfxMon.r-ui.infoGfxMon.l)/2))-(imgW/2) " y" ui.infoGfxMon.t " h" ui.infoGfxMon.b-ui.infoGfxMon.t)

	winSetTransColor("010203",ui.infoGfxGui)
	
}

	closeThis(*) {
		Try	
			ui.infoGfxGui.hide()
		Try
			ui.infoGfxGui.destroy()
		loop 8 {
			ui.button_link_%a_index%.down.opt("hidden")
		}	
		runeWindowVisible:=false
		glyphWindowVisible:=false
	}
	
showRuneWindow(*) {
	displayInfoGfx("./img/d2_runes.png")
}

hideRuneWindow(*) {
	closeThis()
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


;line(ui.mainGui,529,0,2,30,cfg.TrimColor2)
;line(ui.gameTabGui,495,2,2,32,cfg.titleBgColor)
line(ui.mainGui,474,30,55,2,cfg.TabColor1)