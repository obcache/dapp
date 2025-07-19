#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off


if (InStr(A_LineFile,A_ScriptFullPath)) {
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

createHelp(*) {
	ui.keybase:=map()
	ui.keybase["00_CapsLock "]:="Start/Stop Autorun"
	ui.keybase["01_Pause "]:="Enable/Disable DApp"
	ui.keybase["02_Ctrl-Shift-Enter "]:="Theme Editor"
	ui.keybase["03_Alt-Pause "]:="Default Audio Device +"
	ui.keybase["04_"]:=""
	ui.keybase["05_App Keybinds "]:="Keys you wish to use to enact actions"
	ui.keybase["06_Game Keybinds "]:="Keybinds as defined in-game"
	ui.keybase["07_Auto "]:="Automatically import game keybinds"
	ui.keybase["08_Buttons "]:="DIM, Callouts and Maps"



	ui.transparentColor:="010203"
	ui.helpGui:=gui()
	ui.helpGuiPos:=object()
	ui.helpGuiPos.w:=820
	ui.helpGuiPos.h:=390
	ui.helpGuiPos.x:=(a_screenwidth/2)-(ui.helpGuiPos.w/2)
	ui.helpGuiPos.y:=(a_screenheight/2)-(ui.helpGuiPos.h/2)
	ui.helpGui.opt("-caption -border toolWindow alwaysOnTop")
	ui.helpGui.backColor:=ui.transparentColor
	ui.helpGui.color:=ui.transparentcolor

	ui.helpGuiBg:=ui.helpGui.addText("x" 0 " y" 0 " w" ui.helpGuiPos.w " h" ui.helpGuiPos.h " background" cfg.tabColor1)
	ui.helpGuiBg2:=ui.helpGui.addText("x1 y1 w" ui.helpGuiPos.w-2 " h" ui.helpGuiPos.h-2 " background" cfg.tabColor2)
	ui.helpGuiBg3:=ui.helpGui.addText("x3 y3 w" ui.helpGuiPos.w-6 " h" ui.helpGuiPos.h-6 " background" cfg.tabColor1)
	ui.helpGuiTitlebar:=ui.helpGui.addText("x3 y3 w" ui.helpGuiPos.w-6-30 " h" 26 " background" cfg.tabColor3)
	ui.helpGuiTitlebarText:=ui.helpGui.addText("x8 y3 w" ui.helpGuiPos.w-6-30 " h" 26 " backgroundTrans","Help - DApp v" a_fileVersion)
	ui.helpGuiTitlebarText.setFont("s16 c" cfg.fontColor3,"Calibri")
	ui.helpGuiTitlebar.onEvent("click",wm_LButtonDown_callback)
	ui.helpGuiCloseBg:=ui.helpGui.addText("x" ui.helpGuiPos.w-30-3 " y3 w" 30 " h" 26 " background" cfg.tabColor1)
	ui.helpGuiClose:=ui.helpGui.addText("x" ui.helpGuiPos.w-30-3 " y1 w" 30 " h" 26 " backgroundTrans c" cfg.fontColor1,"r")
	ui.helpGuiClose.onEvent("click",toggleHelp)
	ui.helpGuiClose.setFont("s22 c" cfg.fontColor3,"Webdings")

	ui.helpGui.setFont("s16 c" cfg.fontColor3,"Calibri")
	ui.helpGui.addText("x8 y34 w0 h0 section backgroundTrans")
	;ui.helpImg1:=ui.helpGui.addPicture("xs+0 y+0 w800 h55 backgroundTrans","./img/helpImg1.png")
	;ui.helpGuiTextBg:=ui.helpGui.addText("xs+0 y+0 w800 h400 background" cfg.tabColor4)

	for this_hotkey in ui.keybase {
		ui.helpGui.addText("right section xs w180 h30 background" cfg.tabColor4," " substr(this_hotkey,4))
		ui.helpGui.addText("x+6 ys w616 h30 background" cfg.tabColor4," " ui.keybase[this_hotkey])
	}
}

ui.helpVisible:=false
toggleHelp(*) {
	(ui.helpVisible:=!ui.helpVisible)
		? ui.helpGui.show("x" ui.helpGuiPos.x " y" ui.helpGuiPos.y " w" 820 " h" ui.helpGuiPos.h " noActivate")
		: ui.helpGui.hide()
	}
	
^+h:: {
	togglehelp()
	return
}