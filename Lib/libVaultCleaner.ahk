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
		
		if !winExist(this2.gameWin) {
			msgBox("Destiny2 is not Running")
			exit
		}
		
		pbNotify('If Destiny 2 is not already set to "Windowed Fullscreen",`n please do it now and then click "Proceed"',30,"YN","fullscreenProcess","fullscreenCancel")
		try 
			vaultTopGui.destroy()
		vaultTopGui := gui()
		vaultTopGui.backColor:=setting.transColor
		vaultTopGui.setFont("q5 s10 c000000","calibri")
		vaultTopGui.opt("-border alwaysOnTop")	
		vaultTopGui.backColor:=setting.transColor
		vaultTopGui.setFont("q5 s10 c000000","calibri")

		titleBarBg:=vaultTopGui.addText("x0 y0 w1250 h34 vTitleBarBg background777777")
		titleBarBg.onEvent("click",WM_LBUTTONDOWN_callback)
		titleBarText:=vaultTopGui.addText("x10 y-2 w500 h32 backgroundTrans c992121","Vault Mode Enabled. Ready to dismantle unlocked items.")
		titleBarText.setFont("q5 s20 bold cffffff","calibri")
		closeButton:=vaultTopGui.addText("x" setting.gameW-36 " y0 w30 h32 cffffff background777777","T")
		closeButton.setFont("q5 s24","WingDings 2")
		closeButton.onEvent("click",closeProgram)
		closeProgram(*) {
			exitApp
		}w

		onMessage(0x47,this_WINDOWPOSCHANGED)
		this_WINDOWPOSCHANGED(obj,thisWin,test,*) {
		msgBox(obj "`n" thisWin "`n" test)
			try {
				if thisWin=="TitleBarBg" { 
					winGetPos(&tX,&tY,&tw,&th,vaultTopGui.hwnd)
					winMove(tx+0,ty+30,,,this2.gameWin)
				}
			}		
		}
		toggleButton(*) {
			(this2.state:=!this2.state)
				? cleanVaultStart()
				: vault_exitFunc()
		}

		this2.remainHour:=""
		this2.remainMin:=""
		this2.remainSec:=""
		this2.elapsedHour:=""
		this2.elapsedMin:=""
		this2.elapsedSeconds:=""
		
		if this2.gameWin {
			winGetPos(&gameWinX,&gameWinY,&gameWinW,&gameWinH,this2.gameWin)
			this2.origGameWinX:=gameWinX
			this2.origGameWinY:=gameWinY
			this2.origGameWinW:=gameWinW
			this2.origGameWinH:=gameWinH
			winMove((a_screenwidth/2)-640,(a_screenHeight/2)-360,1280,720,this2.gameWin)
			winSetStyle("-0xC00000",this2.GameWin)
			winActivate(this2.gameWin)

			winWait(this2.gameWin)
			sleep(2000)
			vaultTopGui.show("x" (a_screenwidth/2)-640 " y" (a_screenHeight/2)-360 " w" setting.gameW-6 " h30")

			send("{F1}")
			sleep(600)
			send("{Ctrl}")
			sleep(600)
			send("{w}")
			sleep(600)
			this2.mainButtonHotkey.setFont("q5 c00FFFFE")
			this2.statusText.text:="Dismantles ALL unlocked items. *DIM Search 'is:unlocked' to review"
			this2.mainButton.opt("background22aa11")
			this2.mainButton.redraw()
			this2.vaultProgressLabelBg.opt("backgroundD0D0F0")
			this2.vaultProgressLabelBg.redraw()
	} else {
				msgBox("Process " setting.gameExe " not Running")
		}
	}

	
cleanVaultStart(*) {
	winActivate(this2.gameWin)
	this2.statusText.text:="[Esc] to Stop/Exit"
	setTimer(timer,1000)
	timer()
	coordMode("mouse","client")
	this2.mainButtonHotkey.text:="[Esc]" 	
	this2.mainButton.opt("backgroundbb2211 c252525")
	this2.mainButtonText.text:="Stop"
	mouseMove(955,170)
	sleep(500)
	notLastPage:=true
	pageUpColor:=""
	loop {
		if subStr(pixelGetColor(970,170),3,1)<="3" {
			mouseMove(955,170)
			this2.page+=1
			this2.pageCount.text:=format("{:03d}",this2.page)
			sleep(250)
			send("{LButton Down}")
			sleep(250)
			send("{LButton Up}")
		} else {
			break
		}
	}
	if this2.restartQueued {
		exit()
	}
	sleep(250) 	
	mouseMove(905,170)
	sleep(250)
	send("{LButton Down}")
	sleep(250)
	send("{LButton Up}")
	this2.page-=1
	this2.maxRange:=this2.page*50
	this2.pageCount.text:=format("{:03d}",this2.page)
	this2.vaultProgress.opt("range1-" this2.maxRange)
	this2.vaultProgress.value:=0
	sleep(800)

	while this2.page>0 {
		loop setting.rowCount {
			this2.row:=setting.rowCount-a_index
			loop setting.columnCount {
				this2.vaultProgress.value+=1		  
				this2.col:=setting.columnCount-a_index
				this2.itemNum+=1
				dismantle(this2.col,this2.row)				
			}
			mouseMove(905,170)
			sleep(500)
			send("{LButton Down}")
			sleep(350)
			send("{LButton Up}")

			this2.page-=1
			this2.pageCount.text:=format("{:03d}",this2.page)
			sleep(600)
		}
		this2.completeMsg.text:="Operation Complete"
	}
}

dismantle(thisCol,thisRow) {
	x:=tile(thisCol,thisRow).x
	y:=tile(thisCol,thisRow).y
	
	this2.isLocked:=false
	this2.isExotic:=false
	this2.timeoutCounter:=0
	while !winActive(this2.gameWin) && ((this2.timeoutCounter:=a_index) < 20)
		sleep(1000)
		
	if this2.timeoutCounter >= 20 {
		msgBox('Game window out-of-focus too long.`nStopping Vault Clean Process')
		exit
	}
	
	mouseMove(x,y)
	sleep(50)
	send("{f down}")
	sleep(150)
	loop 10 {
		this2.tileColor:=pixelGetColor((thisCol<6) ? x-(setting.tileSize/2) : x+(setting.tileSize/2),y)
		if !(substr(this2.tileColor,3,1)==substr(this2.tileColor,5,1) && substr(this2.tileColor,3,1)==substr(this2.tileColor,7,1)) {
			this2.isLocked:=true
			break
		}
	}
		
	if !this2.isLocked {
		sleep(2000)
		loop 10 {
			this2.tileColor:=pixelGetColor((thisCol<6) ? x-(setting.tileSize/2) : x+(setting.tileSize/2),y)
			if !(substr(this2.tileColor,3,1)==substr(this2.tileColor,5,1) && substr(this2.tileColor,3,1)==substr(this2.tileColor,7,1)) {
				this2.isExotic:=true
				break
			}
		}
		if this2.isExotic
			sleep(3000)
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
	this2.elapsedSec+=1
	this2.remainingItems:=this2.maxRange-this2.itemNum
	this2.currSpeed:=this2.elapsedSec/this2.itemNum
	this2.remainingSec:=this2.remainingItems*this2.currSpeed
	this2.elapsedTime.text := timeFormat(this2.elapsedSec)
	this2.elapsedTime.redraw()
	this2.remainingTime.text:= timeFormat(this2.remainingSec)
	this2.remainingTime.redraw()
}

tile(colNum,rowNum) {
	tile := object()
	tile.x := (setting.xMargin)+(setting.tileSize*colNum)+(setting.tileSize/2)
	tile.y := (setting.yMargin)+(setting.tileSize*rowNum)+(setting.tileSize/2)
	return tile
}





hotIf(isVault)
+\:: {
	cleanVaultStart()
}

~Esc:: {
	try {
		this2.restartQueued:=true
		vault_exitFunc()
	}
}

F5:: {
	libVaultInit()
	vaultCleaner()
}
hotIf()

isVault(*) {
	if winActive(ui.vaultBottomGui) && ui.vaultCleanerOpen
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
		winSetStyle("-0xC00000",this2.GameWin)
	try
		winMove(0,0,a_screenWidth,a_screenHeight,this2.gameWin)
	sleep(2000)
	this2.restartQueued:=false

}
hotIf()