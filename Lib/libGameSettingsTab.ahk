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
	ui.gameSettingsGui.BackColor := cfg.bgColor0
	ui.gameSettingsGui.Color := cfg.bgColor0
	ui.gameSettingsGui.MarginX := 5
	ui.gameSettingsGui.Opt("-Caption -Border +AlwaysOnTop owner" ui.mainGui.hwnd)
	ui.gameSettingsGui.SetFont("s14 c" cfg.fontColor1,"calibri")
	ui.gameTabs := ui.gameSettingsGui.addTab3("-redraw x0 y-5 h194 0x400 bottom c" cfg.bgColor1 " choose" cfg.activeGameTab,["Gameplay","Vault Cleaner"])

	ui.gameTabs.value:=cfg.activeGameTab
	ui.gameTabs.setFont("s16","move-x")
	ui.gameTabs.onEvent("Change",gameTabChanged)
	ui.mainGui.GetPos(&winX,&winY,,)
	winSetRegion("2-0 w495 h190",ui.gameSettingsGui)
	
	ui.d2Sliding := false
	ui.d2HoldingRun := false         
	ui.d2cleanupNeeded := false
	ui.gameSettingsGui.setFont("s12 bold","calibri")

	ui.d2TopPanelOutline:=ui.gameSettingsGui.addText("x8 y5 w480 h66 background" cfg.outlineColor1)
	ui.d2TopPanelBg:=ui.gameSettingsGui.addText("x9 y6 w478 h65 background" cfg.bgColor1)
	ui.d2TopPanelDetail1:=ui.gameSettingsGui.addPicture("x9 y6 w478 h" 15-(15-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_light.png")
	ui.d2TopPanelDetail2:=ui.gameSettingsGui.addPicture("x9 y" 56+(15-cfg.curveAmount) " w478 h" 15-(15-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.bottomPanelOutline:=ui.gameSettingsGui.addText("x8 y76 w480 h69 background" cfg.outlineColor1)
	ui.bottomPanelBg:=ui.gameSettingsGui.addText("x9 y77 w478 h68 background" cfg.bgColor1)
	ui.bottomPanelDetail2:=ui.gameSettingsGui.addPicture("x9 y77 w478 h" 18-(18-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_light.png")
	ui.bottomPanelDetail2:=ui.gameSettingsGui.addPicture("x9 y" 127+(18-cfg.curveAmount) " w478 h" 18-(18-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")

	drawKeybindBar()
	drawLinkBar()
	;d2drawPanel4()
	if d2ActivePanel == 1 
		d2ChangeKeybindPanelTab(1)
	else
		d2ChangeKeybindPanelTab(2)	
	
	drawGameTabs(cfg.activeGameTab)
}	 

drawGameTabs(ui.gameTabs.value)
gameTabChanged(*) { 
	cfg.activeGameTab := ui.gametabs.value
	refreshGameTabs(ui.gameTabs.value)
	;guiVis(ui.gameTabGui,true)
	
;	tabsChanged()
}
refreshGameTabs(tabNum := 1) {
	drawOutlineNamed("gameTabOutline",ui.gameTabGui,0,0,498,2
		,cfg.accentColor1,cfg.accentColor1,2)

ui.gameTabWidth := 0
	((tabNum == 1)
		? ui.gameTab1SkinOutline := ui.gameTabGui.addText("section x0 y0 w110 h32 background" cfg.accentColor1,"" )
		: ui.gameTab1SkinOutline := ui.gameTabGui.addText("section x0 y2 w110 h30 background" cfg.accentColor2,""))
	
	ui.gameTab1Skin := ui.gameTabGui.addText(
		((tabNum == 1) 
			? "y0 h30" 
			: "y2 h28")
				" x2 w108  background" 
		((tabNum == 1) 
			? cfg.bgColor0
			: cfg.bgColor1) 
		" c" ((tabNum == 1) 
			? cfg.fontColor1
			: cfg.fontColor2)
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
			? cfg.fontColor1 
			: cfg.fontColor2)
				,"Gameplay")
	ui.gameTab1Label.setFont((tabNum == 1 
		? "s14" 
		: "s12")
			,"Impact")
	ui.gameTabWidth += 110
	((tabNum == 1 || tabNum == 2)
		? ui.gameTab1Divider:=ui.gameTabGui.addText("y0 x108 w2 h34 background" cfg.accentColor1,"")
		: ui.gameTab1Divider:=ui.gameTabGui.addText("y2 x108 w2 h30 background" cfg.accentColor2,""))
	((tabNum == 2)
		? ui.gameTab2SkinOutline := ui.gameTabGui.addText("x110 y0 w130 h34 background" cfg.accentColor1,"" )
		: ui.gameTab2SkinOutline := ui.gameTabGui.addText("x110 y2 w130 h30 background" cfg.accentColor2,""))

	
	ui.gameTab2Skin := ui.gameTabGui.addText(
		((tabNum == 2) 
			? "y0 h30" 
			: "y2 h28")
				" x110 w130 center background" 
		((tabNum == 2) 
			? cfg.bgColor0 
			: cfg.bgColor1)
				" c" ((tabNum == 2)
			? cfg.fontColor1 
			: cfg.fontColor2)
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
		? cfg.fontColor1 
			: cfg.fontColor2)
		,"Vault Cleaner")
	ui.gameTab2Label.setFont(
		((tabNum == 2)
			? "s14" 
			: "s12")
		,"Impact")
	ui.gameTabWidth += 130	
	((tabNum == 2 || tabNum == 3)
		? ui.gameTab2Divider:=ui.gameTabGui.addText("y0 x238 w2 h34 background" cfg.accentColor1,"")
		: ui.gameTab2Divider:=ui.gameTabGui.addText("y2 x238 w2 h30 background" cfg.accentColor2,""))

	ui.gameTabHelpDetail:=ui.gameTabGui.addPicture("x464 y" 1+(30-cfg.curveAmount) " w31 h" 31-(31-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_light.png")
	
	ui.gameTabDetail1:=ui.gameTabGui.addPicture(((tabNum==1) ? "-hidden " : "-hidden ") "x0 y" 15+(15-cfg.curveAmount) " w108 h" 17-(15-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_light.png")
	ui.gameTabDetail2:=ui.gameTabGui.addPicture(((tabNum==2) ? "-hidden " : "hidden ") "x110 y" 15+(15-cfg.curveAmount) " w128 h" 17-(15-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_light.png")	 
	ui.gameTabDetail3:=ui.gameTabGui.addPicture(((tabNum==2) ? "-hidden " : "hidden ") "x0 y" 1 " w108 h" 15-(15-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.gameTabDetail4:=ui.gameTabGui.addPicture(((tabNum==1) ? "-hidden " : "hidden ") "x110 y" 1 " w128 h" 15-(15-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")	 
	

	ui.gameTab1SkinOutline.redraw()
	ui.gameTab1Skin.redraw()
	ui.gameTab1Label.redraw()
	ui.gameTab1Divider.redraw()
	ui.gameTab2SkinOutline.redraw()
	ui.gameTab2Skin.redraw()
	ui.gameTab2Label.redraw()
	ui.gameTab2Divider.redraw()
	;ui.gameTabDetail.redraw()

	

}


drawGameTabs(tabNum := 1) {
	ui.gameTabWidth := 0
	; try	 
	; ui.gameTabGui.destroy()
	ui.gameTabGui := gui()
	ui.gameTabGui.opt("-caption toolWindow alwaysOnTop +E0x20 owner" ui.gameSettingsGui.hwnd)
	ui.gameTabGui.backColor := ui.transparentColor
	ui.gameTabGui.color := ui.transparentColor
	drawOutlineNamed("gameTabOutline",ui.gameTabGui,0,0,498,2
		,cfg.accentColor1,cfg.accentColor1,2)

	winSetTransColor(ui.transparentColor,ui.gameTabGui)

	((tabNum == 1)
		? ui.gameTab1SkinOutline := ui.gameTabGui.addText("x0 y0 w110 h32 background" cfg.accentColor1,"" )
		: ui.gameTab1SkinOutline := ui.gameTabGui.addText("x0 y2 w110 h30 background" cfg.accentColor2,""))

	ui.gameTab1Skin := ui.gameTabGui.addText(
		((tabNum == 1) 
			? "y0 h30" 
			: "y2 h28")
				" x2 w108  background" 
		((tabNum == 1) 
			? cfg.bgColor0
			: cfg.bgColor1) 
		" c" ((tabNum == 1) 
			? cfg.fontColor1
			: cfg.fontColor2)
		,"")
	ui.gameTab1Skin.setFont((tabNum == 1 
		? "s14" 
		: "s12"),"Impact")
	ui.gameTab1Label := ui.gameTabGui.addText(
		((tabNum == 1) 
			? "y2 h28" 
			: "y4 h28")
				" x2 w106 center backgroundTrans c" 
		((tabNum == 1) 
			? cfg.fontColor1 
			: cfg.fontColor2)
				,"Gameplay")
	ui.gameTab1Label.setFont((tabNum == 1 
		? "s14" 
		: "s12")
			,"Impact")
	ui.gameTabWidth += 110
	((tabNum == 1 || tabNum == 2)
		? ui.gameTab1Divider:=ui.gameTabGui.addText("y0 x108 w2 h34 background" cfg.accentColor1,"")
		: ui.gameTab1Divider:=ui.gameTabGui.addText("y2 x108 w2 h30 background" cfg.accentColor2,""))
	((tabNum == 2)
		? ui.gameTab2SkinOutline := ui.gameTabGui.addText("x110 y0 w130 h34 background" cfg.accentColor1,"" )
		: ui.gameTab2SkinOutline := ui.gameTabGui.addText("x110 y2 w130 h30 background" cfg.accentColor2,""))
	
	ui.gameTab2Skin := ui.gameTabGui.addText(
		((tabNum == 2) 
			? "y0 h32" 
			: "y2 h30")
				" x110 w128 center background" 
		((tabNum == 2) 
			? cfg.bgColor0 
			: cfg.bgColor1)
				" c" ((tabNum == 2)
			? cfg.fontColor1 
			: cfg.fontColor2)
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
		? cfg.fontColor1 
			: cfg.fontColor2)
		,"Vault Cleaner")
	ui.gameTab2Label.setFont(
		((tabNum == 2)
			? "s14"
			: "s12")
		,"Impact")
	ui.gameTabWidth += 130	
	((tabNum == 2 || tabNum == 3)
		? ui.gameTab2Divider:=ui.gameTabGui.addText("y2 x238 w2 h34 background" cfg.accentColor1,"")
		: ui.gameTab2Divider:=ui.gameTabGui.addText("y2 x238 w2 h30 background" cfg.accentColor2,""))
	

	ui.gameTabDetail1:=ui.gameTabGui.addPicture(((tabNum==1) ? "-hidden " : "-hidden ") "x0 y" 32+(30-cfg.curveAmount) " w106 h" 30-(30-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_light.png")
	ui.gameTabDetail2:=ui.gameTabGui.addPicture(((tabNum==2) ? "-hidden " : "hidden ") "x110 y" 32+(30-cfg.curveAmount) " w126 h" 30-(30-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_light.png")	 
	ui.gameTabDetail3:=ui.gameTabGui.addPicture(((tabNum==2) ? "-hidden " : "hidden ") "x0 y" 1 " w106" 30-(30-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.gameTabDetail4:=ui.gameTabGui.addPicture(((tabNum==1) ? "hidden " : "-hidden ") "x110 y" 1 " w126" 30-(30-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")	 
	
	winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui.hwnd)
		ui.gameTabSpacer:=ui.gameTabGui.addText("y2 x240 w" 490-(ui.gameTabWidth) " h29 background" cfg.titleBgColor)
		ui.gameTabSpacer.onEvent("click",WM_LBUTTONDOWN_callback)
		; ui.gameTabSpacerDetail2:=ui.gameTabGui.addPicture("y" 2 " x240 w" 490-240 " h" 30-(30-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
		; ui.gameTabSpacerDetail2.onEvent("click",WM_LBUTTONDOWN_callback)
		ui.gameTabSpacerDetail:=ui.gameTabGui.addPicture("y" 2+(30-cfg.curveAmount) " x240 w" 490-240 " h" 30-(30-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
		ui.gameTabSpacerDetail.onEvent("click",WM_LBUTTONDOWN_callback)
	if !(mainGuiX==0 && mainGuiY==0) {
		ui.gameTabGui.show("w498 h32 noActivate x" mainGuiX+34 " y" mainGuiY+183)
		
	}
	
	createShading(objGui,objX,objY,objW,objH) {
		objGui.addPicture("x" objX " y" objY " w" objW " h" min(cfg.curveAmount,(objH/2)))
		objGui.addPicture("x" objX " y" objH-(min(cfg.curveAmount,(objH/2))) " w" objW " h" min(cfg.curveAmount,(objH/2)))
	}
	
	line(ui.gameTabGui,240,31,500,1,cfg.titleBgColor)
	;line(ui.gameTabGui,216,299,280,1,cfg.accentColor2)
	line(ui.gameTabGui,495,2,28,1,cfg.accentColor1,"VERT")
	drawOutlineNamed("helpOutline",ui.gameTabGui,463,0,34,32,cfg.accentColor1,cfg.accentColor1,3)
	ui.gameTabGui.addText("x464 y2 w31 h29 background" cfg.bgColor1)
	ui.helpIcon := ui.gameTabGui.addPicture("x470 y3 w-1 h26 backgroundTrans","./img/icon_help.png")
	ui.gameTabGui.addPicture("x463 y" 1 " w37 h" min(cfg.curveAmount,13) " backgroundTrans","./img/custom/lightburst_top_bar_light.png")
	ui.gameTabGui.addPicture("x463 y" 13+min(cfg.curveAmount,13) " w37 h" min(cfg.curveAmount,13) " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	;ui.gameTabDetail:=ui.gameTabGui.addPicture("x0 y0 w240 h30 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	
	ui.buildNumber:=ui.gameTabGui.addText("x298 y12 w160 h29 right backgroundTrans","v" a_fileVersion)
	ui.buildNumber.setFont("q5 s10 c" cfg.fontColor4,"Move-X")
	ui.gameplayTabDetail:=ui.gameTabGui.addPicture("x0 y" 2+(30-cfg.curveAmount) " w110 h" 32-(30-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.vaultCleanerTabDetail:=ui.gameTabGui.addPicture("x110 y" 2+(30-cfg.curveAmount) " w130 h" 32-(30-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	;ui.gameTabGui.addPicture("x90 y0 w212 h30 backgroundTrans","./img/custom/lightburst_bl_light.png")	
}


;ui.gameRunningHeaderLabel:=ui.gameTabGui.addText("hidden section x300 y5 w200 h15 backgroundTrans","Attached Game Window")
ui.gameTabGui.setFont("s7 c" cfg.fontColor2,"small font")
;ui.gameLinkLabel:=ui.gameTabGui.addText("x325 y6 w180 h20 backgroundTrans","Game Status")
;ui.gameLinkLabel.setFont("s14 c" cfg.fontColor1,"move-x")

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

ui.d2Log:= ui.gameSettingsGui.addText("x405 y10 w68 h80 hidden background" cfg.titleBgColor " c" cfg.fontColor3," Destiny 2`n Log Started`n Waiting for Input")
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
	ui.d2CodeTitlebar:=ui.d2wwCodesGui.addText("x5 y0 w1200 h30 background" cfg.baseColor)
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
	
keyBindDialogBox(Msg,Alignment := "Center") {
	Global
	if !InStr("LeftRightCenter",Alignment)
		Alignment := "Left"
	Transparent := 250
	
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Bind Key"

	ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow +Owner" ui.mainGui.hwnd)  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := cfg.bgColor1  ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.SetFont("s12")  ; Set a large font size (32-point).
	ui.notifyGui.AddText("c" cfg.trimColor3 " " Alignment " BackgroundTrans","Press desired key to use for: ")
	ui.notifyGui.setFont("s14")
	ui.notifyGui.addText("ys-4 x+0 c" cfg.trimColor4,Msg)
	ui.notifyGui.setFont("s13 c" cfg.trimColor3,"Courier Narrow Bold")
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
	drawOutlineNotifyGui(1,1,w,h,cfg.outlineColor2,cfg.outlineColor1,2)
	drawOutlineNotifyGui(2,2,w-4,h-4,cfg.accentColor4,cfg.accentColor4,1)
	
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

toggleFireteam(*) {
	static fireteamVisible:=false
	fireteamVisible:=!fireteamVisible ? joinFireteam() : closeJoinGui()
}

joinFireteam(*) {
		ui.button_link_2.down.opt("-hidden")
	
	ui.friendsList:=strSplit(iniRead(cfg.file,"Game","FriendsList",""),",")
	try 
		joinGui.destroy()
	joinGui:=gui()
	joinGui.opt("-caption -border alwaysOnTop owner" ui.gameSettingsGui.hwnd)
	joinGui.backColor:=cfg.bgColor0
	joinGui.color:="010203"
	winSetTransColor("010203",joinGui)
	joinGuiOutline:=joinGui.addText("x0 y0 w314 h" (ui.friendsList.length*30)+30 " background" cfg.accentColor1)
	joinGuiBackground:=joinGui.addText("x2 y2 w310 h" (ui.friendsList.length*30)+30 " background" cfg.bgColor0)
	joinGuiTitlebar:=joinGui.addText("x2 y2 w310 h" 24 " background" cfg.titleBgColor)
	joinGuiTitlebar.onEvent("click",WM_LBUTTONDOWN_callback)
	joinGuiAddTextOutline:=("x40 y5 w250 h10 background" cfg.accentColor1)
	joinGuiAddFriendOutline:=joinGui.addText("x4 y4 w18 h18 background" cfg.accentColor1)
	joinGuiAddFriend:=joinGui.addPicture("x5 y5 w16 h16 background" cfg.trimColor3,"./img/button_plus.png")
	joinGuiAddText:=joinGui.addText("x35 y4 w246 h20 backgroundTrans","Click to Join a Friend")		
	joinGuiAddText.setFont("s14 c" cfg.fontColor4,"move-x")
	joinGuiAddText.onEvent("click",addFriend)

	
	drawFriendsList()
	winGetPos(&gsX,&gsY,&gsW,&gsH,ui.gameSettingsGui)
	joinGui.hide()
	winGetPos(&friendsX,&friendsY,&friendsW,&friendsH,joinGui)
	
	joinGui.show("x" (gsX+(gsW/2))-(friendsW/2) " y" (gsY+(gsH/2))-(friendsH/2) " w314 h" (ui.friendsList.length*30)+60)
	
	;addFriend()
	hotkey("ESC",closeJoinGui)
	hotKey("ESC","On")
	drawFriendsList(*) {
		static controlId:=0
		controlId+=1
		ui.joinGuiAnchor:=joinGui.addText("x5 y20 backgroundTrans section")
		for friend in ui.friendsList {
			
			ui.joinGui%a_index%:=""
			ui.joinGui%a_index%MoveDown:=""
			ui.joinGui%a_index%MoveUp:=""

			try
				JoinGui%a_index%:=""
			try
				Up%a_index%:=""
			try
				Down%a_index%:=""
			try
				Delete%a_index%:=""
			; try
				; ui.joinGui%a_index%.opt("vTmp")
			ui.joinGui%a_index%:=joinGui.addText("v" controlId "-" a_index  " section x5 y" (a_index*30) " w223 h26 background" cfg.bgColor1,friend)
			ui.joinGui%a_index%.setFont("s13 c" cfg.fontColor1,"courier sys")
			ui.joinGui%a_index%.onEvent("click",joinFriend)
			
			; try
				; ui.joinGui%a_index%MoveUp.opt("vTmp")
			ui.joinGui%a_index%MoveUp:=joinGui.addPicture("vUp" controlId "-" a_index  " x227 y" (a_index*30) " w26 h26 background" cfg.trimColor%(a_index>1) ? 3 : 2%,"./img/button_up_arrow.png")
			ui.joinGui%a_index%MoveUp.onEvent("click",(a_index>1) ? moveUp : doNothing)

			; try
				; ui.joinGui%a_index%MoveDown.opt("vTmp")
			ui.joinGui%a_index%MoveDown:=joinGui.addPicture("vDown" controlId "-" a_index  " x255 y" (a_index*30) " w26 h26 background" cfg.trimColor%(a_index<ui.friendsList.length) ? 3 : 2%,"./img/button_down_arrow.png")
			ui.joinGui%a_index%MoveDown.onEvent("click",moveDown)
			ui.joinGui%a_index%MoveUp.onEvent("click",(a_index<ui.friendsList.length) ? moveDown : doNothing)

			
			; try
				; ui.joinGui%a_index%Delete.opt("vTmp")
			ui.joinGui%a_index%delete:=joinGui.addPicture("vDelete" controlId "-" a_index  " x283 ys+0 w26 h26 background" cfg.trimColor4,"./img/button_x.png")
			ui.joinGui%a_index%delete.onEvent("click",removeFriend)

			ui.joinGui%a_index%Detail:=joinGui.addPicture("x5 y" a_index*30 " w305 h26 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
		}
		
		joinFriend(friend_idx,*) {
			send("{enter}")
			send('/join " ui.friendsList[friend_idx] "`n"')
			send("{enter}")
		}
		
		ui.joinGuiAddOutline:=joinGui.addText("section center x5 y" (ui.friendsList.length*30)+30 " w304 h26 background" cfg.outlineColor1)
		ui.joinGuiAdd:=joinGui.addText("v" controlId "-" a_index  " section center x7 y" (ui.friendsList.length*30)+32 " w300 h20 background" cfg.titleBgColor,"Add New Friend")
		ui.joinGuiAdd.setFont("s14 bold c" cfg.fontColor1,"move-x")
		ui.joinGuiAdd.onEvent("click",addFriend)
		ui.joinGuiAddDetail:=joinGui.addPicture("section x5 y" (ui.friendsList.length*30)+30 " w304 h26 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")

		doNothing(*) {
			return 0
		}
			
		moveUp(this_ctrl,*) {	
			friend_idx:=strSplit(this_ctrl.name,"-")[2]
			for friend in ui.friendsList {
				if a_index == friend_idx {
					tmpFriendUp:= ui.friendsList[a_index-1]
					ui.friendsList[a_index-1]:= ui.friendsList[a_index]
					ui.friendsList[a_index]:=tmpFriendUp
				}
			}
			drawFriendsList()
		}
		moveDown(this_ctrl,*) {
		
			friend_idx:=strSplit(this_ctrl.name,"-")[2]
			for friend in ui.friendsList {
				if a_index == friend_idx {
					tmpFriendUp:= ui.friendsList[a_index+1]
					ui.friendsList[a_index+1]:= ui.friendsList[a_index]
					ui.friendsList[a_index]:=tmpFriendUp
				}
				
			}
			drawFriendsList()
		}

			winGetPos(,,&joinW,&joinH,joinGui)
			joinGuiOutline.opt("h" joinH+30)
			joinGuiOutline.redraw()
			joinGuiBackground.opt("h" joinH+30)
			joinGuiBackground.redraw()
		

	}
	

	addFriend(*) {
		addFriendGui:=gui()
		addFriendGui.opt("-caption toolWindow alwaysOnTop owner" joinGui.hwnd)
		addFriendGui.backColor:="010203"
		addFriend.color:="010203"
		winSetTransColor("010203",addFriendGui)
		addFriendGuiSubmit:=addFriendGui.addButton("hidden w0 h0 default")
		addFriendGuiSubmit.onEvent("click",saveFriend)
		addFriendGuiOutline:=addFriendGui.addText("x0 y0 w320 h46 background" cfg.accentColor2)
		addFriendGuiBg:=addFriendGui.addText("x2 y2 w310 h42 background" cfg.bgColor1)
		addFriendGuiText:=addFriendGui.addText("x5 w245 y1 h20 backgroundTrans","FRIEND'S BUNGIE ID")
		addFriendGuiText.setFont("s14 c" cfg.fontColor2,"move-x")
		addFriendGui.setFont("s10 c" cfg.fontColor1,"calibri")
		addFriendGuiInput:=addFriendGui.addEdit("r1 x5 y20 w260 background" cfg.bgColor0 " -wantReturn")
		
		addFriendGuiSaveButton:=addFriendGui.addPicture("x270 y4 w40 h38 backgroundTrans","./img/button_save.png")
		addFriendGuiSaveButton.opt("v" addFriendGuiInput.text)
		addFriendGuiSaveButton.onEvent("click",saveFriend)
		winGetPos(&joinX,&joinY,&joinW,&joinH,joinGui)
		addFriendGui.show("x" joinX " y" joinY+joinH-30 " w314 h54")
			
		hotkey("ESC",addFriendClose)
		hotkey("ESC","On")
		saveFriend(*) {
			ui.friendsList.push(addFriendGuiInput.text)
			friendsListStr:=""
			for friend in ui.friendsList {
				friendsListStr.=friend ","
			}
			iniWrite(rtrim(friendsListStr,","),cfg.file,"Game","FriendsList")
			addFriendGui.destroy()
			drawFriendsList()
			;joinFireteam()

			hotkey("ESC",closeJoinGui)
			exit
		}
		addFriendClose(*) {
			addFriendGui.destroy()
			hotkey("ESC",closeJoinGui)
			exit
		}
	}	

	removeFriend(this_ctrl,*) {
		friend_idx:=strSplit(this_ctrl.name,"-")[2]
		ui.friendsList.removeAt(strSplit(this_ctrl.name,"-")[2])
		friendsListStr:=""
		for friend in ui.friendsList {
			friendsListStr.=friend ","
		}
		iniWrite(rtrim(friendsListStr,","),cfg.file,"Game","FriendsList")
		drawFriendsList()
		;joinFireteam()
		
		ui.joinGui%friend_idx%:=""
		ui.joinGui%friend_idx%moveUp:=""
		ui.joinGui%friend_idx%MoveDown:=""
		ui.joinGui%friend_idx%Delete:=""
		ui.joinGuiAddOutline.move(,(ui.friendsList.length*30)+30)
		ui.joinGuiAdd.move(,(ui.friendsList.length*30)+32)
		ui.joinGuiAddDetail.move(,(ui.friendsList.length*30)+32)
		joinGui.show("h" (ui.friendsList.length*30)+40)
	}
}

closeJoinGui(*) {
	hotkey("ESC","Off")
	try
		joinGui.destroy()
	try
		addFriendGui.destroy()
		
	ui.button_link_2.down.opt("hidden")
	exit
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
	static infoGfxSide:="right"
	static infoGfxPosX:=""
	static infoGfxPosH:=""
	
	monitorGetWorkArea(monitorGetPrimary(),&lPrimary,&tPrimary,&rPrimary,&bPrimary)
	loop monitorGetCount() {
		monitorGetWorkArea(a_index,&l,&t,&r,&b)
		if l >= rPrimary {
			infoGfxPosX:=l+((r-l)/2)
			infoGfxPosH:=b-t
		}
	}
	
	if !infoGfxPosX {
		infoGfxSide:="Left"
		loop monitorGetCount() {
			monitorGetWorkArea(a_index,&l,&t,&r,&b)
			if r <= lPrimary {
			infoGfxPosX:=r+((r-l)/2)
			infoGfxPosH:=b-t
			}
		
		}
	}
	
	ui.infoGfxGui:=gui()
	ui.infoGfxGui.opt("-caption toolWindow owner" ui.mainGui.hwnd)
	ui.infoGfxGui.backColor:="010203"
	winSetTransColor("010203",ui.infoGfxGui)



	ui.infoGfxImage:=ui.infoGfxGui.addPicture("h0 w-1 backgroundTrans",imageFilename)
	ui.infoGfxImage.onEvent("DoubleClick",closeThis)
	ui.infoGfxImage.onEvent("click",WM_LBUTTONDOWN_callback)
	ui.infoGfxImage.getPos(,,&imgW)
	if monitorGetCount() > 1 {
	if infoGfxSide=="Left" {
		ui.infoGfxGui.show("x" l-imgW-20 " y" t)
	} else {
		ui.infoGfxGui.show("x" r+20 " y" t)
	}	
	} else {
		ui.infoGfxGui.show("x" l " y" t)
	}
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


drawPanel5(*) {
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
	
	ui.MouseLeftButtonText:=ui.gameSettingsGui.addText("section xs-13 w95 center background" cfg.bgColor0 " c" cfg.fontColor2,cfg.d2GameMouseLeftButtonKey)
	ui.MouseRightButtonText:=ui.gameSettingsGui.addText("x+5 ys w95 center background" cfg.bgColor0 " c" cfg.fontColor2,cfg.d2GameMouseRightButtonKey)
	ui.MouseMiddleButtonText:=ui.gameSettingsGui.addText("x+5 ys w95 center background" cfg.bgColor0 " c" cfg.fontColor2,cfg.d2GameMouseMiddleButtonKey)
	ui.MouseBackButtonText:=ui.gameSettingsGui.addText("x+5 ys w95 center background" cfg.bgColor0 " c" cfg.fontColor2,cfg.d2GameMouseBackButtonKey)
	ui.MouseForwardButtonText:=ui.gameSettingsGui.addText("x+5 ys w95 center background" cfg.bgColor0 " c" cfg.fontColor2,cfg.d2GameMouseForwardButtonKey)
}

;line(ui.mainGui,529,0,2,30,cfg.accentColor2)
;line(ui.gameTabGui,495,2,2,32,cfg.titleBgColor)
line(ui.mainGui,474,30,55,2,cfg.bgColor0)