#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}


if cfg.pushNotificationsEnabled:=iniRead(cfg.file,"Interface","PushNotificationsEnabled",false)
	setTimer(incursionNotice,15000)
	

toggleIncursionNotice(*) {
	cfg.pushNotificationsEnabled := !cfg.pushNotificationsEnabled
	if cfg.pushNotificationsEnabled == 0 {
		setTimer(incursionNotice,0)
		ui.incursionOptOut.value := "./img/checkbox_true.png"
		ui.togglePushNotifications.value := cfg.toggleOff
		ui.togglePushNotifications.opt("background" cfg.OffColor)
	} else {
		setTimer(incursionNotice,15000)
		ui.incursionOptOut.value := "./img/checkbox_false.png"
		ui.togglePushNotifications.value := cfg.toggleOn
		ui.togglePushNotifications.opt("background" cfg.OnColor)
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
try {	
	(!cfg.pushNotificationsEnabled)
		? bail()
		: 0
	cfg.lastIncursion := iniRead(cfg.file,"Game","LastIncursion","000000000000")	
	ui.latestIncursion := 0
	req := ComObject("Msxml2.XMLHTTP")
	req.open("GET", "https://t.me/s/isavexincursionhappening?after=0", true)
	req.onreadystatechange := Ready
	req.send()
	persistent()

	Ready() {
		if (req.readyState != 4) 
			return
		if (req.status == 200) {
			loop parse, strReplace(StrReplace(req.responseText, "&#33;", "¢"),"isavexincursionhappening/","¢") ,"¢" {
					lastField:=a_loopField
			}
	
			lastFieldTime:=strSplit(strReplace(lastField,"dateTime","¢"),"¢")[2]
			lastTime:=strSplit(subStr(lastFieldTime,3),'"')[1]

			ui.latestIncursion:=strReplace(substr(lastTime,1,10),"-","") strReplace(substr(lastTime,12,8),":","")	
			;msgBox(ui.latestIncursion)

			if (ui.latestIncursion != cfg.lastIncursion) {
				if formatTime(a_NowUTC,"yyyyMMddHHmmss")-ui.latestIncursion>300
					return
				
				if ui.d2ShowingIncursionNotice == true
					closeIncursionNotice()

				ui.incursionGui := gui()
				ui.incursionNoticeHwnd := ui.incursionGui.hwnd
				ui.incursionGui.opt("-caption -border toolWindow alwaysOnTop owner" ui.mainGui.hwnd)
				ui.incursionGui.backColor := "010203"
				ui.incursionGuiBg := ui.incursionGui.addText("x3 y3 w344 h44 background" cfg.LabelColor1)
				ui.incursionGuiBg2 := ui.incursionGui.addText("x5 y5 w340 h40 background" cfg.titleBgColor)
				drawOutlineNamed("notice",ui.incursionGui,1,1,348,48,cfg.TrimColor2,cfg.titleFontColor,2)			
				drawPanelLabel(ui.incursionGui,224,0,100,20,"Destiny2 Event",cfg.LabelColor1,cfg.titleFontColor,cfg.titleBgColor)
				ui.incursionNotice := ui.incursionGui.addText("x10 y5 w339 h70 backgroundTrans c" cfg.LabelColor1,"Vex Incursion!")
				ui.incursionGui.setFont("q5 s9 c" cfg.LabelColor1,"Cascadia Code")
				ui.incursionTime := ui.incursionGui.addText("x15 y27 w260 h16 backgroundTrans"," Timestamp:" formatTime("T12"," MM/dd hh:mm:ss "))
				ui.incursionClose := ui.incursionGui.addPicture("x330 y0 w20 h20 background" cfg.AlertColor,"./img/button_quit.png")
				drawOutlineNamed("incursionClose",ui.incursionGui,329,-2,21,22,cfg.titleFontColor,cfg.titleFontColor,1)
				ui.incursionGui.setFont("q5 s12","Arial")
				ui.incursionOptOut := ui.incursionGui.addPicture("x224 y27 w13 h13 section backgroundTrans c" cfg.LabelColor1,"./img/checkbox_false.png")
					
				if cfg.pushNotificationsEnabled	== true {
					ui.incursionOptOut.value := "./img/checkbox_false.png"
				} else {
					ui.incursionOptOut.value := "./img/checkbox_true.png"
				}
						
				ui.incursionOptOutLabel := ui.incursionGui.addText("x+6 ys-1 w359 backgroundTrans c" cfg.LabelColor1,"Dont Show Again")
				ui.incursionOptOutLabel.setFont("q5 s9","Arial")
				ui.incursionClose.onEvent("click", closeIncursionNotice)
				ui.incursionOptOut.onEvent("click",toggleIncursionNotice)
				ui.incursionNotice.setFont("q5 s19 c" cfg.LabelColor1,"Courier")


				
				try {
					incursionX := (a_screenWidth/2)-175
					transLevel := 0
					if winExist("ahk_exe destiny2.exe") {
						if winGetMinMax("ahk_exe destiny2.exe") > 0 {
							if monitorGetCount() != 1 {
								(monitorGetPrimary() == 1) 
									? incursionNoticeMonitor := 2
									: incursionNoticeMonitor := 1
								monitorGet(incursionNoticeMonitor,&l,&t,&r,&b)
								incursionX := ((r+l)/2)-175
							}
						}
					} else {
						incursionNoticeMonitor:=1
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
}
}

d2FlashIncursionNoticeA(*) {
	ui.incursionGuiBg.opt("background" cfg.AuxColor1)
	ui.incursionGuiBg.redraw()
	}

d2FlashIncursionNoticeB(*) {
	ui.incursionGuiBg.opt("background" cfg.LabelColor1)
	ui.incursionGuiBg.redraw()
}
