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
	guiVis(ui.themeEditorGui,true)
}

ui.themeEditorGui := gui()
ui.themeEditorGui.opt("-caption alwaysOnTop toolWindow owner" ui.mainGui.hwnd)
ui.themeEditorGui.backColor := cfg.bgColor2
ui.themeEditorGui.color := cfg.baseColor
ui.themeEditorTitlebar := ui.themeEditorGui.addText("x0 y0 w372 h30 background" cfg.bgColor1 " c" cfg.fontColor1,"")
ui.themeEditorTitlebarText := ui.themeEditorGui.addText("x10 y6 w180 h30 backgroundTrans c" cfg.fontColor1,"Theme Editor" )
ui.themeEditorTitlebarText.setFont("q5 s15","move-x")
ui.themeEditorTitlebar.onEvent("click",wm_lButtonDown_callback)

;drawOutlineNamed("ThemeOutline",ui.themeEditorGui,85,32,61,26,cfg.outlineColor1,cfg.outlineColor1,1)
ui.themeEditorCancelButtonBg := ui.themeEditorGui.addText("x370 y3 w26 h27 background" cfg.bgColor1)
ui.themeEditorCancelButton := ui.themeEditorGui.addText("x367 y1 w26 h26 backgroundTrans c" cfg.fontColor1,"r")
ui.themeEditorCancelButton.setFont("s22","Webdings")
ui.themeEditorCancelButton.onEvent("click", closeThemeEditor)
ui.themeEditorCancelButtonBg.onEvent("click", closeThemeEditor)


guiVis(ui.themeEditorGui,false)
ui.themeEditorGui.show("w400 h250 noActivate")
drawOutlineNamed("themeOutline",ui.themeEditorGui,0,0,398,250,cfg.outlineColor2,cfg.outlineColor2,3)
;drawOutlineNamed("themeOutline",ui.themeEditorGui,1,0,324,24,cfg.outlineColor2,cfg.outlineColor1,2)
ui.ColorSelectorLabel2 := ui.themeEditorGui.AddText("x6 y33 h21 center section w100 BackgroundTrans c"
	((cfg.ColorPickerEnabled) 
		? cfg.fontColor3 " background" cfg.trimColor1 
		: cfg.fontColor3 " background" cfg.trimColor1) 
	,((cfg.ColorPickerEnabled) 
		? (" Color App") 
		: (" Swatches ")))
;drawOutlineNamed("themeEditorCancelButtonOutline",ui.themeEditorGui,300,2,24,24,cfg.outlineColor2,cfg.outlineColor1,2)
ui.ColorSelectorLabel2.setFont("q5 s14","calibri bold")
;drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,10,32,60,28,cfg.outlineColor2,cfg.outlineColor2,2)




ToggleColorSelector(*) {
	ui.toggleColorSelector.Value := 
		(cfg.ColorPickerEnabled := !cfg.ColorPickerEnabled) 
			? (ui.ColorSelectorLabel2.Opt("c" cfg.fontColor3 " background" cfg.trimColor1)
				,ui.ColorSelectorLabel2.Text := " Color App "
				,"./Img/toggle_left.png")
			: (ui.ColorSelectorLabel2.Opt("c" cfg.fontColor4 " background" cfg.trimColor4)
				,ui.ColorSelectorLabel2.Text := " Swatches "
				,"./Img/toggle_right.png") 
	ui.toggleColorSelector.Redraw()
}
ui.toggleColorSelector := ui.themeEditorGui.AddPicture("y30 x107 section w60 h27 backgroundTrans", (cfg.ColorPickerEnabled) ? ("./Img/toggle_left.png") : ("./Img/toggle_right.png"))
ui.toggleColorSelector.OnEvent("Click", ToggleColorSelector)
ui.toggleColorSelector.ToolTip := "Select color picking method for theming features"
ui.buttonNewTheme := ui.themeEditorGui.AddPicture("x+4 ys+1 section w25 h23 Background" cfg.trimColor1,"./Img/button_plus_ready.png")
ui.buttonNewTheme.OnEvent("Click",addTheme)

ui.themeEditorGui.setFont("s11","move-x")
ui.ThemeDDL := ui.themeEditorGui.AddDDL("ys+0 x+0 w176 section center c" cfg.fontColor1 " Background" cfg.trimColor6,cfg.ThemeList)
ui.themeDDL.setFont("s13","arial")
ui.ThemeDDL.OnEvent("Change",ThemeChanged)
ui.ThemeDDL.OnEvent("Focus",RepaintThemeDDL)
ui.ThemeDDL.OnEvent("LoseFocus",RepaintThemeDDL)
ui.ThemeDDL.ToolTip := "Select Theme Preset"
ui.buttonDelTheme := ui.themeEditorGui.AddPicture("ys+0 x+-3 w24 h24 Background" cfg.trimColor2,"./Img/button_minus_ready.png")	
ui.buttonDelTheme.OnEvent("Click",removeTheme)
;drawOutlineNamed("ThemeOutline",ui.themeEditorGui,10,29,302,27,cfg.outlineColor1,cfg.outlineColor1,3)
drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,5,30,388,27,cfg.outlineColor2,cfg.outlineColor2,2)



closeThemeEditor(*) {
	try {
		ui.themeEditorGui.Hide()
		ui.themeEditor.destroy()
		}
}

ui.ThemeDDL.Choose(1)
Loop cfg.ThemeList.Length {
	if (cfg.ThemeList[A_Index] == cfg.Theme) {
		ui.ThemeDDL.Choose(cfg.Theme)
		Break
	}
}

ui.ThemeElements := [
	
	"bgColor0",		"bgColor1",
	"bgColor2", 	"bgColor3","baseColor",
	"fontColor1",	"fontColor2",
	"fontColor3", 	"fontColor4",
	"trimColor1",	"trimColor2",
	"trimColor3",	"trimColor4",
	"trimColor5",	"trimColor6",	
	"accentColor1",	"accentColor2",	
	"accentColor3",	"accentColor4",			
	"outlineColor2","outlineColor1"
		
	 	]

ui.themeEditorGui.AddText("x10 y50 section hidden")

Loop ui.ThemeElements.Length
{
	this_color := ui.ThemeElements[A_Index]
	switch a_index {
		case 6: 
			ui.themeEditorGui.AddText("section x+8 y50 hidden")
		case 10:
			ui.themeEditorGui.AddText("section x+8 y50 hidden")
		case 16:
			ui.themeEditorGui.AddText("section x+8 y50 hidden")
	}

	ui.themeEditorGui.addText("section xs+0 y+4 w30 h20 background" cfg.outlineColor2)
	ui.%this_color%Picker := ui.themeEditorGui.AddText("xs+1 y+-19 w28 h18 Border Background" cfg.%this_color% " c" cfg.%this_color%,this_color)
	ui.%this_color%picker.redraw()
	ui.%this_color%Label := ui.themeEditorGui.AddText("x+6 ys+0 c" cfg.fontColor1,StrReplace(this_color,"Color"))
	ui.%this_color%Picker.OnEvent("Click",PickColor)
}

;ui.hideTitleTextLabel:=ui.themeEditorGui.addText("section x4 y174 w160 h20 right backgroundTrans","Hide Titlebar Text")
;ui.HideTitleTextLabel.setFont("s12 q5 c" cfg.fontColor1)
ui.hidetitleTextCbValue:=iniRead(cfg.themeFile,cfg.theme,"HideTitlebarText",0)
ui.hideTitleTextCb:=ui.themeEditorGui.addCheckbox("x12 y184 vHideTitleBarTextCb w150 h26 c" cfg.fontColor2,"Hide Titlebar Text")
ui.hideTitleTextCb.setFont("s12 q5 c" cfg.fontColor2,"calibri")
ui.hideTitleTextCb.value:=ui.hideTitleTextCbValue
ui.hideTitleTextCb.onEvent("click", toggleTitleText)
toggleTitleText(*) {
	
	iniWrite((ui.hideTitleTextCb.value),cfg.themeFile,cfg.theme,"HideTitlebarText")
	reload()
	;msgBox("value: " ui.hideTitleTextCb.value "`nFile: " cfg.themeFile)
}

ui.titleBarEditBgText:=ui.themeEditorGui.addText("section x47 y218 w280 h26 backgroundTrans","dapp")
ui.titleBarEditBgText.setFont("s14 c" cfg.fontColor2,"move-x")
(ui.hideTitleTextCbValue) ? ui.titleBarEditBgText.opt("hidden") : ui.titleBarEditBgText.opt("-hidden")

ui.titlebarEdit:=ui.themeEditorGui.addPicture("section x10 y214 w30 h30 backgroundTrans","./img/button_edit.png")
ui.titlebarPreview:=ui.themeEditorGui.addPicture("x44 ys+0 w346 h30 backgroundTrans",cfg.titleBarImage)
;ui.titleBarPreviewLabel:=ui.themeEditorGui.addText("x5 y+5 w40 backgroundTrans center","Titlebar Image")
drawOutline(ui.themeEditorGui,42,214,350,30,cfg.outlineColor1,cfg.outlineColor2,2)
;ui.titlebarPreviewLabel.setFont("q5 s9 c" cfg.fontColor2,"ubuntu one")
ui.titlebarPreview.onEvent("click",changeTitlebar)
ui.titlebarEdit.onEvent("click",changeTitlebar)
; ui.themeEditorCancelButton := ui.themeEditorGui.addPicture("x297 y2 w23 h30","./img/button_quit.png")
; ui.themeEditorCancelButton.onEvent("click", (*) => guiVis(ui.themeEditorGui,false))
PostMessage(0x0153, -1, 20, ui.themeDDL)  ; Set height of selection field.
PostMessage(0x0153, 0, 18, ui.themeDDL)  ; Set height of list items.

changeTitlebar(*) {
	titleBarImage:=fileSelect(,a_scriptDir "\img\custom\","Select Titlebar Image","*.png;*.jpg")
	splitPath(titleBarImage,&titleBarImageFilename)
	cfg.titleBarImage:=".\img\custom\" titleBarImageFilename
	ui.titlebarPreview.value:=cfg.titleBarImage
	iniWrite(cfg.titleBarImage,cfg.themeFile,cfg.theme,"TitleBarImage")
	reload()
}

ControlFocus(ui.toggleColorSelector,ui.themeEditorGui)

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
	; drawOutlineNamed("ThemeOutline",ui.themeEditorGui,10,34,222,27,cfg.outlineColor1,cfg.outlineColor1,3)
	; drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,10,34,222,27,cfg.outlineColor2,cfg.outlineColor2,2)
}

ThemeChanged(*) {
	Reload()
}

ChooseColor(ColorType,prev_color)
{
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
		ui.colorGui.Opt("+AlwaysOnTop -Caption toolWindow +Owner" ui.themeEditorGui.Hwnd)
		ui.ColorPicker := ui.colorGui.AddPicture("w515 h1000","./Img/color_swatches.png")
		ui.colorGui.Show("x" DialogX " y" DialogY+DialogH " NoActivate")
		Sleep(1000)
		ClickReceived := KeyWait("LButton","D T15")
		
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
				DialogBox("You have selected: " ChosenColor "`nfor the " ColorType " category.")
				SetTimer(DialogBoxClose,-3000)
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
	ui.newThemeGui.BackColor := "505050"
	ui.newThemeGui.Color := "212121"
	ui.newThemeGui.Opt("-Caption -Border +AlwaysOnTop")
	ui.newThemeGui.setFont("q5 s16 cFF00FF", "calibri Bold")
	
	ui.newThemeGui.AddText("x10 y10 section","Choose Name for New Custom Theme")
	ui.newThemeEdit := ui.newThemeGui.AddEdit("xs section w180","")
	ui.newThemeOkButton := ui.newThemeGui.AddPicture("x+-7 ys w40 h40 Background" cfg.trimColor2,"./Img/button_save_up.png")
	ui.newThemeOkButton.OnEvent("Click",addThemeToDDL)
	ui.newThemeGui.Show("w260 h110 NoActivate")
	drawOutline(ui.newThemeGui,5,5,250,100,cfg.accentColor4,cfg.accentColor3,2)	;New App Profile Modal Outline

	addThemeToDDL(*) {
		Global
		cfg.themeList.Push(ui.newThemeEdit.Value)
		currentTheme := cfg.Theme
		newThemeName := ui.newThemeEdit.value
		ui.themeDDL.Delete()
		ui.themeDDL.Add(cfg.themeList)
		ui.themeDDL.Choose(ui.newThemeEdit.value)

		{ ;write new Theme to ini
		IniWrite(cfg.accentColor4,cfg.file,ui.newThemeEdit.Value,"accentColor4")
		IniWrite(cfg.accentColor3,cfg.file,ui.newThemeEdit.Value,"accentColor3")
		IniWrite(cfg.accentColor2,cfg.file,ui.newThemeEdit.Value,"accentColor2")
		IniWrite(cfg.accentColor1,cfg.file,ui.newThemeEdit.Value,"accentColor1")
		IniWrite(cfg.outlineColor2,cfg.file,ui.newThemeEdit.Value,"outlineColor2")
		IniWrite(cfg.outlineColor1,cfg.file,ui.newThemeEdit.Value,"outlineColor1")
		IniWrite(cfg.baseColor,cfg.file,ui.newThemeEdit.Value,"baseColor")
		IniWrite(cfg.fontColor1,cfg.file,ui.newThemeEdit.Value,"fontColor1")
		IniWrite(cfg.fontColor2,cfg.file,ui.newThemeEdit.Value,"fontColor2")
		IniWrite(cfg.fontColor3,cfg.file,ui.newThemeEdit.Value,"fontColor3")
		IniWrite(cfg.fontColor4,cfg.file,ui.newThemeEdit.Value,"fontColor4")
		IniWrite(cfg.bgColor1,cfg.file,ui.newThemeEdit.Value,"bgColor1")
		IniWrite(cfg.trimColor1,cfg.file,ui.newThemeEdit.Value,"trimColor1")
		IniWrite(cfg.bgColor2,cfg.file,ui.newThemeEdit.Value,"bgColor2")
		IniWrite(cfg.bgColor3,cfg.file,ui.newThemeEdit.Value,"bgColor3")
		IniWrite(cfg.trimColor6,cfg.file,ui.newThemeEdit.Value,"trimColor6")
		IniWrite(cfg.trimColor5,cfg.file,ui.newThemeEdit.Value,"trimColor5")
		IniWrite(cfg.bgColor0,cfg.file,ui.newThemeEdit.Value,"bgColor0")
		IniWrite(cfg.trimColor3,cfg.file,ui.newThemeEdit.Value,"trimColor3")
		IniWrite(cfg.trimColor2,cfg.file,ui.newThemeEdit.Value,"trimColor2")
		IniWrite(cfg.trimColor4,cfg.file,ui.newThemeEdit.Value,"trimColor4")
		} ;end writing theme to ini
		
		ui.newThemeGui.Destroy()
		
	}
}

; ui.bgColor1Objects:=[ui.exitButtonBg,ui.downButtonBg,ui.gvConsole,ui.d2TopPanelBg,ui.panel4box1,ui.panel4box2,ui.d2LaunchGlyphsButtonBg,ui.d2LaunchRunesButtonBg,ui.d2LaunchWishButtonBg,ui.d2LaunchMapsButtonBg]

; updateColors(*) {
	; for bgColor1Obj in ui.bgColorObjects {
		; bgColor1Obj.opt("background" ui.bgColor1)
	; }
; }


removeTheme(*) {
	if cfg.themeList.Length == 1 {
	{
		ResetDefaultThemes()
	} else {
		cfg.themeList.RemoveAt(ui.themeDDL.value)
		ui.themeDDL.Delete()
		ui.themeDDL.Add(cfg.themeList)
		ui.themeDDL.Choose(1)
	}
}
