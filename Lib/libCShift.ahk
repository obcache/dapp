#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}

isCShiftEnabled(*) {
	if cfg.cShiftEnabled
		return 1
	else
		return 0
}

hotIf(isCShiftEnabled)
hotkey("xButton1",nothing)
hotkey("xButton2",holdAlt)
hotkey("~LButton",nades)
hotkey("~MButton",ult)
hotkey("~RButton",melee)
hotIf()


nothing(*) {
}

holdAlt(*) {
	
	send("{LAlt Down}")
	keyWait("xButton2")
	send("{LAlt Up}")
}
nades(*) {
	if getKeyState("xButton1","P")
		send("[")
	;send("{LButton}")
}

ult(*) {
	if getKeyState("xButton1","P")
		send("\")
	;send("{MButton}")
}
melee(*) {
	if getKeyState("xButton1","P")
		send("]")
	;send("{RButton}")
}

