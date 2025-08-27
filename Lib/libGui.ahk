#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}
; ui.1_GameButtonDetail:=ui.mainGui.addPicture("x36 y3 w78 h28 backgroundTrans","./img/custom/lightburst_tr_light.png")
; ui.2_SetupButtonDetail := ui.mainGui.addPicture("x116 y3 w78 h32 backgroundTrans","./img/custom/lightburst_tl_light.png")
mainTabsChanged(*) {
	changeTabs(ui.mainTabGui,ui.mainGuiTabs)
	if ui.mainGuiTabs.value==1 {
		guiVis(ui.gameSettingsGui,true)
		guiVis(ui.gameTabGui,true)
		guiVis(ui.helpGuiButton,true)
	} else {
		guiVis(ui.gameSettingsGui,false)
		guiVis(ui.gameTabGui,false)
		guiVis(ui.helpGuiButton,false)
	}
	
}


tabsChanged(*) {
	;ui.tabDivider:=ui.mainGui.addText("x117 y0 w2 h28 background" cfg.TrimColor1)
	;line(ui.mainGui,115,0,30,2,cfg.TrimColor1,"vert")
	ui.activeTab := ui.mainGuiTabs.Text
	ui.activeMainTab := ui.mainGuiTabs.value
	(ui.activeTab=="1_Game____")
		? (	 ui.1_GameButtonBg:=ui.mainGui.addText("x34 y0 w83 h28 background" cfg.TrimColor1)
			, ui.1_GameButton:=ui.mainGui.addText("x36 y2 w79 h28 background" cfg.TabColor1)
			, ui.2_SetupButtonBg:=ui.mainGui.addText("x117 w80 y0 h28 background" cfg.TrimColor2)
			, ui.2_SetupButton:=ui.mainGui.addText("x117 w78 y2 h28 background" cfg.TabColor2)
			, ui.1_GameButtonLabel := ui.mainGui.addText("x34 y4 w81 h26 center backgroundTrans","Game")
			, ui.1_GameButtonLabel.setFont("s14 q5 c" cfg.FontColor1,"Impact")
			, ui.2_SetupButtonLabel := ui.mainGui.addText("y4 x117 w78 h26 center backgroundTrans","Setup")
			, ui.2_SetupButtonLabel.setFont("s12 q5 c" cfg.FontColor2,"Impact")				
			, ui.Setup_ActiveTabUi:=ui.mainGui.addText("x117 y28 w78 h2 background" cfg.TrimColor1)
			, ui.1_GameButtonDetail:=ui.mainGui.addPicture("x34 y0 w83 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
			, ui.1_GameButtonDetail2:=ui.mainGui.addPicture("hidden x36 y" 28-cfg.curveAmount " w81 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
			, ui.1_GameButtonDetail3:=ui.mainGui.addPicture("hidden x" 36-(cfg.curveAmount/3) " y" 2 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")
			, ui.2_SetupButtonDetail:=ui.mainGui.addPicture("x117 y0 w80 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")			
			, ui.2_SetupButtonDetail2:=ui.mainGui.addPicture("x117 y" 30-cfg.curveAmount " w" 80 " h" cfg.curveAmount-2 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")	
			, ui.2_SetupButtonDetail3:=ui.mainGui.addPicture("x" 117 " y" 4 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
			, ui.Game_ActiveTabUi:=ui.mainGui.addText("hidden x33 y28 w81 h2 background" cfg.trimColor1)
			, guiVis(ui.gameSettingsGui,true)
			, guiVis(ui.gameTabGui,true))
		: (ui.tabDivider:=ui.mainGui.addText("hidden x115 y02 w2 h28 background" cfg.TrimColor1)
			, ui.2_SetupButtonBg:=ui.mainGui.addText("x115 y0 w82 h28 background" cfg.TrimColor1)
			, ui.2_SetupButton:=ui.mainGui.addText("x115 y2 w78 h28 background" cfg.TabColor1)
			, ui.1_GameButtonBg.opt("x36 y0 w81 h32 background" cfg.TrimColor2)
			, ui.1_GameButton.opt("x38 y2 w79 h30 background" cfg.TabColor2)
			, ui.1_GameButtonLabel.opt("hidden")
			, ui.1_GameButtonLabel := ui.mainGui.addText("x36 y4 w79 h28 center backgroundTrans","Game")
			, ui.1_GameButtonLabel.setFont("s12 q5 c" cfg.FontColor2,"Impact")
			, ui.2_SetupButtonLabel.opt("hidden")
			, ui.2_SetupButtonLabel := ui.mainGui.addText("y4 x115 w78 h28 center backgroundTrans","Setup")
			, ui.2_SetupButtonLabel.setFont("s14 q5 c" cfg.FontColor1,"Impact")
			, ui.Setup_ActiveTabUi:=ui.mainGui.addText("hidden x115 y28 w78 h2 background" cfg.trimColor1)
			, ui.Game_ActiveTabUi:=ui.mainGui.addText("x34 y28 w81 h2 background" cfg.TrimColor1)
			, ui.1_GameButtonDetail:=ui.mainGui.addPicture("hidden x34 y0 w81 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
			, ui.1_GameButtonDetail2:=ui.mainGui.addPicture("x34 y" 28-cfg.curveAmount " w82 h" cfg.curveAmount-2 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
			, ui.2_GameButtonDetail3:=ui.mainGui.addPicture("x" 116-(cfg.curveAmount/3) " y" 4 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")
			, ui.2_SetupButtonDetail:=ui.mainGui.addPicture("x115 y0 w82 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
			, ui.2_SetupButtonDetail2:=ui.mainGui.addPicture("hidden x115 y" 26-cfg.curveAmount " w82 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
			, ui.1_SetupButtonDetail3:=ui.mainGui.addPicture("hidden x" 115 " y" 4 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
			, guiVis(ui.gameSettingsGui,false)
			, guiVis(ui.gameTabGui,false))
			
			ui.tabDivider.redraw()
			ui.1_GameButtonBg.redraw()
			ui.1_GameButton.redraw()
			ui.1_GameButtonLabel.redraw()
			ui.2_SetupButtonBg.redraw()
			ui.2_SetupButton.redraw()
			ui.2_SetupButtonLabel.redraw()
			ui.Game_ActiveTabUi.redraw()
			ui.Setup_ActiveTabUi.redraw()
			ui.2_SetupButtonDetail.redraw()
			ui.2_SetupButtonDetail2.redraw()
			ui.2_SetupButtonDetail3.redraw()
			ui.1_GameButtonDetail.redraw()
			ui.1_GameButtonDetail2.redraw()
			ui.1_GameButtonDetail3.redraw()
			
}

tabsInit(*) {
	ui.tabDivider:=ui.mainGui.addText("hidden x115 y0 w2 h28 background" cfg.TrimColor1)
	ui.activeTab := ui.mainGuiTabs.Text
	ui.activeMainTab := ui.mainGuiTabs.value
	(ui.activeTab=="1_Game____")
	? (ui.gameSettingsGui.opt("-toolWindow")
		, ui.gameTabGui.opt("-toolWindow")
		, ui.mainGui.opt("-toolWindow")

		, ui.Game_ActiveTabUi.opt("-hidden")
		, ui.Setup_ActiveTabUi.opt("hidden"))
	: (ui.gameTabGui.opt("+toolWindow")
		, ui.gameSettingsGui.opt("+toolWindow")
		, ui.mainGui.opt("-toolWindow")
		, ui.1_GameButton.opt("x34 y2 w81 h17 background" cfg.TileColor)
		, ui.1_GameButtonBg.opt("y0 background" cfg.TrimColor2)
		, ui.2_SetupButton.opt("y2 h32 background" cfg.TabColor1)
		, ui.2_SetupButtonBg.opt("y0 background" cfg.TrimColor1)
		, ui.Game_ActiveTabUi.opt("hidden")
		, ui.Setup_ActiveTabUi.opt("-hidden"))
}

ui.mainTabGui:=gui()
ui.mainTabGui.name:="mainTabGui"

; 

drawTabs(this_gui:=ui.mainTabGui,tabControl:=ui.mainGuiTabs,tabX:=0,tabY:=0,tabNames:=["Game","Setup"],tabWidths:=[83,82],orient:="top") {
	this_gui.opt("-caption toolWindow alwaysOnTop +E0x20 owner" ui.mainGui.hwnd)
	this_gui.backColor:=ui.TransparentColor
	this_gui.color:=ui.transparentColor
	winSetTransColor(ui.transparentColor,this_gui)

	ui.%this_Gui.name%Tab1BgOff:=this_gui.addText("hidden x" 2 " y" 2 " w" tabWidths[1] " h" 28 " background" cfg.trimColor2)
	ui.%this_Gui.name%Tab1Off:=this_gui.addText("hidden x" 2+2 " y" 4 " w" tabWidths[1] " h" 26 " background" cfg.tabColor2)
	ui.%this_Gui.name%Tab1Bg:=this_gui.addText("x" 0 " y" 0 " w" tabWidths[1]+4 " h" 30 " background" cfg.trimColor1)
	ui.%this_Gui.name%Tab1:=this_gui.addText("x" 0+2 " y" 0+2 " w" tabWidths[1]-4 " h" 28 " background" cfg.tabColor1)
	ui.%this_Gui.name%Tab1Label:=this_gui.addText("center x" 0+2 " y" 0+2 " w" tabWidths[1]-4 " h" 28 " backgroundTrans",tabNames[1])
	ui.%this_Gui.name%Tab1Label.setFont("s15 c" cfg.fontColor1,"Impact")
	ui.%this_Gui.name%Tab2Bg:=this_gui.addText("hidden x" 0+tabWidths[1] " y" 0 " w" tabWidths[2] " h" 30 " background" cfg.trimColor1)

	ui.%this_Gui.name%Tab2:=this_gui.addText("hidden x" 0+tabWidths[1]+2 " y" 0+2 " w" tabWidths[2]-4 " h" 28 " background" cfg.tabColor1)
	ui.%this_Gui.name%Tab2BgOff:=this_gui.addText("x" 0+tabWidths[1] " y" 2 " w" tabWidths[2] " h" 26 " background" cfg.trimColor2)
	ui.%this_Gui.name%Tab2Off:=this_gui.addText("x" 0+tabWidths[1] " y" 4 " w" tabWidths[2]-2 " h" 24 " background" cfg.tabColor2)
	ui.%this_Gui.name%Tab2Label:=this_gui.addText("center x" 0+tabWidths[1] " y" 4 " w" tabWidths[2]-4 " h" 28 " backgroundTrans",tabNames[2])
	ui.%this_Gui.name%Tab2Label.setFont("s12 c" cfg.fontColor2,"Impact")
	ui.%this_gui.name%Tab1Inactive:=this_gui.addText("hidden x" tabX " y" 28 " w" tabWidths[1] " h" 2 " background" cfg.trimColor1)
	;ui.%this_gui.name%tab12Divider:=this_gui.addText("x" tabX+tabWidths[1]-2 " y" 0 " w" 2 " h" 26 " background" cfg.trimColor1)

	ui.%this_gui.name%Tab1InactiveBottom:=this_gui.addPicture("hidden x" tabX+2 " y" 28-(cfg.curveAmount/2) " w" tabWidths[1]-2 " h" cfg.curveAmount/2 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.%this_gui.name%Tab1InactiveRight:=this_gui.addPicture("hidden x" tabX+tabWidths[1]-(cfg.curveAmount/3) " y" 4 " w" cfg.curveAmount/3 " h" 24 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")
	ui.%this_gui.name%Tab2Inactive:=this_gui.addText("x" tabX+tabWidths[1]-2 " y" 28 " w" tabWidths[2] " h" 2 " background" cfg.trimColor1)
	ui.%this_gui.name%Tab2InactiveBottom:=this_gui.addPicture("x" tabX+tabWidths[1] " y" 28-(cfg.curveAmount/2) " w" tabWidths[2] " h" cfg.curveAmount/2 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.%this_gui.name%Tab2InactiveLeft:=this_gui.addPicture("x" 2+tabX+tabWidths[1] " y" 4 " w" cfg.curveAmount/3 " h" 24 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
	ui.%this_gui.name%tab12Divider:=this_gui.addText("hidden x" tabX+tabWidths[1]-2 " y" 0 " w" 2 " h" 28 " background" cfg.trimColor1)
	ui.%this_gui.name%Top1Detail:=this_gui.addPicture("x" tabX " y" tabY " w" tabWidths[1] " h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.%this_gui.name%Top2Detail:=this_gui.addPicture("x" tabX+tabWidths[1] " y" tabY+2 " w" tabWidths[2] " h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	
	ui.%this_gui.name%Tab1InactiveMask:=this_gui.addText("hidden x0 y0 w81 h2 background" ui.transparentColor)
	ui.%this_gui.name%Tab1InactiveMaskLeft:=this_gui.addText("x0 y0 w2 h26 background" ui.transparentColor)
	ui.%this_gui.name%Tab1InactiveMaskLeftMain:=ui.mainGui.addText("x32 y0 w6 h30 background" ui.transparentColor)
	ui.%this_gui.name%Tab2InactiveMask:=this_gui.addText("x83 y0 w83 h2 background" ui.transparentColor)
	; line(this_gui,110,1,387,1,ui.transparentColor)
	; line(this_gui,197,0,300,2,ui.transparentColor)
	

	
	;winSetTransColor(ui.transparentColor,ui.mainTabGui)
	winSetTransparent(0,this_gui)
	winGetPos(&mainTabX,&mainTabY,&tW,&tH,ui.mainGui)
	this_gui.show("x" tabX+mainTabX+34 " y" mainTabY+tabY " w" tabWidths[1]+tabWidths[2] " h" 30 " noActivate")
	ui.gameTab1LeftTransMain:=ui.mainGui.addText("x" 0 " y" 185 " w" 40 " h" 60 " background" ui.transparentColor)

}

changeTabs(this_gui:=ui.mainTabGui,this_tabControl:=ui.mainGuiTabs) {
	if this_tabControl.value==1 {
		ui.%this_Gui.name%Tab1BgOff.opt("hidden")
		ui.%this_Gui.name%Tab1Off.opt("hidden")
		ui.%this_Gui.name%Tab1Bg.opt("-hidden")
		ui.%this_Gui.name%Tab1.opt("-hidden")
		ui.%this_gui.name%Tab1Label.move(,2)
		ui.%this_Gui.name%Tab1Label.setFont("s15 c" cfg.fontColor1,"Impact")
		ui.%this_Gui.name%Tab2Bg.opt("hidden")
		ui.%this_Gui.name%Tab2.opt("hidden")
		ui.%this_Gui.name%Tab2BgOff.opt("-hidden")
		ui.%this_Gui.name%Tab2Off.opt("-hidden")
		ui.%this_gui.name%Tab2Label.move(,4)
		ui.%this_Gui.name%Tab2Label.setFont("s12 c" cfg.fontColor2,"Impact")
		ui.%this_gui.name%Tab1Inactive.opt("hidden")
		ui.%this_gui.name%Tab1InactiveMask.opt("hidden")
		;ui.%this_gui.name%Tab1InactiveLeft.opt("hidden")
		ui.%this_gui.name%Tab1InactiveMaskLeft.opt("hidden")
		ui.%this_gui.name%Tab2InactiveMask.opt("-hidden")
		ui.%this_gui.name%Tab1InactiveBottom.opt("hidden")
		ui.%this_gui.name%Tab1InactiveRight.opt("hidden")
		ui.%this_gui.name%Tab2Inactive.opt("-hidden")
		ui.%this_gui.name%Tab2InactiveBottom.opt("-hidden")
		ui.%this_gui.name%Tab2InactiveLeft.opt("-hidden")
		ui.%this_Gui.name%Top1Detail.move(,0)
		ui.%this_Gui.name%Top2Detail.move(,2)
		ui.gameSettingsGui.show()
		ui.gameTabGui.show()
	} else {
		ui.%this_Gui.name%Tab1BgOff.opt("-hidden")
		ui.%this_Gui.name%Tab1Off.opt("-hidden")
		ui.%this_Gui.name%Tab1Bg.opt("hidden")
		ui.%this_Gui.name%Tab1.opt("hidden")
		ui.%this_gui.name%Tab1Label.move(,4)
		ui.%this_Gui.name%Tab1Label.setFont("s12 c" cfg.fontColor2,"Impact")
		ui.%this_Gui.name%Tab2Bg.opt("-hidden")
		ui.%this_Gui.name%Tab2.opt("-hidden")
		ui.%this_Gui.name%Tab2BgOff.opt("hidden")
		ui.%this_Gui.name%Tab2Off.opt("hidden")
		ui.%this_gui.name%Tab2Label.move(,2)
		ui.%this_Gui.name%Tab2Label.setFont("s15 c" cfg.fontColor1,"Impact")
		ui.%this_gui.name%Tab1InactiveMask.opt("-hidden")
		ui.%this_gui.name%Tab1InactiveMaskLeft.opt("-hidden")
		;ui.%this_gui.name%Tab1InactiveLeft.opt("-hidden")
		ui.%this_gui.name%Tab2InactiveMask.opt("hidden")
		ui.%this_gui.name%Tab1Inactive.opt("-hidden")
		ui.%this_gui.name%Tab1InactiveBottom.opt("-hidden")
		ui.%this_gui.name%Tab1InactiveRight.opt("-hidden")
		ui.%this_gui.name%Tab2Inactive.opt("hidden")
		ui.%this_gui.name%Tab2InactiveBottom.opt("hidden")
		ui.%this_gui.name%Tab2InactiveLeft.opt("hidden")
		ui.%this_Gui.name%Top1Detail.move(,2)
		ui.%this_Gui.name%Top2Detail.move(,0)		
		}
		
}
	
	; drawMainTabs(activeTab:=1) {
		
		
		; ui.tabDivider:=ui.mainTabGui.addText("hidden x115 y0 w2 h28 background" cfg.TrimColor1)
		; tabsInit()
		; tabsChanged()
		; }
	
initGui(&cfg, &ui) {




advProgress(2)
	ui.TransparentColor 	:= "010203"
	ui.MainGui 				:= Gui()
	
	ui.mainGui.setFont("s14 q5 c" cfg.FontColor1,"move-x")
	drawOutlineMainGui(34,28,497,182,cfg.TrimColor1,cfg.TrimColor1,2)
	advProgress(2)
	ui.MainGui.Name 		:= "dapp"
	ui.mainGui.Title		:= "dapp"
	ui.TaskbarHeight 		:= GetTaskBarHeight()
	ui.MainGui.BackColor 	:= ui.transparentColor
	ui.MainGui.Color 		:= ui.TransparentColor
	winSetTransColor(ui.transparentColor,ui.mainGui)
	ui.MainGui.Opt("-Caption -Border toolWindow")
	advProgress(2)
	
	if (cfg.AlwaysOnTopEnabled)
	{
		ui.MainGui.Opt("+AlwaysOnTop 0x4000000")
	}	
	advProgress(2)
	ui.MainGui.MarginX := 0
	ui.MainGui.MarginY := 0
	ui.mainGuiAnchor := ui.mainGui.addText("x0 y0 w0 h0 section hidden")
	
	ui.mainBg := ui.mainGui.addText("x34 y30 w493 h185 background" cfg.TabColor1,"")

	advProgress(2)
	
	advProgress(2)
	
	
	
	ui.3_FillBg:=ui.mainGui.addText("y4 x196 w280 h26 background" cfg.titleBgColor)

	

ui.3_FillOutline:=ui.mainGui.addText("hidden x194 y4 w280 h29 center backgroundTrans","dapp")
		ui.3_FillOutline.setFont("q5 s15 c" cfg.titleFontColor,"Move-X")
		ui.3_TitleTextDetail:=ui.mainGui.addText("x316 y9 w2 h15 background" cfg.titleBgColor)

		(iniRead(cfg.themeFile,cfg.theme,"HideTitlebarText",0)) ? 0 : (ui.3_FillOutline.opt("-hidden"),ui.3_FillOutline.redraw())
if !fileExist(cfg.titleBarImage)
		cfg.titleBarImage:="./img/custom/lightburst_bottom_light.png"
	ui.titleBar:=ui.mainGui.addPicture("x196 y4 w280 h24 left backgroundTrans",cfg.titleBarImage)
	ui.titleBar.onEvent("click",wm_lbuttonDown_callback)

; ui.3_TitleTextDetail2:=ui.mainGui.addText("x339 y9 w2 h15 background" cfg.titleBgColor)
; ui.3_TitleTextDetail3:=ui.mainGui.addText("x355 y9 w2 h15 background" cfg.titleBgColor)

	

	ui.3_FillDetail1:=ui.mainGui.addPicture("x196 y4 w340 h" cfg.curveAmount/2 " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.3_FillDetailBottom:=ui.mainGui.addPicture("x196 y" 28-(cfg.curveAmount/2) " w280 h" cfg.curveAmount/2 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.3_FillDetailLeft:=ui.mainGui.addPicture("x198 y" 4 " w" cfg.curveAmount/3 " h" 24 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
	ui.4_FillDetailRight:=ui.mainGui.addPicture("x" 196+276-(cfg.curveAmount/3) " y" 4 " w" cfg.curveAmount/3 " h" 24 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")
			
			ui.Game_ActiveTabUi:=ui.mainGui.addText("hidden x33 y28 w81 h2 background" cfg.trimColor1)
			ui.1_GameButtonBg:=ui.mainGui.addText("hidden x34 y0 w83 h28 background" cfg.TrimColor1)
			ui.1_GameButton:=ui.mainGui.addText("hidden x36 y2 w79 h28 background" cfg.TabColor1)
			ui.2_SetupButtonBg:=ui.mainGui.addText("hidden x117 w80 y0 h28 background" cfg.TrimColor2)
			ui.2_SetupButton:=ui.mainGui.addText("hidden x117 w78 y2 h28 background" cfg.TabColor2)
			ui.1_GameButtonLabel := ui.mainGui.addText("hidden x34 y4 w81 h26 center backgroundTrans","Game")
			ui.1_GameButtonLabel.setFont("s14 q5 c" cfg.FontColor1,"Impact")
			ui.2_SetupButtonDetail:=ui.mainGui.addPicture("hidden x116 y0 w82 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")			
			ui.2_SetupButtonDetail2:=ui.mainGui.addPicture("hidden x115 y" 28-cfg.curveAmount " w" 82 " h" cfg.curveAmount-2 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")	
			ui.2_SetupButtonDetail3:=ui.mainGui.addPicture("hidden x" 116 " y" 4 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
	
			ui.2_SetupButtonLabel := ui.mainGui.addText("hidden y4 x115 w78 h26 center backgroundTrans","Setup")
			ui.2_SetupButtonLabel.setFont("s12 q5 c" cfg.FontColor2,"Impact")		
			ui.Setup_ActiveTabUi:=ui.mainGui.addText("hidden x115 y28 w78 h2 background" cfg.TrimColor1)
			ui.1_GameButtonDetail:=ui.mainGui.addPicture("hidden x34 y0 w83 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
			ui.1_GameButtonDetail2:=ui.mainGui.addPicture("hidden x36 y" 29-cfg.curveAmount " w82 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
			ui.2_GameButtonDetail4:=ui.mainGui.addPicture("hidden x" 196+275-(cfg.curveAmount/3) " y" 4 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")
			ui.2_GameButtonDetail5:=ui.mainGui.addPicture("hidden x" 115+82 " y" 4 " w" cfg.curveAmount/3 " h" 26 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
			ui.1_GameButtonDetail3:=ui.mainGui.addPicture("hidden x" 34-(cfg.curveAmount/2) " y" 4 " w" cfg.curveAmount/2 " h" 26 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")

	line(ui.mainGui,115,28,375,2,cfg.TrimColor1)
	;ui.mainGuiTitlebarMask:=ui.mainGui.addText("x197 y0 w300 h4 background" ui.transparentColor)
	

;line(ui.mainGui,115,0,30,2,cfg.TrimColor1,"vert")
	; ui.1_gameButtonDetail:=ui.mainGui.addPicture("x34 y0 w83 h" 13-(13-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_light.png")
; ui.2_setupButtonDetail2:=ui.mainGui.addPicture("x117 y0 w80 h" 13-(13-cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_light.png")


	ui.3_FillOutline.onEvent("click",WM_LBUTTONDOWN_callback)

	
	advProgress(2)

	advProgress(2)

	
	ui.mainGuiTabs := ui.MainGui.AddTab3("x36 y4 w492 -redraw h210 Buttons 0x400 Background" cfg.TabColor1 " -E0x200",["1_Game____","2_Setup____"])
	ui.mainGuiTabs.useTab("")
	TCM_SETMINTABWIDTH:= 0x1331
	TCM_SETPADDING  := 0x132b
	
	sendMessage(TCM_SETITEMSIZE:=0x1329,0,80,,ui.mainGuiTabs.hwnd)
	ui.mainGuiTabs.redraw()
	sendMessage(TCM_SETPADDING,0,5,,ui.mainGuiTabs.hwnd)
	
	ui.mainGuiTabs.setFont("q5 s10 q5")
	ui.MainGui.setFont("q5 s12 c" cfg.FontColor1,"prototype")
	ui.MainGuiTabs.OnEvent("Change",mainTabsChanged)

	advProgress(2)
	ui.activeTab 				:= ui.mainGuiTabs.Text
	ui.previousTab 				:= ui.activeTab
	ui.handleBarBorder 			:= ui.mainGui.addText("hidden x0 y0 w34 h220 background" cfg.TrimColor1,"")
	ui.handleBarImage 			:= ui.MainGui.AddPicture("hidden x1 y2 w33 h220 backgroundTrans")
	ui.ButtonHandlebarDebug 	:= ui.MainGui.AddPicture("hidden x2 y185 w30 h27")
	ui.handleBarImage.ToolTip 	:= "Drag Handlebar to Move.`nDouble-Click to collapse/uncollapse."
	advProgress(2)
	ui.brVertLine:=ui.mainGui.addText("hidden x529 y184 w2 h29 background" cfg.TrimColor1)
	ui.rightHandlebarBg 	:= ui.mainGui.addText("hidden x529 y32 w31 h182 background" cfg.TrimColor1,"")
	ui.rightHandlebarImage2 := ui.mainGui.AddPicture("hidden x528 w31 y33 h180 section")
	ui.ExitButtonBorder 	:= ui.mainGui.AddText("x470 y0 w64 h30 Background" cfg.TrimColor1,"")

	ui.ExitButtonbg 		:= ui.mainGui.AddText("x501 y1 w28 h27 center Background" cfg.TabColor2)
	ui.ExitButton 			:= ui.mainGui.AddText("x501 y2 w28 h28 center BackgroundTrans","r")
	ui.exitButton.setFont("s18 c" cfg.FontColor2,"Webdings")
	ui.ExitButton.OnEvent("Click",ExitButtonPushed)

	ui.DownButtonbg 		:= ui.mainGui.AddText("x472 y1 w27 h27 center section Background" cfg.TabColor2)
	ui.DownButton 			:= ui.mainGui.AddText("x473 y-2 w27 h28 center section BackgroundTrans","6")
	ui.downButton.setFont("s23 c" cfg.FontColor2,"Webdings")

	ui.DownButton.OnEvent("Click",guiHide)
	ui.downButtonbg.onEvent("click",guiHide)
	ui.ExitButtonDetail 	:= ui.mainGui.AddPicture("x470 y0 w94 h" cfg.curveAmount/2 " BackgroundTrans","./img/custom/lightburst_top_bar_dark.png")	
	ui.ExitButtonDetail2 	:= ui.mainGui.AddPicture("x472 y" 28-(cfg.curveAmount/2) " w57 h" cfg.curveAmount/2 " BackgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")	
	
	guiHide(*) {
		ui.mainGui.hide()
		ui.mainTabGui.hide()
		ui.gameSettingsGui.hide()
		ui.gameTabGui.hide()
		ui.helpGuiButton.hide()
	}
	
	advProgress(2)
	ui.handleBarImage.OnEvent("Click",WM_LBUTTONDOWN_callback)
	ui.rightHandleBarImage2.OnEvent("Click",WM_LBUTTONDOWN_callback)
	ui.DownButton.ToolTip 	:= "Minimizes dapp App"
	ui.ExitButton.ToolTip 	:= "Terminates dapp App"

	; advProgress(2)
	
	; ui.gvConsole 		:= ui.MainGui.AddListBox("x0 y214 w560 h192 +Background" cfg.TabColor2)
	; ui.gvConsole.Color 	:= cfg.TrimColor1	
	advProgress(2)
	afk 				:= Object()	

	advProgress(2)
	GuiSetupTab(&ui,&cfg)
	
	advProgress(2)
	GuiGameTab()
	
	advProgress(2)
	
	OnMessage(0x0200, WM_MOUSEMOVE)
	OnMessage(0x0202, WM_LBUTTONDOWN)
	OnMessage(0x47, WM_WINDOWPOSCHANGED)
	advProgress(2)

	ui.MainGuiTabs.UseTab("")
ui.Setup_ActiveTabUi:=ui.mainGui.addText("hidden x117 y30 w76 h2 background" cfg.TabColor1)
ui.Game_ActiveTabUi:=ui.mainGui.addText("hidden x36 y30 w79 h2 background" cfg.TabColor1)
advProgress(2)
line(ui.mainGui,34,208,495,2,cfg.TrimColor1)


}

line(this_gui,startingX,startingY,length,thickness,color,vertical:=false) {
	this_guid := comObject("Scriptlet.TypeLib").GUID
	if (vertical) {
		this_guid := this_gui.addText("x" startingX " y" startingY " w" thickness " h" length " background" color)
	} else {
		this_guid := this_gui.addText("x" startingX " y" startingY " w" length " h" thickness " background" color)
	}
	return this_guid
}


toggleChanged(toggleControl,*) {
	toggleControl.value := 
		(cfg.%toggleControl.name%Enabled := !cfg.%toggleControl.name%Enabled)
			? (toggleControl.Opt("Background" cfg.OnColor),cfg.toggleOn)
			: (toggleControl.Opt("Background" cfg.OffColor),cfg.toggleOff)
			iniWrite(cfg.%toggleControl.name%Enabled,cfg.file,"Interface",toggleControl.name "Enabled")
			trayTip(toggleControl.name " changed to " ((cfg.%toggleControl.name%Enabled) ? "On" : "Off"),"dapp Config Change","Iconi Mute")

		; reload()
		}
		
toggleChange(name,onOff := "",toggleOnImg := cfg.toggleOn,toggleOffImg := cfg.toggleOff,toggleOnColor := cfg.OnColor,toggleOffColor := cfg.OffColor) {
	 (onOff)
		? (%name%.Opt("Background" toggleOnColor),toggleOnImg) 
		: (%name%.Opt("Background" toggleOffColor),toggleOffImg)
}
ui.loadingProgressValue += 5

ui.isFading := false
hotIf(isFading)
	hotkey("LButton",(*) => ui.isFading := true)
hotIf()

isFading(*) {
	if ui.isFading
		return 1
	else
		return 0
}

fadeIn() {
	if (cfg.AnimationsEnabled==3) {
		ui.isFading := true
		;winGetPos(&mainGuiX,&mainGuiY,,,ui.mainGui)
		transparency := 0
		switch ui.mainGuiTabs.text {
			case "1_Game____":
				
				while transparency < 223 {
					transparency += 25
					;winSetTransparent(min(round(transparency+40),255),ui.mainTabGui)
					winSetTransparent(min(round(transparency)+60,255),ui.gameTabGui)
					winSetTransparent(min(round(transparency)+60,255),ui.helpGuiButton)
					
					winSetTransparent(round(transparency),ui.mainGui)
					winSetTransparent(min(round(transparency)+0,255),ui.gameSettingsGui)
					sleep(1)
				}
				
		
			default:
			while transparency < 253 {
				transparency += 2.5
				winSetTransparent(round(transparency),ui.mainGui)
				sleep(1)
			}
		}
		ui.isFading := false
	}
	guiVis(ui.mainTabGui,true)
	guiVis(ui.mainGui,true)
	guiVis(ui.gameSettingsGui,true)
	guiVis(ui.helpGuiButton,true)
	guiVis(ui.gameTabGui,true)
}

winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,ui.mainGui)
ui.mainGuiTabs.useTab("")

exitButtonPushed(this_button,*) {
	exitApp
} 


quickOSD()
quickOSD(*) {
	ui.quickOsdBg := gui()
	ui.quickOsdBg.opt("-caption -border toolWindow alwaysOnTop")
	ui.quickOsdBg.backColor := "010203"

	ui.quickOSD := gui()
	ui.quickOSD.opt("-caption -border toolWindow alwaysOnTop")
	ui.quickOSD.backColor := "010203"
	ui.msgLog := ui.quickOSD.AddText("x10 y15 w600 h800 backgroundTrans cLime","")
	ui.msgLog.setFont("q5 s12")
	winSetTransparent(155,ui.quickOsdBg.hwnd)
	winSetTransColor("010203",ui.quickOSD.hwnd)
}

osdLog(msg) {
if cfg.debugEnabled {
		ui.quickOsdBg.show("x5 y200 w610 h810 noActivate")
		ui.quickOSD.show("x5 y200 w610 h810 noActivate")
		setTimer () => (ui.quickOsdBg.hide(),ui.quickOSD.hide()),-5000
	} else {
		ui.quickOsdBg.hide()
		ui.quickOSD.hide()
	}
	ui.msgLog.text := msg "`n" ui.msgLog.text
}

exitAppCallback(*) {
	ExitApp
}

savePrevGuiPos(*) {
	winGetPos(&prevGuiX,&prevGuiY,,,ui.mainGui)
	ui.prevGuiX := prevGuiX
	ui.prevGuiY := prevGuiY
}

saveGuiPos(*) {
	Global
	winGetPos(&GuiX,&GuiY,,,ui.MainGui.hwnd)
	cfg.GuiX := GuiX
	cfg.GuiY := GuiY
	IniWrite(cfg.GuiX,cfg.file,"Interface","GuiX")
	IniWrite(cfg.GuiY,cfg.file,"Interface","GuiY")
	debugLog("Saving Window Location at x" GuiX " y" GuiY)
}

initConsole(&ui) {
	ui.gvMonitorSelectGui := Gui()
	ui.gvMonitorSelectGui.Opt("-Theme -Border -Caption toolWindow +AlwaysOnTop +Parent" ui.MainGui.Hwnd " +Owner" ui.MainGui.Hwnd)
	ui.gvMonitorSelectGui.BackColor := "212121"
	ui.gvMonitorSelectGui.setFont("q5 s16 c00FFFF","calibri Bold")
	ui.gvMonitorSelectGui.Add("Text",,"Click anywhere on the screen`nyou'd like your AppDock on.")
}

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

drawMainOutlines() {
	ui.mainGuiTabs.useTab("")
	drawOutlineNamed("consolePanelOutline",ui.mainGui,34,200,498,2,cfg.OutlineColor2,cfg.OutlineColor1,2) 		;Log Panel Outline
}

drawOpsOutlines() {
	ui.mainGuiTabs.useTab("")
}

; drawGridLines() {
	; ui.MainGuiTabs.UseTab("2_SETUP____")
		; drawOutline(ui.MainGui,101,62,157,100,cfg.titleFontColor,cfg.titleFontColor,2) 	;Win1 Info Frame
		; drawOutline(ui.MainGui,102,62,156,100,cfg.TrimColor1,cfg.TrimColor1,1) 	;Win1 Info Frame
		; drawOutline(ui.MainGui,101,76,157,16,cfg.titleFontColor,cfg.titleFontColor,2)		;Win1 Info Gridlines  
		; drawOutline(ui.MainGui,102,76,156,15,cfg.TrimColor1,cfg.TrimColor1,1)		;Win1 Line above ClassDDL
		; drawOutline(ui.MainGui,101,90,157,17,cfg.titleFontColor,cfg.titleFontColor,2)		;Win1 Line above ClassDDL
		; drawOutline(ui.MainGui,102,90,156,15,cfg.TrimColor1,cfg.TrimColor1,1)		;Win1 Line above ClassDDL
		; drawOutline(ui.MainGui,306,62,156,100,cfg.titleFontColor,cfg.titleFontColor,1)		;WIn2 Info Frame
		; drawOutline(ui.MainGui,306,62,155,100,cfg.TrimColor1,cfg.TrimColor1,2)	;WIn2 Info Frame
		; drawOutline(ui.MainGui,306,76,156,16,cfg.titleFontColor,cfg.titleFontColor,2)		;Win2 Info Gridlines
		; drawOutline(ui.MainGui,306,76,155,15,cfg.TrimColor1,cfg.TrimColor1,1)		;Win2 Line above ClassDDL
		; drawOutline(ui.MainGui,306,90,156,16,cfg.titleFontColor,cfg.titleFontColor,2)		;Win2 Line above ClassDDL
		; drawOutline(ui.MainGui,306,90,155,15,cfg.TrimColor1,cfg.TrimColor1,1)		;Win2 Line above ClassDDL
; }
		
controlFocus(ui.mainGuiTabs,ui.mainGui)
ui.previousTab := ui.activeTab

tabDisabled() {
		ui.mainGuiTabs.choose(ui.previousTab)
		tabsChanged()
		sleep(300)
		notifyOSD("This tab has been`ndisabled by the developer",2000)
		return 1
} 

guiVis(guiName,isVisible:= true) {
	if (isVisible) {
		if guiName != "all" {
			winSetTransparent(255,guiName)
			winSetTransparent("Off",guiName)
			winSetTransColor(ui.transparentColor,guiName)
			winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,guiName)
			
		} else {
			try {
				winSetTransparent(255,ui.mainGui)
				winSetTransparent("Off",ui.mainGui)
				winSetTransColor(ui.transparentColor,ui.mainGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.mainGui)
			}
			try { 
				winSetTransparent(255,ui.gameSettingsGui)
				winSetTransparent("Off",ui.gameSettingsGui)
				winSetTransColor(ui.transparentColor,ui.gameSettingsGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.gameSettingsGui)
			}
			try {
				winSetTransparent(255,ui.gameTabGui)
				winSetTransparent("Off",ui.gameTabGui)
				winSetTransColor(ui.transparentColor,ui.gameTabGui)
				winSetAlwaysOnTop(cfg.AlwaysOnTopenabled,ui.gameTabGui)
			}
		}
	} else {
		if guiName != "all" {
			winSetTransparent(0,guiName)

		} else {
			try {
				winSetTransparent(0,ui.mainGui)

			}
			try {
				winSetTransparent(0,ui.gameSettingsGui)
			
			}
			try {
				winSetTransparent(0,ui.gameTabGui)
			}
			try {
				winSetTransparent(0,ui.mainTabGui)
			}
		}
	}
}

fadeOut(*) {
	if (cfg.AnimationsEnabled) {
		ui.disableMouseClick := true
		activeTab := ui.mainGuiTabs.text
		transValue := 255
		switch activeTab {
			case "3_AFK":
				while (transValue > 20) {
					transValue -= 10
					;winSetTransparent(transValue,ui.titleBarButtonGui)
					winSetTransparent(transValue,ui.afkGui)
					winSetTransparent(transValue,ui.mainGui)
					sleep(10)
				}

				guiVis(ui.afkGui,false)
			case "1_GAME____":
				while(transValue > 20) {
					transValue -= 10
					;winSetTransparent(transValue,ui.titleBarButtonGui)
					winSetTransparent(transValue,ui.mainGui)
					winSetTransparent(transValue,ui.gameSettingsGui)
					winSetTransparent(transValue,ui.gameTabGui)
					sleep(10)
				}
				guiVis(ui.gameSettingsGui,false)
				guiVis(ui.gameTabGui,false)
				
			default:
				while(transValue > 20) {
					transValue -= 10
					winSetTransparent(transValue,ui.mainGui)
					sleep(10)
				}
		}	
	}
	guiVis("all",false)
	ui.disableMouseClick := false
}

; d2KeybindGameTabClicked()
; d2KeybindAppTabClicked()
line(ui.mainGui,34,30,183,2,cfg.TrimColor1,"vert")