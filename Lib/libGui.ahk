#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

tabsChanged(*) {
	ui.activeTab := ui.mainGuiTabs.Text
	ui.activeMainTab := ui.mainGuiTabs.value
	(ui.activeTab=="1_Game")
	? (guiVis(ui.gameSettingsGui,true)
			, guiVis(ui.gameTabGui,true)
			, ui.gameSettingsGui.opt("-toolWindow")
			, ui.gameTabGui.opt("-toolWindow")
			, ui.mainGui.opt("-toolWindow")
			, ui.1_GameButton.opt("x36 y4 w78 h36")
			, ui.1_GameButton.redraw()
			, ui.Game_ActiveTabUi.opt("-hidden")
			, ui.Setup_ActiveTabUi.opt("hidden"))
	: (guiVis(ui.gameSettingsGui,false)
			, guiVis(ui.gameTabGui,false)
			, ui.gameTabGui.opt("+toolWindow")
			, ui.gameSettingsGui.opt("+toolWindow")
			, ui.mainGui.opt("-toolWindow")
			, ui.1_GameButton.opt("x36 y2 w78 h32")
			, ui.Game_ActiveTabUi.opt("hidden")
			, ui.Setup_ActiveTabUi.opt("-hidden"))

}


	initGui(&cfg, &ui) {
		
advProgress(2)
	ui.TransparentColor 	:= "010203"
	ui.MainGui 				:= Gui()
	drawOutlineMainGui(34,29,497,155,cfg.ThemeBright1Color,cfg.themeBright1Color,2)
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
	ui.MainGui.setFont("q5 s13 c" cfg.ThemeFont1Color,"calibri")
	ui.mainGuiAnchor := ui.mainGui.addText("x0 y0 w0 h0 section hidden")
	line(ui.mainGui,529,184,2,29,cfg.themeBright1Color)
	ui.mainBg := ui.mainGui.addText("x36 y29 w493 h185 background" cfg.themePanel2Color,"")
	ui.mainTabBg:=ui.mainGui.addText("x34 y0 w162 h28 background" cfg.themeBright1Color)
	ui.1_GameButtonBg := ui.mainGui.addText("x36 y2 w78 h32 background" cfg.themePanel2Color)
	
	ui.2_SetupButtonBg := ui.mainGui.addText("x116 y2 w78 h34 background" cfg.themePanel1Color)
	
	advProgress(2)
	
	advProgress(2)
	ui.3_FillBg:=ui.mainGui.addText("y2 x196 w280 h28 background" cfg.themeFont3Color)
	ui.titleBar:=ui.mainGui.addPicture("x190 y2 w280 h32 left backgroundTrans",cfg.titleBarImage)
	ui.3_FillOutline:=ui.mainGui.addText("x216 y-1 w280 h30 left backgroundTrans","dapp")
	ui.3_FillOutline.setFont("q5 s19 c" cfg.themeBright1Color,"move-x")
	ui.buildNumber:=ui.mainGui.addText("x424 y12 w280 h28 left backgroundTrans","v" a_fileVersion)
	ui.buildNumber.setFont("q5 s10 c" cfg.themeDark2Color,"move-x")

	
	ui.1_GameButton := ui.mainGui.addText("x36 y4 w78 h36 center background" cfg.themePanel2Color,"Game")
	ui.1_gameButton.redraw()
	ui.2_SetupButton := ui.mainGui.addText("y4 x116 w78 h32 center background" cfg.themePanel2Color,"Setup")
	ui.2_setupButton.redraw()
	line(ui.mainGui,34,28,490,2,cfg.themeBright1Color)
	; line(ui.mainGui,34,0,490,2,cfg.themeBright1Color)
	; line(ui.mainGui,34,0,2,30,cfg.themeBright1Color)
	; line(ui.mainGui,112,0,3,30,cfg.themeBright1Color)
	; line(ui.mainGui,192,0,30,2,cfg.themeBright1Color,"vert")
	; line(ui.mainGui,194,0,310,2,cfg.themePanel2Color)	
	gameTabClicked(*) {
		ui.mainGuiTabs.choose(1)
	}
	setupTabClicked(*) {
		ui.mainGuiTabs.choose(2)
	}
	

	ui.3_FillOutline.onEvent("click",WM_LBUTTONDOWN_callback)
	
	
	advProgress(2)

	advProgress(2)
	
	ui.mainGuiTabs := ui.MainGui.AddTab3("x34 y2 w494 h213 Buttons -redraw Background" cfg.ThemePanel2Color " -E0x200",["1_Game","2_Setup"])
	ui.MainGuiTabs.useTab("")
	ui.mainGuiTabs.setFont("q5 s10 q5")
	ui.MainGui.setFont("q5 s10 q5 c" cfg.ThemeFont1Color,"calibri")
	ui.MainGuiTabs.OnEvent("Change",TabsChanged)
	line(ui.mainGui,196,1,300,1,cfg.themeBright2Color)
	advProgress(2)
	ui.activeTab 				:= ui.mainGuiTabs.Text
	ui.previousTab 				:= ui.activeTab
	ui.handleBarBorder 			:= ui.mainGui.addText("hidden x0 y0 w34 h220 background" cfg.themeBright1Color,"")
	ui.handleBarImage 			:= ui.MainGui.AddPicture("hidden x1 y2 w33 h220 backgroundTrans")
	ui.ButtonHandlebarDebug 	:= ui.MainGui.AddPicture("hidden x2 y185 w30 h27")
	ui.handleBarImage.ToolTip 	:= "Drag Handlebar to Move.`nDouble-Click to collapse/uncollapse."
	advProgress(2)
	
	ui.rightHandlebarBg 	:= ui.mainGui.addText("hidden x529 y32 w31 h182 background" cfg.themeBright1Color,"")
	ui.rightHandlebarImage2 := ui.mainGui.AddPicture("hidden x528 w31 y33 h180 section")
	ui.ExitButtonBorder 	:= ui.mainGui.AddText("x472 y0 w60 h29 Background" cfg.ThemeBright1Color,"")
	ui.ExitButton 			:= ui.mainGui.AddPicture("x501 y2 w28 h28 Background" cfg.ThemeButtonReadyColor,"./Img/button_power_ready.png")
	ui.DownButton 			:= ui.mainGui.AddPicture("x474 y2 w27 h28 section Background" cfg.ThemeButtonReadyColor,"./Img/button_minimize.png")
	ui.ExitButton.OnEvent("Click",ExitButtonPushed)
	ui.DownButton.OnEvent("Click",HideGui)
	advProgress(2)
	ui.handleBarImage.OnEvent("Click",WM_LBUTTONDOWN_callback)
	ui.rightHandleBarImage2.OnEvent("Click",WM_LBUTTONDOWN_callback)
	ui.DownButton.ToolTip 	:= "Minimizes dapp App"
	ui.ExitButton.ToolTip 	:= "Terminates dapp App"
	ui.Game_ActiveTabUi:=ui.mainGui.addText("x36 y28 w78 h2 background" cfg.themePanel2Color)
	ui.Setup_ActiveTabUi:=ui.mainGui.addText("x116 y28 w78 h2 background" cfg.themePanel2Color)

	advProgress(2)
	
	ui.gvConsole 		:= ui.MainGui.AddListBox("x0 y214 w560 h192 +Background" cfg.ThemePanel1Color)
	ui.gvConsole.Color 	:= cfg.ThemeBright1Color	
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

	advProgress(2)
line(ui.mainGui,34,211,496,2,cfg.themeBright1Color)


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
			? (toggleControl.Opt("Background" cfg.ThemeButtonOnColor),cfg.toggleOn)
			: (toggleControl.Opt("Background" cfg.ThemeButtonReadyColor),cfg.toggleOff)
			iniWrite(cfg.%toggleControl.name%Enabled,cfg.file,"Toggles",toggleControl.name "Enabled")
			trayTip(toggleControl.name " changed to " ((cfg.%toggleControl.name%Enabled) ? "On" : "Off"),"dapp Config Change","Iconi Mute")

		; reload()
		}
		
toggleChange(name,onOff := "",toggleOnImg := cfg.toggleOn,toggleOffImg := cfg.toggleOff,toggleOnColor := cfg.themeButtonOnColor,toggleOffColor := cfg.themeButtonReadyColor) {
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
		winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui)
		transparency := 0
		if cfg.topDockEnabled {
			guiVis(ui.mainGui,false)
			;guiVis(ui.titleBarButtonGui,false)
			showDockBar()
			while transparency < 253 {
				transparency += 2.5
				winSetTransparent(round(transparency),ui.dockBarGui)
				sleep(1)
			}
			guiVis(ui.dockBarGui,true)
		} else {
			switch ui.mainGuiTabs.text {
				case "1_Game":
					guiVis(ui.gameTabGui,true)
					while transparency < 223 {
						transparency += 4
						winSetTransparent(min(round(transparency)+60,255),	ui.gameTabGui)
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
	if (cfg.alwaysOnTopEnabled) {
		ui.mainGui.opt("alwaysOnTop")
	} else {
		ui.mainGui.opt("-alwaysOnTop")
		;ui.titleBarButtonGui.opt("-alwaysOnTop")
	}
	ui.mainGuiTabs.useTab("")
}

autoFireButtonClicked(*) {
	ToggleAutoFire()
}

toggleGuiCollapse(*) {
	static activeMainTab := ui.mainGuiTabs.value
		
	(ui.GuiCollapsed := !ui.GuiCollapsed) 
		? CollapseGui() 
		: UncollapseGui()
}

CollapseGui() {
	winGetPos(&mainX,&mainY,&mainW,&mainH,ui.mainGui)
	GuiWidth := mainW
	;guiVis(ui.titleBarButtonGui,false)
	guiVis(ui.afkGui,false)
	guiVis(ui.gameSettingsGui,false)
	if (cfg.AnimationsEnabled) {
		While GuiWidth > 250 {
			ui.MainGui.Move(mainX,mainY,GuiWidth,)
			GuiWidth -= 30
			sleep(20)
		}		
		guiVis(ui.gameTabGui,false)
		While GuiWidth > 5 {
			ui.MainGui.Move(mainX,mainY,GuiWidth,)
			GuiWidth -= 30
			sleep(20)
		}	
	}
	ui.MainGui.Move(mainX,mainY,35,)
}

redrawGuis(GuiWidth,mainX,mainY) {
}

UncollapseGui() {
	winGetPos(&mainX,&mainY,&mainW,&mainH,ui.mainGui)
	GuiWidth := 0
	;guiVis(ui.titleBarButtonGui,false)
	if (cfg.AnimationsEnabled) {
		While GuiWidth < 160 {
			ui.MainGui.Move(mainX,mainY,GuiWidth,)
			GuiWidth += 30
			sleep(20)
		}
	}

	if (cfg.AnimationsEnabled) {
		While GuiWidth < 575 {
			ui.MainGui.Move(mainX,mainY,GuiWidth,)
			GuiWidth += 30
			sleep(20)
		}
	}
	ui.mainGui.move(,,575,)
	guiVis(ui.gameTabGui,true)
	tabsChanged()
}

exitMenuShow(this_button) {
	winGetPos(&tbX,&tbY,,,ui.mainGui)
	ui.exitMenuGui := gui()
	ui.exitMenuGui.Opt("-caption -border toolWindow AlwaysOnTop Owner" ui.mainGui.hwnd)
	ui.exitMenuGui.BackColor := ui.transparentColor
	ui.gamingModeLabel := ui.exitMenuGui.addText("x0 y2 w72 h15 center background" cfg.themePanel3color " c" cfg.themeButtonOnColor," Gaming Mode")
	ui.gamingModeLabel.setFont("q5 s8")
	ui.gamingLabels := ui.exitMenuGui.addText("x0 y16 w72 h52 center background" cfg.themePanel3color " c" cfg.themeButtonAlertColor," Stop   Start ")
	ui.gamingLabels.setFont("q5 s10")
	ui.stopGamingButton := ui.exitMenuGui.addPicture("x0 y32 section w35 h35 background" cfg.themeFont2Color,"./img/button_quit.png")
	ui.startGamingButton := ui.exitMenuGui.addPicture("x+2 ys w35 h35 background" cfg.themeFont2Color,"./img/button_exit_gaming.png")
	ui.stopGamingButton.onEvent("Click",exitAppCallback)
	ui.startGamingButton.onEvent("Click",stopGaming)
	WinSetTransColor(ui.transparentColor,ui.exitMenuGui)
	drawOutlineNamed("exitMenuBorder",ui.exitMenuGui,0,0,74,68,cfg.themeFont3Color,cfg.themeFont3Color,2)
	ui.exitMenuGui.show("x" tbX+490 " y" tbY-70 " AutoSize noActivate")
	loop 70 {
		ui.exitMenuGui.move(tbX+490,tbY-a_index)
	}
	
}

exitButtonPushed(this_button,*) {
	exitApp
	if !keyWait("LButton","T.450") {
		exitMenuShow(this_button)
		keyWait("LButton")
		mouseGetPos(,,,&ctrlUnderMouse,2)
		winGetPos(&menuX,&menuY,,&menuH,ui.exitMenuGui.hwnd)
		switch ctrlUnderMouse {
			case ui.startGamingButton.hwnd:
				loop 69 {
					ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
				}
					ui.exitMenuGui.destroy()
					startGaming()
			case ui.stopGamingButton.hwnd:
				loop 69 {
					ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)	
				}
				ui.exitMenuGui.destroy()
				stopGaming()
			case ui.exitButton.hwnd:
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
					exitApp()
			default: 
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
			}
		} else {
			mouseGetPos(,,,&ctrlUnderMouse,2)
			winGetPos(&menuX,&menuY,,&menuH,ui.exitMenuGui.hwnd)	
			switch ctrlUnderMouse {
				case ui.startGamingButton.hwnd:
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
					startGaming()
				case ui.stopGamingButton.hwnd:
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
					stopGaming()
				case ui.exitButton.hwnd:
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
					exitApp()
				default: 
					loop 69 {
						ui.exitMenuGui.move(menuX,menuY+a_index,,menuH-a_index)
					}
					ui.exitMenuGui.destroy()
			}
		}
} 

; drawLinks(guiName:=ui.mainGui,linkArr:=["DIM"]) {
		; linkW:=40
		; linkH:=40
		; linkBgColor:=cfg.themeDark2Color
		; for link in linkArr {
		; guiName.addText("x5 y5 w" linkW " h" linkH " background" linkBgColor )}
	
; }

stopGaming(*) {
	winCloseAll("Gaming Mode")
	exitApp()
}

startGaming(*) {
	applyWinPos("Gaming Mode")
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

showGui(*) {
	ui.mainGui.move(cfg.GuiX,cfg.GuiY)	
	debugLog("Showing Interface")
}

; toggleConsole(*) {
	; Global
	; if (cfg.ConsoleVisible == false)
	; {
		; cfg.ConsoleVisible := true
		
		; ui.ButtonDebug.Value := "./Img/button_console_on.png"
		; ui.ButtonDebug.Opt("Background" cfg.ThemeButtonOnColor)
		; ui.buttonHandlebarDebug.value := "./img/button_console_on.png"
		; ui.buttonHandlebarDebug.opt("background" cfg.themeButtonOnColor)
		; if (cfg.AnimationsEnabled) {
		; GuiH := 214	
			; While (GuiH < 395)
			; {
				; GuiH += 10
				; ui.mainGui.move(,,,GuiH) 
				; Sleep(10)
			; }
		; }
		; GuiH := 430
		; ui.mainGui.Move(,,,GuiH)
		; winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui)
		;MsgBox(GuiX "`n" GuiY "`n" GuiW "`n" GuiH)
		; debugLog("Showing Log")
	; } else {
		; cfg.ConsoleVisible := false
		; ui.ButtonDebug.Value := "./Img/button_console_ready.png"
		; ui.ButtonDebug.Opt("Background" cfg.ThemeButtonReadyColor)
		; ui.buttonHandlebarDebug.value := "./img/button_console_ready.png"
		; ui.buttonHandlebarDebug.opt("background" cfg.themeButtonReadyColor)

		; winGetPos(&GuiX,&GuiY,&GuiW,&GuiH,ui.mainGui)
		; if (cfg.AnimationsEnabled) {
			; While (GuiH > 225)
			; {
				; GuiH -= 10
				; ui.MainGui.move(,,,GuiH)
				; Sleep(10)
			; }
		; }
		; GuiH := 214
		; ui.MainGui.move(,,,GuiH)
		; debugLog("Hiding Log")
	; }
; }



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
	drawOutlineNamed("consolePanelOutline",ui.mainGui,34,200,498,2,cfg.ThemeBorderDarkColor,cfg.ThemeBorderLightColor,2) 		;Log Panel Outline
}

drawOpsOutlines() {
	ui.mainGuiTabs.useTab("")
}

drawGridLines() {
	ui.MainGuiTabs.UseTab("2_SETUP")
		drawOutline(ui.MainGui,101,62,157,100,cfg.ThemeBright2Color,cfg.ThemeBright2Color,2) 	;Win1 Info Frame
		drawOutline(ui.MainGui,102,62,156,100,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1) 	;Win1 Info Frame
		drawOutline(ui.MainGui,101,76,157,16,cfg.ThemeBright2Color,cfg.ThemeBright2Color,2)		;Win1 Info Gridlines  
		drawOutline(ui.MainGui,102,76,156,15,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)		;Win1 Line above ClassDDL
		drawOutline(ui.MainGui,101,90,157,17,cfg.ThemeBright2Color,cfg.ThemeBright2Color,2)		;Win1 Line above ClassDDL
		drawOutline(ui.MainGui,102,90,156,15,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)		;Win1 Line above ClassDDL
		drawOutline(ui.MainGui,306,62,156,100,cfg.ThemeBright2Color,cfg.ThemeBright2Color,1)		;WIn2 Info Frame
		drawOutline(ui.MainGui,306,62,155,100,cfg.ThemeBright1Color,cfg.ThemeBright1Color,2)	;WIn2 Info Frame
		drawOutline(ui.MainGui,306,76,156,16,cfg.ThemeBright2Color,cfg.ThemeBright2Color,2)		;Win2 Info Gridlines
		drawOutline(ui.MainGui,306,76,155,15,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)		;Win2 Line above ClassDDL
		drawOutline(ui.MainGui,306,90,156,16,cfg.ThemeBright2Color,cfg.ThemeBright2Color,2)		;Win2 Line above ClassDDL
		drawOutline(ui.MainGui,306,90,155,15,cfg.ThemeBright1Color,cfg.ThemeBright1Color,1)		;Win2 Line above ClassDDL
}
		
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
			case "1_GAME":
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

d2KeybindGameTabClicked()
d2KeybindAppTabClicked()
line(ui.mainGui,34,30,198,2,cfg.themeBright1Color,"vert")