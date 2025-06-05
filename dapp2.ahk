A_FileVersion := "2.0.0.0"
a_appName := "dapp2"
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

#include <class_sqliteDb>
#include <class_lv_colors>

persistent()
installMouseHook()
installKeybdHook()
keyHistory(10)
setWorkingDir(a_scriptDir)
	
installDir 		:= a_myDocuments "\dapp"
configFileName 	:= "dapp.ini"
themeFileName	:= "dapp.themes"

onExit(exitFunc)
exitFunc(*) {
	cfgWrite()
}

