#requires autohotkey v2.0+
#singleInstance

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

persistent()

this:=object()
color:=object()

themeInit(*) {
	color.frame1:="707070"
	color.back1:="454545"
	color.accent1:="959595"
	color.font1:="454545"
	this.transColor:="010203"
}

uiInit(*) {
	; this.ui:=gui()
	; this.ui.opt("-border -caption")
	; this.ui.color:=this.transColor
	; this.ui.backColor:=this.transColor
	; winSetTransColor(this.transColor,this.ui)
	
	; this.wsFrame1:=this.ui.addText("x0 y0 w800 h600 background" color.frame1)
	; this.wsBack1:=this.ui.addText("x2 y2 w796 h596 background" color.back1)
	; this.wsCaption:=this.ui.addText("x2 y2 w796 h30 background" color.accent1)
	; this.wsCaptionText:=this.ui.addText("x2 y4 w796 h30 backgroundTrans"," cShift")
	; this.wsCaptionVersion:=this.ui.addText("x2 y4 w740 h30 backgroundTrans right","v" a_fileVersion "  ")
	; this.wsCaptionHideBg:=this.ui.addText("x738 y2 w30 h29 right background" color.back1)
	; this.wsCaptionHide:=this.ui.addText("x735 y5 w30 h29 right backgroundTrans","")
	; this.wsCaptionQuitBg:=this.ui.addText("x768 y2 w30 h29 right backgroundBB2222")
	; this.wsCaptionQuit:=this.ui.addText("x765 y4 w30 h29 right backgroundTrans","")
	; this.wsCaptionQuit.setFont("s18 c" color.font1,"Segoe MDL2 Assets")
	; this.wsCaptionHide.setFont("s18 c" color.accent1,"Segoe MDL2 Assets")
	; this.wsCaptionText.setFont("s18 c" color.font1,"arial")
	; this.wsCaptionVersion.setFont("s18 c" color.font1,"arial")
	; this.ui.show("w800 h600")
	; this.wsCaption.onEvent("click",wmLButtonDown_callback)
	
	; this.wsLb:=this.ui.addListBox("x4 y32 w790 h400")
}

wmLButtonDown_callback(*) {
	postMessage("0xA1",2)
}
;

isCShiftEnabled(*) {
	if cfg.cShiftEnabled
		return 1
	else
		return 0
}

hotIf(isCShiftEnabled)
hotkey("xButton1",nothing)
hotkey("xButton2",mapAlt)
hotkey("*~LButton",nades)
hotkey("*~RButton",ult)
hotkey("*~MButton",melee)
hotIf()


nothing(*) {
}

mapAlt(*) {
	send("{LAlt Down}")
	keyWait("xButton2")
	send("{LAlt Up}")
}

nades(*) {
	if getKeyState("xButton1","P")
		send("[")
}
melee(*) {
	if getKeyState("xButton1","P")
		send("\")
}
ult(*) {
	if getKeyState("xButton1","P")
		send("]")
}

; themeInit()
; uiInit()

