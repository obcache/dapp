#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}



^+[:: {
	static currOutputDeviceNum := 1
	ui.audioDevices := array()

	regAudioDevices := "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\MMDevices\Audio\Render\"
	cfg.allowedAudioOutput := ["S2MASTER","G432","Realtek","Yeti Classic","Tango"]

	RunWait('.\redist\SoundVolumeView.exe /scomma .tmp /columns "Device Name,Type,Name,Direction" | .\redist\GetNir.exe ""')
	loop read, ".\.tmp" {
		lineArr := strSplit(a_loopReadLine,",")
		if lineArr[2] == "Device" && lineArr[4] == "Render" && !inStr(lineArr[1],"VB-Audio") && !inStr(lineArr[1],"NVIDIA") && lineArr[3] != "Monitor"
			ui.audioDevices.push(lineArr[1] "\" lineArr[2] "\" lineArr[3] "\" lineArr[4])
	}

	tmpStr := ""
	loop ui.audioDevices.length {
		tmpStr .= ui.audioDevices[A_Index] "`n"
	}

		currOutputDeviceNum += 1	
	Run('.\Redist\soundVolumeView.exe /SetDefault "' ui.audioDevices[currOutputDeviceNum] '" "all"')
	TrayTip("Audio Changed:`n " strSplit(ui.audioDevices[currOutputDeviceNum],"\")[1],"dapp Audio Mgr","Iconi Mute")
}


