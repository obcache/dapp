A_FileVersion := "1.1.1.4"
#singleInstance
#warn all,off


discordRegKey := "HKCU\Software\Discord\Modules\discord_aegis"
discordValueName := "Path_x86"
timeoutValue := 60
timeoutCounter := 0

discordRegValue := regRead(discordRegKey,discordValueName,false)
if (discordRegValue) {
	discordPathArray := strSplit(discordRegValue,"\")
}

loop discordPathArray.length {
	if discordPathArray[a_index] == "modules" {
		break
	}
	discordPath .= discordPathArray[a_index] "\"
}

discordPath := subStr(discordPath,5)

run(discordPath "discord.exe")

while (timeoutCounter < timeoutValue) and !processExist("discord.exe") {
	sleep(1000)
	timeoutCounter += 1
}

if (processExist("discord.exe")) {
	sleep(5000)
	return
}
