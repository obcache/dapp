#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) { ;run main app
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}


ui.mapBrowserVisible:=false
toggleMapBrowser(this_Ctrl,*) {
	(ui.mapBrowserVisible:=!ui.mapBrowserVisible)
		? showMapBrowser(this_Ctrl)
		: closeMapBrowser(this_Ctrl)
		
	closeMapBrowser(*) {
		this_Ctrl:=ui.mapButton
		ui.mapBrowserVisible:=false
		ui.mapGui.destroy()

		ui.button_link_%strSplit(this_Ctrl.name,"_")[3]%.bg.opt("background" cfg.auxColor1)
		ui.button_link_%strSplit(this_Ctrl.name,"_")[3]%.bg.redraw()
	}
	
	showMapBrowser(this_Ctrl,*) {
		ui.mapButton:=this_Ctrl
		ui.button_link_%strSplit(this_Ctrl.name,"_")[3]%.bg.opt("background" cfg.alertColor)
		ui.button_link_%strSplit(this_Ctrl.name,"_")[3]%.bg.redraw()
		ui.last_map:=""
		ui.this_map:=""
		ui.resourceMap:=map()
		ui.mapArr:=array()
		try
			ui.mapGui.destroy()
			
		ui.mapGui:=gui()
		ui.mapGui.opt("toolWindow -border -caption alwaysOnTop owner" ui.mainGui.hwnd)
		ui.mapGui.backColor:=cfg.TabColor2
		ui.mapGui.color:="010203"
		winSetTransColor("010203",ui.mapGui)
		
		
		
		
		ui.mapGuiTitleBg:=ui.mapGui.addText("x0 y0 w600 h30 background" cfg.TabColor1)
		ui.mapGuiTitleBg.onEvent("click",WM_LButtonDown_Callback)
		ui.mapGuiTitleText:=ui.mapGui.addText("x5 y2 w595 h31 backgroundTrans","Resource Browser")
		ui.mapGuiTitleText.setFont("s16 Bold c" cfg.fontColor1,"move-x")
		ui.mapGuiName:=ui.mapGui.addDDL("x630 y2 w400 center background" cfg.tabColor1)
		ui.mapGuiName.setFont("s13 c" cfg.fontColor1,"move-x")
		ui.mapGuiName.onEvent("change",mapChanged)
		mapChanged(*) {
			ui.selectedMap:=ui.mapGuiName.text
			refreshMaps()
		}
		;OD_Colors.attach(hMapNameDDL, {T: 0x000080, B: 0x656565, 4: {T: 0xFFFFFF, B: 0xFF0000}, 6: {T: 0x858585, B: 0xFF0000}})
		ui.mapGuiMoveLeftBg:=ui.mapGui.addText("x600 y0 w30 h30 background" cfg.tabColor1)
		ui.mapGuiMoveLeft:=ui.mapGui.addText("x600 y-1 w26 h30 backgroundTrans c" cfg.fontColor1,"Û")
		ui.mapGuiMoveLeft.setFont("s23","Wingdings")
		ui.mapGuiMoveRightBg:=ui.mapGui.addText("x1030 y0 w28 h30 background" cfg.tabColor1)
		ui.mapGuiMoveRight:=ui.mapGui.addText("x1032 y-1 w30 h30 backgroundTrans c" cfg.fontColor1,"Ü")
		ui.mapGuiMoveLeft.onEvent("click",mapDown)
		ui.mapGuiTitleSpacer:=ui.mapGui.addText("x1058 y0 w132 h30 background" cfg.tabColor1)
		ui.mapGuiTitleSpacer.onEvent("click",WM_LButtonDown_Callback)
		ui.mapNum:=0
		mapDown(*) {
			loop ui.mapArr.length {
				if ui.mapArr[a_index] == ui.selectedMap {
					ui.mapNum:=a_index
					if ui.mapNum > 1
						ui.mapNum-=1
					else
						ui.mapNum:=ui.mapArr.length
						
					ui.selectedMap:=ui.mapArr[ui.mapNum]
					ui.mapGuiName.choose(ui.mapNum)
					refreshMaps()
					break
				}
			}
		}
		mapUp(*) {
			loop ui.mapArr.length {
				if ui.mapArr[a_index] == ui.selectedMap {
					ui.mapNum:=a_index
					if ui.mapNum <= ui.mapArr.length-1
						ui.mapNum+=1
					else
						ui.mapNum:=1
					ui.selectedMap:=ui.mapArr[ui.mapNum]
					ui.mapGuiName.choose(ui.mapNum)
					refreshMaps()
					break
				}
			}
		}
		ui.mapGuiMoveRight.onEvent("click",mapUp)
		ui.mapGuiMoveRight.setFont("s23","Wingdings")
		ui.mapGuiClose:=ui.mapGui.AddText("x1190 y2 w30 h30 center BackgroundTrans","r")
		
	
		ui.mapGuiClose.setFont("s18 c" cfg.FontColor2,"Webdings")
		ui.mapGuiClose.onEvent("click",closeMapBrowser)

		loop files, "./img/maps/*.*" {
			ui.this_map:=strSplit(a_loopFilename,"_")[1]
			ui.this_resource:=strSplit(strSplit(a_loopFilename,"_")[2],".")[1]
			if ui.this_map != ui.last_map {
				ui.mapArr.push(ui.this_map)
			}
			ui.resourceMap.set(ui.this_map,ui.this_resource)
			ui.last_map:=ui.this_map
		}
		ui.selectedMap:=ui.mapArr[1]
		ui.mapGuiName.add(ui.mapArr)
		ui.mapGuiName.choose(ui.selectedMap)
		ui.thumbCount:=0
	
	refreshMaps(*) {
		
		try
			ui.resThumbsGui.destroy()
			
		ui.resThumbsGui:=gui()
		ui.resThumbsGui.opt("-caption -border toolWindow alwaysOnTop owner" ui.mapGui.hwnd)
		ui.resThumbsGui.backColor:=cfg.tabColor2
		ui.resThumbsGui.color:=ui.transparentColor
		winSetTransColor(ui.transparentColor,ui.resThumbsGui)

			colNum:=0
			currX:=5
			currY:=5
			loop files, "./img/maps/*.*" {
			
				if strSplit(a_loopFilename,"_").length < 3
					continue
				ui.this_map:=strSplit(a_loopFilename,"_")[1]
				ui.this_resource:=strSplit(strSplit(a_loopFilename,"_")[2],".")[1]
				if (ui.selectedMap == ui.this_map) {
					colNum+=1
					if colNum > 3 {
						colNum:=0
						currX:=5
						currY+=208
					}
				
				ui.mapThumb%a_index%:=ui.resThumbsGui.addPicture(" x" currX " y" currY " w400 h196 backgroundTrans","./img/maps/" a_loopFilename)
				ui.mapThumb%a_index%.onEvent("click",showMap)
				activityLabelBg:=ui.resThumbsGui.addText("center x" currX " y" currY+0 " w400 h25 background" cfg.TabColor1)
				activityLabel:=ui.resThumbsGui.addText("left x" currX+10 " y" currY+4 " w290 h25 backgroundTrans",strSplit(a_loopFilename,"_")[1])
				encounterIndexLabel:=ui.resThumbsGui.addText("right x" currX+200 " y" currY+4 " w190 h21 background" cfg.TabColor1,subStr(strSplit(strSplit(a_loopFilename,"_")[2],".")[1],4))
				ui.resThumbsGui.addPicture("x" currX " y" currY " w400 h25 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
				encounterNameLabelBg:=ui.resThumbsGui.addText("center x" currX " y" currY+176 " w400 h24 background" cfg.TabColor1)
				encounterNameLabel:=ui.resThumbsGui.addText("center x" currX " y" currY+176 " w400 h24 backgroundTrans",strSplit(strSplit(a_loopFilename,"_")[3],".")[1])
				ui.resThumbsGui.addPicture("x" currX " y" currY+176 " w400 h24 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
				activityLabel.setFont("c" cfg.auxColor1 " s12 q5","move-x")
				encounterIndexLabel.setFont("c" cfg.auxColor1 " s12 q5","move-x")
				encounterNameLabel.setFont("c" cfg.fontColor3 " s15 bold q5","move-x")
				;drawOutlineNamed("mapThumb" a_index,ui.resThumbsGui,currX, currY,400,196,cfg.TrimColor1,cfg.outlineColor2,1)
				currX+=405
				}
			}
					
					winGetPos(&tmpX,&tmpY,&tmpW,&tmpH,ui.mapGui.hwnd)
					ui.resThumbsGui.show("x" tmpX " y" tmpY+30 " w1220")
		ui.mapGuiMoveLeft.focus()
		}
		winGetPos(&mbX,&mbY,&mbW,&mbH,ui.mapGui)

		ui.mainGui.getPos(&tmpX,&tmpY)
		ui.infoGfxMon:=object()
		loop monitorGetCount() {
			monitorGetWorkArea(a_index,&l,&t,&r,&b)
			if (tmpX >= l && tmpX <=r) && (tmpY >= t && tmpY <= b) {
				ui.infoGfxMon.l:=l
				ui.infoGfxMon.t:=t 
				ui.infoGfxMon.r:=r
				ui.infoGfxMon.b:=b
			}
		}
		;msgBox(ui.infoGfxMon.l "`t" ui.infoGfxMon.t "`t" ui.infoGfxMon.r "`t" ui.infoGfxMon.b)
	  
		ui.mapGui.show("x" (ui.infoGfxMon.l+((ui.infoGfxMon.r-ui.infoGfxMon.l)/2)-610) " w1220")
		ui.mapGui.getPos(&tmpX,&tmpY,&tmpW,&tmpH)
		ui.mapGui.show("x" (ui.infoGfxMon.l+((ui.infoGfxMon.r-ui.infoGfxMon.l)/2)-610) " y" (ui.infoGfxMon.t+((ui.infoGfxMon.b-ui.infoGfxMon.t)/2))-(tmpH/2))
		winGetPos(&tX,&tY,&tW,&tH,ui.mapGui)
		drawOutlineNamed("mapOutline",ui.mapGui,0,0,tW,tH,cfg.TrimColor2,cfg.TrimColor2,1)
		refreshMaps()
		

	}

	showMap(this_control,*) {
		showMapGui := gui() 
		showMapGui.opt("-caption toolWindow alwaysOnTop owner" ui.mapGui.hwnd)
		showMapGui.backColor:="010203"
		winSetTransColor("010203",showMapGui)
		fullMap:=showMapGui.addPicture("x0 y2 w1600 h-1 backgroundTrans",this_control.value)
		fullMap.onEvent("doubleClick",closeMap)
		fullMap.onEvent("click",dragMap)
		fullMap.getPos(,,,&mH)
		showMapGui.show("x" ui.infoGfxMon.l+((ui.infoGfxMon.r-ui.infoGfxMon.l)/2)-800  " w1600 h" mH)
		winGetPos(&tmpX,&tmpY,&tmpW,&tmpH,showMapGui)
		showMapGui.show("y" ui.infoGfxMon.t+((ui.infoGfxMon.b-ui.infoGfxMon.t)/2)-(tmpH/2))
		
		dragMap(*) {
			mouseGetPos(&startingMouseX,&startingMouseY)
			postMessage("0xA1",2,,,"A")
			while getKeyState("LButton")
				mouseGetPos(&mouseX,&mouseY)
				
			showMapGui.show("y" ui.infoGfxMon.t+((ui.infoGfxMon.b-ui.infoGfxMon.t)/2)-(tmpH/2))
		}
		closeMap(*) {
			try 
				showMapGui.destroy()
		}
	}
	
	hideMapBrowser(*) {
		try
			mapGui.destroy()
	}

}
