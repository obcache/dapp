#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}
this.gameWin:="ahk_exe " setting.gameExe
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

	this.page:=0
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
			vaultGui.destroy()
		
		vaultGui := gui()
		vaultGui := gui()
		
		vaultGui.backColor:=setting.transColor
		vaultGui.setFont("s10 c000000","Calibri")
		vaultGui.opt("-border")	
		vaultGui.backColor:=setting.transColor
		vaultGui.setFont("s10 c000000","Calibri")
		;vaultGui.opt("-border owner" winGetID("ahk_exe destiny2.exe"))	
	

		;winSetTransColor(setting.transColor,vaultGui.hwnd)
		;help:=vaultGui.addText("section x5 y5 w650 h40 backgroundTrans c00FFFF",
		titleBarBg:=vaultGui.addText("x0 y0 w1254 h34 background454545")
		titleBarBg.onEvent("click",WM_LBUTTONDOWN_callback)
		titleBarText:=vaultGui.addText("x10 y-2 w500 h32 backgroundTrans c212121","VaultCleaner for Destiny2 (v1.2)" )
		titleBarText.setFont("s20 bold cbbbbbb","calibri")
		closeButton:=vaultGui.addText("x1250 y0 w30 h32 cBBBBBB background454545","T")
		closeButton.setFont("s24","WingDings 2")
		closeButton.onEvent("click",closeProgram)
		closeProgram(*) {
			exitApp
		}
		footerBarBg:=vaultGui.addText("x0 y" this.yOffset " w1284 h100 background454545")
		vaultGui.addText("x0 y30 w1284 h2 background959595")
		vaultGui.addText("x0 y" this.YOffset " w1284 h2 background959595")
		onMessage(0x47,this_WINDOWPOSCHANGED)
		this_WINDOWPOSCHANGED(*) {
			try {
				winGetPos(&tX,&tY,,,vaultGui.hwnd)
				winSetAlwaysOnTop(1,this.gameWin)
				winMove(tx+3,ty+35,,,this.gameWin)
				winSetAlwaysOnTop(0,this.gameWin)
				;winMove(tx,ty,,,vaultGui.hwnd)
			}		
		}
		; this_LBUTTONDOWN_callback(this_control*) {
			; postMessage("0xA1",2,,,this_control)
		; }
		this.statusText:=vaultGui.addText("x10 y" 38+this.yOffset " w640 h30 backgroundTrans c00FFFF","Please Wait....")
		this.statusText.setFont("s16")
		this.mainButtonBg:=vaultGui.addText("x5 y" 5+this.yOffset " w80 h30 background353535")
		this.mainButton:=vaultGui.addText("section center x7 y" 7+this.yOffset " w76 h26 background454545 c00FFFF","")
		this.mainButtonText:=vaultGui.addText("section center x7 y" 2+this.yOffset " w76 h30 backgroundTrans c353535","Start")
		this.mainButtonText.setFont("s20")
		this.mainButtonHotkey:=vaultGui.addText("left ys backgroundTrans c454545 h30 w130","[ Shift ]+[ \ ]")
		this.mainButtonHotkey.setFont("s20")
		this.mainButton.onEvent("click",cleanVaultStart)
		this.mainButtonText.onEvent("click",cleanVaultStart)
		;this.mainButton.onEvent("click",toggleButton)
		toggleButton(*) {
			(this.state:=!this.state)
				? cleanVaultStart()
				: vault_exitFunc()
		}
		;help2:=vaultGui.addText("xs+0 w600 h60 y+0 backgroundTrans c00FFFF","")
		vaultGui.setFont("s12")
		drawOutlineNamed("vaultStats",vaultGui,998,this.yOffset+8,270,55,"c00FFFF","c00FFFF",1)
		this.pageLabel:=vaultGui.addText("right x1000 y" 10+this.yOffset " w80 h25 backgroundTrans c00FFFF","Page: ")
		this.pageCount:=vaultGui.addText("x1080 y" 10+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}",this.page))
		;this.statusUnderline:=vaultGui.addText("x1000 y" 8+this.yOffset " w270 center h1 c00FFFF background00FFFF")
		this.statusHeaderLabel:=vaultGui.addText("x1000 y" this.yOffset " w140 left h25 c00FFFF backgroundTrans","")
		this.elapsed:=vaultGui.addText("x1000 y" 25+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Elapsed: ")
		this.elapsedTime:=vaultGui.addText("x1080 y" 25+this.yOffset " left w80 h25 c00FFFF backgroundTrans","00:00:00")
		this.remaining:=vaultGui.addText("x1000 y" 40+this.yOffset " right w80 h25 c00FFFF backgroundTrans","Remaining: ")
		this.remainingtime:=vaultGui.addText("x1080 y" 40+this.yOffset " left w80 h25 c00FFFF backgroundTrans","00:00:00")
		
		
		;this.dismantledUnderline:=vaultGui.addText("x1160 y" 18+this.yOffset " w110 center h1 c00FFFF background00FFFF")
		this.dismantledHeaderLabel:=vaultGui.addText("x1160 y" this.yOffset " w110 right h25 c00FFFF backgroundTrans","")
		this.dismantledLegendaryLabel:=vaultGui.addText("x1160 y" 10+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Legendary: ")
		this.dismantledLegendary:=vaultGui.addText("x1240 y" 10+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))
		this.dismantledExoticLabel:=vaultGui.addText("x1160 y" 25+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Exotic: ")
		this.dismantledExotics:=vaultGui.addText("x1240 y" 25+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))
		this.dismantledTotalLabel:=vaultGui.addText("x1160 y" 40+this.yOffset " w80 right h25 c00FFFF backgroundTrans","Total: ")
		this.dismantledTotal:=vaultGui.addText("x1240 y" 40+this.yOffset " left w80 h25 c00FFFF backgroundTrans",format("{:03d}","000"))
		


		this.remainHour:=""
		this.remainMin:=""
		this.remainSec:=""
		this.elapsedHour:=""
		this.elapsedMin:=""
		this.elapsedSeconds:=""

		this.vaultProgressLabelBg:=vaultGui.addText("x0 y" 70+this.yOffset " w100 h30 background505060 c151515","")
		this.vaultProgressLabel:=vaultGui.addText("x5 y" 70+this.yOffset " w85 h30 backgroundTrans c302535","Progress")
		this.vaultProgressLabel.setFont("s18","Mode-X")
		this.vaultProgress := vaultGui.addProgress("x90 y" 70+this.yOffset " w1289 h30 c440000 background151515 range1-500")
		this.completeMsg := vaultGui.addText("x30 y67 w500 h30 backgroundTrans c00FFFF","")
		
		
		

		
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
			sleep(2000)
			vaultGui.show("x" this.gameWinX+2 " y" this.gameWinY-28 " w1280 h" 30+720+94 " noActivate")
		;vaultGui.show("x" this.gameWinX+2 " y" this.gameWinY-28 " w1280 h" 30+720+94 " noActivate")
			;winSetAlwaysOnTop(true,this.gameWin)
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
			this2.mainButtonHotkey.setFont("c00FFFF")
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
	winActivate(this.gameWin)
	this.statusText.text:="[Esc] to Stop/Exit"
	this2.statusText.text:="[Esc] to Stop/Exit"
	setTimer(timer,1000)
	timer()
	coordMode("mouse","client")
	this.mainButtonHotkey.text:="[Esc]" 	
	this.mainButton.opt("backgroundbb2211 c252525")
	this.mainButtonText.text:="Stop"
	this2.mainButtonHotkey.text:="[Esc]" 	
	this2.mainButton.opt("backgroundbb2211 c252525")
	this2.mainButtonText.text:="Stop"

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
			this2.pageCount.text:=format("{:03d}",this.page)
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
	this2.pageCount.text:=format("{:03d}",this.page)
	this.maxRange:=this.page*50
	this.vaultProgress.opt("range1-" this.maxRange)
	this.vaultProgress.value:=0
	this2.vaultProgress.opt("range1-" this.maxRange)
	this2.vaultProgress.value:=0
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
		;sleep(500)
		mouseMove(905,170)
		sleep(500)
		send("{LButton Down}")
		sleep(350)
		send("{LButton Up}")
		this.page-=1
		
		this.pageCount.text:=format("{:03d}",this.page)
		this2.pageCount.text:=format("{:03d}",this.page)
		sleep(600)
	}
	this.completeMsg.text:="Operation Complete"
	this2.completeMsg.text:="Operation Complete"
	}
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
	;sleep(20)
	result.locked:=false
	; loop 10 {
				; this.color:=pixelGetColor(x+(setting.tileSize/2)-(thisCol-7),y)
				; if subStr(this.color,3,1) != subStr(this.color,5,1) {
					; result.locked:=true
					; break
				; }
			; }
		
	switch { 
		case thisCol > 5: ;10-7=3 9-7=2 8-7=1 7-7=0 6-7=- 5-3=2 4-1=3 3+1=4 2+3=5 1+5=6
				loop 5 {
					this.color:=pixelGetColor(round(x+(setting.tileSize/2)-2),y)
					if subStr(this.color,3,1) != subStr(this.color,5,1) {
						result.locked:=true
						break
					}
				}		
		case thisCol > 4 && thisCol <6: ;10-7=3 9-7=2 8-7=1 7-7=0 6-7=- 5-3=2 4-1=3 3+1=4 2+3=5 1+5=6
			loop 5 {
				this.color:=pixelGetColor(round(x+(setting.tileSize/2)-4),y)
				if subStr(this.color,3,1) != subStr(this.color,5,1) {
					result.locked:=true
					break
				}
			}
		
		; case (thisCol >= 4) && (thiscol <= 7): ;6-5=1
			; loop 5 {
				; this.color:=pixelGetColor(x+(setting.tileSize/2)-(thisCol+1,y)
				; if subStr(this.color,3,1) != subStr(this.color,5,1) {
					; result.locked:=true
					; break
				; }
			; }

		case thisCol < 5: ;1+3=4
			loop 10 {
				this.color:=pixelGetColor(round(x-(setting.tileSize/2)+1),y)
				if subStr(this.color,3,1) != subStr(this.color,5,1) {
					result.locked:=true
					break
				}
			}
		}

	sleep(150)
	if !result.locked {
		sendEvent("{f down}")
		sleep(1500)
		if this.restartQueued {
			exit()
		}
		loop 20 {
			if -(!pixelSearch(&returnX,&returnY,(thisCol>=5) ? x+50 : x-150,300,100,720,"0xFFFFFF",50)) {
				this.exotic:=true
				sleep(2000)
				break
			}
			sleep(10)
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





hotIf(isVault)
+\:: {
	cleanVaultStart()
}

~Esc:: {
	try {
		this.restartQueued:=true
		vault_exitFunc()
	}
}

F5:: {
	libVaultInit()
	vaultCleaner()
}
hotIf()

isVault(*) {
	if winActive(ui.vaultGui) && ui.vaultCleanerOpen
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
		vaultGui.hide()
	try
		winSetStyle("-0xC00000",this.GameWin)
	try
		winMove(0,0,a_screenWidth,a_screenHeight,this.gameWin)
	sleep(2000)
	this.restartQueued:=false

}
hotIf()