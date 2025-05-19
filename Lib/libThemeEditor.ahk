;file: libThemeEditor.ahk
;descr: library for theme editor Gui
;info: requires "ui" and "cfg" be declared as objects in calling script


#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) {	
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}


showThemeEditor(*) {
	drawThemeEditor()
	ui.mainGui.getPos(&mainGuiX,&mainGuiY,&mainGuiW,&mainGuiH)
	ui.themeEditorGui.move(mainGuiX+(mainGuiW/2)-(200),mainGuiY+(mainGuiH/2)-125)
	guiVis(ui.themeEditorGui,true)
}

drawThemeEditor()
drawThemeEditor(*) {
	if ui.hasProp("themeEditorGui")
		try
			ui.themeEditorGui.destroy()
	
	ui.themeEditorGui := gui()
	ui.themeEditorGui.opt("-caption -border alwaysOnTop toolWindow owner" ui.mainGui.hwnd)
	ui.themeEditorGui.backColor := cfg.tabColor2
	ui.themeEditorGui.color := cfg.fontColor2

	ui.themeEditorTitlebar := ui.themeEditorGui.addText("x0 y0 w372 h30 background" cfg.TabColor1 " c" cfg.FontColor1,"")
	ui.themeEditorTitlebarDetail := ui.themeEditorGui.addPicture("x2 y0 w398 h30 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.themeEditorTitlebarText := ui.themeEditorGui.addText("x10 y6 w180 h30 backgroundTrans c" cfg.FontColor1,"Theme Editor" )
	ui.themeEditorTitlebarText.setFont("q5 s15","move-x")
	ui.themeEditorTitlebar.onEvent("click",wm_lButtonDown_callback)

	;drawOutlineNamed("ThemeOutline",ui.themeEditorGui,85,32,61,26,cfg.OutlineColor1,cfg.OutlineColor1,1)
	ui.themeEditorCancelButtonBg := ui.themeEditorGui.addText("x370 y3 w26 h27 background" cfg.TabColor2)
	ui.themeEditorCancelButton := ui.themeEditorGui.addText("x369 y1 w26 h26 backgroundTrans c" cfg.FontColor2,"r")
	ui.themeEditorCancelButton.setFont("s22","Webdings")
	ui.themeEditorCancelButton.onEvent("click", closeThemeEditor)
	ui.themeEditorCancelButtonBg.onEvent("click", closeThemeEditor)


	guiVis(ui.themeEditorGui,false)

	ui.titlebarPreview:=ui.themeEditorGui.addPicture("x44 y214 w346 h30 background" cfg.tabColor2,cfg.titleBarImage)
	ui.titlebarEdit:=ui.themeEditorGui.addPicture("x10 y214 w30 h30 background" cfg.tabColor2,"./img/button_edit.png")

	drawOutlineNamed("themeOutline",ui.themeEditorGui,0,0,400,250,cfg.trimColor1,cfg.trimColor1,3)
	;drawOutlineNamed("themeOutline",ui.themeEditorGui,1,0,324,24,cfg.OutlineColor2,cfg.OutlineColor1,2)
	ui.ColorSelectorLabel2 := ui.themeEditorGui.AddText("x2 y32 h24 center section w114  c"
		((cfg.ColorPickerEnabled) 
			? cfg.FontColor1 " background" cfg.disabledColor 
			: cfg.FontColor1 " background" cfg.disabledColor) 
			,((cfg.ColorPickerEnabled) 
			? ("Color App") 
			: ("Swatches ")))
	;drawOutlineNamed("themeEditorCancelButtonOutline",ui.themeEditorGui,300,2,24,24,cfg.OutlineColor2,cfg.OutlineColor1,2)
	ui.ColorSelectorLabel2.setFont("q5 s14","Sans Serif")
	;drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,10,32,60,28,cfg.OutlineColor2,cfg.OutlineColor2,2)




	ToggleColorSelector(*) {
		ui.toggleColorSelector.Value := 
			(cfg.ColorPickerEnabled := !cfg.ColorPickerEnabled) 
				? (ui.ColorSelectorLabel2.Opt("c" cfg.fontColor1 " background" cfg.disabledColor)
					,ui.ColorSelectorLabel2.Text := "Color App"
					,"./Img/toggle_left.png")
				: (ui.ColorSelectorLabel2.Opt("c" cfg.fontColor1 " background" cfg.disabledColor)
					,ui.ColorSelectorLabel2.Text := "Swatches"
					,"./Img/toggle_right.png") 
		ui.toggleColorSelector.Redraw()
	}
	ui.toggleColorSelector := ui.themeEditorGui.AddPicture("y30 x114 section w60 h28 backgroundTrans", (cfg.ColorPickerEnabled) ? ("./Img/toggle_left.png") : ("./Img/toggle_right.png"))
	ui.toggleColorSelector.OnEvent("Click", ToggleColorSelector)
	ui.toggleColorSelector.ToolTip := "Select color picking method for theming features"
	ui.buttonNewTheme := ui.themeEditorGui.AddPicture("x+1 ys+1 section w25 h26 Background" cfg.OffColor,"./Img/button_plus_ready.png")
	ui.buttonNewTheme.OnEvent("Click",addTheme)
	ui.buttonDelTheme := ui.themeEditorGui.AddPicture("ys+0 x+0 w22 h26 Background" cfg.OffColor,"./Img/button_minus_ready.png")	
	ui.buttonDelTheme.OnEvent("Click",removeTheme)
	ui.themeEditorGui.setFont("s11 q5 c" cfg.fontColor2,"Prototype")
	ui.ThemeDDL := ui.themeEditorGui.AddDDL("ys+0 x+1 w176 section center altSubmit c" cfg.FontColor1 " Background" cfg.disabledColor,cfg.ThemeList)
	ui.themeDDL.setFont("s13","arial")
	ui.ThemeDDL.OnEvent("Change",ThemeChanged)
	ui.ThemeDDL.OnEvent("Focus",RepaintThemeDDL)
	ui.ThemeDDL.OnEvent("LoseFocus",RepaintThemeDDL)
	ui.ThemeDDL.ToolTip := "Select Theme Preset"

	;drawOutlineNamed("ThemeOutline",ui.themeEditorGui,10,29,302,27,cfg.OutlineColor1,cfg.OutlineColor1,3)
	drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,0,30,400,28,cfg.TrimColor1,cfg.TrimColor1,2)
	ui.themeEditorGui.show("w400 h250 noActivate")


	closeThemeEditor(*) {
		try {
			ui.themeEditorGui.Hide()
			ui.themeEditorGui.destroy()
			}
	}

	; ui.ThemeDDL.Choose(1)
	; Loop cfg.ThemeList.Length {
		; if (cfg.ThemeList[A_Index] == cfg.Theme) {
			; ui.ThemeDDL.Choose(cfg.Theme)
			; Break
		; }
	; }

	ui.themeDDL.choose(cfg.theme)
	ui.ThemeElements := [
		
		"TabColor1","TabColor2","TabColor3","TabColor4",
		"FontColor1","FontColor2","FontColor3","LabelColor1",
		"TrimColor1","TrimColor2","TileColor","OnColor","OffColor","AlertColor",
		"TitleBgColor","TitleFontColor","DisabledColor","OutlineColor1","OutlineColor2","AuxColor1"
			]

	ui.themeEditorGui.AddText("x10 y50 section hidden")

	Loop ui.ThemeElements.Length
	{
		this_color := ui.ThemeElements[A_Index]
		switch a_index {
			case 5: 
				ui.themeEditorGui.AddText("section x+22 y50 hidden")
			case 9:
				ui.themeEditorGui.AddText("section x+22 y50 hidden")
			case 15:
				ui.themeEditorGui.AddText("section x+22 y50 hidden")
		}

		ui.themeEditorGui.addText("section xs+0 y+4 w30 h20 background" cfg.trimColor2)
		ui.%this_color%Picker := ui.themeEditorGui.AddText("xs+1 y+-19 w28 h18 Border Background" cfg.%this_color% " c" cfg.%this_color%,this_color)
		ui.%this_color%picker.redraw()
		ui.%this_color%Label := ui.themeEditorGui.AddText("x+6 ys+0 backgroundTrans c" cfg.FontColor2,((isNumber(substr(this_color,-1,1))) ? rtrim(StrReplace(this_color,"Color"),0123456789) : strReplace(this_color,"Color")) ((isNumber(substr(this_color,-1,1))) ? (" " substr(this_color,-1,1)) : " "))
		ui.%this_color%Label.setFont("q5 c" cfg.fontColor2)
		ui.%this_color%Picker.OnEvent("Click",PickColor)
	}
	ui.curveSliderOutline2:=ui.themeEditorGui.addText("x11 y166 w103 border h18 background" cfg.TabColor2)
	ui.curveSliderOutline:=ui.themeEditorGui.addText("x10 y165 w105 h20 background" cfg.TrimColor2)
	; ui.curveSliderBg:=ui.themeEditorGui.addText("x89 y161 w88 h22 background" cfg.TabColor2)
	cfg.curveAmount:=iniRead(cfg.themeFile,cfg.theme,"CurveAmount",20)
	ui.curveSliderLabel:=ui.themeEditorGui.addText("x120 y167 w70 h14 background" cfg.tabColor2,"Bevel Depth")
	ui.curveSliderLabel.setFont("s10 q5 c" cfg.fontColor2,"Prototype")
	ui.curveSliderBuddy:=ui.themeEditorGui.addText("x15 y167 w22 h16 background" cfg.tabColor2 " vCurveSliderBuddy c" cfg.tabColor4,cfg.curveAmount)
	ui.curveSliderBuddy.setFont("s10 q5 c" cfg.FontColor2,"Calibri")
	ui.curveSlider:=ui.themeEditorGui.addSlider("x32 y169 w80 h14 range5-30 center NoTicks ToolTipTop buddyCurveSliderBuddy vcurveSlider",cfg.curveAmount)
	ui.curveSlider.onEvent("change",changeCurve)
	ui.curveSlider.focus()

	ui.themeEditorTitlebarText.focus()
	changeCurve(*) {
		cfg.curveAmount:=ui.curveSlider.value
		iniWrite(ui.curveSlider.value,cfg.themeFile,cfg.theme,"CurveAmount")
		reload()
	}
	;ui.hideTitleTextLabel:=ui.themeEditorGui.addText("section x4 y174 w160 h20 right backgroundTrans","Hide Titlebar Text")
	;ui.HideTitleTextLabel.setFont("s12 q5 c" cfg.FontColor1)
	ui.hidetitleTextCbValue:=iniRead(cfg.themeFile,cfg.theme,"HideTitlebarText",0)
	ui.hideTitleTextCb:=ui.themeEditorGui.addCheckbox("x12 y187 vHideTitleBarTextCb w150 h26 c" cfg.FontColor2,"Hide Titlebar Text")
	ui.hideTitleTextCb.setFont("s12 q5 c" cfg.FontColor2,"Prototype")
	ui.hideTitleTextCb.value:=ui.hideTitleTextCbValue
	ui.hideTitleTextCb.onEvent("click", toggleTitleText)
	toggleTitleText(*) {
		
		iniWrite((ui.hideTitleTextCb.value),cfg.themeFile,cfg.theme,"HideTitlebarText")
		reload()
		;msgBox("value: " ui.hideTitleTextCb.value "`nFile: " cfg.themeFile)
	}

	ui.titleBarEditBgText:=ui.themeEditorGui.addText("x55 y218 w280 h26 backgroundTrans","dapp")
	ui.titleBarEditBgText.setFont("s14 c" cfg.FontColor2,"move-x")
	(ui.hideTitleTextCbValue) ? ui.titleBarEditBgText.opt("hidden") : ui.titleBarEditBgText.opt("-hidden")


	; ui.themeEditorCancelButton := ui.themeEditorGui.addPicture("x297 y2 w23 h30","./img/button_quit.png")
	; ui.themeEditorCancelButton.onEvent("click", (*) => guiVis(ui.themeEditorGui,false))
	PostMessage(0x0153, -1, 20, ui.themeDDL)  ; Set height of selection field.
	PostMessage(0x0153, 0, 18, ui.themeDDL)  ; Set height of list items.


	;ui.titleBarPreviewLabel:=ui.themeEditorGui.addText("x5 y+5 w40 backgroundTrans center","Titlebar Image")
	drawOutline(ui.themeEditorGui,42,214,350,30,cfg.OutlineColor2,cfg.OutlineColor2,2)
	;ui.titlebarPreviewLabel.setFont("q5 s9 c" cfg.FontColor2,"ubuntu one")
	ui.titlebarPreview.onEvent("click",changeTitlebar)
	ui.titlebarEdit.onEvent("click",changeTitlebar)
	changeTitlebar(*) {
		titleBarImage:=fileSelect(,a_scriptDir "\img\custom\","Select Titlebar Image","*.png;*.jpg")
		splitPath(titleBarImage,&titleBarImageFilename)
		cfg.titleBarImage:=".\img\custom\" titleBarImageFilename
		ui.titlebarPreview.value:=cfg.titleBarImage
		iniWrite(cfg.titleBarImage,cfg.themeFile,cfg.theme,"TitleBarImage")
		reload()
	}

	ControlFocus(ui.toggleColorSelector,ui.themeEditorGui)
}
	
PickColor(Obj,msg,Info*)
{
	this_color := Obj.Text
	prev_color := cfg.%this_color%
	cfg.%this_color% := ChooseColor(this_color,prev_color)
	IniWrite(cfg.%this_color%,cfg.themeFile,cfg.Theme,this_color)
	;ui.ThemeDDL.Choose("Custom")
	;Sleep(1000)
	Reload()
}


RepaintThemeDDL(*) {
	ui.themeDDL.choose(ui.themeDDL.value)
	; drawOutlineNamed("ThemeOutline",ui.themeEditorGui,10,34,222,27,cfg.OutlineColor1,cfg.OutlineColor1,3)
	; drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,10,34,222,27,cfg.OutlineColor2,cfg.OutlineColor2,2)
}

ThemeChanged(*) {
	cfg.theme:=ui.themeDDL.text
	iniWrite(cfg.theme,cfg.file,"Interface","Theme")
	; msgBox(cfg.theme "`n" cfg.file)
	Reload()
}

ChooseColor(ColorType,prev_color) {
	if (cfg.ColorPickerEnabled)
	{
		DialogBox("Click the color you'd like to use for " ColorType "`non the Color Chart","Selecting Color for " ColorType)
		
	
		

			ChosenColor := Format("{:X}", RunWait('./lib/ColorChooser.exe 0x' cfg.%ColorType% ' ' cfg.GuiX ' ' cfg.GuiY))
			DialogBoxClose()
		
		if (ChosenColor == 0) || (ChosenColor == "")
		{
			NotifyOSD("No Color Chosen",3000)
			Return prev_color
		} else {
			NotifyOSD("You have selected: " ChosenColor "`nfor the " ColorType " category.",3000)
			if (InStr(ChosenColor,"0x")) {
				ChosenColor := SubStr(ChosenColor,3,6)
			}
			Return ChosenColor	
		}
	} else {
		winGetPos(&DialogX,&DialogY,&DialogW,&DialogH,ui.themeEditorGui)
		ui.colorGui := Gui()
		ui.ColorPicker := ui.colorGui.addPicture("w515 h1000","./Img/color_swatches.png")
		ui.colorGui.Opt("+AlwaysOnTop -Caption toolWindow +Owner" ui.themeEditorGui.Hwnd)
		ui.colorGui.Show("x" DialogX " y" DialogY+DialogH)
		sleep(1000)
		ClickReceived := KeyWait("LButton","D T30")
		;msgBox(clickReceived)
		if (ClickReceived)
		{
			MouseGetPos(&MouseX,&MouseY)
			ChosenColor := PixelGetColor(MouseX,MouseY)
			if (ChosenColor == 0) || (ChosenColor == "")
			{
				DialogBox("No Color Chosen")
				SetTimer(DialogBoxClose,-3000)
				Return prev_color
			} else {
				;DialogBox("You have selected: " ChosenColor "`nfor the " ColorType " category.")
				;SetTimer(DialogBoxClose,-3000)
				if (InStr(ChosenColor,"0x")) {
					ChosenColor := SubStr(ChosenColor,3,6)
				}
				Return ChosenColor	
			}
		} else {
			DialogBoxClose()
			DialogBox("No Color Chosen. `nReturning to App.")
			SetTimer(DialogBoxClose,-3000)
		}
		ui.colorGui.Destroy()
		
	}
}

addTheme(*) {
	Global
	ui.newThemeGui := Gui(,"Add New Theme")
	ui.newThemeGui.BackColor := cfg.trimColor2
	ui.newThemeGui.Color := "212121"
	ui.newThemeGui.Opt("-Caption -Border +AlwaysOnTop owner" ui.themeEditorGui.hwnd)
	ui.newThemeGui.setFont("q5 s16 cFF00FF", "calibri Bold")
	ui.newThemeTitlebar:=ui.newThemeGui.addText("x3 y2 w172 h24 background" cfg.tabColor1)
	ui.newThemeLabel:=ui.newThemeGui.AddText("x6 y2 section backgroundTrans","New Theme Name")
	ui.newThemeLabel.setFont("q5 s14 c" cfg.fontColor2,"prototype")
	
	ui.newThemeEditorCancelButtonBg := ui.newThemeGui.addText("x172 y2 w26 h24 background" cfg.TabColor2)

	ui.newThemeEditorCancelButton := ui.newThemeGui.addText("x174 y1 w20 h24 backgroundTrans c" cfg.FontColor2,"r")
	ui.newthemeEditorCancelButton.setFont("s17","Webdings")
	ui.newthemeEditorCancelButton.onEvent("click", closeNewTheme)
	ui.newthemeEditorCancelButtonBg.onEvent("click", closeNewTheme)
	ui.newthemeGui.setFont("s12","calibri")
	ui.newThemeEdit := ui.newThemeGui.AddEdit("x2 y28 section w174 h24 -theme background" cfg.tabColor2 " c" cfg.fontColor2,"")
	ui.newThemeOkButton := ui.newThemeGui.AddPicture("x176 ys+0 w22 h22 Background" cfg.OffColor,"./Img/button_save_up.png")
	ui.newThemeOkButton.OnEvent("Click",addThemeToDDL)
	ui.newThemeTitlebarDetail:=ui.newThemeGui.addPicture("x3 y2 w196 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.mainGui.getPos(&tmpX,&tmpY,&tmpW,&tmpH)
	ui.newThemeGui.Show("w200 h52 NoActivate")
	ui.newThemeGui.getPos(&nX,&nY,&nW,&nH)
	

	ui.newThemeGui.Show("x" tmpX+(tmpW/2)-100 " y" tmpY+(tmpH/2)-26 " w200 h52 NoActivate")
	;drawOutline(ui.newThemeGui,0,0,200,51,cfg.trimColor1,cfg.trimColor1,1)	;New App Profile Modal Outline
	closeNewTheme(*) {
		try
			ui.newThemeGui.destroy()
	}
	addThemeToDDL(*) {
		Global
		cfg.themeList.Push(ui.newThemeEdit.Value)
		currentTheme := cfg.Theme
		newThemeName := ui.newThemeEdit.value
		ui.themeDDL.Delete()
		ui.themeDDL.Add(cfg.themeList)
		ui.themeDDL.Choose(ui.newThemeEdit.value)

		{ ;write new Theme to ini
		IniWrite(cfg.titleFontColor,cfg.themeFile,ui.newThemeEdit.Value,"titleFontColor")
		IniWrite(cfg.DisabledColor,cfg.themeFile,ui.newThemeEdit.Value,"DisabledColor")
		IniWrite(cfg.TrimColor2,cfg.themeFile,ui.newThemeEdit.Value,"TrimColor2")
		IniWrite(cfg.TrimColor1,cfg.themeFile,ui.newThemeEdit.Value,"TrimColor1")
		IniWrite(cfg.OutlineColor2,cfg.themeFile,ui.newThemeEdit.Value,"OutlineColor2")
		IniWrite(cfg.OutlineColor1,cfg.themeFile,ui.newThemeEdit.Value,"OutlineColor1")
		IniWrite(cfg.baseColor,cfg.themeFile,ui.newThemeEdit.Value,"baseColor")
		IniWrite(cfg.FontColor1,cfg.themeFile,ui.newThemeEdit.Value,"FontColor1")
		IniWrite(cfg.FontColor2,cfg.themeFile,ui.newThemeEdit.Value,"FontColor2")
		IniWrite(cfg.LabelColor1,cfg.themeFile,ui.newThemeEdit.Value,"LabelColor1")
		IniWrite(cfg.fontColor3,cfg.themeFile,ui.newThemeEdit.Value,"fontColor3")
		IniWrite(cfg.TabColor2,cfg.themeFile,ui.newThemeEdit.Value,"TabColor2")
		IniWrite(cfg.titleBgColor,cfg.themeFile,ui.newThemeEdit.Value,"titleBgColor")
		IniWrite(cfg.TabColor1,cfg.themeFile,ui.newThemeEdit.Value,"TabColor3")
		IniWrite(cfg.TileColor,cfg.themeFile,ui.newThemeEdit.Value,"TileColor")
		IniWrite(cfg.tabColor4,cfg.themeFile,ui.newThemeEdit.Value,"tabColor4")
		IniWrite(cfg.AuxColor1,cfg.themeFile,ui.newThemeEdit.Value,"AuxColor1")
		IniWrite(cfg.TabColor1,cfg.themeFile,ui.newThemeEdit.Value,"TabColor1")
		IniWrite(cfg.OnColor,cfg.themeFile,ui.newThemeEdit.Value,"OnColor")
		IniWrite(cfg.OffColor,cfg.themeFile,ui.newThemeEdit.Value,"OffColor")
		IniWrite(cfg.AlertColor,cfg.themeFile,ui.newThemeEdit.Value,"AlertColor")
		} ;end writing theme to ini
		
		ui.newThemeGui.Destroy()
		cfg.theme:=newThemeName
		ui.themeDDL.choose(cfg.theme)
		reload()
	}
}

; ui.TabColor2Objects:=[ui.exitButtonBg,ui.downButtonBg,ui.gvConsole,ui.d2TopPanelBg,ui.panel4box1,ui.panel4box2,ui.d2LaunchGlyphsButtonBg,ui.d2LaunchRunesButtonBg,ui.d2LaunchWishButtonBg,ui.d2LaunchMapsButtonBg]

; updateColors(*) {
	; for TabColor2Obj in ui.bgColorObjects {
		; TabColor2Obj.opt("background" ui.TabColor2)
	; }
; }


removeTheme(*) {
	for theme in cfg.themeList {
		if theme==ui.themeDDL.text {
			cfg.themeList.RemoveAt(a_index)
			ui.themeDDL.Delete()
			ui.themeDDL.Add(cfg.themeList)
			cfg.theme:=ui.themeDDL.text
			cfg.theme:=cfg.themeList[a_index-1]
			ui.themeDDL.Choose(cfg.theme)
			reload()
		}
	}
}
