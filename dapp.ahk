A_FileVersion := "1.6.6.1"
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
    try
    {
        if a_isCompiled
            run '*runAs "' a_scriptFullPath '" /restart'
			else
            run '*runAs "' a_ahkPath '" /restart "' a_scriptFullPath '"'
    }
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

advProgress(progressAmount:=5,*) {
		ui.loadingProgress.value += progressAmount
}

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
cfgLoad(&cfg, &ui)
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

winSetRegion("34-0 w497 h234",ui.mainGui)
advProgress(5)

guiVis(ui.mainGui,false)
guiVis(ui.gameSettingsGui,false)
guiVis(ui.gameTabGui,false)

winSetAlwaysOnTop(cfg.alwaysOnTopEnabled,ui.MainGui)

ui.mainGui.Show("x" cfg.guix " y" cfg.guiy " w567 h213 NoActivate")
ui.gameSettingsGui.show("x" cfg.guiX+34 " y" cfg.guiY+30 " w495 h182 noActivate")
ui.gameTabGui.show("w497 h32 noActivate x" cfg.guiX+34 " y" cfg.guiY+183)

monitorResChanged()

advProgress(5)

if (cfg.startMinimizedEnabled) {
	ui.mainGui.hide()
	ui.gameSettingsGui.hide()
	ui.gameTabGui.hide()
}  

advProgress(5)

try {
	whr := ComObject("WinHttp.WinHttpRequest.5.1")
	whr.Open("GET", "http://sorryneedboost.com/cacheApp/recentIncursion.dat", true)
	whr.Send()
	whr.WaitForResponse()
	iniWrite(whr.ResponseText,cfg.file,"Game","LastIncursion")
}

ui.mainGuiTabs.choose(cfg.mainTabList[1])
ui.gameTabs.value:=cfg.activeGameTab
tabsInit()
fadeIn()

autoUpdate()
;msgBox(ui.installedVersion "`n" ui.latestVersion)
d2AutoGameConfigOverride()
ui.isActiveWindow:=""
loadScreen(0)
