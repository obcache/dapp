#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

ui.vaultCleanerOpen := false

libVaultInit(*) {
	ui.vaultCleanerOpen:=true
	setting.gameExe := "destiny2.exe"
	setting.xMargin:=306
	setting.yMargin:=235
	setting.columnCount:=10
	setting.rowCount:=5
	setting.tileSize:=67
	setting.gameW:=1280
	setting.gameH:=720
	setting.transColor:="010203"

	result.tileNum:=0
	result.tileStr := ""
}
	
	fullscreenProcess(*) {
		ui.waitingForPrompt:=false
		ui.notifyResponse:=true
		
		
	}
	
	fullscreenCancel(*) {
		ui.waitingForPrompt:=false
		ui.notifyResponse:=false
		vaultModeOff()
	}
	
	vaultCleaner() {
		global
		
		if !winExist(this.gameWin) {
			msgBox("Destiny2 is not Running")
			exit
		}
		
		pbNotify('If Destiny 2 is not already set to "Windowed Fullscreen",`n please do it now and then click "Proceed"',30,"YN","fullscreenProcess","fullscreenCancel")
		try 
			vaultTopGui.destroy()
		vaultTopGui := gui()
		vaultTopGui.backColor:=setting.transColor
		vaultTopGui.setFont("q5 s10 c000000","calibri")
		vaultTopGui.opt("-border")	
		vaultTopGui.backColor:=setting.transColor
		vaultTopGui.setFont("q5 s10 c000000","calibri")

		titleBarBg:=vaultTopGui.addText("x0 y0 w1250 h34 vTitleBarBg background777777")
		titleBarBg.onEvent("click",vault_LBUTTONDOWN_callback)
		titleBarText:=vaultTopGui.addText("x10 y-2 w500 h32 backgroundTrans c992121","Vault Mode Enabled. Ready to dismantle unlocked items.")
		titleBarText.setFont("q5 s20 bold cffffff","calibri")
		closeButton:=vaultTopGui.addText("x" setting.gameW-36 " y0 w30 h32 cffffff background777777","T")
		closeButton.setFont("q5 s24","WingDings 2")
		closeButton.onEvent("click",closeProgram)
		closeProgram(*) {
			exitApp
		}


		toggleButton(*) {
			(this.state:=!this.state)
				? cleanVaultStart()
				: vault_exitFunc()
		}

		this.remainHour:=""
		this.remainMin:=""
		this.remainSec:=""
		this.elapsedHour:=""
		this.elapsedMin:=""
		this.elapsedSeconds:=""
		
		if this.gameWin {
			winGetPos(&gameWinX,&gameWinY,&gameWinW,&gameWinH,this.gameWin)
			this.origGameWinX:=gameWinX
			this.origGameWinY:=gameWinY
			this.origGameWinW:=gameWinW
			this.origGameWinH:=gameWinH
			winMove((a_screenwidth/2)-640,(a_screenHeight/2)-360,1280,720,this.gameWin)
			winSetStyle("-0xC00000",this.GameWin)
			winActivate(this.gameWin)

			winWait(this.gameWin)
			sleep(2000)
			vaultTopGui.show("x" (a_screenwidth/2)-640 " y" (a_screenHeight/2)-360 " w" setting.gameW-6 " h30")

			send("{F1}")
			sleep(600)
			send("{Ctrl}")
			sleep(600)
			send("{w}")
			sleep(600)
			;this.mainButtonHotkey.setFont("q5 c00FFFFE")
			this.statusText.text:="Dismantles ALL unlocked items. *DIM Search 'is:unlocked' to review"
			this.mainButton.opt("background" cfg.themeButtonAlertColor)
			this.mainButtonText.setFont("c" cfg.themeFont2Color)
			this.mainButton.redraw()
			;this.vaultProgressLabelBg.opt("backgroundD0D0F0")
			;this.vaultProgressLabelBg.redraw()
	} else {
				msgBox("Process " setting.gameExe " not Running")
		}
	}

vault_LBUTTONDOWN_callback(thisControl,info) {
	postMessage("0xA1",2,,,"A")
	;WM_LBUTTONDOWN(0,0,0,thisControl)	
}
stopCleaning(*) {
	this.isRunning:=false
	this.mainButtonText.text:="Start"
	this.statusText.text:="[Spacebar] to start cleaning"
	this.mainButton.opt("background" cfg.themeButtonReadyColor "c" cfg.themeFont4Color)
	setTimer(timer,0)
	this.restartQueue:=false
	exit
}	

cleanVaultStart(*) {
	(winExist(this.gameWin)) 
		? winActivate(this.gameWin)
		: notifyOSD("No Destiny Window Found")
	this.isRunning:=true
	winActivate(this.gameWin)
	

	this.statusText.text:="[Spacebar] to Stop/Exit"
	setTimer(timer,1000)
	timer()
	coordMode("mouse","client")
	
	(this.restartQueued) ? (this.restartQueued:=false,exit) : 0
	
	; this.mainButtonHotkey.text:="[Delete]" 	
	; this.mainButton.opt("background" cfg.themeButtonOnColor " c" cfg.themeFont2Color)
	; this.mainButtonText.text:="Stop"
	mouseMove(955,170)
	sleep(500)
	notLastPage:=true
	pageUpColor:=""

	loop {
	(this.restartQueued) ? stopCleaning() : 0
		if subStr(pixelGetColor(970,170),3,1)<="3" {
			mouseMove(955,170)
			this.page+=1
			this.pageCount.text:=format("{:03d}",this.page)
			sleep(250)
			send("{LButton Down}")
			sleep(250)
			send("{LButton Up}")
		} else {
			break
		}
	}
	(this.restartQueued) ? stopCleaning() : 0
	sleep(250) 	
	mouseMove(905,170)
	sleep(250)
	send("{LButton Down}")
	sleep(250)
	send("{LButton Up}")
	this.page-=1
	this.maxRange:=this.page*50
	this.pageCount.text:=format("{:03d}",this.page)
	this.vaultProgress.opt("range1-" this.maxRange)
	this.vaultProgress.value:=0
	sleep(800)

	while this.page>0 {
		loop setting.rowCount {
			this.row:=setting.rowCount-a_index
			loop setting.columnCount {
				(this.restartQueued) ? stopCleaning() : 0
				this.vaultProgress.value+=1  
				this.col:=setting.columnCount-a_index
				this.itemNum+=1
				dismantle(this.col,this.row)				
			}
		}
			mouseMove(905,170)
			sleep(500)
			send("{LButton Down}")
			sleep(350)
			send("{LButton Up}")

			this.page-=1
			this.pageCount.text:=format("{:03d}",this.page)
			sleep(600)
		this.statusText.text:="Operation Complete"
		this.isRunning:=false
	}
}

dismantle(thisCol,thisRow) {
	x:=tile(thisCol,thisRow).x
	y:=tile(thisCol,thisRow).y
	
	this.isLocked:=false
	this.isExotic:=false
	this.timeoutCounter:=0
	while !winActive(this.gameWin) && ((this.timeoutCounter:=a_index) < 20)
		sleep(1000)
		
	if this.timeoutCounter >= 20 {
		msgBox('Game window out-of-focus too long.`nStopping Vault Clean Process')
		exit
	}
	
	mouseMove(x,y)
	sleep(200)
	send("{f}")
	this.isExotic:=false
	this.isLocked:=false
	loop 30 {
		this.tileColor:=pixelGetColor((thisCol<6) ? x-(setting.tileSize/2)+1 : x+(setting.tileSize/2)-3,y)	
		; (thisCol<6)
			; ? logTxt:="Check Locked," formatTime("T12","yyMMddhhmmss") "," thisRow ":" thisCol "," x ":" y "," x-(setting.tileSize/2) ":" y "," this.tileColor
			; : logTxt:="Check Locked," formatTime("T12","yyMMddhhmmss") "," thisRow ":" thisCol "," x ":" y "," x+(setting.tileSize/2) ":" y "," this.tileColor 
		; fileAppend(logTxt "`n" ,"./.debug.txt","`n")
		rValue:="0x" substr(this.tileColor,3,1)
		gValue:="0x" substr(this.tileColor,5,1)
		if (rValue - gValue > 1) || (rValue - gValue < -1) {
			this.isLocked:=true  
			break
		}
	}
	
	if !this.isLocked {
		sleep(300)
		send("{f down}")
		while pixelGetColor((thisCol<6) ? x-(setting.tileSize/2)+1 : x+(setting.tileSize/2)-3,y) == this.tileColor && isIdle()   {
			sleep(100)
			if a_index > 30 
				this.isExotic:=true
		}
		if this.isExotic
			this.dismantledExotics.text+=1
		else
			this.dismantledLegendary.text+=1
	}
	send("{f up}")
}

timeFormat(seconds) {
	sec:=mod(seconds,60)
	min:=round(seconds/60)
	hour:=round(seconds/3600)
	return(format("{:02d}",hour) ":" format("{:02d}",min) ":" format("{:02d}",sec))
}

timer(*) {
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





hotIf(isVault)
hotkey("Delete",cleanVaultStart)
hotIf()

hotIf(vaultCleanerRunning)
hotkey("End",queueStop)
hotIf()

queueStop(*) {
	this.restartQueued:=true
}

vaultCleanerRunning(*) {
	return this.isRunning
}
isVault(*) {
	this.hwnd:=0
	try
		this.hwnd:=winExist(vaultTopGui)
		
	if this.hwnd > 0 && winActive(this.gameWin)
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
	ui.vaultCleanerOpen:=false
	try
		setTimer(timer,0)
	try
		vaultBottomGui.hide()
	try
		winSetStyle("-0xC00000",this.GameWin)
	try
		winMove(0,0,a_screenWidth,a_screenHeight,this.gameWin)
	sleep(2000)
	this.restartQueued:=false

}
hotIf()