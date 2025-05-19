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


ui.gametabs.useTab("Vault Cleaner")
	ui.gameSettingsGui.addText("x5 y3 w488 h146 background" cfg.TabColor1)
	;drawOutlineNamed("vaultStats",ui.gameSettingsGui,5,4,488,150,cfg.OutlineColor1,cfg.OutlineColor1,1)
	;ui.gameSettingsGui.addText("x11 y8 w118 h60 background" cfg.TileColor)
	buttonBg:=ui.gameSettingsGui.addText("x9 y8 w66 h20 background" cfg.TabColor1)
	textBg:=ui.gameSettingsGui.addText("x75 y8 w412 h20 background" cfg.TabColor1)
	;ui.gameSettingsGui.addPicture("x50 y30 w500 h10 backgroundTrans","./img/custom/lightburst_top_light.png")
	;ui.gameSettingsGui.addPicture("x10 y30 w476 h22 backgroundTrans","./img/custom/lightburst_top_light.png")
	;drawOutline(ui.gameSettingsGui,10,9,478,64,cfg.TrimColor1,cfg.TrimColor1,2)
	ui.gameSettingsGui.setFont("s10 c" cfg.fontColor2)
	this.mainButton:=ui.gameSettingsGui.addPicture("hidden section center x10 y10 w75 h20 background" cfg.TabColor2 " c" cfg.fontColor2,"./img/custom/lightburst_top_bar_light.png")
	this.mainButtonTextBg1:=ui.gameSettingsGui.addPicture("hidden x10 y10 w480 h20 backgroundTrans","./img/custom/lightburst_top_bar_light.png")	
	;this.mainButtonTextBg:=ui.gameSettingsGui.addPicture("x85 y10 w200 h20 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	;this.mainButtonTextBg1:=ui.gameSettingsGui.addPicture("x10 y10 w480 h20 backgroundTrans","./img/custom/lightburst_top_bar_light.png")
	this.mainButtonBg:=ui.gameSettingsGui.addPicture("hidden x10 y10 w85 h20 backgroundTrans","./img/custom/lightburst_br_light.png")
	this.mainButtonText:=ui.gameSettingsGui.addText("hidden section center x10 y9 w74 h20 backgroundTrans","Start")
	this.mainButtonText.setFont("s12 q5 c" cfg.LabelColor1,"move-x")
	
	this.mainButtonHotkey:=ui.gameSettingsGui.addPicture("hidden hidden left x36 y10 background" cfg.tabColor2 " c" cfg.fontColor2 " h20 w72")
	this.mainButtonHotkeyDetail1:=ui.gameSettingsGui.addPicture("hidden left x10 y10 backgroundTrans h20 w480","./img/custom/lightburst_bottom_bar_dark.png")
	; this.mainButtonHotkeyDetail2:=ui.gameSettingsGui.addPicture("left x10 y10 backgroundTrans h20 w243","./img/custom/lightburst_tl_light.png")
	;this.mainButtonHotkeyDetail1:=ui.gameSettingsGui.addPicture("left x245 y10 backgroundTrans h20 w243","./img/custom/lightburst_bottom_bar_dark.png")
	; this.mainButtonHotkeyDetail2:=ui.gameSettingsGui.addPicture("left x245 y10 backgroundTrans h20 w243","./img/custom/lightburst_tr_light.png")

	this.mainButtonHotkeyText:=ui.gameSettingsGui.addText("hidden left x91 y9 backgroundTrans c" cfg.fontColor2 " h20 w280","Press [Del] to START")
	;this.mainButtonHotkeyTextDetail:=ui.gameSettingsGui.addPicture("left x200 y18 backgroundTrans h14 w300","./img/custom/lightburst_bottom_light.png")
	;this.mainButtonHotkeyTextDetail:=ui.gameSettingsGui.addPicture("left x200 y18 backgroundTrans h14 w300","./img/custom/lightburst_bottom_light.png")
	this.mainButtonHotkeyText.setFont("s12 q5 c" cfg.LabelColor1,"move-x")
	this.mainButton.onEvent("click",cleanVaultStart)
	this.mainButtonText.onEvent("click",cleanVaultStart)
	ui.gameSettingsGui.setFont("s12 c" cfg.fontColor3)
	this.statusTextBg:=ui.gameSettingsGui.addText("hidden x10 y30 w480 h22 background" cfg.tabColor2,"")
	this.statusText:=ui.gameSettingsGui.addText("hidden x20 y31 w470 h22 backgroundTrans","Toggle VAULT MODE to enable START button")
	this.statusText.setFont("s12 c" cfg.fontColor3,"move-x")
	; this.statusTextDetail:=ui.gameSettingsGui.addPicture("x20 y30 w468 h22 backgroundTrans","./img/custom/lightburst_tr_light.png")
	; this.statusTextDetail2:=ui.gameSettingsGui.addPicture("x20 y30 w468 h22 backgroundTrans","./img/custom/lightburst_br_light.png")
	; this.statusTextDetail3:=ui.gameSettingsGui.addPicture("x10 y30 w468 h22 backgroundTrans","./img/custom/lightburst_tl_light.png")
	; this.statusTextDetail4:=ui.gameSettingsGui.addPicture("x10 y30 w468 h22 backgroundTrans","./img/custom/lightburst_bl_light.png")



	this.statBg:=ui.gameSettingsGui.addText("hidden x10 y78 w239 h64 background" cfg.TabColor2)

	this.statBg.onEvent("click",toggleVaultMode)
	this.statBg2:=ui.gameSettingsGui.addPicture("hidden x240 y84 w200 h66 background" cfg.tabColor2)
	ui.gameSettingsGui.addText("hidden x245 y78 w245 h66 background" cfg.tabColor2 " c" cfg.fontColor2)
	ui.gameSettingsGui.addText("hidden x10 y78 w242 h66 background" cfg.tabColor2,"")
	ui.gameSettingsGui.addPicture("hidden x10 y" 78+(66-cfg.curveAmount) " w480 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	ui.gameSettingsGui.addPicture("hidden x10 y" 78 " w480 h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_light.png")
	;drawOutlineNamed("vaultStats2",ui.gameSettingsGui,242,78,249,66,cfg.TrimColor1,cfg.TrimColor1,1)
	ui.gameSettingsGui.setFont("s9 q5 c" cfg.fontColor1,"prototype")


	this.statBoxOutline:=ui.gameSettingsGui.addText("x244 y82 w246 h60 background" cfg.trimColor2)
	this.statBoxBg:=ui.gameSettingsGui.addText("x247 y84 w242 h56 background" cfg.tabColor2)
	
	
	this.statTop:=ui.gameSettingsGui.addPicture("x" 249 " y" 84 " w" 237 " h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	this.statBottom:=ui.gameSettingsGui.addPicture("x" 249 " y" 84+56-cfg.curveAmount " w" 237 " h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	this.statLeft:=ui.gameSettingsGui.addPicture("x" 249 " y" 82 " w" cfg.curveAmount/3 " h" 62 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
	this.statRight:=ui.gameSettingsGui.addPicture("x" 250+240-(cfg.curveAmount/3) " y" 82 " w" cfg.curveAmount/3 " h" 60 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")
	
	
	this.pageLabel:=ui.gameSettingsGui.addText("right section x370 y88 w80 h25 backgroundTrans c" cfg.fontColor2 "","Page: ")
	this.pageCount:=ui.gameSettingsGui.addText("x420 ys+1 right w56 h25 c" cfg.fontColor2 " backgroundTrans",format("{:03d}",this.page))
	this.elapsedLabel:=ui.gameSettingsGui.addText("section x340 y104 w80 right h25 c" cfg.fontColor2 " backgroundTrans","Elapsed: ")
	this.elapsedTime:=ui.gameSettingsGui.addText("x420 ys+0 left w80 h25 c" cfg.fontColor2 " backgroundTrans","00:00:00")
	this.remaining:=ui.gameSettingsGui.addText("section x340 y119 right w80 h25 c" cfg.fontColor2 " backgroundTrans","Remaining: ")
	this.remainingtime:=ui.gameSettingsGui.addText("x420 ys+0 left w80 h25 c" cfg.fontColor2 " backgroundTrans","00:00:00") 
	
	;this.dismantledHeaderLabel:=ui.gameSettingsGui.addText("x250 y0 w110 right h25 c" cfg.fontColor3 " backgroundTrans","")
	this.dismantledLegendaryLabel:=ui.gameSettingsGui.addText("section x255 y88  left h25 c" cfg.fontColor2 " backgroundTrans","Legendary: ")
	this.dismantledLegendary:=ui.gameSettingsGui.addText("x+0 ys+0 left w83 h25 c" cfg.fontColor2 " backgroundTrans",format("{:03d}","000"))
	this.dismantledExoticLabel:=ui.gameSettingsGui.addText("section x255 y104 left h25 c" cfg.fontColor2 " backgroundTrans","Exotic: ")
	this.dismantledExotics:=ui.gameSettingsGui.addText("x+0 ys+0 left w80 h25 c" cfg.fontColor2 " backgroundTrans",format("{:03d}","000"))
	this.dismantledTotalLabel:=ui.gameSettingsGui.addText("section x255 y119 left h25 c" cfg.fontColor2 " backgroundTrans","Total: ")
	this.dismantledTotal:=ui.gameSettingsGui.addText("x+0 ys+0 left w80 h25 c" cfg.fontColor2 " backgroundTrans",format("{:03d}","000"))
	
	this.vaultProgressLabelBg:=ui.gameSettingsGui.addText("x8 y60 w96 h20 background" cfg.TabColor2,"")

	this.vaultProgress := ui.gameSettingsGui.addProgress("x106 y62 w384 h20 c" cfg.tabColor2 " background" cfg.fontColor2 " range1-500")
	; this.vaultDetail:=ui.gameSettingsGui.addPicture("x10 y52 w398 h" min(20,cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	this.vaultDetail2:=ui.gameSettingsGui.addPicture("hidden x200 y" 60+20-min(20,cfg.curveAmount) " w292 h" min(20,cfg.curveAmount) " backgroundTrans","./img/custom/lightburst_br_light.png")
	this.completeMsg := ui.gameSettingsGui.addText("hidden x33 y61 w500 h30 backgroundTrans c" cfg.fontColor2 "","")
	
	this.statBgDetail:=ui.gameSettingsGui.addPicture("hidden x10 y60 w480 h20 backgroundTrans","./img/custom/lightburst_bottom_bar_light.png")
	this.statBgDetail2:=ui.gameSettingsGui.addPicture("hidden x10 y80 w480 h20 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	this.statBgDetail3:=ui.gameSettingsGui.addPicture("hidden x10 y80 w6 h66 backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
	;drawOutlineNamed("vaultCleanerButton",ui.gameSettingsGui,10,79,234,65,cfg.OutlineColor1,cfg.OutlineColor1,1)
	;drawOutlineNamed("vaultCleanerButton",ui.gameSettingsGui,247,79,243,64,cfg.TrimColor2,cfg.TrimColor1,4)
	drawOutlineNamed("vaultStats",ui.gameSettingsGui,9,80,481,64,cfg.trimColor2,cfg.trimColor2,1)
	;drawOutlineNamed("vaultStats",ui.gameSettingsGui,9,9,482,64,cfg.OutlineColor1,cfg.OutlineColor1,1)
	
	;this.vaultProgressLabelBg2:=ui.gameSettingsGui.addPicture("x10 y52 w96 h20 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	this.d2LaunchVaultCleanerButton := ui.gameSettingsGui.addPicture("hidden x9 y76 w70 h70 backgroundTrans","./img/button_vault_up.png")
	this.d2LaunchVaultCleanerButton.onEvent("click",toggleVaultMode)
	this.d2LaunchVaultCleanerText:=ui.gameSettingsGui.addText("hidden x65 y85 w180 h50 center backgroundTrans c" cfg.fontColor2,'Vault Mode: Off`nClick to Toggle.')
	this.d2LaunchVaultCleanerText.setFont("s14 c" cfg.fontColor2 " bold","Prototype")
	this.vaultProgressLabel:=ui.gameSettingsGui.addText("x16 y63 w110 h15 backgroundTrans c" cfg.fontColor2,"Progress")
	this.vaultProgressLabel.setFont("s10 c" cfg.fontColor2,"move-x")
	drawOutlineNamed("vaultOutline",ui.gameSettingsGui,7,8,484,136,cfg.trimColor2,cfg.trimColor2,1)
	
	; this.vaultStepOutline
	; this.vaultStepBg
	; this.vaultStepText
	; this.vaultStepText2
	; this.vaultStepButton
	
	wizPanelParams:=[ui.gameSettingsGui,1,"Lock all items you wish to keep.",'Use DIM search: "is:unlocked" to verify items to be dismantled before proceeding.',"Next","Cancel",8,9,482,52]
	wizPanel(wizPanelParams)
	wizPanelParams:=[ui.gameSettingsGui,2,'Perform Manual Actions','Set Destiny 2 video mode to "Windowed Fullscreen in-game".','Next','Cancel',8,9,482,52]
	wizPanel(wizPanelParams)
	WizPanelParams:=[ui.gameSettingsGui,3,"Navigate to the VAULT screen in Destiny 2.",'Ensure that Destiny 2 is on the vault screen and click "Start" to begin cleaning.','Start','Cancel',8,9,482,52]
	wizPanel(wizPanelParams)
	
	this.helpOutline:=ui.gameSettingsGui.addText("x" 8 " y" 82 " w" 240 " h" 60 " background" cfg.trimColor2)
	this.helpBg:=ui.gameSettingsGui.addText("x" 9 " y" 84 " w" 239 " h" 56 " background" cfg.tabColor2)
	this.helpText:=ui.gameSettingsGui.addText("x" 15 " y" 87 " w" 231 " h" 52 " backgroundTrans")
	this.helpText.setFont("s10 q5 c" cfg.fontColor2,"Arial Narrow")
	this.helpText.text:='         To avoid inconsistencies, Destiny 2`n         must be in "Windowed Fullscreen" mode. This wizard will outline the process.'
	this.helpIcon:=ui.gameSettingsGui.addPicture("x16 y90 w20 h26 backgroundTrans","./img/icon_help.png")
	this.helpTop:=ui.gameSettingsGui.addPicture("x" 10 " y" 84 " w" 237 " h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	this.helpBottom:=ui.gameSettingsGui.addPicture("x" 10 " y" 84+56-cfg.curveAmount " w" 237 " h" cfg.curveAmount " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
	this.helpLeft:=ui.gameSettingsGui.addPicture("x" 9 " y" 82 " w" cfg.curveAmount/3 " h" 62 " backgroundTrans","./img/custom/lightburst_left_bar_dark.png")
	this.helpRight:=ui.gameSettingsGui.addPicture("x" 248-(cfg.curveAmount/3) " y" 82 " w" cfg.curveAmount/3 " h" 60 " backgroundTrans","./img/custom/lightburst_right_bar_dark.png")

	wizPanel(wizPanelParams) {
		this_guid:=newGuid()
		ui.wizPanelGuids.push(this_guid)
		
		this_gui			:=wizPanelParams[1]
		this_page			:=wizPanelParams[2]
		this_text1			:=wizPanelParams[3]
		this_text2			:=wizPanelParams[4]
		this_buttonLabel1	:=wizPanelParams[5]
		this_buttonLabel2	:=wizPanelParams[6]
		this_X				:=wizPanelParams[7]
		this_Y				:=wizPanelParams[8]
		this_W				:=wizPanelParams[9]
		this_H				:=wizPanelParams[10]
		
		ui.wizPanelOutline_%this_guid%:= this_gui.addText("x" this_X " y" this_Y " w" this_W " h" this_H " background" cfg.trimColor2)
		ui.wizPanelBg_%this_guid%:=this_gui.addText("x" this_X+1 " y" this_Y+1 " w" this_W-2 " h" this_H-2 " background" cfg.tabColor2)
		ui.wizPanelTextOutline_%this_guid%:=this_gui.addText("x" this_X+1 " y" this_Y+1 " w" this_W-2 " h" this_H-2 " background" cfg.trimColor2)

		ui.wizPanelStepText1Bg_%this_guid%:=this_gui.addText("x" this_X+1 " y" this_Y+1 " w" 40 " h" 32 " background" cfg.tabColor2)
		ui.wizPanelStepText2Bg_%this_guid%:=this_gui.addText("x" this_X+1 " y" this_Y+35 " w" 40 " h" 15 " background" cfg.fontColor2)
		ui.wizPanelStepText1_%this_guid%:=this_gui.addText("center x" this_X+2 " y" this_Y+3 " w" 38 " h" 28 " backgroundTrans c" cfg.fontColor1,"1")
		ui.wizPanelStepText1_%this_guid%.setFont("s18 c" cfg.fontColor2 " q5","Impact")
		ui.wizPanelStepText2_%this_guid%:=this_gui.addText("center x" this_X+2 " y" this_Y+34 " w" 38 " h" 15 " backgroundTrans c" cfg.fontColor2,"Step")
		ui.wizPanelStepText2_%this_guid%.setFont("s9 q5 c" cfg.tabColor2)
		ui.wizPanelText1Bg_%this_guid%:=this_gui.addText("x" this_X+43 " y" this_Y+1 " w" this_W-198 " h" 17 " background" cfg.tabColor2)
		ui.wizPanelText2Bg_%this_guid%:=this_gui.addText("x" this_X+43 " y" this_Y+20 " w" this_W-198 " h" 30 " background" cfg.tabColor1)
		ui.wizPanelText1_%this_guid%:=this_gui.addText("x" this_X+47 " y" this_Y+2 " w" this_W-204 " h" 18 " backgroundTrans c" cfg.fontColor2,this_text1)
		ui.wizPanelText1_%this_guid%.setFont("s10 c" cfg.fontColor2 " q5","Consolas")
		ui.wizPanelText2_%this_guid%:=this_gui.addText("x" this_X+47 " y" this_Y+21 " w" this_W-204 " h" 29 " backgroundTrans c" cfg.fontColor2,this_text2)
		ui.wizPanelText2_%this_guid%.setFont("s8 c" cfg.fontColor2 " q5","Consolas")
		ui.wizPanelButtonOutline_%this_guid%:=this_gui.addText("x" this_X+this_W-153 " y" this_Y+1 " w" 86 " h" 49 " background" cfg.tabColor2)
		ui.wizPanelButton1_%this_guid%:=this_gui.addPicture("x" (this_X+this_W)-150  " y" this_Y+2 " w" 80 " h" 24 " backgroundTrans","./img/button_next.png")
		ui.wizPanelButton2_%this_guid%:=this_gui.addPicture("x" (this_X+this_W)-150 " y" this_Y+25 " w" 80 " h" 24 " backgroundTrans","./img/button_cancel.png")
		ui.wizPanelButton1_%this_guid%.onEvent("click",wizNext)
		ui.wizPanelButton2_%this_guid%.onEvent("click",wizCancel)
		loop 3 {
			ui.wizPanelStepBg%a_index%_%this_guid%:=this_gui.addText("right x" this_X+this_W-65 " y" this_Y+(a_index*17)-16 " w" 64 " h" 15 " background" 
				((this_page!=a_index) ? cfg.fontColor2 : cfg.tabColor2))		
			ui.wizPanelStep%a_index%_%this_guid%:=this_gui.addText("right x" this_X+this_W-84 " y" this_Y+(a_index*17)-16 " w" 80 " h" 15 " backgroundTrans", "Step " a_index " " ((this_page>=a_index) ? "■" : "□") " ")			
			ui.wizPanelStep%a_index%_%this_guid%.setFont("s8 q5 c" ((this_page != a_index) ? cfg.tabColor2 : cfg.fontColor2),"Sans Serif")
		}
		
	}

	ui.wizPage:=1
	wizPanelPageChange(1)

		
	wizPanelPageChange(pageNum:=ui.wizPage) {
		for this_guid in ui.wizPanelGuids {
			if a_index == pageNum {
				ui.wizPanelOutline_%this_guid%.opt("-hidden")
				ui.wizPanelBg_%this_guid%.opt("-hidden")
				ui.wizPanelTextOutline_%this_guid%.opt("-hidden")
				ui.wizPanelStepText1Bg_%this_guid%.opt("-hidden")
				ui.wizPanelStepText2Bg_%this_guid%.opt("-hidden")
				ui.wizPanelStepText1_%this_guid%.opt("-hidden")
				ui.wizPanelStepText2_%this_guid%.opt("-hidden")
				ui.wizPanelText1Bg_%this_guid%.opt("-hidden")
				ui.wizPanelText2Bg_%this_guid%.opt("-hidden")
				ui.wizPanelText1_%this_guid%.opt("-hidden")
				ui.wizPanelText2_%this_guid%.opt("-hidden")
				ui.wizPanelButtonOutline_%this_guid%.opt("-hidden")
				ui.wizPanelButton1_%this_guid%.opt("-hidden")
				ui.wizPanelButton2_%this_guid%.opt("-hidden")
				ui.wizPanelStepBg1_%this_guid%.opt("-hidden")
				ui.wizPanelStep1_%this_guid%.opt("-hidden")		
				ui.wizPanelStepBg2_%this_guid%.opt("-hidden")		
				ui.wizPanelStep2_%this_guid%.opt("-hidden")		
				ui.wizPanelStepBg3_%this_guid%.opt("-hidden")		
				ui.wizPanelStep3_%this_guid%.opt("-hidden")
			} else {
				ui.wizPanelOutline_%this_guid%.opt("hidden")
				ui.wizPanelBg_%this_guid%.opt("hidden")
				ui.wizPanelTextOutline_%this_guid%.opt("hidden")
				ui.wizPanelStepText1Bg_%this_guid%.opt("hidden")
				ui.wizPanelStepText2Bg_%this_guid%.opt("hidden")
				ui.wizPanelStepText1_%this_guid%.opt("hidden")
				ui.wizPanelStepText2_%this_guid%.opt("hidden")
				ui.wizPanelText1Bg_%this_guid%.opt("hidden")
				ui.wizPanelText2Bg_%this_guid%.opt("hidden")
				ui.wizPanelText1_%this_guid%.opt("hidden")
				ui.wizPanelText2_%this_guid%.opt("hidden")
				ui.wizPanelButtonOutline_%this_guid%.opt("hidden")
				ui.wizPanelButton1_%this_guid%.opt("hidden")
				ui.wizPanelButton2_%this_guid%.opt("hidden")
				ui.wizPanelStepBg1_%this_guid%.opt("hidden")
				ui.wizPanelStep1_%this_guid%.opt("hidden")		
				ui.wizPanelStepBg2_%this_guid%.opt("hidden")		
				ui.wizPanelStep2_%this_guid%.opt("hidden")		
				ui.wizPanelStepBg3_%this_guid%.opt("hidden")		
				ui.wizPanelStep3_%this_guid%.opt("hidden")
			}
		}
	}

	wizNext(*) {
		switch ui.wizPage {
			case 2:
				vaultModeOn()
			case 3:
				cleanVaultStart()
				vaultModeOff()
				ui.wizPage:=1
				wizPanelPageChange(ui.wizPage)
				Return
		}		
		ui.wizPage+=1
		wizPanelPageChange(ui.wizPage)
	}
	
	
	wizCancel(*) {
		ui.wizPage:=1
		wizPanelPageChange(1)
		
	}
	
	isWindowedFullscreen(*) {
		static tx:=""
		static ty:=""
		static tw:=""
		static th:=""
		if !winExist(this.gameWin)
			return
		winGetPos(&tx,&ty,&tw,&th,this.gameWin)
		if winGetMinMax(this.gameWin) == 0 && a_screenwidth==tw  {
			return 1
		} else {
			return 0
		}
	}
	toggleVaultMode(*) {
		static vaultMode:=false
	
		(vaultMode:=!vaultMode) 
			? vaultModeOn()
			: vaultModeOff()
			
	}

	vaultModeOn(*) {
		;if isWindowedFullscreen() {
		if !winExist(this.gameWin) {
			notifyOSD("Game window not found. Vault mode aborted.",2000,ui.gameSettingsGui)
			vaultMode:=false
			Return
		}
			; winActivate(this.gameWin)
			this.d2LaunchVaultCleanerButton.value:="./img/button_vault_down.png"
			this.d2LaunchVaultCleanerButton.redraw()
			this.statusText.text :="Press [Del] to begin cleanup"
			this.d2LaunchVaultCleanerText.text:="Vault Mode: On`nClick to Toggle"
			this.statBg.opt("background" cfg.TabColor2)
			this.statBg.value:="./img/custom/lightburst_tl.png"
			drawOutlineNamed("vaultCleanerButton",ui.gameSettingsGui,13,82,230,56,cfg.DisabledColor,cfg.DisabledColor,1)
			this.d2LaunchVaultCleanerButton.value:="./img/button_vault_down.png"
			; winMove((a_screenwidth/2)-640,(a_screenheight/2)-360,1280,720,this.gameWin)
			; winActivate(ui.mainGui)
			vaultCleaner()
			
			buttonBg.opt("background" cfg.OnColor)
			this.vaultProgressLabelBg.opt("background" cfg.TabColor2)
			this.vaultProgressLabel.setFont("c" cfg.fontColor2)
			this.vaultProgressLabelBg.redraw()
			this.mainButtonHotkeyText.setFont("c" cfg.fontColor2)
			this.mainButtonText.setFont("s12 q5 c" cfg.tabColor2)
			this.vaultProgressLabel.setFont("s10 c" cfg.fontColor2,"move-x")
	
			textBg.opt("background" cfg.TabColor2)
			
			textBg.redraw()
	;}
	}


	vaultModeOff(*) {
		if !winExist(this.gameWin) {
			notifyOSD("Vault mode not applicable.`nGame window not found.",2000,ui.gameSettingsGui)
			Return
		}
		winActivate(this.gameWin)
		this.mainButtonHotkeyText.text:="Click Vault Icon to Toggle VAULT MODE"
		this.statusText.text:="Cannot START vault cleaning when not in VAULT MODE"
		; this.d2LaunchVaultCleanerButton.redraw()
		this.d2LaunchVaultCleanerText.text:="Vault Mode: Off`nClick to Toggle"
		this.statBg.opt("background" cfg.TabColor2)
		this.statBg.value:="./img/custom/lightburst_br_light.png"
		drawOutlineNamed("vaultCleanerButton",ui.gameSettingsGui,13,82,230,60,cfg.OutlineColor1,cfg.OutlineColor1,1)
		this.d2LaunchVaultCleanerButton.value:="./img/button_vault_up.png"
		try 
			vaultTopGui.destroy()
		winMove(0,0,a_screenwidth,a_screenHeight,this.gameWin)
		winRestore(this.gameWin)
		winActivate(ui.mainGui)

		this.mainButtonText.setFont("s12 q5 c" cfg.LabelColor1)
		this.vaultProgressLabel.setFont("s10 c" cfg.LabelColor1,"move-x")

		buttonBg.opt("background" cfg.TabColor2)
		this.vaultProgressLabelBg.opt("background" cfg.tabColor4)
		this.vaultProgressLabel.setFont("c" cfg.LabelColor1)
		this.vaultProgressLabelBg.redraw()
		this.mainButtonHotkeyText.setFont("c" cfg.LabelColor1)
		textBg.opt("background" cfg.tabColor4)
		textBg.redraw()

		
	}



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
		
		
		;msgBox(winGetMinMax("ahk_exe destiny2.exe"))
		pbNotify('If Destiny 2 is not already set to "Windowed Fullscreen",`n please do it now and then click "Proceed"',30,"YN","fullscreenProcess","fullscreenCancel")
		; try 
			; vaultTopGui.destroy()
		; vaultTopGui := gui()
		; vaultTopGui.backColor:=setting.transColor
		; vaultTopGui.setFont("q5 s10 c000000","calibri")
		; vaultTopGui.opt("-border")	
		; vaultTopGui.backColor:=setting.transColor
		; vaultTopGui.setFont("q5 s10 c000000","calibri")

		; titleBarBg:=vaultTopGui.addText("x0 y0 w1250 h34 vTitleBarBg background777777")
		; titleBarBg.onEvent("click",vault_LBUTTONDOWN_callback)
		; titleBarText:=vaultTopGui.addText("x10 y-2 w500 h32 backgroundTrans c992121","Vault Mode Enabled. Ready to dismantle unlocked items.")
		; titleBarText.setFont("q5 s20 bold cffffff","calibri")
		; closeButton:=vaultTopGui.addText("x" setting.gameW-36 " y0 w30 h32 cffffff background777777","T")
		; closeButton.setFont("q5 s24","WingDings 2")
		; closeButton.onEvent("click",closeProgram)
		; closeProgram(*) {
			; exitApp
		; }


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
			DetectHiddenWindows(1)
			GameWindowMode:=winGetMinMax(this.gameWin)
			; switch GameWindowMode {
				; case 1:
					; send("{alt}{enter}")
				; case -1: 
					; winActivate(this.gameWin)
				
			; }
			winGetPos(&gameWinX,&gameWinY,&gameWinW,&gameWinH,this.gameWin)
			this.origGameWinX:=gameWinX
			this.origGameWinY:=gameWinY
			this.origGameWinW:=gameWinW
			this.origGameWinH:=gameWinH
			;vaultTopGui.show("x" (a_screenwidth/2)-640 " y" (a_screenHeight/2)-360 " w" setting.gameW-6 " h30")
			winMove((a_screenwidth/2)-640,(a_screenHeight/2)-360,1280,720,this.gameWin)
			;winSetStyle("-0xC00000",this.GameWin)
			winActivate(this.gameWin)
			;winWait(this.gameWin)
			;sleep(2000)

			send("{F1}")
			sleep(600)
			send("{Ctrl}")
			sleep(600)
			send("{w}")
			sleep(600)
			;this.mainButtonHotkey.setFont("q5 c00FFFFE")
			this.statusText.text:="Dismantles ALL unlocked items (DIM Search 'is:unlocked' to review)"
			this.mainButton.opt("background" cfg.titleFontColor)
			this.mainButtonText.setFont("c" cfg.fontColor3)
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
	this.restartQueued:=false
	this.mainButtonText.text:="Start"
	this.statusText.text:="[Del] to start cleaning"
	this.mainButton.opt("background" cfg.AlertColor "c" cfg.LabelColor1)
	setTimer(timer,0)
	this.restartQueue:=false
	exit
}	

cleanVaultStart(*) {
	this.restartQueued:=true

	(winExist(this.gameWin)) 
		? winActivate(this.gameWin)
		: notifyOSD("No Destiny Window Found")
	
	winActivate(this.gameWin)
	

	this.statusText.text:="[End] to Stop"
	setTimer(timer,1000)
	timer()
	coordMode("mouse","client")
	
	(this.restartQueued) ? (this.restartQueued:=false,exit) : 0
	
	; this.mainButtonHotkey.text:="[Delete]" 	
	; this.mainButton.opt("background" cfg.OnColor " c" cfg.fontColor3)
	; this.mainButtonText.text:="Stop"
	mouseMove(955,170)
	sleep(500)
	notLastPage:=true
	pageUpColor:=""

	loop {
	;(this.restartQueued) ? stopCleaning() : 0
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
				;(this.restartQueued) ? stopCleaning() : 0
				this.vaultProgress.value+=1  
				this.col:=setting.columnCount-a_index
				this.itemNum+=1
				dismantle(this.col,this.row)				
			}
			
			;(this.restartQueued) ? exit : 0
		}
			mouseMove(905,170)
			sleep(500)
			send("{LButton Down}")
			sleep(350)
			send("{LButton Up}")

			this.page-=1
			this.pageCount.text:=format("{:03d}",this.page)
			sleep(600)
			
	}
	this.statusText.text:="Operation Complete"
	stopCleaning()
}

dismantle(thisCol,thisRow) {
	(this.restartQueued) ? (this.restartQueued:=false,exit) : 0
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
	
	this.isExotic:=false
	this.isLocked:=false
	;(this.restartQueued) ? exit : 0
	mouseMove(x,y)
	sleep(200)
	send("{f}")

	loop 30 {
		this.tileColor:=pixelGetColor((thisCol<6) ? x-(setting.tileSize/2)+1 : x+(setting.tileSize/2)-(6-(thisCol-5)),y)
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
		sleep(10)
	}
	
	if !this.isLocked {
		sleep(100)
		sendEvent("{f}")
		sleep(100)
		sendPlay("{f}")
		send("{f down}")
		while pixelGetColor((thisCol<6) ? x-(setting.tileSize/2)+1 : x+(setting.tileSize/2)-(6-(thisCol-5)),y) == this.tileColor && isIdle()   {
			sleep(100)
			if a_index > 30 
				this.isExotic:=true
			if a_index > 80
				break
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
	return this.restartQueued
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