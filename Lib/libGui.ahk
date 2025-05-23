#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}
; ui.1_GameButtonDetail:=ui.mainGui.addPicture("x36 y3 w78 h28 backgroundTrans","./img/custom/lightburst_tr_light.png")
; ui.2_SetupButtonDetail := ui.mainGui.addPicture("x116 y3 w78 h32 backgroundTrans","./img/custom/lightburst_tl_light.png")
tabsChanged(*) {
	;ui.tabDivider:=ui.mainGui.addText("x117 y0 w2 h28 background" cfg.TrimColor1)
	;line(ui.mainGui,115,0,30,2,cfg.TrimColor1,"vert")
	ui.activeTab := ui.mainGuiTabs.Text
	ui.activeMainTab := ui.mainGuiTabs.value
	(ui.activeTab=="1_Game____")
		? (	 ui.1_GameButtonBg:=ui.mainGui.addText("x34 y0 w83 h28 background" cfg.TrimColor1)
			, ui.1_GameButton:=ui.mainGui.addText("x36 y2 w79 h28 background" cfg.TabColor1)
			, ui.2_SetupButtonBg:=ui.mainGui.addText("x117 w80 y0 h28 background" cfg.TrimColor2)
			, ui.2_SetupButton:=ui.mainGui.addText("x117 w78 y2 h28 background" cfg.TabColor2)
			, ui.1_GameButtonLabel := ui.mainGui.addText("x34 y4 w81 h26 center backgroundTrans","Game")
			, ui.1_GameButtonLabel.setFont("s14 q5 c" cfg.FontColor1,"Impact")
			, ui.2_SetupButtonLabel := ui.mainGui.addText("y4 x117 w78 h26 center backgroundTrans","Setup")
			, ui.2_SetupButtonLabel.setFont("s12 q5 c" cfg.FontColor2,"Impact")				

			, ui.Setup_ActiveTabUi:=ui.mainGui.addText("x117 y28 w78 h2 background" cfg.TrimColor1)
			, ui.1_GameButtonDetail:=ui.mainGui.addPicture("x34 y0 w83 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
			, ui.1_GameButtonDetail2:=ui.mainGui.addPicture("hidden x36 y" 28-cfg.curveAmount " w81 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
			, ui.1_GameButtonDetail3:=ui.mainGui.addPicture("hidden x" 36-(cfg.curveAmount/3) " y" 2 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")
			, ui.2_SetupButtonDetail:=ui.mainGui.addPicture("x117 y0 w80 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")			
			, ui.2_SetupButtonDetail2:=ui.mainGui.addPicture("x117 y" 30-cfg.curveAmount " w" 80 " h" cfg.curveAmount-2 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")	
			, ui.2_SetupButtonDetail3:=ui.mainGui.addPicture("x" 117 " y" 2 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
			, ui.Game_ActiveTabUi:=ui.mainGui.addText("hidden x33 y28 w81 h2 background" cfg.trimColor1)
			, guiVis(ui.gameSettingsGui,true)
			, guiVis(ui.gameTabGui,true))
		: (ui.tabDivider:=ui.mainGui.addText("hidden x117 y02 w2 h28 background" cfg.TrimColor1)
			, ui.2_SetupButtonBg:=ui.mainGui.addText("x115 y0 w82 h28 background" cfg.TrimColor1)
			, ui.2_SetupButton:=ui.mainGui.addText("x117 y2 w78 h28 background" cfg.TabColor1)
			, ui.1_GameButtonBg.opt("x34 y0 w81 h32 background" cfg.TrimColor2)
			, ui.1_GameButton.opt("x36 y2 w79 h30 background" cfg.TabColor2)
			, ui.1_GameButtonLabel.opt("hidden")
			, ui.1_GameButtonLabel := ui.mainGui.addText("x36 y4 w79 h28 center backgroundTrans","Game")
			, ui.1_GameButtonLabel.setFont("s12 q5 c" cfg.FontColor2,"Impact")
			, ui.2_SetupButtonLabel.opt("hidden")
			, ui.2_SetupButtonLabel := ui.mainGui.addText("y4 x117 w78 h28 center backgroundTrans","Setup")
			, ui.2_SetupButtonLabel.setFont("s14 q5 c" cfg.FontColor1,"Impact")
			, ui.Setup_ActiveTabUi:=ui.mainGui.addText("hidden x117 y28 w78 h2 background" cfg.trimColor1)
			, ui.Game_ActiveTabUi:=ui.mainGui.addText("x34 y28 w81 h2 background" cfg.TrimColor1)
			, ui.1_GameButtonDetail:=ui.mainGui.addPicture("hidden x34 y0 w81 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
			, ui.1_GameButtonDetail2:=ui.mainGui.addPicture("x34 y" 30-cfg.curveAmount " w81 h" cfg.curveAmount-2 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
			, ui.2_GameButtonDetail3:=ui.mainGui.addPicture("x" 116-(cfg.curveAmount/3) " y" 2 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")
			, ui.2_SetupButtonDetail:=ui.mainGui.addPicture("x115 y0 w82 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
			, ui.2_SetupButtonDetail2:=ui.mainGui.addPicture("hidden x117 y" 26-cfg.curveAmount " w80 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
			, ui.1_SetupButtonDetail3:=ui.mainGui.addPicture("hidden x" 115 " y" 2 " w" cfg.curveAmount/3 " h" 28 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
			, guiVis(ui.gameSettingsGui,false)
			, guiVis(ui.gameTabGui,false))
			
			ui.tabDivider.redraw()
			ui.1_GameButtonBg.redraw()
			ui.1_GameButton.redraw()
			ui.1_GameButtonLabel.redraw()
			ui.2_SetupButtonBg.redraw()
			ui.2_SetupButton.redraw()
			ui.2_SetupButtonLabel.redraw()
			ui.Game_ActiveTabUi.redraw()
			ui.Setup_ActiveTabUi.redraw()
			ui.2_SetupButtonDetail.redraw()
			ui.2_SetupButtonDetail2.redraw()
			ui.2_SetupButtonDetail3.redraw()
			ui.1_GameButtonDetail.redraw()
			ui.1_GameButtonDetail2.redraw()
			ui.1_GameButtonDetail3.redraw()
			
}

tabsInit(*) {
	ui.tabDivider:=ui.mainGui.addText("hidden x115 y0 w2 h28 background" cfg.TrimColor1)
	ui.activeTab := ui.mainGuiTabs.Text
	ui.activeMainTab := ui.mainGuiTabs.value
	(ui.activeTab=="1_Game____")
	? (ui.gameSettingsGui.opt("-toolWindow")
		, ui.gameTabGui.opt("-toolWindow")
		, ui.mainGui.opt("-toolWindow")

		, ui.Game_ActiveTabUi.opt("-hidden")
		, ui.Setup_ActiveTabUi.opt("hidden"))
	: (ui.gameTabGui.opt("+toolWindow")
		, ui.gameSettingsGui.opt("+toolWindow")
		, ui.mainGui.opt("-toolWindow")
		, ui.1_GameButton.opt("x34 y2 w81 h17 background" cfg.TileColor)
		, ui.1_GameButtonBg.opt("y0 background" cfg.TrimColor2)
		, ui.2_SetupButton.opt("y2 h32 background" cfg.TabColor1)
		, ui.2_SetupButtonBg.opt("y0 background" cfg.TrimColor1)
		, ui.Game_ActiveTabUi.opt("hidden")
		, ui.Setup_ActiveTabUi.opt("-hidden"))
}


initGui(&cfg, &ui) {
		
advProgress(2)
	ui.TransparentColor 	:= "010203"
	ui.MainGui 				:= Gui()
	
	ui.mainGui.setFont("s14 q5 c" cfg.FontColor1,"move-x")
	drawOutlineMainGui(34,28,497,185,cfg.TrimColor1,cfg.TrimColor1,2)
	advProgress(2)
	ui.MainGui.Name 		:= "dapp"
	ui.mainGui.Title		:= "dapp"
	ui.TaskbarHeight 		:= GetTaskBarHeight()
	ui.MainGui.BackColor 	:= ui.transparentColor
	ui.MainGui.Color 		:= ui.TransparentColor
	ui.MainGui.Opt("-Caption -Border")
	advProgress(2)
	
	if (cfg.AlwaysOnTopEnabled)
	{
		ui.MainGui.Opt("+AlwaysOnTop 0x4000000")
	}	
	advProgress(2)
	ui.MainGui.MarginX := 0
	ui.MainGui.MarginY := 0
	ui.mainGuiAnchor := ui.mainGui.addText("x0 y0 w0 h0 section hidden")
	
	ui.mainBg := ui.mainGui.addText("x34 y30 w493 h185 background" cfg.TabColor1,"")
	ui.tabDivider:=ui.mainGui.addText("hidden x115 y0 w2 h28 background" cfg.TrimColor1)

	advProgress(2)
	
	advProgress(2)
	ui.3_FillBg:=ui.mainGui.addText("y2 x196 w280 h28 background" cfg.titleBgColor)

	ui.3_FillOutline:=ui.mainGui.addText("hidden x206 y1 w260 h29 center backgroundTrans","dapp")
	ui.3_FillOutline.setFont("q5 s17 c" cfg.titleFontColor,"Move-X")
	ui.3_TitleTextDetail:=ui.mainGui.addText("x316 y9 w2 h15 background" cfg.titleBgColor)
	; ui.3_TitleTextDetail2:=ui.mainGui.addText("x339 y9 w2 h15 background" cfg.titleBgColor)
	; ui.3_TitleTextDetail3:=ui.mainGui.addText("x355 y9 w2 h15 background" cfg.titleBgColor)

	(iniRead(cfg.themeFile,cfg.theme,"HideTitlebarText",0)) ? 0 : (ui.3_FillOutline.opt("-hidden"),ui.3_FillOutline.redraw())
	
	if !fileExist(cfg.titleBarImage)
		cfg.titleBarImage:="./img/custom/lightburst_bottom_light.png"
	ui.titleBar:=ui.mainGui.addPicture("x196 y2 w280 h27 left backgroundTrans",cfg.titleBarImage)
	ui.titleBar.onEvent("click",wm_lbuttonDown_callback)
	ui.3_FillDetail1:=ui.mainGui.addPicture("x196 y0 w340 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.3_FillDetailBottom:=ui.mainGui.addPicture("x196 y" 28-cfg.curveAmount " w280 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")

			ui.Game_ActiveTabUi:=ui.mainGui.addText("hidden x33 y28 w81 h2 background" cfg.trimColor1)
			ui.1_GameButtonBg:=ui.mainGui.addText("x34 y0 w83 h28 background" cfg.TrimColor1)
			ui.1_GameButton:=ui.mainGui.addText("x36 y2 w79 h28 background" cfg.TabColor1)
			ui.2_SetupButtonBg:=ui.mainGui.addText("x117 w80 y0 h28 background" cfg.TrimColor2)
			ui.2_SetupButton:=ui.mainGui.addText("x117 w78 y2 h28 background" cfg.TabColor2)
			ui.1_GameButtonLabel := ui.mainGui.addText("x34 y4 w81 h26 center backgroundTrans","Game")
			ui.1_GameButtonLabel.setFont("s14 q5 c" cfg.FontColor1,"Impact")
			ui.2_SetupButtonDetail:=ui.mainGui.addPicture("x117 y0 w80 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")			
			ui.2_SetupButtonDetail2:=ui.mainGui.addPicture("x117 y" 30-cfg.curveAmount " w" 80 " h" cfg.curveAmount-2 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")	
			ui.2_SetupButtonDetail3:=ui.mainGui.addPicture("x" 117 " y" 2 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
	
			ui.2_SetupButtonLabel := ui.mainGui.addText("y4 x117 w78 h26 center backgroundTrans","Setup")
			ui.2_SetupButtonLabel.setFont("s12 q5 c" cfg.FontColor2,"Impact")		
			ui.Setup_ActiveTabUi:=ui.mainGui.addText("x117 y28 w78 h2 background" cfg.TrimColor1)
			ui.1_GameButtonDetail:=ui.mainGui.addPicture("x34 y0 w83 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
			ui.1_GameButtonDetail2:=ui.mainGui.addPicture("hidden x36 y" 29-cfg.curveAmount " w81 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
			ui.2_GameButtonDetail4:=ui.mainGui.addPicture("x" 196+275-(cfg.curveAmount/3) " y" 2 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")
			ui.2_GameButtonDetail5:=ui.mainGui.addPicture("x" 115+82 " y" 2 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
			ui.1_GameButtonDetail3:=ui.mainGui.addPicture("x" 34-(cfg.curveAmount/2) " y" 2 " w" cfg.curveAmount/2 " h" 26 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")

	line(ui.mainGui,115,28,375,2,cfg.TrimColor1)
	;line(ui.mainGui,115,0,30,2,cfg.TrimColor1,"vert")
	; ui.1_gameButtonDetail:=ui.mainGui.addPicture("x34 y0 w83 h" 13-(13-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_light.png")
	; ui.2_setupButtonDetail2:=ui.mainGui.addPicture("x117 y0 w80 h" 13-(13-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_light.png")


	ui.3_FillOutline.onEvent("click",WM_LBUTTONDOWN_callback)
	
	
	advProgress(2)

	advProgress(2)

	
	ui.mainGuiTabs := ui.MainGui.AddTab3("x34 y2 w494 h233 Buttons -redraw Background" cfg.TabColor1 " -E0x200",["1_Game____","2_Setup____"])
	ui.mainGuiTabs.useTab("")
	
	ui.mainGuiTabs.setFont("q5 s10 q5")
	ui.MainGui.setFont("q5 s12 c" cfg.FontColor1,"prototype")
	ui.MainGuiTabs.OnEvent("Change",TabsChanged)
	line(ui.mainGui,197,1,300,1,cfg.DisabledColor)
	line(ui.mainGui,197,0,300,2,"010203")
	advProgress(2)
	ui.activeTab 				:= ui.mainGuiTabs.Text
	ui.previousTab 				:= ui.activeTab
	ui.handleBarBorder 			:= ui.mainGui.addText("hidden x0 y0 w34 h220 background" cfg.TrimColor1,"")
	ui.handleBarImage 			:= ui.MainGui.AddPicture("hidden x1 y2 w33 h220 backgroundTrans")
	ui.ButtonHandlebarDebug 	:= ui.MainGui.AddPicture("hidden x2 y185 w30 h27")
	ui.handleBarImage.ToolTip 	:= "Drag Handlebar to Move.`nDouble-Click to collapse/uncollapse."
	advProgress(2)
	ui.brVertLine:=ui.mainGui.addText("hidden x529 y184 w2 h29 background" cfg.TrimColor1)
	ui.rightHandlebarBg 	:= ui.mainGui.addText("hidden x529 y32 w31 h182 background" cfg.TrimColor1,"")
	ui.rightHandlebarImage2 := ui.mainGui.AddPicture("hidden x528 w31 y33 h180 section")
	ui.ExitButtonBorder 	:= ui.mainGui.AddText("x470 y0 w64 h30 Background" cfg.TrimColor1,"")

	ui.ExitButtonbg 		:= ui.mainGui.AddText("x501 y1 w28 h27 center Background" cfg.TabColor2)
	ui.ExitButton 			:= ui.mainGui.AddText("x501 y2 w28 h28 center BackgroundTrans","r")
	ui.exitButton.setFont("s18 c" cfg.FontColor1,"Webdings")
	ui.ExitButton.OnEvent("Click",ExitButtonPushed)
	
	ui.DownButtonbg 		:= ui.mainGui.AddText("x472 y1 w27 h27 center section Background" cfg.TabColor2)
	ui.DownButton 			:= ui.mainGui.AddText("x473 y-2 w27 h28 center section BackgroundTrans","6")
	ui.downButton.setFont("s23 c" cfg.FontColor1,"Webdings")

	ui.DownButton.OnEvent("Click",guiHide)
	ui.downButtonbg.onEvent("click",guiHide)
	ui.ExitButtonDetail 	:= ui.mainGui.AddPicture("x470 y0 w94 h" cfg.curveAmount " BackgroundTrans","./img/custom/lightburst_top_bar_dark.png")	
	ui.ExitButtonDetail2 	:= ui.mainGui.AddPicture("x472 y" 28-cfg.curveAmount " w57 h" cfg.curveAmount " BackgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")	
	
	guiHide(*) {
		ui.mainGui.hide()
		ui.gameSettingsGui.hide()
		ui.gameTabGui.hide()
	}
	
	advProgress(2)
	ui.handleBarImage.OnEvent("Click",WM_LBUTTONDOWN_callback)
	ui.rightHandleBarImage2.OnEvent("Click",WM_LBUTTONDOWN_callback)
	ui.DownButton.ToolTip 	:= "Minimizes dapp App"
	ui.ExitButton.ToolTip 	:= "Terminates dapp App"

	; advProgress(2)
	
	; ui.gvConsole 		:= ui.MainGui.AddListBox("x0 y214 w560 h192 +Background" cfg.TabColor2)
	; ui.gvConsole.Color 	:= cfg.TrimColor1	
	advProgress(2)
	afk 				:= Object()	

	advProgress(2)
	GuiSetupTab(&ui,&cfg)
	
	advProgress(2)
	GuiGameTab()
	
	advProgress(2)
	
	OnMessage(0x0200, WM_MOUSEMOVE)
	OnMessage(0x0202, WM_LBUTTONDOWN)
	OnMessage(0x47, WM_WINDOWPOSCHANGED)
	advProgress(2)

	ui.MainGuiTabs.UseTab("")
ui.Setup_ActiveTabUi:=ui.mainGui.addText("hidden x117 y30 w76 h2 background" cfg.TabColor1)
ui.Game_ActiveTabUi:=ui.mainGui.addText("hidden x36 y30 w79 h2 background" cfg.TabColor1)
advProgress(2)
line(ui.mainGui,34,211,495,2,cfg.TrimColor1)


}

line(this_gui,startingX,startingY,length,thickness,color,vertical:=false) {
	this_guid := comObject("Scriptlet.TypeLib").GUID
	if (vertical) {
		this_guid := this_gui.addText("x" startingX " y" startingY " w" thickness " h" length " background" color)
	} else {
		this_guid := this_gui.addText("x" startingX " y" startingY " w" length " h" thickness " background" color)
	}
	return this_guid
}


toggleChanged(toggleControl,*) {
	toggleControl.value := 
		(cfg.%toggleControl.name%Enabled := !cfg.%toggleControl.name%Enabled)
			? (toggleControl.Opt("Background" cfg.OnColor),cfg.toggleOn)
			: (toggleControl.Opt("Background" cfg.OffColor),cfg.toggleOff)
			iniWrite(cfg.%toggleControl.name%Enabled,cfg.file,"Toggles",toggleControl.name "Enabled")
			trayTip(toggleControl.name " changed to " ((cfg.%toggleControl.name%Enabled) ? "On" : "Off"),"dapp Config Change","Iconi Mute")

		; reload()
		}
		
toggleChange(name,onOff := "",toggleOnImg := cfg.toggleOn,toggleOffImg := cfg.toggleOff,toggleOnColor := cfg.OnColor,toggleOffColor := cfg.OffColor) {
	 (onOff)
		? (%name%.Opt("Background" toggleOnColor),toggleOnImg) 
		: (%name%.Opt("Background" toggleOffColor),toggleOffImg)
}
ui.loadingProgress.value += 5

ui.isFading := false
hotIf(isFading)
	hotkey("LButton",(*) => ui.isFading := true)
hotIf()

isFading(*) {
	if ui.isFading
		return 1
	else
		return 0
}

fadeIn() {
	if (cfg.AnimationsEnabled) {
		ui.isFading := true
		;winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui)
		transparency := 0
		switch ui.mainGuiTabs.text {
			case "1_Game____":
				guiVis(ui.gameTabGui,true)
				while transparency < 223 {
					transparency += 4
					winSetTransparent(min(round(transparency)+60,255),ui.gameTabGui)
					winSetTransparent(round(transparency),ui.mainGui)	
					winSetTransparent(min(round(transparency)+0,255),ui.gameSettingsGui)
					sleep(1)
				}
			guiVis(ui.gameTabGui,true)
					
			default:
			while transparency < 253 {
				transparency += 2.5
				winSetTransparent(round(transparency),ui.mainGui)
				sleep(1)
			}
		}
		guiVis(ui.mainGui,true)
	}
	ui.isFading := false
}

winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,ui.mainGui)
ui.mainGuiTabs.useTab("")

exitButtonPushed(this_button,*) {
	exitApp
} 


quickOSD()
quickOSD(*) {
	ui.quickOsdBg := gui()
	ui.quickOsdBg.opt("-caption -border toolWindow alwaysOnTop")
	ui.quickOsdBg.backColor := "010203"

	ui.quickOSD := gui()
	ui.quickOSD.opt("-caption -border toolWindow alwaysOnTop")
	ui.quickOSD.backColor := "010203"
	ui.msgLog := ui.quickOSD.AddText("x10 y15 w600 h800 backgroundTrans cLime","")
	ui.msgLog.setFont("q5 s12")
	winSetTransparent(155,ui.quickOsdBg.hwnd)
	winSetTransColor("010203",ui.quickOSD.hwnd)
}

osdLog(msg) {
	if cfg.debugEnabled {
		ui.quickOsdBg.show("x5 y200 w610 h810 noActivate")
		ui.quickOSD.show("x5 y200 w610 h810 noActivate")
		setTimer () => (ui.quickOsdBg.hide(),ui.quickOSD.hide()),-5000
	} else {
		ui.quickOsdBg.hide()
		ui.quickOSD.hide()
	}
	ui.msgLog.text := msg "`n" ui.msgLog.text
}

exitAppCallback(*) {
	ExitApp
}

savePrevGuiPos(*) {
	winGetPos(&prevGuiX,&prevGuiY,,,ui.mainGui)
	ui.prevGuiX := prevGuiX
	ui.prevGuiY := prevGuiY
}

saveGuiPos(*) {
	Global
	winGetPos(&GuiX,&GuiY,,,ui.MainGui.hwnd)
	cfg.GuiX := GuiX
	cfg.GuiY := GuiY
	IniWrite(cfg.GuiX,cfg.file,"Interface","GuiX")
	IniWrite(cfg.GuiY,cfg.file,"Interface","GuiY")
	debugLog("Saving Window Location at x" GuiX " y" GuiY)
}

initConsole(&ui) {
	ui.gvMonitorSelectGui := Gui()
	ui.gvMonitorSelectGui.Opt("-Theme -Border -Caption toolWindow +AlwaysOnTop +Parent" ui.MainGui.Hwnd " +Owner" ui.MainGui.Hwnd)
	ui.gvMonitorSelectGui.BackColor := "212121"
	ui.gvMonitorSelectGui.setFont("q5 s16 c00FFFF","calibri Bold")
	ui.gvMonitorSelectGui.Add("Text",,"Click anywhere on the screen`nyou'd like your AppDock on.")
}

drawOutlineMainGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		ui.MainGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		ui.MainGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		ui.MainGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		ui.MainGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}

	drawOutlineDialogBoxGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		ui.dialogBoxGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		ui.dialogBoxGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		ui.dialogBoxGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		ui.dialogBoxGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}

	drawOutlineNewGameGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		ui.NewGameGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		ui.NewGameGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		ui.NewGameGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		ui.NewGameGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
		}

	drawOutlineNotifyGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		ui.NotifyGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		ui.NotifyGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		ui.NotifyGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		ui.NotifyGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}

	drawOutlineAfkGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		
		ui.AfkGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		ui.AfkGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		ui.AfkGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		ui.AfkGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}

	drawOutline(guiName, X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		
		guiName.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		guiName.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		guiName.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		guiName.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}	
	
	drawOutlineNamed(outLineName, guiName, X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		outLineName1	:= outLineName "1"
		outLineName2	:= outLineName "2"
		outLineName3	:= outLineName "3"
		outLineName4	:= outLineName "4"
		(outLineName1 := outLineName "1") := guiName.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		(outLineName2 := outLineName "2") := guiName.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		(outLineName3 := outLineName "3") := guiName.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		(outLineName4 := outLineName "4") := guiName.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	}

drawMainOutlines() {
	ui.mainGuiTabs.useTab("")
	drawOutlineNamed("consolePanelOutline",ui.mainGui,34,200,498,2,cfg.OutlineColor2,cfg.OutlineColor1,2) 		;Log Panel Outline
}

drawOpsOutlines() {
	ui.mainGuiTabs.useTab("")
}

; drawGridLines() {
	; ui.MainGuiTabs.UseTab("2_SETUP____")
		; drawOutline(ui.MainGui,101,62,157,100,cfg.titleFontColor,cfg.titleFontColor,2) 	;Win1 Info Frame
		; drawOutline(ui.MainGui,102,62,156,100,cfg.TrimColor1,cfg.TrimColor1,1) 	;Win1 Info Frame
		; drawOutline(ui.MainGui,101,76,157,16,cfg.titleFontColor,cfg.titleFontColor,2)		;Win1 Info Gridlines  
		; drawOutline(ui.MainGui,102,76,156,15,cfg.TrimColor1,cfg.TrimColor1,1)		;Win1 Line above ClassDDL
		; drawOutline(ui.MainGui,101,90,157,17,cfg.titleFontColor,cfg.titleFontColor,2)		;Win1 Line above ClassDDL
		; drawOutline(ui.MainGui,102,90,156,15,cfg.TrimColor1,cfg.TrimColor1,1)		;Win1 Line above ClassDDL
		; drawOutline(ui.MainGui,306,62,156,100,cfg.titleFontColor,cfg.titleFontColor,1)		;WIn2 Info Frame
		; drawOutline(ui.MainGui,306,62,155,100,cfg.TrimColor1,cfg.TrimColor1,2)	;WIn2 Info Frame
		; drawOutline(ui.MainGui,306,76,156,16,cfg.titleFontColor,cfg.titleFontColor,2)		;Win2 Info Gridlines
		; drawOutline(ui.MainGui,306,76,155,15,cfg.TrimColor1,cfg.TrimColor1,1)		;Win2 Line above ClassDDL
		; drawOutline(ui.MainGui,306,90,156,16,cfg.titleFontColor,cfg.titleFontColor,2)		;Win2 Line above ClassDDL
		; drawOutline(ui.MainGui,306,90,155,15,cfg.TrimColor1,cfg.TrimColor1,1)		;Win2 Line above ClassDDL
; }
		
controlFocus(ui.mainGuiTabs,ui.mainGui)
ui.previousTab := ui.activeTab

tabDisabled() {
		ui.mainGuiTabs.choose(ui.previousTab)
		tabsChanged()
		sleep(300)
		notifyOSD("This tab has been`ndisabled by the developer",2000)
		return 1
} 

guiVis(guiName,isVisible:= true) {
	if (isVisible) {
		if guiName != "all" {
			WinSetTransparent(255,guiName)
			WinSetTransparent("Off",guiName)
			WinSetTransColor(ui.TransparentColor,guiName)
			winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,guiName)
		} else {
			try {
				winSetTransparent(255,ui.mainGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.mainGui)
			}
			try { 
				winSetTransparent(255,ui.gameSettingsGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.gameSettingsGui)
			}
			try {
				winSetTransparent(255,ui.gameTabGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.gameTabGui)
			}
		}
	} else {
		if guiName != "all" {
			WinSetTransparent(0,guiName)
			winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,guiName)
		} else {
			try {
				winSetTransparent(0,ui.mainGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.mainGui)
			}
			try {
				winSetTransparent(0,ui.gameSettingsGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.gameSettingsGui)
			}
			try {
				winSetTransparent(0,ui.gameTabGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopEnabled,ui.gameTabGui)
			}
		}
		}
}

fadeOut(*) {
	if (cfg.AnimationsEnabled) {
		ui.disableMouseClick := true
		activeTab := ui.mainGuiTabs.text
		transValue := 255
		switch activeTab {
			case "3_AFK":
				while (transValue > 20) {
					transValue -= 10
					;winSetTransparent(transValue,ui.titleBarButtonGui)
					winSetTransparent(transValue,ui.afkGui)
					winSetTransparent(transValue,ui.mainGui)
					sleep(10)
				}

				guiVis(ui.afkGui,false)
			case "1_GAME____":
				while(transValue > 20) {
					transValue -= 10
					;winSetTransparent(transValue,ui.titleBarButtonGui)
					winSetTransparent(transValue,ui.mainGui)
					winSetTransparent(transValue,ui.gameSettingsGui)
					winSetTransparent(transValue,ui.gameTabGui)
					sleep(10)
				}
				guiVis(ui.gameSettingsGui,false)
				guiVis(ui.gameTabGui,false)
				
			default:
				while(transValue > 20) {
					transValue -= 10
					winSetTransparent(transValue,ui.mainGui)
					sleep(10)
				}
		}	
	}
	guiVis("all",false)
	ui.disableMouseClick := false
}

; d2KeybindGameTabClicked()
; d2KeybindAppTabClicked()
line(ui.mainGui,34,30,183,2,cfg.TrimColor1,"vert")


;tmpGameTabs()
tmpGameTabs(*) {

ui.bt:=object()
ui.bt.x:=34
ui.bt.y:=183
ui.bt.w:=497
ui.bt.h:= 32

drawOutlineNamed("gameTabOutline",ui.mainGui,ui.bt.x,ui.bt.y,ui.bt.w,ui.bt.h
	,cfg.TrimColor1,cfg.TrimColor1,2)

;winSetTransColor(ui.transparentColor,ui.gameTabGui)

bottomTabChanged(1)

gameTabCtrls:=[
ui.gameTab1SkinOutline,
ui.gameTab1Skin,
ui.gameTab1Label,
ui.gameTab1Divider,
ui.gameTab2SkinOutline,
ui.gameTab2Skin,
ui.gameTab2Label,
ui.gameTab2Divider,
ui.gameTabDetail1,
ui.gameTabDetail2,
ui.gameTabDetail3,
ui.gameTabDetail4,
ui.gameTabDetail6,
ui.gameTabDetail5
]

gameTab1Ctrls:=[
ui.gameTab1SkinOutline,
ui.gameTab1Skin,
ui.gameTab1Label,
ui.gameTab1Divider,
ui.gameTabDetail1,
ui.gameTabDetail3,
ui.gameTabDetail4
]

ui.gameTab2Ctrls:=[
ui.gameTab2SkinOutline,
ui.gameTab2Skin,
ui.gameTab2Label,
ui.gameTab2Divider,
ui.gameTabDetail2,
ui.gameTabDetail6,
ui.gameTabDetail5,
]

ui.gameTab1SkinOutline.redraw()
ui.gameTab1Skin.redraw()
ui.gameTab1Label.redraw()
ui.gameTab1Divider.redraw()
ui.gameTab2SkinOutline.redraw()
ui.gameTab2Skin.redraw()
ui.gameTab2Label.redraw()
ui.gameTab2Divider.redraw()
ui.gameTabDetail1.redraw()
ui.gameTabDetail2.redraw()
ui.gameTabDetail3.redraw()
ui.gameTabDetail4.redraw()
ui.gameTabDetail6.redraw()
ui.gameTabDetail5.redraw()

	; ui.gameTabDetail1:=ui.mainGui.addPicture(((tabNum==1) ? "-hidden " : "-hidden ") "x" ui.bt.x+0 " y" ((tabNum==1) ? 2 : 2)+30-cfg.curveAmount " w110 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	; ui.gameTabDetail2:=ui.mainGui.addPicture(((tabNum==2) ? "-hidden " : "-hidden ") "x110 y" ((tabNum==1) ? 2 : 2)+30-cfg.curveAmount " w130 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")	 
	; ui.gameTabDetail3:=ui.mainGui.addPicture(((tabNum==2) ? "-hidden " : "hidden ") "x0 y" 2 " w108 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	; ui.gameTabDetail4:=ui.mainGui.addPicture(((tabNum==1) ? "hidden " : "-hidden ") "x" 108-(cfg.curveAmount/3) " y" 2 " w" cfg.curveAmount/3 " h" 28 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")	 
 	; ui.gameTabDetail6:=ui.mainGui.addPicture(((tabNum==2) ? "hidden " : "-hidden ") "x112 y" 2 " w130 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	; ui.gameTabDetail5:=ui.mainGui.addPicture(((tabNum==1) ? "-hidden " : "hidden ") "x110 y" 2 " w" cfg.curveAmount/3 " h" 28 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")	
	
	; ui.gameTab1SkinOutline.redraw()
	; ui.gameTab1Skin.redraw()
	; ui.gameTab1Label.redraw()
	; ui.gameTab1Divider.redraw()
	; ui.gameTab2SkinOutline.redraw()
	; ui.gameTab2Skin.redraw()
	; ui.gameTab2Label.redraw()
	; ui.gameTab2Divider.redraw()
	;ui.gameTabDetail0.redraw()
	; ui.gameTabDetail1.redraw()
	; ui.gameTabDetail2.redraw()
	; ui.gameTabDetail3.redraw()
	; ui.gameTabDetail4.redraw()
	; ui.gameTabDetail5.redraw()
	; ui.gameTabDetail6.redraw()
	
	

	ui.gameTabSpacer:=ui.mainGui.addText("y" ui.bt.y+2 " x" ui.bt.x+240 " w" 490 " h29 background" cfg.titleBgColor)
	ui.gameTabSpacer.onEvent("click",WM_LBUTTONDOWN_callback)
	ui.buildNumber:=ui.mainGui.addText("x" ui.bt.x+298 " y" ui.bt.y+16 " w160 h29 right backgroundTrans","v" a_fileVersion)
	ui.buildNumber.setFont("q5 s9 c" cfg.titleFontColor,"move-x")	

	ui.statusBarText:=ui.mainGui.addText("hidden x250 y9 w240 h26 backgroundTrans")
	ui.statusBarText.text:="     "
	ui.statusBarText.setFont("s10 q5 c" cfg.titleFontColor,"calibri")
	
	ui.gameTabSpacerDetail2:=ui.mainGui.addPicture("y" ui.bt.y+2 " x" ui.bt.x+240 " w" 250 " h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.gameTabSpacerDetail2.onEvent("click",WM_LBUTTONDOWN_callback)
	ui.gameTabSpacerDetail:=ui.mainGui.addPicture("y" ui.bt.y+31-cfg.curveAmount " x" ui.bt.x+240 " w" 250 " h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.gameTabSpacerDetail.onEvent("click",WM_LBUTTONDOWN_callback)
	ui.mainGui.addPicture("x" ui.bt.x+240 " y" ui.bt.y+2 " w" cfg.curveAmount/3 " h" 29 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
	ui.mainGui.addPicture("x" ui.bt.x+466-(cfg.curveAmount/3) " y" ui.bt.y+2 " w" cfg.curveAmount/3 " h" 29 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")	
	ui.mainGui.addPicture("x" ui.bt.x+240 " y" ui.bt.y+2 " w250 h29 backgroundTrans",(fileExist(subStr(cfg.titleBarImage,1,(strLen(cfg.titleBarImage)-4)) "_flipped.png")) ? subStr(cfg.titleBarImage,1,(strLen(cfg.titleBarImage)-4)) "_flipped.png" : cfg.titleBarImage)
	if !fileExist(cfg.titleBarImage)
		cfg.titleBarImage:="./img/custom/lightburst_bottom_light.png"


	createShading(objGui,objX,objY,objW,objH) {
		objGui.addPicture("x" objX " y" objY " w" objW " h" min(cfg.curveAmount,(objH/2)))
		objGui.addPicture("x" objX " y" objH-(min(cfg.curveAmount,(objH/2))) " w" objW " h" min(cfg.curveAmount,(objH/2)))
	}
	
	line(ui.mainGui,ui.bt.x+240,214,500,1,"010203")
	line(ui.mainGui,ui.bt.x+529,185,28,1,cfg.TrimColor1,"VERT")
	ui.mainGui.addText("x" 499 " y" ui.bt.y+2 " w31 h29 background" cfg.TabColor2)
	ui.helpIcon := ui.mainGui.addPicture("x" 504 " y" ui.bt.y+3 " w-1 h26 backgroundTrans","./img/icon_help.png")
	ui.helpIcon.onEvent("click",test)
	ui.mainGui.addPicture("x" 499 " y" 185 " w30 h" 16-(15-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.mainGui.addPicture("x" 497 " y" 198+(15-cfg.curveAmount) " w37 h" 17-(15-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	drawOutlineNamed("helpOutline",ui.mainGui,497,183,34,32,cfg.TrimColor1,cfg.TrimColor1,2)


	ui.vaultCleanerTabDetail:=ui.mainGui.addPicture("x144 y" 185+(30-cfg.curveAmount) " w130 h" 32-(30-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.gameplayTabDetail:=ui.mainGui.addPicture("x36 y" 185+(30-cfg.curveAmount) " w108 h" 32-(30-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.vaultCleanerTabDetail.onEvent("click",test)
}

test(*) {
msgbox('test')
	}
bottomTabChanged(activeGameTab,*) {
	cfg.activeGameTab:=activeGameTab
	if cfg.activeGameTab == 1 {
		ui.gameTab1SkinOutline := ui.mainGui.addText("section x" ui.bt.x+0 " y" ui.bt.y+0 " w110 h32 background" cfg.TrimColor1)
		ui.gameTab1SkinOutline.onEvent("click",test)
		ui.gameTab1Skin := ui.mainGui.addText("y" ui.bt.y+0 " h30 x" ui.bt.x+2 " w108  background" cfg.TabColor1)
		ui.gameTab1Skin.onEvent("click",test)
		ui.gameTab1Label := ui.mainGui.addText("y" ui.bt.y+2 " h28 x" ui.bt.x+2 " w108 center backgroundTrans c" cfg.FontColor1,"Gameplay")
		ui.gameTab1Label.setFont("s14","Impact")
		ui.gameTab1Label.onEvent("click",test)
		ui.gameTab1Divider:=ui.mainGui.addText("y" ui.bt.y+0 " x" ui.bt.x+108 " w2 h34 background" cfg.TrimColor1)
		ui.gameTab2SkinOutline := ui.mainGui.addText("x" ui.bt.x+110 " y" ui.bt.y+2 " w130 h30 background" cfg.TrimColor2)
		ui.gameTab2Skin := ui.mainGui.addText("y" ui.bt.y+2 " h28 x" ui.bt.x+110 " w130 center background" cfg.TabColor2)
		ui.gameTab2Skin.onEvent("click",test)
		ui.gameTab2Label := ui.mainGui.addText("y" ui.bt.y+5 " h32 x" ui.bt.x+110 " w130 center backgroundTrans c" cfg.FontColor2,"Vault Cleaner")
		ui.gameTab2Label.setFont("s12","Impact")
		ui.gameTab2Label.onEvent("click",test)
		ui.gameTab2Divider:=ui.mainGui.addText("y" ui.bt.y+2 " x" ui.bt.x+238 " w2 h32 background" cfg.TrimColor2)
	} else {
		ui.gameTab1SkinOutline := ui.mainGui.addText("section x" ui.bt.x+0 " y" ui.bt.y+2 " w110 h30 background" cfg.TrimColor2)
		ui.gameTab1Skin := ui.mainGui.addText("y" ui.bt.y+2 " h28 x" ui.bt.x+2 " w108 background" cfg.TabColor2)
		ui.gameTab1Skin.onEvent("click",bottomTabChanged)
		ui.gameTab1Label := ui.mainGui.addText("ys" ui.bt.y+2 " h28 x" ui.bt.x+2 " w108 center backgroundTrans c" cfg.FontColor2,"Vault Cleaner")
		ui.gameTab1Label.setFont("s12","Impact")
		ui.gameTab1Divider:=ui.mainGui.addText("y" ui.bt.y+0 " x" ui.bt.x+108 " w2 h34 background" cfg.TrimColor1)
		ui.gameTab2SkinOutline := ui.mainGui.addText("x" ui.bt.x+108 " y" ui.bt.x+0 " w130 h34 background" cfg.TrimColor1)
		ui.gameTab2Skin := ui.mainGui.addText("y" ui.bt.y+0 " h30 x" ui.bt.x+110 " w130 center background" cfg.TabColor1)
		ui.gameTab2Skin.onEvent("click",bottomTabChanged)
		ui.gameTab2Label := ui.mainGui.addText("y" ui.bt.y+3 " h26 x" ui.bt.x+110 " w130 center backgroundTrans c" cfg.FontColor1,"Vault Cleaner")
		ui.gameTab2Label.setFont("s14","Impact")
		ui.gameTab2Divider:=ui.mainGui.addText("y" ui.bt.y+2 " x" ui.bt.x+238 " w2 h30 background" cfg.TrimColor2,"")
	}
}