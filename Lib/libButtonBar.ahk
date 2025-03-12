#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) { ;run main app
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}



; ui.d2ToggleAppFunctions.ToolTip 			:= "Toggles holdToCrouch"
; ui.d2LaunchDIMbutton.ToolTip				:= "Launch DIM in Browser"
; ui.d2LaunchVaultCleanerButton.toolTip 		:= "Launch Vault Cleaner"
; ui.d2LaunchLightGGButton.toolTip		:= "Launch LightGG.gg in Browser"
; ui.d2Launchd2CheckListButton.toolTip		:= "Launch D2Checklist.com in Browser"
; ui.d2LaunchDestinyTrackerButton.toolTip		:= "Launch DestinyTracker.com in Browser"
; ui.d2LaunchBrayTechButton.toolTip			:= "Launch Bray.Tech in Browser"
; ui.d2Launchd2FoundryButton.toolTip			:= "Launch d2Foundry"

; ui.d2ToggleAppFunctions.OnEvent("Click", d2ToggleAppFunctions)
; ui.d2ToggleAutoGameConfig.OnEvent("Click", d2ToggleAutoGameConfig)
; ui.dappLoadoutKey.onEvent("click",dappLoadoutKeyClicked)
; ui.dappLoadoutKeyData.onEvent("click",dappLoadoutKeyClicked)
; ui.dappToggleSprintKey.onEvent("click",dappToggleSprintKeyClicked)
; ui.dappToggleSprintKeyData.onEvent("click",dappToggleSprintKeyClicked)
; ui.d2LaunchDIMbutton.onEvent("click",d2launchDIMbuttonClicked)

; ui.d2LaunchD2checkListButton.onEvent("click",d2launchD2checklistButtonClicked)
; ui.d2LaunchLightGGButton.onEvent("click",d2launchLightGGButtonClicked)
; ui.d2LaunchDestinyTrackerButton.onEvent("click",d2LaunchDestinyTrackerButtonClicked)
; ui.d2Launchd2FoundryButton.onEvent("click",toggleGlyphWindow)
; ui.d2LaunchBrayTechButton.onEvent("click",d2LaunchBrayTechButtonClicked)

d2RedrawUI(*) {
	reload()
}

d2LaunchDIMButtonClicked(*) {
	ui.d2LaunchDIMbutton.value := "./img/button_DIM_down.png"
	setTimer () => ui.d2LaunchDIMbutton.value := "./img/button_DIM.png",-400
	
	run("chrome.exe http://app.destinyitemmanager.com")
}

d2LaunchVaultCleanerButtonClicked(*) {
	ui.d2LaunchVaultCleanerButton.value := "./img/button_vault_down.png"
	setTimer () => ui.d2LaunchVaultCleanerButton.value := "./img/button_vault_up.png",-400
	vaultCleaner()	
}

d2LaunchNewVaultCleanerButtonClicked(*) {
	ui.d2LaunchVaultCleanerButton.value := "./img/button_vault_down.png"
	setTimer () => ui.d2LaunchVaultCleanerButton.value := "./img/button_vault_up.png",-400
	vaultCleaner()	
}

d2LaunchLightGGButtonClicked(*) {
	ui.d2LaunchLightGGButton.value := "./img/button_LightGG_down.png"
	setTimer () => ui.d2LaunchLightGGButton.value := "./img/button_LightGG.png",-400
	run("chrome.exe https://www.Light.gg")
}
	
d2Launchd2CheckListButtonClicked(*) {
	ui.d2Launchd2ChecklistButton.value := "./img/button_d2Checklist_down.png"
	setTimer () => ui.d2Launchd2ChecklistButton.value := "./img/button_d2Checklist.png",-400
	run("chrome.exe https://www.d2checklist.com")
}

d2LaunchDestinyTrackerButtonClicked(*) {
	ui.d2LaunchDestinyTrackerButton.value := "./img/button_DestinyTracker_down.png"
	setTimer () => ui.d2LaunchDestinyTrackerButton.value := "./img/button_DestinyTracker.png",-400
	run("chrome.exe https://www.DestinyTracker.com")
}

d2Launchd2FoundryButtonClicked(*) {
		if winActive("ahk_exe destiny2.exe")
	; run("chrome.exe https://www.d2foundry.gg")
		 toggleGlyphWindow()
}	

d2LaunchBrayTechButtonClicked(lparam,wparam*) {
			toggleCodeWindow(lparam)
}
