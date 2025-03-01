#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

if !(StrCompare(A_LineFile,A_ScriptFullPath)) {
	InstallDir 		:= IniRead("./dapp.ini","System","InstallDir",A_MyDocuments "\dapp")
	MainScriptName 	:= IniRead("./dapp.ini","System","MainScriptName","dapp")
	
	Run(a_scriptdir "/../" MainScriptName ".ahk")
	ExitApp
}


listChanged(*) {
	lvColSizes := [65,70,70,200]
	lvColNames := ["ListName","Action","Type","Options"]

	iniWrite(ui.listDDL.value,cfg.file,"System","SelectedList")
	sqliteQuery(cfg.dbFilename,"SELECT * FROM listActions WHERE listName='" ui.listDDL.text "'",&sqlResult)
	;sqliteShowResult(ui.ListsLV,sqlResult,lvColNames,lvColSizes)
	ui.ListsLV.delete()
	loop ui.ListsLV.getCount("col") 
		ui.ListsLV.deleteCol(1)
	loop lvColNames.length {
		ui.ListsLV.insertCol(a_index, "", lvColNames[a_index])
		if a_index == 1
			ui.ListsLV.modifyCol(a_index,lvColSizes[a_index]-1)
		else
			ui.ListsLV.modifyCol(a_index,lvColSizes[a_index]+1)
			
	}
	if (sqlResult.hasRows) {
		ui.mainGui.setFont("s8","Arial")
		loop sqlResult.rows.length {
			ui.ListsLV.add("", sqlResult.rows[a_index]*)
		drawGridLines()
		}
	}	
}

GuiListsTab(&ui,&cfg) {
	selectedRow := ""
	ui.MainGuiTabs.UseTab("5_Lists")
	ui.mainGui.setFont("s10")
	lvColSizes := [65,70,70,178]
	lvColNames := ["List","Action","Type","Options"]
	ui.mainGui.setFont("s10")
	drawPanel(ui.mainGui,40,40,400,170,cfg.themePanel1Color,cfg.themeBright2Color,cfg.themeDark2Color,1,1,.75,85,"Window Sets","Arial Slim",cfg.themeFont1Color )
	ui.mainGui.setFont("s10")
	drawPanel(ui.mainGui,442,40,85,170,cfg.themePanel1Color,cfg.themeBright2Color,cfg.themeDark2Color,1,1,1.75,40,"Actions","Arial Slim",cfg.themeFont1Color)

	workspaceArr := array()

	ui.SelectedList := iniRead(cfg.file,"Lists","SelectedList",1)
	sqliteQuery(cfg.dbFilename,"SELECT listName FROM lists",&sqlResult)
	
	if (sqlResult.hasRows) {
		rowNum := a_index
		loop sqlResult.rows.length {
			workspaceArr.push(sqlResult.rows[a_index][1])
		}
	}
	
	ui.listDDL := ui.mainGui.addComboBox("x45 y45 w150 r6 section altSubmit choose" ui.SelectedList " c" cfg.themeFont1Color " background" cfg.themePanel1Color,workspaceArr) 
	ui.listDDL.setFont("s9","arial")
drawOutlineNamed("AppListView",ui.mainGui,45,73,390,19,cfg.themeBright2Color,cfg.themeBorderDarkColor,2)
	drawOutlineNamed("AppListView",ui.mainGui,46,74,388,17,cfg.themeBorderLightColor,cfg.themeDark1Color,1)

	ui.listDDL.onEvent("change",listChanged)
	
	ui.mainGui.AddText("xs-8 y+-17 section hidden")
	ui.mainGui.setFont("s10 bold")
	for width in lvColSizes {
		ui.mainGui.AddText("x+0 ys+0 w" width " h18 center c" cfg.themeFont2Color " background" cfg.themePanel2Color, lvColNames[a_index])
		if a_index < lvColSizes.length 
			ui.mainGui.AddText("x+0 ys+0 w1 h18 background" cfg.themeBright2Color,"")
	}
	ui.mainGui.setFont("s8","Calibri Light")
	ui.ListsLV := ui.mainGui.addListView("x45 y92 w390 h114 0x3 0x2000 -Hdr c" cfg.themeFont2Color " background" cfg.themePanel2Color)
	ui.ListsLV.setFont("s9","Calibri")
	ui.ListsLV.onEvent("itemFocus",changeWinSelected)
		ui.mainGui.setFont("s9","calibri")

	ui.MainGui.AddText("x428 y50 section backgroundTrans w60 Right backgroundTrans","Add")
	ui.ListsAdd := ui.MainGui.AddPicture("x+5 ys+1 w30 h20 background" cfg.themeButtonReadyColor,"")
	ui.ListsAdd.OnEvent("Click",ListsAdd)
	ui.ListsAdd.Value := "./Img/button_down.png"
	ui.ListsAdd.toolTipData := "Add window to current workspace" 
	ui.MainGui.AddText("xs+0 y+0 section backgroundTrans w60 Right backgroundTrans","Delete")
	ui.ListsDelete := ui.MainGui.AddPicture("x+5 ys+0 w30 h20 background" cfg.themeButtonReadyColor,"")
	ui.ListsDelete.OnEvent("Click",ListsDelete)
	ui.ListsDelete.Value := "./Img/button_down.png"
	ui.ListsDelete.toolTip := "Delete selected window from current workspace"
	ui.RestoreWinPosLabel := ui.mainGui.addText("xs+0 y+20 w60 right section backgroundTrans","Apply")
	ui.restoreWinPosButton := ui.mainGui.addPicture("x+5 ys+1 w30 h20 background" cfg.themeButtonAlertColor,"./img/button_down.png")
	ui.restoreWinPosButton.onEvent("click",applyWinPos)
	ui.MainGui.SetFont("s9 c" cfg.ThemeFont1Color,"Calibri")

	changeWinSelected(*) {
		drawGridlines()
		this_winTitle := ui.ListsLV.getText(ui.ListsLV.GetNext(0, "F"),1)
		if (getWinOption(this_winTitle,"caption")) {
			ui.toggleCaption.opt("background" cfg.themeButtonOnColor)
		} else {
			ui.toggleCaption.opt("background" cfg.themeDisabledColor)
		}
		if (getWinOption(this_winTitle,"alwaysOnTop")) {
			ui.toggleOnTop.opt("background" cfg.themeButtonOnColor)
		} else {
			ui.toggleOnTop.opt("background" cfg.themeButtonAlertColor)
		}

		sqliteQuery(cfg.dbFilename,"SELECT processPath from winPositions where title='" this_winTitle "'",&this_processPath)
		if this_processPath.hasRows
			toolTip("Process Path: " this_processPath.rows[1][1])
	}
	
	
	drawGridLines(*) {
		ui.mainGui.setFont("s8","Arial")
		ui.mainGui.AddText("x45 y80 hidden section")
		loop sqlResult.rows.length
			ui.mainGui.addText("x46 y+17 w390 h1 background" cfg.themeFont2Color)
	}

	cfg.winOptionList := ["caption","alwaysOnTop","transparent","autoStart","autoStop"]
	getWinOption(winTitle,winOption) {
		sqliteQuery(cfg.dbFilename,"SELECT [optionEnabled] from [winOptions] WHERE [window]='" winTitle "' AND [option]= '" winOption "'",&tblWinOptions)
		
		if tblWinOptions.hasRows
			return tblWinOptions.rows[1][1]
		else {
			setWinOption(winTitle,winOption,false)
			return false
		}
	}
	
	setWinOption(this_winTitle,winOption,isEnabled) {
		sqliteExec(cfg.dbFilename,"DELETE FROM winOptions WHERE [Window]='" this_winTitle "' and [Option]= '" winOption "'",&result)
		sqliteExec(cfg.dbFilename,"INSERT INTO winOptions VALUES ('" this_winTitle "','" winOption "','" isEnabled "')",&result)
		;trayTip("Win: " this_winTitle "`nOption: " winOption "`nValue: " ((isEnabled) ? "On" : "Off"))
	}
	
	ListsAdd(*) {
		DialogBox("Click Any Window`nTo Add Current Positioning`nTo Workspace " ui.listDDL.text)
		keyWait("LButton","D")
		mouseGetPos(,,&winClicked)
		splitPath(winGetProcessPath(winClicked),,,,&winName)
		winGetPos(&currWinX,&currWinY,&currWinW,&currWinH,winClicked)
		sqliteExec(cfg.dbFilename,"INSERT into winPositions VALUES ('" ui.listDDL.text "','" winName "','" currWinX "','" currWiny "','" currWinW "','" currWinH "','','" winGetProcessPath(winClicked) "')",&insertResult)
		listChanged(lvColNames,lvColSizes)
		drawGridlines()
		DialogBoxClose()
	}
	
	winPosUpdate(*) {
	
	}
	
	ListsDelete(*) {
			sqliteExec(cfg.dbFilename,"DELETE from winPositions WHERE [Title]='" ui.ListsLV.getText(ui.ListsLV.GetNext(0, "F"),1) "'",&sqlExecResult)
			listChanged()
			setTimer () => drawGridLines(),-300
	}
	


	applyWinPos(*) {
		sqliteQuery(cfg.dbFilename,"SELECT * FROM winPositions WHERE workspace='" ui.listDDL.text "'",&sqlResult)
		
		if (sqlResult.hasRows) {
			loop sqlResult.rows.length {
				winNum := a_index
				processPath := sqlResult.rows[winNum][8]
				splitPath(processPath,&processName,&processDir)
				processRunning := false
				timeoutCounter := 0
				while (processRunning == false) || (timeoutCounter < 15) {
					timeoutCounter += 1
					if !(processExist(processName)) {
						run(processPath,processDir)
						sleep(2000)
					} else {
						processRunning := true
					}
				}
				this_win := winGetTitle("ahk_exe " processName)
				winMove(sqlResult.rows[winNum][3],sqlResult.rows[winNum][4],sqlResult.rows[winNum][5],sqlResult.rows[winNum][6],this_win)		
			}
		}
	}
	
	; toggleCaption(*) {
		; if (ui.toggleCaption.value == "./img/button_down.png")
			; setWinOption(winTitle,winOption,false)
		; else
			; setWinOption(winTitle,winOption,true)
	; }

	listChanged(lvColNames,lvColSizes)

	; getWinPos(this_button,*) {
			; DialogBox("Click a window to`nRecord its position.")
			; keyWait("LButton","D")
			; mouseGetPos(,,&winClicked)
			; winGetPos(&remWinX,&remWinY,&remWinW,&remWinH,winClicked)
			; iniWrite(%this_button.name%.x := remWinX "," %this_button.name%.y := remWinY "," %this_button.name%.w := remWinW "," %this_button.name%.h := remWinH "," winGetProcessName(winClicked),cfg.file,"AppDock",this_button.name "Coords")
			; iniWrite(%this_button.name%.winGetProcessPath(winClicked),cfg.file,"AppDock",this_button_name "ProcessPath")
			; DialogBoxClose()
			; ui.get%this_button.name%Pos.toolTipData := "Current Position:`nx: " remWinX ", y: " remWinY ", w: " remWinW ", h: " remWinH "`nClick to change" 
	; }

	
	
	drawDivider(DockY) { 
		MonitorGetWorkArea(cfg.AppDockMonitor, &Left, &Top, &Right, &Bottom)
		WorkAreaHeightWhenDocked :=  (Bottom - Top - cfg.DockHeight)
		ui.dividerGui.opt("-caption +alwaysOnTop +ToolWindow +0x4000000")
		ui.dividerGui.backColor := cfg.themeBright1Color
		ui.dividerGui.show("x" Left " y" DockY-8 " w" Right-Left " h12 NoActivate")
		winSetTransparent(255,ui.dividerGui)
	}
}