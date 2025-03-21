#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

if cfg.pushNotificationsEnabled:=iniRead(cfg.file,"Toggles","PushNotificationsEnabled",false)
	setTimer(incursionNotice,15000)
	

toggleIncursionNotice(*) {
	cfg.pushNotificationsEnabled := !cfg.pushNotificationsEnabled
	if cfg.pushNotificationsEnabled == 0 {
		setTimer(incursionNotice,0)
		ui.incursionOptOut.value := "./img/checkbox_true.png"
		ui.togglePushNotifications.value := cfg.toggleOff
		ui.togglePushNotifications.opt("background" cfg.trimColor2)
	} else {
		setTimer(incursionNotice,15000)
		ui.incursionOptOut.value := "./img/checkbox_false.png"
		ui.togglePushNotifications.value := cfg.toggleOn
		ui.togglePushNotifications.opt("background" cfg.trimColor3)
	}
}

closeIncursionNotice(*) {
	ui.d2FlashingIncursionNotice := false
	ui.d2ShowingIncursionNotice := false
	setTimer(d2FlashIncursionNoticeA,0)
	setTimer(d2FlashIncursionNoticeB,0)

	ui.incursionGui.hide()
	ui.incursionGui.destroy()
}

incursionNotice(this_trigger := "") {
	(cfg.pushNotificationsEnabled)
		? bail()
		: 0
	cfg.lastIncursion := iniRead(cfg.file,"Game","LastIncursion","000000000000")	
	ui.latestIncursion := cfg.lastIncursion
	
	try {
		whr := ComObject("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET","http://sorryneedboost.com/cacheApp/recentIncursion.dat", true)
		whr.Send()
		whr.WaitForResponse()
		ui.latestIncursion := whr.ResponseText
	}
	
	if ((ui.latestIncursion != cfg.lastIncursion) && cfg.pushNotificationsEnabled) || (ui.incursionDebug == true) || (this_trigger == "manualFire") {
		if ui.d2ShowingIncursionNotice == true
			closeIncursionNotice()

		ui.incursionGui := gui()
		ui.incursionNoticeHwnd := ui.incursionGui.hwnd
		ui.incursionGui.opt("-caption -border toolWindow alwaysOnTop owner" ui.mainGui.hwnd)
		ui.incursionGui.backColor := "010203"
		ui.incursionGuiBg := ui.incursionGui.addText("x3 y3 w344 h44 background" cfg.fontColor3)
		ui.incursionGuiBg2 := ui.incursionGui.addText("x5 y5 w340 h40 background" cfg.trimColor1)
		drawOutlineNamed("notice",ui.incursionGui,1,1,348,48,cfg.accentColor2,cfg.accentColor4,2)			
		drawPanelLabel(ui.incursionGui,224,0,100,20,"Destiny2 Event",cfg.fontColor3,cfg.accentColor4,cfg.trimColor1)
		ui.incursionNotice := ui.incursionGui.addText("x10 y5 w339 h70 backgroundTrans c" cfg.fontColor3,"Vex Incursion!")
		ui.incursionGui.setFont("q5 s9 c" cfg.fontColor3,"Cascadia Code")
		ui.incursionTime := ui.incursionGui.addText("x15 y27 w260 h16 backgroundTrans"," Timestamp:" formatTime("T12"," MM/dd hh:mm:ss "))
		ui.incursionClose := ui.incursionGui.addPicture("x330 y0 w20 h20 background" cfg.trimColor4,"./img/button_quit.png")
		drawOutlineNamed("incursionClose",ui.incursionGui,329,-2,21,22,cfg.accentColor4,cfg.accentColor4,1)
		ui.incursionGui.setFont("q5 s12","Arial")
		ui.incursionOptOut := ui.incursionGui.addPicture("x224 y27 w13 h13 section backgroundTrans c" cfg.fontColor3,)
			
		if cfg.pushNotificationsEnabled	== true {
			ui.incursionOptOut.value := "./img/checkbox_false.png"
		} else {
			ui.incursionOptOut.value := "./img/checkbox_true.png"
		}
				
		ui.incursionOptOutLabel := ui.incursionGui.addText("x+6 ys-1 w359 backgroundTrans c" cfg.fontColor3,"Dont Show Again")
		ui.incursionOptOutLabel.setFont("q5 s9","Arial")
		ui.incursionClose.onEvent("click", closeIncursionNotice)
		ui.incursionOptOut.onEvent("click",toggleIncursionNotice)
		ui.incursionNotice.setFont("q5 s19 c" cfg.fontColor3,"Courier")


		
		try {
			if cfg.topDockEnabled {
			
				cfg.dockbarMonitor := iniRead(cfg.file,"Interface","DockbarMonitor",monitorGetPrimary())
				if monitorGetCount() < cfg.dockbarMonitor {
					cfg.dockbarMonitor := 1
				}
				monitorGet(cfg.dockbarMonitor,&dockbarMonitorL,&dockbarMonitorT,&dockbarMonitorR,&dockbarMonitorB,)
				incursionGuix := ((dockbarMonitorL + dockbarMonitorR)/2)-175
				dockbarPosY := dockbarMonitorT
				if cfg.animationsEnabled {
					ui.incursionGui.show("x" incursionGuix " y" dockbarPosY+31 " w350 h0 noActivate")
					posH := 0
					while posH < 60 {
						posH += 10
						ui.incursionGui.move(incursionGuix,dockbarPosY+31,,posH)
						sleep(1)
					}
				}
				ui.incursionGui.show("x" incursionGuix " y" dockbarPosY+31 " w352 h51 noActivate")
				ui.d2ShowingIncursionNotice := true
			} else {
				incursionX := (a_screenWidth/2)-175
				transLevel := 0
				if winGetMinMax("ahk_exe destiny2.exe") > 0 {
					if monitorGetCount() != 1 {
						(monitorGetPrimary() == 1) 
							? incursionNoticeMonitor := 2
							: incursionNoticeMonitor := 1
							monitorGet(incursionNoticeMonitor,&l,&t,&r,&b)
							incursionX := ((r+l)/2)-175
					}
				}
				
				if cfg.animationsEnabled {
					guiVis(ui.incursionGui,false)
					ui.incursionGui.show("x" incursionX " y150 w350 h51 noActivate")
					while transLevel < 255 {
						transLevel += 5
						winSetTransparent(transLevel,ui.incursionGui)
						sleep(1)
					}
				}		
				ui.incursionGui.show("y150 w352 h51 noActivate")
				ui.d2ShowingIncursionNotice := true
			}
			winSetTransColor("010203",ui.incursionGui)
			soundPlay("./redist/incursionAudio.mp3")
			ui.d2FlashIncursionNoticeActive := true
			setTimer(d2FlashIncursionNoticeA,2000)
			sleep(1000)
			setTimer(d2FlashIncursionNoticeB,2000)
			cfg.lastIncursion := ui.latestIncursion
			iniWrite(cfg.lastIncursion,cfg.file,"Game","LastIncursion")
		}
	}
}

d2FlashIncursionNoticeA(*) {
	ui.incursionGuiBg.opt("background" cfg.trimColor5)
	ui.incursionGuiBg.redraw()
	}

d2FlashIncursionNoticeB(*) {
	ui.incursionGuiBg.opt("background" cfg.fontColor3)
	ui.incursionGuiBg.redraw()
}
