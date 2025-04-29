#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}


WM_WINDOWPOSCHANGED(wParam, lParam, msg, Hwnd) {
	try
		collateGuis(hwnd)
}

collateGuis(hwnd := ui.mainGui.hwnd) {
	; msgBox(vaultTopGui.hwnd "`n" hwnd)

		if hwnd == ui.mainGui.hwnd {
					winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui)
					ui.gameTabGui.move((mainGuiX+34)*(A_ScreenDPI/96),(mainGuiY+183)*(A_ScreenDPI/96))
					ui.gameSettingsGui.move((mainGuiX+34)*(A_ScreenDPI/96),(mainGuiY+30)*(A_ScreenDPI/96))
					;ui.gameSettingsLinkGui.move((mainGuiX+35+12)*(A_ScreenDPI/96),(mainGuiY+35+79)*(A_ScreenDPI/96))
			
			; case ui.infoGui.hwnd:
					; winGetPos(&tmpX,&tmpY,,,ui.infoGui)
					; ui.infoGuiBg.move(tmpX,tmpY)
			
			; case ui.pbConsoleBg.hwnd:
				; winGetPos(&winX,&winY,,,ui.pbConsoleBg.hwnd)
				; ui.pbConsole.move(winX,winY)
			
		}
				if hwnd == vaultTopGui.hwnd {
				winGetPos(&tX,&tY,,,vaultTopGui)
				winMove(tx+0,ty+30,,,"ahk_exe destiny2.exe")
		} 
}


{ ;mouse events
wm_winActivated(this_control,info,msg,hwnd) {
	static prev_hwnd := hwnd
	if hwnd == ui.mainGui.hwnd && prev_hwnd != hwnd {
		restoreWin()       
		ui.prevHwnd := hwnd
	}
}

WM_LBUTTONDOWN_callback(thisControl,info) {
	postMessage("0xA1",2,,,"A")
	;WM_LBUTTONDOWN(0,0,0,thisControl)	
}

WM_LBUTTONDOWN_pBcallback(*) {
	WM_LBUTTONDOWN(0,0,0,"A")
}

; setTimer () => 	msgbox(winGetTitle(winActive("A"))),3000

WM_LBUTTONDOWN(wParam, lParam, msg, Hwnd) {
	;ShowMouseClick()
		postMessage("0xA1",2)
}

wm_mouseMove(wParam, lParam, msg, hwnd) {
	static prevHwnd := 0
	try {
		if hwnd!=prevHwnd {
			prevHwnd:=hwnd
			if cfg.tooltipsEnabled && guiCtrlFromHwnd(hwnd).hasProp("ToolTip") { 
					toolTipDelayStart(hwnd)
			}
			
		} else 
			prevHwnd:=hwnd

	}
	try {
	(ui.incursionGui.hwnd == hwnd)
				? (setTimer(d2FlashIncursionNoticeA,0)
					,setTimer(d2FlashIncursionNoticeB,0)
					,ui.incursionGuiBg.opt("background" cfg.FontColor3))
				: prevHwnd:=hwnd
			prevHwnd:=hwnd
	}
}

toolTipDelayStart(origHwnd) {
	mouseGetPos(,,&currCtrlWin,&currCtrlClass)
	try {
		if origHwnd == controlGetHwnd(currCtrlClass,currCtrlWin) {
			origGuiCtrl := guiCtrlFromHwnd(origHwnd)
			if origGuiCtrl.hasProp("ToolTipData")
				toolTip(origGuiCtrl.toolTipData)
			else
				toolTip(origGuiCtrl.toolTip)
			setTimer () => toolTip(), -4000
		}
	}
}


} ;end mouse EVENTS##############
;end modal guis
	
{ ;window utilities

getTaskbarHeight() {
	MonitorGet(MonitorGetPrimary(),,,,&TaskbarBottom)
	MonitorGetWorkArea(MonitorGetPrimary(),,,,&TaskbarTop)
	TaskbarHeight := TaskbarBottom - TaskbarTop
	Return taskbarHeight
}


} ;end utility functions


drawPanel2(params) {
;USAGE:
;drawPanel(drawPanelParams)
;drawPanelParams := [
;	targetGui, 		;gui object the panel will be on
;	panelX,			;x coordinate of the panel (in relation to the gui)
;	panelY,			;y coordinate of the panel
;	panelW,			;width of panel
;	panelH,			;height of panel
;	panelColor,		;panel background color
;	outlineColor,	;panel outlineColor
;	OutlineColor2,	;secondary "3d" effect outline color (not required)
;	labelText,		;label text (leave blank for no label)
;	labelW,			;label width 
;	labelPos,		;label position (from 0-1 based on length of gui)
;	outlineWidth,	;outline width
;	outlineOffset,	;outline offset (how many pixels inset the border starts)
;	labelFont, 		;label font
;	labelFontColor]	;label font color

	targetGui		:= params[1]
	panelX			:= params[2]
	panelY			:= params[3]
	panelW			:= params[4]
	panelH			:= params[5]
	panelColor		:= params[6]
	outlineColor	:= params[7]
	OutlineColor2	:= params[8]
	labelText 		:= (params.length >= 9) ? params[9] : ""
	labelW 			:= (params.length >= 10) ? params[10] : 100
	labelPos 		:= (params.length >= 11) ? params[11] : .5
	outlineWidth 	:= (params.length >= 12) ? params[12] : 1
	outlineOffset 	:= (params.length >= 13) ? params[13] : 0
	labelFont 		:= (params.length >= 14) ? params[14] : "calibri"
	labelFontColor 	:= (params.length >= 15) ? params[15] : "white"
		
	labelH := 20
	static panelId := 0
	panelId+=1
	
	ui.backPanel%panelId% := ui.%targetGui%.addText("x" panelX " y" panelY " w" panelW " h" panelH " background" panelColor)		
	ui.panelOutline2%panelId% := ui.%targetGui%.addText("x" panelX+outlineOffset " y" panelY+outlineOffset " w" panelW-outlineOffset*2 " h" panelH-outlineOffset*2 " background" OutlineColor2)		
	ui.panelOutline1%panelId% := ui.%targetGui%.addText("x" panelX+outlineOffset " y" panelY+outlineOffset " w" panelW-outlineWidth-outlineOffset*2 " h" panelH-outlineWidth-outlineOffset*2 " background" outlineColor	)
	ui.panel%panelId% := ui.%targetGui%.addText("x" panelX+outlineWidth+outlineOffset " y" panelY+outlineWidth+outlineOffset " w" panelW-outlineWidth*2-outlineOffset*2 " h" panelH-outlineWidth*2-outlineOffset*2 " background" panelColor)	

	if (labelText != "") {
		labelBottom := false
		if (labelPos > 1) {
			labelBottom := true
			labelPos -= 1
			labelY := panelY + panelH - labelH + outlineWidth
			labelOutlineColor := OutlineColor2
		} else {
			labelY := panelY
			labelOutlineColor := outlineColor
		}
		labelX := panelX+panelW*labelPos
		

		ui.labelTop%panelId% := ui.%targetGui%.addText("x" labelX-outlineWidth " y" labelY-outlineOffset " w" labelW+outlineWidth*2 " h" labelH-2 " background" labelOutlineColor " center c" labelFontColor) 
		
		ui.labelTop%panelId%.setFont("q5 s10")
		
		if (labelBottom) {
			ui.labelTop%panelId% := ui.%targetGui%.addText("x" labelX-outlineWidth " y" labelY+outlineOffset " w" labelW+outlineWidth*2 " h" labelH-outlineWidth " background" labelOutlineColor " center c" labelFontColor) 
		
			ui.labelTop%panelId%.setFont("q5 s10")			
			ui.label%panelId% := ui.%targetGui%.addText("x" labelX " y" labelY+(outlineWidth) " w" labelW " h" labelH-outlineWidth*2 " background" ui.%targetGui%.backColor,"")
			ui.label%panelId%.setFont("q5 s10")

			ui.labelBottom%panelId% := ui.%targetGui%.addText("x" labelX+1 " y" labelY+3 " w" labelW-2 " h" labelH " backgroundTrans center c" labelFontColor, labelText) 
			ui.labelBottom%panelId%.setFont("q5 s10")
		} else {
			ui.labelTop%panelId% := ui.%targetGui%.addText("x" labelX-outlineWidth " y" labelY+outlineOffset " w" labelW+outlineWidth*2 " h" labelH-2 " background" labelOutlineColor " center c" labelFontColor) 
		
		ui.labelTop%panelId%.setFont("q5 s10")
			ui.label%panelId% := ui.%targetGui%.addText("x" labelX " y" labelY-1 " w" labelW " h" labelH-outlineWidth*2 " background" ui.%targetGui%.backColor,"")
		
		
			ui.label%panelId%.setFont("q5 s10")
		

			ui.labelBottom%panelId% := ui.%targetGui%.addText("x" labelX+1 " y" labelY-2 " w" labelW-2 " h" labelH " backgroundTrans center c" labelFontColor, labelText) 
		
			ui.labelBottom%panelId%.setFont("q5 s10")
		}
				
	}
}
