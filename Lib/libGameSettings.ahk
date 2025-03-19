#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

;libGuiSetupTab
	
GuiGameTab(&ui,&cfg)
{

	; ui.MainGuiTabs.UseTab("Setup")
	; ui.MainGui.setFont("q5 s09")
	; ui.GameTabs := ui.MainGui.AddTab3("x35 y1 w495 h213 Buttons -Redraw Background" cfg.bgColor2 " -E0x200", cfg.gameList)
	; ui.MainGui.setFont("q5 s10")
	; ui.MainGui.setFont("q5 s10")
	; ui.holdToCrouch := ui.MainGui.AddPicture("x85 y50 w60 h25 section vHoldToCrouch " ((cfg.holdToCrouch) ? ("Background" cfg.trimColor3) : ("Background" cfg.trimColor2)),((cfg.holdToCrouch) ? (cfg.toggleOn) : (cfg.toggleOff)))
	; ui.holdToCrouch.OnEvent("Click", toggleChanged)
	; ui.holdToCrouch.ToolTip := "Toggles holdToCrouch"
	; ui.labelToolTips := ui.MainGui.AddText("x+3 ys+3 BackgroundTrans","Hold To Crouch")


} ;End Game Profile List Modal Gui
