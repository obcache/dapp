#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) { ;run main app
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}


tabProperties := {
	tabNames: ["Game","Setup"],
	tabX: 200,
	tabY: 200,
	tabW: 600,
	tabH: 400,
	tabGui,
	
	}



tabCreate(tabProperties) {
	}

drawInfographic(infographicName:="vod",imageWidth := 150,imageHeight := 150, numColumns := 5) {
	imageTypes := "png,jpg,gif,bmp"
	infographicFolder := "./img/infogfx"
	transparentColor := "030405"

	if (cfg.topDockEnabled) {
		infoGuiMon := cfg.dockbarMon
	} else { 
		winGetPos(&infoGuiX,&infoGuiY,,,ui.mainGui)
		infoGuiMon := 1
		loop monitorGetCount() {
			monitorGet(a_index,&monLeft,,&monRight,)
			if infoGuiX > monLeft && infoGuiX < monRight {
				infoGuiMon := a_index
				break
			}
		}
	}

	monitorGet(infoGuiMon,&infoGuiMonL,&infoGuiMonT,&infoGuiMonR,&infoGuiMonB)
	ui.infoGuiBg := gui()
	ui.infoGuiBg.opt("toolWindow alwaysOnTop -caption")
	ui.infoGuiBg.backColor := "454545"
	winSetTransparent(120,ui.infoGuiBg.hwnd)
	ui.infoGui := gui()
	ui.infoGui.opt("toolWindow -caption AlwaysOnTop owner" ui.gameSettingsGui.hwnd)
	ui.infoGui.backColor := transparentColor
	ui.infoGui.color := transparentColor
	winSetTransColor(transparentColor,ui.infoGui.hwnd)

	rowNum := 0
	columnNum := 1
	fileList := array()
	
	loop files, infographicFolder "/" infographicName "/*.png" {
		fileList.push(a_loopFilename)
	}
	
	for file in fileList {
		if columnNum == 1 {
			ui.%infographicName%%a_index% := ui.infoGui.addPicture("x0 y" 30+(rowNum*imageHeight) " w" imageWidth " h" imageHeight,infographicFolder "/" infographicName "/" file)
			ui.%infographicName%%a_index%.onEvent("click",d2ClickedGlyph)
			ui.%infographicName%%a_index%.onEvent("doubleclick",d2DoubleClickedGlyph)
			rowNum +=1
		} else {	
			ui.%infographicName%%a_index% := ui.infoGui.addPicture("x" (columnNum*imageWidth)-imageWidth " y" 30+(rowNum*imageHeight)-imageHeight " w" imageWidth " h" imageHeight,infographicFolder "/" infographicName "/" file)
			ui.%infographicName%%a_index%.onEvent("click",d2ClickedGlyph)
			ui.%infographicName%%a_index%.onEvent("doubleclick",d2DoubleClickedGlyph)
		}
		columnNum += 1
		if columnNum > numColumns
			columnNum := 1
	}
	ui.%infographicName%QuitButton := ui.infoGui.addPicture("x770 y0 w30 h30 backgroundTrans","./img/button_quit.png")
	ui.%infographicName%QuitButton.onEvent("click",closeInfographic)
		
	infoGuiWidth := numColumns*imageWidth
	infoGuiHeight := (rowNum*imageHeight)+30
	ui.infoGuiDragZone := ui.infoGuiBg.addText("x0 y0 w" infoGuiWidth " y" infoGuiHeight " background" transparentColor,"")
	winSetTransparent(0,ui.infoGuiBg.hwnd)
	winSetTransparent(0,ui.infoGui.hwnd)
	ui.infoGuiBg.show("x" ((infoGuiMonL+infoGuiMonR)/2)-(infoGuiWidth/2) " y" ((infoGuiMonT+infoGuiMonB)/2)-(infoGuiHeight/2) " w" infoGuiWidth " h" infoGuiHeight " noActivate")
	ui.infoGui.show("x" ((infoGuiMonL+infoGuiMonR)/2)-(infoGuiWidth/2) " y" ((infoGuiMonT+infoGuiMonB)/2)-(infoGuiHeight/2) " w" infoGuiWidth " h" infoGuiHeight " noActivate")
	ui.infoGui.opt("owner" ui.infoGuiBg.hwnd)
}

closeInfographic(*) {
	try 
		ui.infoGui.hide()
	try
		ui.infoGuiBg.hide()
	try
		ui.infoGui.destroy()
	try	
		ui.infoGuiBg.destroy()
}

