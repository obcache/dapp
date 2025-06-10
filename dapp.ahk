A_FileVersion := "1.7.5.0"
a_appName := "dapp"
if (fileExist("./dapp_currentBuild.dat"))
	a_fileVersion := fileRead("./dapp_currentBuild.dat")

;@ahk2Exe-let fileVersion=%a_priorLine~U)^(.+"){1}(.+)".*$~$2% 
;@ahk2Exe-setName dapp
;@ahk2Exe-setVersion %a_fileVersion%
;@ahk2Exe-setFileVersion %a_fileVersion%

#requires autoHotkey v2.0+
#singleInstance
#warn All, Off

if !a_isAdmin {
    if a_isCompiled
		run '*runAs "' a_scriptFullPath '" /restart'
	else
		run '*runAs "' a_ahkPath '" /restart "' a_scriptFullPath '"'
    
    exitApp()
}

a_cmdLine := DllCall("GetCommandLine", "str")
a_restarted := 
			(inStr(a_cmdLine,"/restart"))
				? true
				: false

persistent()
installMouseHook()
installKeybdHook()
keyHistory(10)
setWorkingDir(a_scriptDir)
	
installDir 		:= a_myDocuments "\dapp"
configFileName 	:= "dapp.ini"
themeFileName	:= "dapp.themes"


preAutoExec(InstallDir,ConfigFileName)
cfg.file 		:= "./" ConfigFileName


d2ActivePanel := 1

; ui.AfkGui 		:= Gui()
dockApp 		:= Object()
workApp			:= Object()

cfg.ThemeFile	:= "./" ThemeFileName
ui.pinned 		:= 0
ui.hidden 		:= 0
ui.hwndAfkGui 	:= ""
ui.AfkHeight 	:= 170
ui.latestVersion := ""
ui.installedVersion := ""
ui.incursionDebug := false

cfgLoad(&cfg, &ui)
loadScreen() 
advProgress(5)
MonitorGet(MonitorGetprimary(),
	&primaryMonitorTop,
	&primaryMonitorRight,
	&primaryMonitorBottom)
MonitorGetWorkArea(MonitorGetprimary(),
	&primaryWorkAreaLeft,
	&primaryWorkAreaTop,
	&primaryWorkAreaRight,
	&primaryWorkAreaBottom)

advProgress(5)	



initTrayMenu()
initGui(&cfg, &ui)
advProgress(5)

initConsole(&ui)
advProgress(5)

#include <class_sqliteDb>
advProgress(1)
#include <class_lv_colors>
advProgress(1)
#include <lib_snbGuiTools>
advProgress(1)
#include <libGlobal>
advProgress(2)
#include <libGui>
advProgress(3)
#include <libWinMgr>
advProgress(1)
#include <libInstall>
advProgress(3)
#include <libGuiSetupTab>
advProgress(2)
#include <libKeybindUI>
advProgress(2)
#include <libGameAssists>
advProgress(1)
#include <libVaultCleaner>
advProgress(2)
#include <libFriendsList>
advProgress(2)
#include <libGameSettingsTab>
advProgress(4)
#include <libButtonBar>
advProgress(2)
#include <libIncursionCheck>
advProgress(2)
#include <libHotkeys>
advProgress(2)
#include <libRoutines>
advProgress(2)
#include <libThemeEditor>
advProgress(1)

OnExit(ExitFunc)

advProgress(5)

guiVis(ui.mainGui,false)
guiVis(ui.gameSettingsGui,false)
guiVis(ui.gameTabGui,false)

winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,ui.MainGui)
winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,ui.mainTabGui)
winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,ui.gameSettingsGui)
winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,ui.gameTabGui)

winSetRegion("34-0 w497 h234",ui.mainGui)
drawTabs()
ui.mainTabGui.show("x" cfg.guiX+34 " y" cfg.guiY " w497 h" 30)
ui.mainGui.Show("x" cfg.guiX " y" cfg.guiY " w532 h212 NoActivate")
ui.gameTabGui.show("w497 h32 noActivate x" cfg.guiX+34 " y" cfg.guiY+183)
ui.gameSettingsGui.show("x" cfg.guiX+34 " y" cfg.guiY+30 " w495 h183 noActivate")


;ui.gameSettingsGui.show("x" cfg.guiX+34 " y" cfg.guiY+30 " w495 h150 noActivate")


monitorResChanged()

advProgress(5)

if (cfg.startMinimizedEnabled) {
	ui.mainGui.hide()
	ui.mainTabGui.hide()
	ui.gameSettingsGui.hide()
	ui.gameTabGui.hide()
}  

advProgress(5)

; try {
	; whr := ComObject("WinHttp.WinHttpRequest.5.1")
	; whr.Open("GET", "http://sorryneedboost.com/cacheApp/recentIncursion.dat", true)
	; whr.Send()
	; whr.WaitForResponse()
	; iniWrite(whr.ResponseText,cfg.file,"Game","LastIncursion")
; }



;msgBox('here')
;tabsInit()
;msgBox('here')

fadeIn()
ui.mainGuiTabs.choose(cfg.mainTabList[1])
changeTabs(ui.mainTabGui,ui.mainGuiTabs)
ui.gameTabs.value:=cfg.activeGameTab

loadScreen(0)
autoUpdate()

d2AutoGameConfigOverride()
ui.isActiveWindow:=""

sbUpdate("Application Version Current")
sleep(2500)
sbUpdate("Ready...")
