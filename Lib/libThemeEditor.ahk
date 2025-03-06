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
ui.themeEditorGui.backColor := cfg.themeBackgroundColor
ui.themeEditorGui.color := cfg.themeBackgroundColor
ui.themeEditorTitlebar := ui.themeEditorGui.addText("x0 y0 w295 h25 background" cfg.themePanel1Color " c" cfg.themeFont1Color,"")
ui.themeEditorTitlebarText := ui.themeEditorGui.addText("x5 y3 w100 h25 backgroundTrans c" cfg.themeFont1Color,"Theme Editor" )
ui.themeEditorTitlebarText.setFont("s13","calibri bold")
ui.themeEditorTitlebar.onEvent("click",wm_lButtonDown_callback)


guiVis(ui.themeEditorGui,false)
ui.themeEditorGui.show("w320 h250 noActivate")
drawOutlineNamed("themeOutline",ui.themeEditorGui,0,0,320,250,cfg.ThemeBorderDarkColor,cfg.ThemeBorderLightColor,3)
drawOutlineNamed("themeOutline",ui.themeEditorGui,1,0,320,25,cfg.ThemeBorderDarkColor,cfg.ThemeBorderLightColor,2)
ui.ColorSelectorLabel2 := ui.themeEditorGui.AddText("x11 y34 h23 section w75 BackgroundTrans c"
	((cfg.ColorPickerEnabled) 
		? cfg.ThemeFont3Color " background" cfg.themePanel3Color 
		: cfg.ThemeFont3Color " background" cfg.themePanel3Color) 
	,((cfg.ColorPickerEnabled) 
		? (" Color App") 
		: (" Swatches ")))
ui.themeEditorCancelButton := ui.themeEditorGui.addPicture("x295 y0 w25 h25","./img/button_quit.png")
ui.themeEditorCancelButton.onEvent("click", (*) => guiVis(ui.themeEditorGui,false))
drawOutlineNamed("themeEditorCancelButtonOutline",ui.themeEditorGui,295,0,25,25,cfg.themeBorderDarkColor,cfg.themeBorderLightColor,2)
ui.ColorSelectorLabel2.setFont("s13","calibri bold")
drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,86,32,60,26,cfg.ThemeBorderDarkColor,cfg.ThemeBorderDarkColor,2)


ui.toggleColorSelector := ui.themeEditorGui.AddPicture("ys-2 x+-61 section w60 h27 background" cfg.themeBackgroundColor, (cfg.ColorPickerEnabled) ? ("./Img/toggle_on.png") : ("./Img/toggle_off.png"))
ui.toggleColorSelector.OnEvent("Click", ToggleColorSelector)
ui.toggleColorSelector.ToolTip := "Select color picking method for theming features"

ToggleColorSelector(*) {
	ui.toggleColorSelector.Value := 
		(cfg.ColorPickerEnabled := !cfg.ColorPickerEnabled) 
			? (ui.ColorSelectorLabel2.Opt("c" cfg.ThemeFont3Color " background" cfg.themeButtonOnColor)
				,ui.ColorSelectorLabel2.Text := " Color App "
				,"./Img/toggle_on.png")
			: (ui.ColorSelectorLabel2.Opt("c" cfg.ThemeFont3Color " background" cfg.ThemeButtonReadyColor)
				,ui.ColorSelectorLabel2.Text := " Swatches "
				,"./Img/toggle_off.png") 
	ui.toggleColorSelector.Redraw()
}

ui.buttonNewTheme := ui.themeEditorGui.AddPicture("x+0 ys+1  section w23 h22 Background" cfg.ThemeButtonReadyColor,"./Img/button_plus_ready.png")
ui.buttonNewTheme.OnEvent("Click",addTheme)
ui.ThemeDDL := ui.themeEditorGui.AddDDL("ys+0 x+1 w120 section center c" cfg.themeFont1Color " Background" cfg.ThemeEditboxColor,cfg.ThemeList)

;
ui.ThemeDDL.OnEvent("Change",ThemeChanged)
ui.ThemeDDL.OnEvent("Focus",RepaintThemeDDL)
ui.ThemeDDL.OnEvent("LoseFocus",RepaintThemeDDL)
ui.themeEditorGui.SetFont("s09")
ui.ThemeDDL.ToolTip := "Select Theme Preset"
ui.buttonDelTheme := ui.themeEditorGui.AddPicture("ys+1 x+-2 w23 h22 Background" cfg.ThemeButtonReadyColor,"./Img/button_minus_ready.png")	
ui.buttonDelTheme.OnEvent("Click",removeTheme)
;drawOutlineNamed("ThemeOutline",ui.themeEditorGui,10,29,302,27,cfg.ThemeBorderLightColor,cfg.ThemeBorderLightColor,3)
drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,10,32,302,26,cfg.ThemeBorderDarkColor,cfg.ThemeBorderDarkColor,2)

;drawOutlineNamed("ThemeOutline",ui.themeEditorGui,85,32,61,26,cfg.ThemeBorderLightColor,cfg.ThemeBorderLightColor,1)

ui.ThemeDDL.Choose(1)
Loop cfg.ThemeList.Length {
	if (cfg.ThemeList[A_Index] == cfg.Theme) {
		ui.ThemeDDL.Choose(cfg.Theme)
		Break
	}
}

ui.ThemeDDL.SetFont("s11")
ui.ThemeElements := [
	"ThemePanel1Color",		"ThemePanel2Color",		
	"ThemeFont1Color",		"ThemeFont2Color",
	"ThemeBright1Color",	"ThemeBright2Color",	"ThemeEditboxColor",
	"ThemePanel3Color",		"ThemePanel4Color",
	"ThemeFont3Color",		"ThemeFont4Color",	
	"ThemeDark1Color",		"ThemeDark2Color",		"ThemeProgressColor",		
	"ThemeBackgroundColor",	"ThemeDisabledColor",
	"ThemeBorderDarkColor",	"ThemeBorderLightColor",
	"ThemeButtonReadyColor","ThemeButtonOnColor", 	"ThemeButtonAlertColor"]

ui.themeEditorGui.SetFont("s10")
ui.themeEditorGui.AddText("x10 y52 section hidden")

Loop ui.ThemeElements.Length
{
	this_color := ui.ThemeElements[A_Index]
	if (A_Index == 8 || A_Index == 15)
		ui.themeEditorGui.AddText("x+5 y52 section hidden")
	ui.%this_color%Picker := ui.themeEditorGui.AddText("xs y+2 section w30 h20 Border Background" cfg.%this_color% " c" cfg.%this_color%,this_color)
	ui.%this_color%Label := ui.themeEditorGui.AddText("x+5 ys+2 c" cfg.ThemeFont1Color,StrReplace(SubStr(this_color,6),"Color"))
	ui.%this_color%Picker.OnEvent("Click",PickColor)
}

ui.titlebarEdit:=ui.themeEditorGui.addPicture("section x4 y214 w32 h-1 backgroundTrans","./img/button_edit.png")
ui.titlebarPreview:=ui.themeEditorGui.addPicture("x37 ys+0 w280 h-1",cfg.titleBarImage)
;ui.titleBarPreviewLabel:=ui.themeEditorGui.addText("x5 y+5 w40 backgroundTrans center","Titlebar Image")
;ui.titlebarPreviewLabel.setFont("s9 c" cfg.themeFont2Color,"ubuntu one")
ui.titlebarPreview.onEvent("click",changeTitlebar)
ui.titlebarEdit.onEvent("click",changeTitlebar)

changeTitlebar(*) {
	cfg.titleBarImage:=fileSelect(,a_scriptDir "\img\","Select Titlebar Image","*.png;*.jpg")
	ui.titlebarPreview.value:=cfg.titleBarImage
	iniWrite(cfg.titleBarImage,cfg.file,"Interface","TitleBarImage")
	
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
	; drawOutlineNamed("ThemeOutline",ui.themeEditorGui,10,34,222,27,cfg.ThemeBorderLightColor,cfg.ThemeBorderLightColor,3)
	; drawOutlineNamed("ThemeOutlineShadow",ui.themeEditorGui,10,34,222,27,cfg.ThemeBorderDarkColor,cfg.ThemeBorderDarkColor,2)
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
	ui.newThemeGui.SetFont("s16 cFF00FF", "Calibri Bold")
	
	ui.newThemeGui.AddText("x10 y10 section","Choose Name for New Custom Theme")
	ui.newThemeEdit := ui.newThemeGui.AddEdit("xs section w180","")
	ui.newThemeOkButton := ui.newThemeGui.AddPicture("x+-7 ys w40 h40 Background" cfg.ThemeButtonReadyColor,"./Img/button_save_up.png")
	ui.newThemeOkButton.OnEvent("Click",addThemeToDDL)
	ui.newThemeGui.Show("w260 h110 NoActivate")
	drawOutline(ui.newThemeGui,5,5,250,100,cfg.ThemeBright2Color,cfg.ThemeBright1Color,2)	;New App Profile Modal Outline

	addThemeToDDL(*) {
		Global
		cfg.themeList.Push(ui.newThemeEdit.Value)
		currentTheme := cfg.Theme
		newThemeName := ui.newThemeEdit.value
		ui.themeDDL.Delete()
		ui.themeDDL.Add(cfg.themeList)
		ui.themeDDL.Choose(ui.newThemeEdit.value)

		{ ;write new Theme to ini
		IniWrite(cfg.ThemeBright2Color,cfg.file,ui.newThemeEdit.Value,"ThemeBright2Color")
		IniWrite(cfg.ThemeBright1Color,cfg.file,ui.newThemeEdit.Value,"ThemeBright1Color")
		IniWrite(cfg.ThemeDark2Color,cfg.file,ui.newThemeEdit.Value,"ThemeDark2Color")
		IniWrite(cfg.ThemeDark1Color,cfg.file,ui.newThemeEdit.Value,"ThemeDark1Color")
		IniWrite(cfg.ThemeBorderDarkColor,cfg.file,ui.newThemeEdit.Value,"ThemeBorderDarkColor")
		IniWrite(cfg.ThemeBorderLightColor,cfg.file,ui.newThemeEdit.Value,"ThemeBorderLightColor")
		IniWrite(cfg.ThemeBackgroundColor,cfg.file,ui.newThemeEdit.Value,"ThemeBackgroundColor")
		IniWrite(cfg.ThemeFont1Color,cfg.file,ui.newThemeEdit.Value,"ThemeFont1Color")
		IniWrite(cfg.ThemeFont2Color,cfg.file,ui.newThemeEdit.Value,"ThemeFont2Color")
		IniWrite(cfg.ThemeFont3Color,cfg.file,ui.newThemeEdit.Value,"ThemeFont3Color")
		IniWrite(cfg.ThemeFont4Color,cfg.file,ui.newThemeEdit.Value,"ThemeFont4Color")
		IniWrite(cfg.ThemePanel1Color,cfg.file,ui.newThemeEdit.Value,"ThemePanel1Color")
		IniWrite(cfg.ThemePanel3Color,cfg.file,ui.newThemeEdit.Value,"ThemePanel3Color")
		IniWrite(cfg.ThemePanel2Color,cfg.file,ui.newThemeEdit.Value,"ThemePanel2Color")
		IniWrite(cfg.ThemePanel4Color,cfg.file,ui.newThemeEdit.Value,"ThemePanel4Color")
		IniWrite(cfg.ThemeEditboxColor,cfg.file,ui.newThemeEdit.Value,"ThemeEditboxColor")
		IniWrite(cfg.ThemeProgressColor,cfg.file,ui.newThemeEdit.Value,"ThemeProgressColor")
		IniWrite(cfg.ThemeDisabledColor,cfg.file,ui.newThemeEdit.Value,"ThemeDisabledColor")
		IniWrite(cfg.ThemeButtonOnColor,cfg.file,ui.newThemeEdit.Value,"ThemeButtonOnColor")
		IniWrite(cfg.ThemeButtonReadyColor,cfg.file,ui.newThemeEdit.Value,"ThemeButtonReadyColor")
		IniWrite(cfg.ThemeButtonAlertColor,cfg.file,ui.newThemeEdit.Value,"ThemeButtonAlertColor")
		} ;end writing theme to ini
		
		ui.newThemeGui.Destroy()
		
	}
}

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
