#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)){
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

preAutoExec(InstallDir,ConfigFileName) {
	Global
	data			:= object()
	cfg				:= object()
	ui 				:= object()
	tmp				:= object()
	afk				:= object()
	this			:= object()
	setting 		:= object()
	result 			:= object()
	libVaultInit()
	
	if (A_IsCompiled)
	{
		if StrCompare(A_ScriptDir,InstallDir)
  		{
			createPbConsole("dapp Install")
			pbConsole("Running standalone executable, attempting to install")
			installLog("Running standalone executable, attempting to auto-install")
			if !(DirExist(InstallDir))
			{
				pbConsole("Attempting to create install folder")
				installLog("Attempting to create install folder")
				try
				{
					DirCreate(InstallDir)
					SetWorkingDir(InstallDir)
				} catch {
					installLog("Couldn't create install location")
					sleep(1500)
					pbConsole("Cannot Create Folder at the Install Location.")
					pbConsole("Suspect permissions issue with the desired install location")
					pbConsole("`n`nTERMINATING")
					sleep(4000)
					ExitApp
				}
				pbConsole("Successfully created install location at " InstallDir)
				installLog("Successfully created install location at " InstallDir)
				sleep(1000)
			}
			pbConsole("Copying executable to install location")
			installLog("Copying executable to install location")
			sleep(1000)
			try{
				FileCopy(A_ScriptFullPath, InstallDir "/" A_AppName ".exe", true)
			}

			if (FileExist(InstallDir "/dapp.ini"))
			{
				msgBoxResult := MsgBox("Previous install detected. `nAttempt to preserve your existing settings?",, "Y/N T300")
				
				switch msgBoxResult {
					case "No": 
					{
						sleep(1000)
						pbConsole("`nReplacing existing configuration files with updated and clean files")
						if !dirExist(installDir "/backups")
							dirCreate(installDir "/backups")
						fileMove(installDir "/dapp.ini",installDir "/backups/dapp_ini-" formatTime("T12","yyMMddhhmmss") ".bak",1)
						FileInstall("./dapp.ini",InstallDir "/dapp.ini",1)
						FileInstall("./dapp.themes",InstallDir "/dapp.themes",1)
						FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
						fileInstall("./dapp.db",installDir "/dapp.db",1)
					} 
					case "Yes": 
					{
						cfg.fontColor1 := "00FFFF"
						sleep(1000)
						pbConsole("`nPreserving existing configuration may cause issues.")
						pbConsole("If you encounter issues,try installing again, choosing NO.")
						if !(FileExist(InstallDir "/AfkData.csv"))
							FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
						if !(FileExist(InstallDir "/dapp.themes"))
							FileInstall("./dapp.themes",InstallDir "/dapp.themes",1)
						if !(fileExist(installDir "/dapp.db"))
							fileInstall("./dapp.db",installDir "/dapp.db",1)
					}
					case "Timeout":
					{
						setTimer () => pbNotify("Timed out waiting for your response.`Attempting to update using your exiting config files.`nIf you encounter issues, re-run the install `nselecting the option to replace your existing files.",5000),-100
						if !fileExist("./dapp.ini")
							fileInstall("./dapp.ini",installDir "/dapp.ini")
						if !(FileExist(InstallDir "/AfkData.csv"))
							FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
						if !(FileExist(InstallDir "/dapp.themes"))
							FileInstall("./dapp.themes",InstallDir "/dapp.themes",1)
						if !(fileExist(installDir "/dapp.db"))
							fileInstall("./dapp.db",installDir "/dapp.db",1)	
					}
				}
			} else {
				sleep(1000)
				pbConsole("This seems to be the first time you're running dapp.")
				pbConsole("A fresh install to " A_MyDocuments "\dapp is being performed.")

				FileInstall("./dapp.ini",InstallDir "/dapp.ini",1)
				FileInstall("./dapp.themes",InstallDir "/dapp.themes",1)
				FileInstall("./AfkData.csv",InstallDir "/AfkData.csv",1)
				fileInstall("./dapp.db",installDir "/dapp.db",1)

			}
			if !(DirExist(InstallDir "\lib"))
			{
				DirCreate(InstallDir "\lib")
			}			
			if !(DirExist(InstallDir "\Img"))
			{
				DirCreate(InstallDir "\Img")
			}
			if !(DirExist(InstallDir "\Img\custom"))
			{
				DirCreate(InstallDir "\Img\custom")
			}
			if !(DirExist(InstallDir "\Redist"))
			{
				DirCreate(InstallDir "\Redist")
			}
			installLog("Created Img folder")
			
			if !dirExist(installDir "/img/infogfx")
				dirCreate(installDir "/img/infogfx")
			
			if !dirExist(installDir "/img/infogfx/vod")
				dirCreate(installDir "/img/infogfx/vod")

			if !dirExist(installDir "/redist/mouseSC")
				dirCreate(installDir "/redist/mouseSC")
			
			fileInstall("./redist/mouseSC_x64.exe",installDir "/redist/mouseSC_x64.exe",1)
			fileInstall("./img/dapp.png",installdir "/img/dapp.png",1)
			fileInstall("./img/mouse_lmb.png",installDir "/img/mouse_lmb.png",1)
			fileInstall("./img/mouse_rmb.png",installDir "/img/mouse_rmb.png",1)
			fileInstall("./img/mouse_mmb.png",installDir "/img/mouse_mmb.png",1)
			fileInstall("./img/mouse_fb.png",installDir "/img/mouse_fb.png",1)
			fileInstall("./img/mouse_bb.png",installDir "/img/mouse_bb.png",1)
			; fileInstall("./img/checkbox_true.png",installDir "/img/checkbox_true.png",1)
			; fileInstall("./img/checkbox_false.png",installDir "/img/checkbox_false.png",1)
			FileInstall("./Img/color_swatches.png",InstallDir "/Img/color_swatches.png",1)
			FileInstall("./Img/toggle_off.png",InstallDir "/Img/toggle_off.png",1)
			FileInstall("./Img/toggle_on.png",InstallDir "/Img/toggle_on.png",1)
			fileInstall("./img/toggle_vertical_trans_on.png",installDir "/img/toggle_vertical_trans_on.png",1)
			fileInstall("./img/toggle_vertical_trans_off.png",installDir "/img/toggle_vertical_trans_off.png",1)
			fileInstall("./img/toggle_button_on.png",installDir "/img/toggle_button_on.png",1)
			fileInstall("./img/toggle_button_off.png",installDir "/img/toggle_button_off.png",1)

			FileInstall("./Img/button_update.png",InstallDir "/img/button_update.png",1)
			FileInstall("./Img/button_exit_gaming.png",InstallDir "/img/button_exit_gaming.png",1)
			fileInstall("./img/d2ClassIconWarlock_on.png",installDir "/img/d2ClassIconWarlock_on.png",1)
			fileInstall("./img/d2ClassIconWarlock_off.png",installDir "/img/d2ClassIconWarlock_off.png",1)
			fileInstall("./img/d2ClassIconHunter_on.png",installDir "/img/d2ClassIconHunter_on.png",1)
			fileInstall("./img/d2ClassIconHunter_off.png",installDir "/img/d2ClassIconHunter_off.png",1)
			fileInstall("./img/d2ClassIconTitan_on.png",installDir "/img/d2ClassIconTitan_on.png",1)
			fileInstall("./img/d2ClassIconTitan_off.png",installDir "/img/d2ClassIconTitan_off.png",1)
			FileInstall("./Img/button_plus.png",InstallDir "/Img/button_plus.png",1)
			FileInstall("./Img/button_power.png",InstallDir "/Img/button_power.png",1)
			FileInstall("./Img/button_minus.png",InstallDir "/Img/button_minus.png",1)

			; FileInstall("./Img/button_autoClicker_ready.png",InstallDir "/Img/button_autoClicker_ready.png",1)
			; FileInstall("./Img/button_autoClicker_on.png",InstallDir "/Img/button_autoClicker_on.png",1)
			; FileInstall("./Img/button_quit.png",InstallDir "/Img/button_quit.png",true)
			; FileInstall("./Img/button_minimize.png",InstallDir "/Img/button_minimize.png",true)
			fileInstall("./img/tab_selected.png",installDir "/img/tab_selected.png",1)
			fileInstall("./img/tab_unselected.png",installDir "/img/tab_unselected.png",1)
			fileInstall("./img/handlebar_vertical.png", installDir "/img/handlebar_vertical.png",1)
			fileInstall("./img/right_handlebar_vertical.png", installDir "/img/right_handlebar_vertical.png",1)
			FileInstall("./Img/button_plus_ready.png",InstallDir "/Img/button_plus_ready.png",true)
			FileInstall("./Img/button_plus_on.png",InstallDir "/Img/button_plus_on.png",true)
			FileInstall("./Img/button_minus_ready.png",InstallDir "/Img/button_minus_ready.png",true)
			FileInstall("./Img/button_minus_on.png",InstallDir "/Img/button_minus_on.png",true)
			; FileInstall("./Img/button_LightGG.png",InstallDir "/Img/button_LightGG.png",1)
			; FileInstall("./Img/button_LightGG_down.png",InstallDir "/Img/button_LightGG_down.png",1)
			; FileInstall("./Img/button_d2Checklist.png",InstallDir "/Img/button_d2Checklist.png",1)
			; FileInstall("./Img/button_d2Checklist_down.png",InstallDir "/Img/button_d2Checklist_down.png",1)
			fileInstall("./img/button_keybindTarget.png",installDir "/img/button_keybindTarget.png",1)
			; fileInstall("./img/icon_d2Checklist.png",installDir "/img/icon_d2Checklist.png",1)
			; FileInstall("./Img/button_d2Foundry.png",InstallDir "/Img/button_d2Foundry.png",1)
			; FileInstall("./Img/button_d2Foundry_down.png",InstallDir "/Img/button_d2Foundry_down.png",1)
			FileInstall("./Img/button_DIM.png",InstallDir "/Img/button_DIM.png",1)
			FileInstall("./Img/button_DIM_down.png",InstallDir "/Img/button_DIM_down.png",1)
			fileInstall("./img/icon_DIM.png",installDir "/img/icon_dim.png",1)
			; FileInstall("./Img/button_brayTech.png",InstallDir "/Img/button_brayTech.png",1)
			; FileInstall("./Img/button_brayTech_down.png",InstallDir "/Img/button_brayTech_down.png",1)
			; fileInstall("./img/icon_brayTech.png",installDir "/img/icon_brayTech.png",1)
			; fileInstall("./img/icon_LightGG.png",installDir "/img/icon_LightGG.png",1)
			; FileInstall("./Img/button_DestinyTracker.png",InstallDir "/Img/button_DestinyTracker.png",1)
			; FileInstall("./Img/button_DestinyTracker_down.png",InstallDir "/Img/button_DestinyTracker_down.png",1)
			FileInstall("./Img/button_power.png",InstallDir "/Img/button_power.png",1)
			; FileInstall("./Img/button_power_on.png",InstallDir "/Img/button_power_on.png",1)
			; FileInstall("./Img/button_power_ready.png",InstallDir "/Img/button_power_ready.png",1)
			FileInstall("./Img/button_save_up.png",InstallDir "/Img/button_save_up.png",1)
			fileInstall("./img/button_edit.png",installDir "/img/button_edit.png",1)
			FileInstall("./Img/button_up.png",InstallDir "/Img/button_up.png",1)
			FileInstall("./Img/button_down.png",InstallDir "/Img/button_down.png",1)
			fileInstall("./img/button_vault_up.png",installDir "/img/button_vault_up.png",1)
			fileInstall("./img/button_vault_down.png",installDir "/img/button_vault_down.png",1)
			; fileInstall("./img/icon_running.png",installDir "/img/icon_running.png",1)
			; fileInstall("./img/icon_steeringwheel.png",installDir "/img/icon_steeringwheel.png",1)		
			FileInstall("./Img/keyboard_key_up.png",InstallDir "/img/keyboard_key_up.png",1)
			FileInstall("./Img/keyboard_key_down.png",InstallDir "/img/keyboard_key_down.png",1)
			fileInstall("./redist/Discord.exe",installDir "/redist/Discord.exe",1)
			fileInstall("./redist/getNir.exe",installDir "/redist/getNir.exe",1)
			fileInstall("./redist/soundVolumeView.exe",installDir "/redist/soundVolumeView.exe",1)
			fileInstall("./redist/sqlite3.dll",installDir "/redist/sqlite3.dll",1)
			fileInstall("./redist/incursionAudio.mp3",installDir "/redist/incursionAudio.mp3",1)
			FileInstall("./lib/ColorChooser.exe",InstallDir "/lib/ColorChooser.exe",1)
			FileInstall("./Redist/nircmd.exe",InstallDir "/Redist/nircmd.exe",1)
			FileInstall("./dapp_updater.exe",InstallDir "/dapp_updater.exe",1)
			FileInstall("./Img/help.png",InstallDir "/Img/help.png",1)
			FileInstall("./dapp_currentBuild.dat",InstallDir "/dapp_currentBuild.dat",1)			
			; FileInstall("./img/button_afk_ready.png",InstallDir "/img/button_afk_ready.png",true)
			fileInstall("./img/dapp_icon.ico",installDir "/img/dapp_icon.ico",1)
			fileInstall("./img/dapp_logo.png",installDir "/img/dapp_logo.png",1)
			fileInstall("./img/d2_MorgethBridge.png",installDir "/img/d2_MorgethBridge.png",1)
			fileInstall("./img/d2_MorgethBridge_thumb.png",installDir "/img/d2_MorgethBridge_thumb.png",1)
			fileInstall("./img/d2_ShuroChi.png",installDir "/img/d2_ShuroChi.png",1)
			fileInstall("./img/d2_ShuroChi_thumb.png",installDir "/img/d2_ShuroChi_thumb.png",1)
			fileInstall("./img/d2_CorruptedEggs.png",installDir "/img/d2_CorruptedEggs.png",1)
			fileInstall("./img/d2_CorruptedEggs_thumb.png",installDir "/img/d2_CorruptedEggs_thumb.png",1)
			fileInstall("./img/d2_NumbersOfPowerEmblem.png",installDir "/img/d2_NumbersOfPowerEmblem.png",1)
			fileInstall("./img/custom/dapp_titlebar.png",installDir "/img/custom/dapp_titlebar.png",1)
			fileInstall("./img/custom/dapp_titlebar2.png",installDir "/img/custom/dapp_titlebar2.png",1)
			fileInstall("./img/dapp_lightburst.png",installDir "/img/custom/dapp_lightburst.png",1)
			fileInstall("./img/lightburst_tl.png",installDir "/img/custom/lightburst_tl.png",1)
			fileInstall("./img/lightburst_tr.png",installDir "/img/custom/lightburst_tr.png",1)
			fileInstall("./img/lightburst_bl.png",installDir "/img/custom/lightburst_bl.png",1)
			fileInstall("./img/lightburst_br.png",installDir "/img/custom/lightburst_br.png",1)
			fileInstall("./img/lightburst_bottom.png",installDir "/img/custom/lightburst_bottom.png",1)
			fileInstall("./img/lightburst_top.png",installDir "/img/custom/lightburst_top.png",1)
			fileInstall("./img/lightburst_tl_light.png",installDir "/img/custom/lightburst_tl_light.png",1)
			fileInstall("./img/lightburst_tr_light.png",installDir "/img/custom/lightburst_tr_light.png",1)
			fileInstall("./img/lightburst_bl_light.png",installDir "/img/custom/lightburst_bl_light.png",1)
			fileInstall("./img/lightburst_br_light.png",installDir "/img/custom/lightburst_br_light.png",1)
			fileInstall("./img/lightburst_bottom_light.png",installDir "/img/custom/lightburst_bottom_light.png",1)
			fileInstall("./img/lightburst_top_light.png",installDir "/img/custom/lightburst_top_light.png",1)			
			fileInstall("./img/dapp_titlebar.png",installDir "/img/dapp_titlebar.png",1)
			fileInstall("./img/button_down_layer.png",installDir "/img/button_down_layer.png",1)
			fileInstall("./img/dapp_titlebar2.png",installDir "/img/dapp_titlebar2.png",1)
			fileInstall("./img/dapp_lightburst.png",installDir "/img/dapp_lightburst.png",1)
			fileInstall("./img/lightburst_bottom.png",installDir "/img/lightburst_bottom.png",1)
			fileInstall("./img/lightburst_top.png",installDir "/img/lightburst_top.png",1)
			fileInstall("./img/lightburst_bottom_light.png",installDir "/img/lightburst_bottom_light.png",1)
			fileInstall("./img/lightburst_top_light.png",installDir "/img/lightburst_top_light.png",1)
			fileInstall("./img/lightburst_tl.png",installDir "/img/lightburst_tl.png",1)
			fileInstall("./img/lightburst_tr.png",installDir "/img/lightburst_tr.png",1)
			fileInstall("./img/lightburst_bl.png",installDir "/img/lightburst_bl.png",1)
			fileInstall("./img/lightburst_br.png",installDir "/img/lightburst_br.png",1)
			fileInstall("./img/lightburst_tl_light.png",installDir "/img/lightburst_tl_light.png",1)
			fileInstall("./img/lightburst_tr_light.png",installDir "/img/lightburst_tr_light.png",1)
			fileInstall("./img/lightburst_bl_light.png",installDir "/img/lightburst_bl_light.png",1)
			fileInstall("./img/lightburst_br_light.png",installDir "/img/lightburst_br_light.png",1)
			fileInstall("./img/custom/lightburst_tile.png",installDir "/img/custom/lightburst_tile.png",1)
			fileInstall("./img/custom/lightburst_tile_flipped.png",installDir "/img/custom/lightburst_tile_flipped.png",1)
			fileInstall("./img/custom/lightburst_diag.png",installDir "/img/custom/lightburst_diag.png",1)
			fileInstall("./img/custom/lightburst_top_bar_light.png",installDir "/img/custom/lightburst_top_bar_light.png",1)
			fileInstall("./img/custom/lightburst_bottom_bar_light.png",installDir "/img/custom/lightburst_bottom_bar_light.png",1)			
			fileInstall("./img/custom/lightburst_top_bar_dark.png",installDir "/img/custom/lightburst_top_bar_dark.png",1)
			fileInstall("./img/custom/lightburst_bottom_bar_dark.png",installDir "/img/custom/lightburst_bottom_bar_dark.png",1)
			fileInstall("./img/icon_help.png",installDir "/img/icon_help.png",1)
			fileInstall("./img/d2_maps_thumb.png",installDir "/img/d2_maps_thumb.png",1)
			fileInstall("./img/d2_NumbersOfPowerEmblem_thumb.png",installDir "/img/d2_NumbersOfPowerEmblem_thumb.png",1)
			fileInstall("./img/d2_Glyphs.png",installDir "/img/d2_Glyphs.png",1)
			fileInstall("./img/d2_Glyphs_thumb.png",installDir "/img/d2_Glyphs_thumb.png",1)
			fileInstall("./img/d2_Runes.png",installDir "/img/d2_Runes.png",1)
			fileInstall("./img/d2_Runes_thumb.png",installDir "/img/d2_Runes_thumb.png",1)
			fileInstall("./img/d2_WishCodes_thumb.png",installDir "/img/d2_WishCodes_thumb.png",1)
			fileInstall("./img/button_glyph.png",installDir "/img/button_glyph.png",1)
			fileInstall("./img/button_glyph_down.png",installDir "/img/button_glyph_down.png",1)
			fileInstall("./img/d2_button_unbound.png",installDir "/img/d2_button_unbound.png",1)
			fileInstall("./img/toggle_left.png",installDir "/img/toggle_left.png",1)
			fileInstall("./img/toggle_right.png",installDir "/img/toggle_right.png",1)
			fileInstall("./img/button_quit.png",installDir "/img/button_quit.png",1)
			fileInstall("./img/button_x.png",installDir "/img/button_x.png",1)
			fileInstall("./img/button_up_arrow.png",installDir "/img/button_up_arrow.png",1)
			fileInstall("./img/button_down_arrow.png",installDir "/img/button_down_arrow.png",1)
			fileInstall("./img/ft_icon.png",installDir "/img/ft_icon.png",1)
			fileInstall("./img/custom/lightburst_blank.png",installDir "/img/custom/lightburst_blank.png",1)
			
			if !fileExist("c:\windows\fonts\move-x.otf") {
				fileInstall("./redist/move-x.otf","c:\windows\fonts\move-x.otf",1)
				runWait('reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "FontName (TrueType)" /t REG_SZ /d move-x.otf /f',,"Min")
			}
			
			pbConsole("`nINSTALL COMPLETED SUCCESSFULLY!")
			installLog("Copied Assets to: " InstallDir)	
		
			fileCreateShortcut(installDir "/dapp.exe", A_Desktop "\dapp.lnk",installDir,,"dapp - Destiny2 Companion",installDir "/img/dapp_icon.ico")
			fileCreateShortcut(installDir "/dapp.exe", A_StartMenu "\Programs\dapp.lnk",installDir,,"dapp - Destiny2 Companion",installDir "/img/dapp_icon.ico")
			IniWrite(installDir,installDir "/dapp.ini","System","InstallDir")
			Run(InstallDir "\" A_AppName ".exe")
			sleep(4500)
			ExitApp
		}
	}
}

createPbConsole(title) {
	transColor := "010203"
	ui.pbConsoleBg := gui()
	ui.pbConsoleBg.backColor := "303030"
	ui.pbConsoleHandle := ui.pbConsoleBg.addPicture("w700 h400 background555555","")
	;ui.pbConsoleBg.show("w700 h400 noActivate")
	;winSetTransparent(160,ui.pbConsoleBg)
	ui.pbConsole := gui()
	ui.pbConsole.opt("-caption")
	ui.pbConsole.backColor := "454545"
	ui.pbConsole.color := "b0b0b0"
	if !fileExist("c:\windows\fonts\move-x.otf") {
		fileInstall("./redist/move-x.otf","c:\windows\fonts\move-x.otf",1)
		runWait('reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" /v "FontName (TrueType)" /t REG_SZ /d move-x.otf /f',,"Min")
	}
	;winSetTransColor(transColor,ui.pbConsole)
	ui.pbConsoleTitle := ui.pbConsole.addText("x5 y5 w690 h35 section center backgroundc0c0c0 c202020",title)
	ui.pbConsoleTitle.setFont("q5 s20","move-x")
	drawOutlineNamed("pbConsoleTitle",ui.pbConsole,4,4,692,392,"b0b0b0","b0b0b0",1)

	drawOutlineNamed("pbConsoleOutside",ui.pbConsole,1,1,698,398,"444444","444444",1)
	drawOutlineNamed("pbConsoleOutside2",ui.pbConsole,2,2,696,396,"777777","777777",1)
	drawOutlineNamed("pbConsoleOutside3",ui.pbConsole,3,3,694,394,"999999","999999",1)

	ui.pbConsoleData := ui.pbConsole.addText("x10 y40 w680 h380 backgroundTrans c303030","")
	ui.pbConsoleData.setFont("q5 s16")
	ui.pbConsole.show("w700 h400 noActivate")
	;ui.pbConsoleBg.opt("-caption owner" ui.pbConsole.hwnd)
}

hidePbConsole(*) {
	guiVis(ui.pbConsole,false)
	guiVis(ui.pbConsoleBg,false)
}

showPbConsole(*) {
	guiVis(ui.pbConsole,false)
	guiVis(ui.pbConsoleBg,false)
}
pbConsole(msg) {
	if !hasProp(ui,"pbConsole")
		createPbConsole("dapp Console")
	ui.pbConsoleData.text := msg "`n" ui.pbConsoleData.text
}

testPbConsole() {
	createPbConsole("Test Console")
	loop 40 {
		pbConsole("This is test console message #" a_index)
		sleep(1500)
	}
	ui.pbConsole.destroy()
}

pbNotify(NotifyMsg,Duration := 10,YN := "",confirmCustomScript:="notifyConfirm",cancelCustomScript:="notifyCancel") {
	Transparent := 250
	ui.notifyGui			:= Gui()
	ui.notifyGui.Title 		:= "Notify"

	ui.notifyGui.Opt("+AlwaysOnTop -Caption +ToolWindow")  ; +ToolWindow avoids a taskbar button and an alt-tab menu item.
	ui.notifyGui.BackColor := "353535" ; Can be any RGB color (it will be made transparent below).
	ui.notifyGui.setFont("q5 s16")  ; Set a large font size (32-point).
	ui.notifyGui.AddText("c00FFFF center BackgroundTrans",NotifyMsg)  ; XX & YY serve to 00auto-size the window.
	ui.notifyGui.AddText("xs hidden")
	
	if (YN) {
		ui.notifyGui.AddText("xs hidden")
		ui.notifyGui.setFont("q5 s10")
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
	if (YN !="") {
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
				setTimer () => (sleep(duration),fadeOSD()),-duration
			}
				
		} 
		timeout:=0
	} 
	sleep(duration)
} 

pbWaitOSD() {
	ui.notifyGui.destroy()
	pbNotify("Timed out waiting for response.`nPlease try your action again",-1000)
}

FileFound(fileName,destination,fileDescription) {
	source := fileName
	dest := destination
	PreserveData := pbNotify('
	(
	' fileName ' - (' fileDescription ')
	from previous installation found. 
	Would you like to preserve it?
	)'
	,,1)
	
	if !(PreserveData) {
		MsgBox("FileInstall('" source "','" dest "',1)")
	} else {
		pbNotify('
		(
			If you encounter any issues with your saved data
			please re-run this install and answer "No" when
			asked if you would like to preserve the file.
		)'
		,3000)
	}
}
			
installLog(LogMsg) {
 	if !(DirExist(InstallDir "\Logs"))
	{
		DirCreate(InstallDir "\Logs")
		FileAppend(A_YYYY A_MM A_DD " [" A_Hour ":" A_Min ":" A_Sec "] Created Logs Folder`n",InstallDir "/Logs/persist.log")
	}

	FileAppend(A_YYYY A_MM A_DD " [" A_Hour ":" A_Min ":" A_Sec "] " LogMsg "`n",InstallDir "/Logs/persist.log")
}

bail(*) {
	return
}
	
autoUpdate() {	
	runWait("cmd /C start /b /wait ping -n 1 8.8.8.8 > " a_scriptDir "/.tmp",,"Hide")
	try {
		if !inStr(fileRead(a_scriptDir "/.tmp"),"100% loss") {
			checkForUpdates(1)
		} else {
				setTimer () => pbNotify("Network Down. Bypassing Auto-Update.",1000),-100
		}
		if fileExist("./.tmp")
			fileDelete("./.tmp")
	}
}	

CheckForUpdates(msg:=0,*) {
	ui.latestVersion:="1111"
		
	if fileExist("./.tmp")
		fileDelete("./.tmp")
		
	if fileExist("./dapp_currentBuild.dat") {
		ui.installedVersion := fileRead("./dapp_currentBuild.dat")
	} 
	ui.installedVersionText.text := "Installed:`t" substr(ui.installedVersion,1,1) "." substr(ui.installedVersion,2,1) "." substr(ui.installedVersion,3,1) "." substr(ui.installedVersion,4,1)
	ui.installedVersionText.redraw()
	ui.latestVersion := ui.installedVersion
	
	try {
		whr := ComObject("WinHttp.WinHttpRequest.5.1")
		whr.Open("GET", "https://raw.githubusercontent.com/obcache/dapp/main/dapp_currentBuild.dat", true)
		whr.Send()
		whr.WaitForResponse()
		ui.latestVersion := whr.ResponseText
	} catch {
		if(msg != 0) {
			ui.latestVersionText.text := "Available:`t--No Network--"
			notifyOSD("Network down.`nTry again later.",3000)
		}
	}
	
	if !inStr(ui.latestVersion,"404:") {
		if (ui.installedVersion < ui.latestVersion) {
			if(msg != 0) {
				ui.latestVersionText.text := "Available:`t" substr(ui.latestVersion,1,1) "." substr(ui.latestVersion,2,1) "." substr(ui.latestVersion,3,1) "." substr(ui.latestVersion,4,1)
				if ui.latestVersiontext.text > ui.CurrentVersionText.text
					run("./dapp_updater.exe")
					sleep(1000)
					exit
			} 
		} else {
			notifyOSD("No upgraded needed.`nInstalled: " substr(ui.installedVersion,1,1) "." substr(ui.installedVersion,2,1) "." substr(ui.installedVersion,3,1) "." substr(ui.installedVersion,4,1) "`nAvailable: " substr(ui.latestVersion,1,1) "." substr(ui.latestVersion,2,1) "." substr(ui.latestVersion,3,1) "." substr(ui.latestVersion,4,1),2500)
		}
	} else {
		ui.latestVersionText.text:="Latest:`t           ERROR"
		pbNotify("Cannot reach update site.`nCheck network.",5000)
	}


}
