#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

setting:=object()
this:=object()
result:=object()
ui:=object()
ui.waitingForPrompt:=""
ui.notifyResponse:=""
libVaultInit()
vaultCleaner()
libVaultInit(*) {
	setting.gameExe := "destiny2.exe"
	setting.xMargin:=305
	setting.yMargin:=235
	setting.columnCount:=10
	setting.rowCount:=5
	setting.tileSize:=67
	setting.gameW:=1280
	setting.gameH:=720
	setting.transColor:="010203"

	result.tileNum:=0
	result.tileStr := ""

	this.page:=1
	this.row:=1
	this.col:=1
	this.x:=0
	this.y:=1
	this.locked:=true
	this.exotic:=false
	this.wasMax:=false
	this.maxRange:=100
	this.state:=false
	this.itemNum:=1
	this.YOffset:=748
	this.restartQueued:=false
	this.elapsedSec:=1
}
	
	fullscreenProcess(*) {
		ui.waitingForPrompt:=false
		ui.notifyResponse:=true
		
		
	}
	
	fullscreenCancel(*) {
		ui.waitingForPrompt:=false
		ui.notifyResponse:=false
	}
	
	vaultCleaner() {
		global
		this.gameWin:="ahk_exe " setting.gameExe
		if !winExist(this.gameWin) {
			msgBox("Destiny2 is not Running")
			exit
		}
		
		pbNotify('If Destiny 2 is not already set to "Windowed Fullscreen",`n please do it now and then click "Proceed"',30,"YN","fullscreenProcess","fullscreenCancel")
		
		; bgGui := gui()
		; bgGui.opt("alwaysOnTop -caption -border toolWindow")
		; bgGui.backColor:="333333"
		; winSetTransparent(190,bgGui.hwnd)
		try 
			thisGui.destroy()
		
		thisGui := gui()
		thisGui.backColor:=setting.transColor
		thisGui.setFont("s10 c000000","Calibri")
		thisGui.opt("-border owner" winGetID("ahk_exe destiny2.exe"))	
		winSetTransColor(setting.transColor,thisGui.hwnd)
		;help:=thisGui.adwdText("section x5 y5 w650 h40 backgroundTrans c00FFFF",
		titleBarBg:=thisGui.addText("x0 y0 w1254 h30 background454545")
		titleBarBg.onEvent("click",wm_lbuttonDown_callback)
		titleBarText:=thisGui.addText("x10 y-2 w500 h30 backgroundTrans c212121","VaultCleaner for Destiny2 (v1.2)" )
		titleBarText.setFont("s20 bold cbbbbbb","calibri")
		closeButton:=thisGui.addText("x1250 y0 w30 h30 cBBBBBB background454545","T")
		closeButton.setFont("s24","WingDings 2")
		closeButton.onEvent("click",closeProgram)
		closeProgram(*) {
			exitApp
		}
		footerBarBg:=thisGui.addText("x0 y" this.yOffset " w1284 h100 background454545")
		thisGui.addText("x0 y30 w1284 h2 background959595")
		thisGui.addText("x0 y" this.YOffset " w1284 h2 background959595")
		onMessage(0x47,WM_WINDOWPOSCHANGED)
		WM_WINDOWPOSCHANGED(*) {
			try {
				winGetPos(&tX,&tY,,,thisGui.hwnd)
				winMove(tx+3,ty+32,,,this.gameWin)
			}		
		}
		WM_LBUTTONDOWN_callback(this_control*) {
			postMessage("0xA1",2,,,"A")
			;WM_LBUTTONDOWN(0,0,0,this_control)
		}
		this.statusText:=thisGui.addText("x10 y" 38+this.yOffset " w640 h30 backgroundTrans c00FFFF","Please Wait....")
		this.statusText.setFont("s16")
		this.mainButtonBg:=thisGui.addText("x5 y" 5+this.yOffset " w80 h30 background353535")
		this.mainButton:=thisGui.addText("section center x7 y" 7+this.yOffset " w76 h26 background454545 c00FFFF","")
		this.mainButtonText:=thisGui.addText("section center x7 y" 2+this.yOffset " w76 h30 backgroundTrans c353535","Start")
		this.mainButtonText.setFont("s20")
		this.mainButtonHotkey:=thisGui.addText("left ys backgroundTrans c454545 h30 w130","[ Shift ]+[ \ ]")
		this.mainButtonHotkey.setFont("s20")
		;this.mainButton.onEvent("click",toggleButton)
		toggleButton(*) {
			(this.state:=!this.state)
				? cleanVaultStart()
				: vault_exitFunc()
		}		
		
		;help2:=thisGui.addText("xs+0 w600 h60 y+0 backgroundTrans c00FFFF","")
		thisGui.setFont("s12")
		drawOutlineNamed("vaultStats",thisGui,998,this.yOffset+8,270,55,"c00FFFF","c00FFFF",1)
		this.pageLabel:=thisGui.addText("right x1000 y" 10+this.yOffset " w80 h25 backgroundTrans c00FFFF","Page: ")
		this.pageCount:=thisGui.addText("x1080 y" 10+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}",this.page))
		;this.statusUnderline:=thisGui.addText("x1000 y" 8+this.yOffset " w270 center h1 c00FFFF background00FFFF")
		this.statusHeaderLabel:=thisGui.addText("x1000 y" this.yOffset " w140 left h25 c00FFFF backgroundTrans","")
		this.elapsed:=thisGui.addText("x1000 y" 25+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Elapsed: ")
		this.elapsedTime:=thisGui.addText("x1080 y" 25+this.yOffset " left w80 h25 c00FFFF backgroundTrans","00:00:00")
		this.remaining:=thisGui.addText("x1000 y" 40+this.yOffset " right w80 h25 c00FFFF backgroundTrans","Remaining: ")
		this.remainingtime:=thisGui.addText("x1080 y" 40+this.yOffset " left w80 h25 c00FFFF backgroundTrans","00:00:00")
			


		
		
		;this.dismantledUnderline:=thisGui.addText("x1160 y" 18+this.yOffset " w110 center h1 c00FFFF background00FFFF")
		this.dismantledHeaderLabel:=thisGui.addText("x1160 y" this.yOffset " w110 right h25 c00FFFF backgroundTrans","")
		this.dismantledLegendaryLabel:=thisGui.addText("x1160 y" 10+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Legendary: ")
		this.dismantledLegendary:=thisGui.addText("x1240 y" 10+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))
		this.dismantledExoticLabel:=thisGui.addText("x1160 y" 25+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Exotic: ")
		this.dismantledExotics:=thisGui.addText("x1240 y" 25+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))
		this.dismantledTotalLabel:=thisGui.addText("x1160 y" 40+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Total: ")
		this.dismantledTotal:=thisGui.addText("x1240 y" 40+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))
		
		


		this.remainHour:=""
		this.remainMin:=""
		this.remainSec:=""
		this.elapsedHour:=""
		this.elapsedMin:=""
		this.elapsedSeconds:=""

		this.vaultProgressLabelBg:=thisGui.addText("x0 y" 70+this.yOffset " w100 h30 background505060 c151515","")
		this.vaultProgressLabel:=thisGui.addText("x5 y" 70+this.yOffset " w85 h30 backgroundTrans c302535","Progress")
		this.vaultProgressLabel.setFont("s14","Helvetica")
		this.vaultProgress := thisGui.addProgress("x90 y" 70+this.yOffset " w1289 h30 c440000 background151515 range1-500")
		this.completeMsg := thisGui.addText("x30 y67 w500 h30 backgroundTrans c00FFFF","")

		useTab("
		this.status2Text:=ui.gameSettingsGui.addText("x10 y" 38+this.yOffset " w640 h30 backgroundTrans c00FFFF","Please Wait....")
		this.status2Text.setFont("s16")
		this.mainButton2Bg:=ui.gameSettingsGui.addText("x5 y" 5+this.yOffset " w80 h30 background353535")
		this.mainButton2:=ui.gameSettingsGui.addText("section center x7 y" 7+this.yOffset " w76 h26 background454545 c00FFFF","")
		this.mainButton2Text:=ui.gameSettingsGui.addText("section center x7 y" 2+this.yOffset " w76 h30 backgroundTrans c353535","Start")
		this.mainButton2Text.setFont("s20")
		this.mainButton2Hotkey:=ui.gameSettingsGui.addText("left ys backgroundTrans c454545 h30 w130","[ Shift ]+[ \ ]")
		this.mainButton2Hotkey.setFont("s20")
		;this.mainButton.onEvent("click",toggleButton)
		toggleButton(*) {
			(this.state:=!this.state)
				? cleanVaultStart()
				: vault_exitFunc()
		}
		drawOutlineNamed("vaultStats2",ui.gameSettingsGui,998,this.yOffset+8,270,55,"c00FFFF","c00FFFF",1)
		this.pageLabel2:=ui.gameSettingsGui.addText("right x1000 y" 10+this.yOffset " w80 h25 backgroundTrans c00FFFF","Page: ")
		this.pageCount2:=ui.gameSettingsGui.addText("x1080 y" 10+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}",this.page))
		;this.statusUnderline:=ui.gameSettingsGui.addText("x1000 y" 8+this.yOffset " w270 center h1 c00FFFF background00FFFF")
		this.statusHeaderLabel2:=ui.gameSettingsGui.addText("x1000 y" this.yOffset " w140 left h25 c00FFFF backgroundTrans","")
		this.elapsed2:=ui.gameSettingsGui.addText("x1000 y" 25+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Elapsed: ")
		this.elapsedTime2:=ui.gameSettingsGui.addText("x1080 y" 25+this.yOffset " left w80 h25 c00FFFF backgroundTrans","00:00:00")
		this.remaining2:=ui.gameSettingsGui.addText("x1000 y" 40+this.yOffset " right w80 h25 c00FFFF backgroundTrans","Remaining: ")
		this.remainingtime2:=ui.gameSettingsGui.addText("x1080 y" 40+this.yOffset " left w80 h25 c00FFFF backgroundTrans","00:00:00")
		this.vaultProgress2LabelBg:=ui.gameSettingsGui.addText("x0 y" 70+this.yOffset " w100 h30 background505060 c151515","")
		this.vaultProgress2Label:=ui.gameSettingsGui.addText("x5 y" 70+this.yOffset " w85 h30 backgroundTrans c302535","Progress")
		this.vaultProgress2Label.setFont("s14","Helvetica")
		this.vaultProgress2 := ui.gameSettingsGui.addProgress("x90 y" 70+this.yOffset " w1289 h30 c440000 background151515 range1-500")
		this.completeMsg2 := ui.gameSettingsGui.addText("x30 y67 w500 h30 backgroundTrans c00FFFF","")
		this.dismantled2HeaderLabel:=ui.gameSettingsGui.addText("x1160 y" this.yOffset " w110 right h25 c00FFFF backgroundTrans","")
		this.dismantled2LegendaryLabel:=ui.gameSettingsGui.addText("x1160 y" 10+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Legendary: ")
		this.dismantled2Legendary:=ui.gameSettingsGui.addText("x1240 y" 10+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))
		this.dismantled2ExoticLabel:=ui.gameSettingsGui.addText("x1160 y" 25+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Exotic: ")
		this.dismantled2Exotics:=ui.gameSettingsGui.addText("x1240 y" 25+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))
		this.dismantled2TotalLabel:=ui.gameSettingsGui.addText("x1160 y" 40+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Total: ")
		this.dismantled2Total:=ui.gameSettingsGui.addText("x1240 y" 40+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))

		


		if this.gameWin {
			winGetPos(&gameWinX,&gameWinY,&gameWinW,&gameWinH,this.gameWin)
			this.origGameWinX:=gameWinX
			this.origGameWinY:=gameWinY
			this.origGameWinW:=gameWinW
			this.origGameWinH:=gameWinH
			this.gameWinX:=gameWinX
			this.gameWinY:=gameWinY
			this.gameWinW:=gameWinW
			this.gameWinH:=gameWinH
			winMove((a_screenwidth/2)-640,(a_screenHeight/2)-360,1280,720,this.gameWin)
			winSetStyle("-0xC00000",this.GameWin)
			winActivate(this.gameWin)
			winWait(this.gameWin)
			thisGui.show("x" this.gameWinX+2 " y" this.gameWinY-28 " w1280 h" 30+720+94 " noActivate")
			sleep(2000)

			;winSetTransColor("830303","ahk_exe destiny2.exe")

			send("{F1}")
			sleep(600)
			send("{Ctrl}")
			sleep(600)
			send("{w}")
			sleep(600)
			this.mainButtonHotkey.setFont("c00FFFF")
			this.statusText.text:="Dismantles ALL unlocked items. *DIM Search 'is:unlocked' to review"
			this.mainButton.opt("background22aa11")
			this.mainButton.redraw()
			this.vaultProgressLabelBg.opt("backgroundD0D0F0")
			this.vaultProgressLabelBg.redraw()
	} else {
				msgBox("Process " setting.gameExe " not Running")
		}
	}

	
cleanVaultStart(*) {
	setTimer(timer,1000)
	timer()
	coordMode("mouse","client")
	this.mainButtonHotkey.text:="[Esc]" 	
	this.mainButton.opt("backgroundbb2211 c252525")
	this.mainButtonText.text:="Stop"

	mouseMove(955,170)
	sleep(500)
	notLastPage:=true
	pageUpColor:=""
	if this.restartQueued {
		exit()
	}
	loop {
		;msgBox(pageUpColor := pixelGetColor(970,170))
		;msgBox(subStr(pageUpColor,3,1))
		if this.restartQueued {
			exit()
		}
		if subStr(pixelGetColor(970,170),3,1)<="3" {
			mouseMove(955,170)
			this.page+=1
			this.pageCount.text:=format("{:03d}",this.page)
			sleep(250)
			send("{LButton Down}")
			sleep(250)
			send("{LButton Up}")
			;sleep(350)
		} else {
			break
		}
	}
	if this.restartQueued {
		exit()
	}
	sleep(250) 	
	mouseMove(905,170)
	sleep(250)
	send("{LButton Down}")
	sleep(250)
	send("{LButton Up}")
	this.page-=1
	this.pageCount.text:=format("{:03d}",this.page)
	this.maxRange:=this.page*50
	this.vaultProgress.opt("range1-" this.maxRange)
	this.vaultProgress.value:=0
	sleep(800)


	while this.page>0 {

		loop setting.rowCount {
			this.row:=setting.rowCount-a_index
			loop setting.columnCount {
			if this.restartQueued {
				exit()
			}
			this.vaultProgress.value+=1
			this.col:=setting.columnCount-a_index
			this.itemNum+=1
			;dismantle(this.col,this.row,tile(this.col,this.row).x,tile(this.col,this.row).y)
			if this.restartQueued {
				exit()
			}
			isUnlocked(this.col,this.row)
				
			}
		}
		;sleep(500)
		mouseMove(905,170)
		sleep(500)
		send("{LButton Down}")
		sleep(350)
		send("{LButton Up}")
		this.page-=1
		
		this.pageCount.text:=format("{:03d}",this.page)
		sleep(600)
	}
	this.completeMsg.text:="Operation Complete"
	
		;msgBox(result.logUi.text)
}

isUnlocked(thisCol,thisRow,x:=tile(thisCol,thisRow).x,y:=tile(thisCol,thisRow).y) {
	this.timeoutCounter:=0
	while !winActive(this.gameWin) && ((this.timeoutCounter:=a_index) < 20)
		sleep(1000)
		
	if this.timeoutCounter >= 20 {
		msgBox('Game window out-of-focus too long.`nStopping Vault Clean Process')
		exit
	}
	
	mouseMove(x,y)
	sleep(50)
	send("{f}")
	this.color:=array()
	sleep(20)
	result.locked:=false
	if thisCol >= 6 {
		loop 5 {
			this.color:=pixelGetColor(x+(setting.tileSize/2)-4,y)
			if subStr(this.color,3,1) != subStr(this.color,5,1) {
				result.locked:=true
				break
			}
		}
	} else {
		loop 5 {
			this.color:=pixelGetColor(x-(setting.tileSize/2)+2,y) '`n'
			if subStr(this.color,3,1) != subStr(this.color,5,1) {
				result.locked:=true
				break
			}
		}
	}

	sleep(150)
	if !result.locked {
		sendEvent("{f down}")
		sleep(1800)
		if this.restartQueued {
			exit()
		}
		loop 30 {
			if pixelSearch(&returnX,&returnY,(thisCol>=5) ? x+50 : x-150,300,100,720,"0x830303",1) {
				this.exotic:=true
				sleep(3200)
				break
			}
			sleep(5)
		}
	
		this.dismantledTotal.text:=format("{:03d}",round(this.dismantledTotal.text)+1)
		if this.exotic
			this.dismantledExotics.text:=format("{:03d}",round(this.dismantledExotics.text)+1)
		else
			this.dismantledLegendary.text:=format("{:03d}",round(this.dismantledLegendary.text)+1)				
		this.exotic:=false
	}
	send("{f up}")
}
dismantle(thisCol,thisRow,x:=tile(thisCol,thisRow).x,y:=tile(thisCol,thisRow).y) {
	isUnlocked:=false
	isExotic:=false
	mouseMove(x,y)
	sleep(50)
	send("{f down}")
	sleep(150)
	loop 30 {
		if pixelSearch(&returnX,&returnY,0,300,1280,720,"0x830303",1) {
			;msgBox("pass1")
			isUnlocked := true
			break
		}
	}
	
	if isUnlocked {
		sleep(2000)
		loop 30 {
			if pixelSearch(&returnX,&returnY,0,300,1280,720,"0x830303",1) {
				isExotic := true
				break
			}
		}
		if isExotic
			sleep(3000)
	}
	
	send("{f up}")
	isUnlocked:=false
	isExotic:=false
}

timeFormat(seconds) {
	;msgBox(seconds)
	sec:=mod(seconds,60)
	min:=round(seconds/60)
	hour:=round(seconds/3600)
	return(format("{:02d}",hour) ":" format("{:02d}",min) ":" format("{:02d}",sec))
}

timer(*) {
	;msgBox(this.elapsedSec)
	this.elapsedSec+=1
	this.remainingItems:=this.maxRange-this.itemNum
	this.currSpeed:=this.elapsedSec/this.itemNum
	this.remainingSec:=this.remainingItems*this.currSpeed
	this.elapsedTime.text := timeFormat(this.elapsedSec)
	this.elapsedTime.redraw()
	this.remainingTime.text:= timeFormat(this.remainingSec)
	this.remainingTime.redraw()
}

tile(colNum,rowNum) {
	tile := object()
	tile.x := (setting.xMargin)+(setting.tileSize*colNum)+(setting.tileSize/2)
	tile.y := (setting.yMargin)+(setting.tileSize*rowNum)+(setting.tileSize/2)
	return tile
}

hotIf(isHot)
+\:: {
	this.statusText.text:="[Esc] to Stop/Exit"
	
	cleanVaultStart()
}

Esc:: {
	this.restartQueued:=true
	vault_exitFunc()
}

F5:: {
	libVaultInit()
	vaultCleaner()
}
hotIf()

isHot(*) {
	if winActive(this.gameWin)
		return 1
	else
		return 0
}
		
isIdle(*) {
	if (A_TimeIdlePhysical > 1500 && A_TimeIdleMouse > 1500)
		return 1
	else 
		return 0
}

vault_exitFunc(*) {
	try
		setTimer(timer,0)
	try
		thisGui.hide()
	try
		winSetStyle("-0xC00000",this.GameWin)
	try
		winMove(0,0,a_screenWidth,a_screenHeight,this.gameWin)
	sleep(2000)
	this.restartQueued:=false

}
hotIf()


pbNotify(NotifyMsg,Duration := 10,YN := "",confirmCustomScript:="notifyConfirm",cancelCustomScript:="notifyCancel") {
	Transparent := 250
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Notify"

	ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := "353535" ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.SetFont("s16")  ; Set a large font size (32-point).
	ui.notifyGui.AddText("c00FFFF center BackgroundTrans",NotifyMsg)  ; XX & YY serve to 00auto-size the window.
	ui.notifyGui.AddText("xs hidden")
	
	if (YN) {
		ui.notifyGui.AddText("xs hidden")
		ui.notifyGui.SetFont("s10")
		ui.notifyYesButton := ui.notifyGui.AddButton("ys section w60 h25","Proceed")
		ui.notifyYesButton.OnEvent("Click",%confirmCustomScript%)
		ui.notifyNoButton := ui.notifyGui.AddButton("xs w60 h25","Cancel")
		ui.notifyNoButton.OnEvent("Click",%cancelCustomScript%)
	}
	
	ui.notifyGui.Show("AutoSize")
	winGetPos(&x,&y,&w,&h,ui.notifyGui.hwnd)
	drawOutline(ui.notifyGui,0,0,w,h,"202020","808080",3)
	drawOutline(ui.notifyGui,5,5,w-10,h-10,"BBBBBB","DDDDDD",2)
	canProceed:=""
	timeout:=0
	if (YN) {
		while timeout < 90 && ui.waitingForPrompt {
				timeout+=1
				sleep(500)
		}
		ui.waitingForPrompt:=true
		if timeout > 89 {
			notifyOSD("Timed out waiting for response. Cancelling")
			setTimer () => (fadeOSD()),-1
			Exit
		} else {
			if !ui.notifyResponse {
				setTimer () => (fadeOSD()),-1
				
				exit
			} else {
				setTimer () => (sleep(duration),fadeOSD()),-1
			}
				
		} 
		timeout:=0
	} else
			setTimer () => (sleep(duration),fadeOSD()),duration
} 

pbWaitOSD() {
	ui.notifyGui.destroy()
	pbNotify("Timed out waiting for response.`nPlease try your action again",-1000)
}



{ ;Draw Outline Functions
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


	; drawOutlineTitleBarButtonGui(X, Y, W, H, Color1 := "Black", Color2 := "Black", Thickness := 1) {	
		
		; ui.titleBarButtonGui.AddProgress("x" X " y" Y " w" W " h" Thickness " Background" Color1) 
		; ui.titleBarButtonGui.AddProgress("x" X " y" Y " w" Thickness " h" H " Background" Color1) 
		; ui.titleBarButtonGui.AddProgress("x" X " y" Y + H - Thickness " w" W " h" Thickness " Background" Color2) 
		; ui.titleBarButtonGui.AddProgress("x" X + W - Thickness " y" Y " w" Thickness " h" H " Background" Color2) 	
	
	; }
} ;End Draw Outline Functions


fadeOSD() {
	ui.transparent := 250
	While ui.Transparent > 10 { 	
	
		try
			WinSetTransparent(ui.Transparent,ui.notifyGui)
		ui.Transparent -= 3
		Sleep(1)
	}
	try
		guiVis(ui.notifyGui,false)
	
	ui.Transparent := ""
	
}
