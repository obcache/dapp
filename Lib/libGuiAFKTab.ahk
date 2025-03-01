#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) {
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
}	
	
guiAFKTab(&ui,&afk) {
	errorLevel:=1
	; ui.MainGuiTabs.UseTab("3_AFK")
	;Any logic needed for the AFK tab beneath the docked AfkGui
	; win1afk.routine := ui.mainGui.addListView("x325 y37 section w200 h78 0xC 0x2000 -Hdr readOnly Background" cfg.ThemeEditBoxColor,["","","",""])
	; win2afk.routine := ui.mainGui.addListView("xs y+10 w200 h78 0xC 0x2000 -Hdr readOnly Background" cfg.ThemeEditboxColor,["","","",""])
	; win1afk.routine.SetFont("s10 c" cfg.themeFont1color)
	; win2afk.routine.SetFont("s10 c" cfg.themeFont1color)
	; loop 2 {
	; win%a_index%afk.routine.modifyCol(1,15)
	; win%a_index%afk.routine.modifyCol(2,180)
	; win%a_index%afk.routine.modifyCol(3,60)
	; win%a_index%afk.routine.modifyCol(4,8)
	
	
	}
	
	
	
