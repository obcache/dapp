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
	return cfg.cShiftEnabled
}

hotIf(isCShiftEnabled)
hotkey("xButton1",nothing)
hotkey("xButton2",holdAlt)
hotkey("LButton",nades)
hotkey("MButton",ult)
hotkey("RButton",melee)

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
}

ult(*) {
	if getKeyState("xButton1","P")
		send("\")
}
melee(*) {
	if getKeyState("xButton1","P")
		send("]")
}

themeInit()
uiInit()

