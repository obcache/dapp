#Requires AutoHotKey v2.0+
#SingleInstance
#Warn All, Off

if (InStr(A_LineFile,A_ScriptFullPath)) { ;run main app
	Run(A_ScriptDir "/../dapp.ahk")
	ExitApp
	Return
}



toggleFireteam(*) {
	static fireteamVisible:=false
	fireteamVisible:=!fireteamVisible ? joinFireteam() : closeJoinGui()
}

joinFireteam(*) {
;		ui.button_link_2.down.opt("-hidden")
	


	
	drawFriendsList()

	
	drawFriendsList(*) {
		
		cfg.friendsBungieIDArr:=strSplit(iniRead(cfg.file,"Game","FriendsBungieIDs",""),",")
		cfg.friendsNicknameArr:=strSplit(iniRead(cfg.file,"Game","FriendsNicknames",""),",")

		
		try
			ui.joinGui.destroy()
		ui.joinGui:=gui()
		ui.joinGui.name:="joinGui"
		ui.joinGui.opt("-caption -border alwaysOnTop owner" ui.gameSettingsGui.hwnd)
		ui.joinGui.backColor:=cfg.TabColor1
		ui.joinGui.color:=ui.transparentColor
		winSetTransColor(ui.transparentColor,ui.joinGui)
		ui.joinGuiOutline:=ui.joinGui.addText("x0 y22 w637 h" (cfg.friendsBungieIdArr.length*28)+59 " background" cfg.TrimColor2)
		ui.joinGuiBackground:=ui.joinGui.addText("x2 y24 w633 h" (cfg.friendsBungieIdArr.length*28)+55 " background" cfg.TabColor4)
		ui.joinGuiTitlebar:=ui.joinGui.addText("hidden x2 y2 w609 h" 24 " background" cfg.tabColor2)


		;ui.joinGuiAddTextOutline:=ui.joinGui.addText("x40 y5 w250 h10 background" cfg.TrimColor2)
		;ui.joinGuiAddFriendOutline:=ui.joinGui.addText("x4 y4 w18 h18 background" cfg.TrimColor1)
		;ui.joinGuiAddFriend:=ui.joinGui.addPicture("x5 y5 w16 h16 background" cfg.OnColor,"./img/button_plus.png")
		ui.joinGuiAddText:=ui.joinGui.addText("hidden x8 y0 w246 h23 backgroundTrans","Click to copy /join command")		
		ui.joinGuiAddText.setFont("s14 q5 c" cfg.fontColor1,"Prototype")
		ui.joinGuiAddText.onEvent("click",addFriend)
		ui.joinGuiColOutline1:=ui.joinGui.addText("x3 y24 w207 h" (cfg.friendsBungieIdArr.length*28)+28+26 " background" cfg.auxColor1)
		ui.joinGuiColOutline2:=ui.joinGui.addText("x208 y24 w344 h" (cfg.friendsBungieIdArr.length*28)+28+26 " background" cfg.auxColor1)
		ui.joinGuiColOutline3:=ui.joinGui.addText("x550 y24 w56 h" (cfg.friendsBungieIdArr.length*28)+28+26 " background" cfg.auxColor1)
		ui.joinGuiColOutline4:=ui.joinGui.addText("x604 y24 w30 h" (cfg.friendsBungieIdArr.length*28)+28+26 " background" cfg.auxColor1)
		ui.joinGuiCloseButton:=ui.joinGui.addText("x606 y25 w26 h26 background652826")
		ui.joinGuiCloseButton.onEvent("click",closejoinGui)
		ui.joinGuiCloseLetter:=ui.joinGui.addText("x607 y25 w26 h26 backgroundTrans cCCCCCC","r")
		ui.joinGuiCloseLetter.setFont("s18 q5","webdings")
		ui.joinGuiCLoseLetter.onEvent("click",closeJoinGui)
		
		ui.joinGuiColHeader1:=ui.joinGui.addText("x5 y25 w203 h" 26 " background" cfg.auxColor1)
		ui.joinGuiColHeader2:=ui.joinGui.addText("x210 y25 w340 h26 background" cfg.auxColor1)
		ui.joinGuiColHeader3:= ui.joinGui.addText("x552 y25 w52 h26 background" cfg.auxColor1)
		ui.joinGuiColHeader4:=ui.joinGui.addText("hidden x606 y25 w26 h26 background" cfg.tabColor3)
		ui.joinGui%a_index%Detail0:=ui.joinGui.addPicture("x5 y" 25 " w627 h" cfg.curveAmount/2 " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
		ui.joinGui%a_index%Detail11:=ui.joinGui.addPicture("x5 y" 44 " w627 h" cfg.curveAmount/2 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")

		ui.joinGuiColHeader1Text:=ui.joinGui.addText("x9 y26 w160 h22 backgroundTrans c" cfg.fontColor2,"Bungie ID")
		
		ui.joinGuiColHeader2Text:=ui.joinGui.addText("x214 y26 w340 h22 backgroundTrans c" cfg.fontColor2,"Nickname")
		ui.joinGuiColHeader3Text:= ui.joinGui.addText("center x554 y26 w50 h22 backgroundTrans c" cfg.fontColor2,"Sort")
		
		ui.joinGuiColHeader1Text.setFont("s15 q5","move-x")
		ui.joinGuiColHeader2Text.setFont("s15 q5","move-x")
		ui.joinGuiColHeader3Text.setFont("s15 q5","move-x")
		ui.joinGuiColHeader1Text.onEvent("click",WM_LBUTTONDOWN_callback)
		ui.joinGuiColHeader2Text.onEvent("click",WM_LBUTTONDOWN_callback)
		ui.joinGuiColHeader3Text.onEvent("click",WM_LBUTTONDOWN_callback)
		ui.joinGuiAnchor:=ui.joinGui.addText("x5 y20 backgroundTrans section")
		
		static controlId:=0  
		
		loop cfg.friendsBungieIdArr.length {
		; ui.joinGui%a_index%:=""
			; ui.joinGui%a_index%Nickname:=""
			; ui.joinGui%a_index%MoveDown:=""
			; ui.joinGui%a_index%MoveUp:=""

			; try
				; ui.joinGui%a_index%:=""
			; try
				; Up%a_index%:=""
			; try
				; Down%a_index%:=""
			; try
				; Delete%a_index%:=""
			; try
			; ui.joinGui%a_index%.opt("vTmp")
				
			
			ui.joinGuiBg%a_index%:=ui.joinGui.addText("v_" cfg.friendsBungieIdArr[a_index] " section x5 w203 h28" ((mod(a_index+2,2)==0) ? " y" (a_index*28)+23 " background" cfg.tabColor2 : " y" (a_index*28)+23 " background" cfg.fontColor2))
			ui.joinGuiText%a_index%:=ui.joinGui.addText("v2_" cfg.friendsBungieIdArr[a_index] " section x10 y" (a_index*28)+27 " w200 h28 backgroundTrans",cfg.friendsBungieIdArr[a_index])
			ui.joinGuiBg%a_index%Nickname:=ui.joinGui.addText("v3_" cfg.friendsBungieIdArr[a_index] " section x210 y" (a_index*28)+23 " w340 h28 " ((mod(a_index+2,2)==0) ? " y" (a_index*28)+23 " background" cfg.tabColor2 : " y" (a_index*28)+23 " background" cfg.fontColor2))
			ui.joinGuiText%a_index%Nickname:=ui.joinGui.addText("v4_" cfg.friendsBungieIdArr[a_index] " section x214 y" (a_index*28)+27 " w337 h28 backgroundTrans",cfg.friendsNicknameArr[a_index])
		
			ui.joinGuiText%a_index%Nickname.setFont("s12 q5 " ((mod(a_index+2,2)==0) ? "c" cfg.fontColor2 : "c" cfg.tabColor2),"prototype")
			ui.joinGuiText%a_index%Nickname.onEvent("click",joinFriend)
			ui.joinGuiText%a_index%Nickname.onEvent("doubleClick",editNickname)
			ui.joinGuiBg%a_index%Nickname.onEvent("click",joinFriend)
			ui.joinGuiBg%a_index%Nickname.onEvent("doubleClick",editNickname)

			editNickname(this_ctrl,*) {
				this_ctrl.getPos(&jX,&jY,&jW,&jH)
				this_friendsBungieId:=strSplit(this_ctrl.name,"_")[2]
				ui.renameNickname:=ui.joinGui.addEdit("X" jX " y" jY " w" jW " h" jH " background" cfg.tabColor2 " c" cfg.fontColor2)
				ui.renameNickname.setFont("s14 c" cfg.fontColor2,"move-x")
				ui.renameNickname.text:=this_ctrl.text
				renameActive(*) {
					if controlGetFocus("A")==ui.renameNickname.hwnd
						return(1)
					else
						return(0)
				}
				submitRename(*) {
					loop cfg.friendsBungieIdArr.length {
						if cfg.friendsBungieIdArr[a_index] == this_friendsBungieId {
							cfg.friendsNicknameArr[a_index]:=ui.renameNickname.text
							ui.joinGuiText%a_index%Nickname.text:=ui.renameNickname.text
							break
						}
					}
					ui.renameNickname.text:=""
					ui.renameNickname.hide()
				}
				hotIf(renameActive)
				hotkey("{Esc}",cancelRename)
				hotkey("{Enter}",submitRename)
				hotIf()
				cancelRename(*) {
					ui.renameNickname.text:=""
					ui.renameNickname.hide()
				}
			}
			ui.joinGuiText%a_index%.setFont("s12 q5 c" ((mod(a_index+2,2)==0) ? cfg.fontColor2 : cfg.tabColor2),"prototype")
			ui.joinGuiText%a_index%.onEvent("click",joinFriend)
			ui.joinGuiBg%a_index%.onEvent("click",joinFriend)
			
			
			
			; try
			; ui.joinGui%a_index%MoveUp.opt("vTmp")
			ui.joinGui%a_index%MoveUp:=ui.joinGui.addText("v5_" cfg.friendsBungieIdArr[a_index] " x552 y" (a_index*28)+23 " w25 h28 " ((mod(a_index+2,2)==0) ? "background" cfg.tabColor2 : "background" cfg.fontColor2))
			ui.joinGui%a_index%MoveUpText:=ui.joinGui.addText("v5.2_" cfg.friendsBungieIdArr[a_index] " x552 y" (a_index*28)+23 " w25 h28 backgroundTrans","5")
			ui.joinGui%a_index%MoveUpText.setFont("s20 q5 c" ((a_index>1) ? cfg.OnColor : cfg.offColor),"Webdings")
			ui.joinGui%a_index%MoveUp.onEvent("click",(a_index>1) ? moveUp : doNothing)

			; try
			; ui.joinGui%a_index%MoveDown.opt("vTmp")
			ui.joinGui%a_index%MoveDown:=ui.joinGui.addText("v6_" cfg.friendsBungieIdArr[a_index] " x579 y" (a_index*28)+23 " w25 h28 " ((mod(a_index+2,2)==0) ? "background" cfg.tabColor2 : "background" cfg.fontColor2))
			ui.joinGui%a_index%MoveDownText:=ui.joinGui.addText("v6.2_" cfg.friendsBungieIdArr[a_index] " x579 y" (a_index*28)+23 " w25 h28 backgroundTrans","6")
			ui.joinGui%a_index%MoveDownText.setFont("s20 q5 c" ((a_index<cfg.friendsBungieIdArr.length) ? cfg.OnColor : cfg.offColor),"Webdings")
			;ui.joinGui%a_index%MoveDown.onEvent("click",moveDown)
			ui.joinGui%a_index%MoveDown.onEvent("click",(a_index==cfg.friendsBungieIdArr.length) ? doNothing : moveDown)
			
			; try
			; ui.joinGui%a_index%Delete.opt("vTmp")
		
			ui.joinGui%a_index%delete:=ui.joinGui.addPicture("v7_" cfg.friendsBungieIdArr[a_index] " x606 y" (a_index*28+23) " w26 h28 background" ((mod(a_index+2,2)==0) ? cfg.tabColor2 : cfg.tabColor2),"./img/button_delete.png")
			ui.joinGui%a_index%delete.onEvent("click",removeFriend)

			if mod(a_index+2,2)==1 
				ui.joinGui%a_index%Detail:=ui.joinGui.addPicture("x5 y" a_index*28+23 " w627 h" cfg.curveAmount/2 " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
			ui.joinGui%a_index%Detail2:=ui.joinGui.addPicture("x5 y" a_index*28+23 " w627 h" cfg.curveAmount/2 " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
		}
		
		
		joinFriend(this_ctrl,*) {
			a_clipboard:= "/join " strSplit(this_ctrl.name,"_")[2]
			static vertCenter:=(((cfg.friendsBungieIdArr.length*28)+28)/2)-28
			winGetPos(&tmpX,&tmpY,&tmpW,&tmpH,ui.joinGui)
			confirmMsgOutline:=ui.joinGui.addText("x2 y24 w" tmpW-8 " h" tmph-38 " background" cfg.tabColor1)
			confirmMsgBody:=ui.joinGui.addText("x2 y24 w" tmpW-8 " h" tmph-38 " background" cfg.tabColor1)		

		
			confirmMsgTitle:=ui.joinGui.addText("center x" 16 " y" (tmpH/2)-50 " w610 h40 background" cfg.tabColor1,"Copied to Clipboard:")
			confirmMsgTitle.setFont("s28 q5 c" cfg.fontColor1,"move-x")
		
			confirmMsgText:=ui.joinGui.addText("center x" 16 " y" (tmpH/2)+20 " w604 h42 background" cfg.tabColor2)
			confirmMsgText.setFont("s22 q5 c" cfg.fontColor2,"Prototype")
			confirmMsgText.text:=a_clipboard
			setTimer(clearConfirm,-2000)
				clearConfirm(*) {
				try {
				confirmMsgOutline.opt("hidden")
				confirmMsgBody.opt("hidden")
				confirmMsgTitle.opt("hidden")
				confirmMsgText.opt("hidden")
				confirmMsgOutline:=""
				confirmMsgBody:=""
				confirmMsgTitle:=""
				confirmMsgText:=""
				}
			}
		}
		
		
		
		ui.joinGuiAddOutline:=ui.joinGui.addText("hidden section center x5 y" (cfg.friendsBungieIdArr.length*28)+28+24 " w660 h30 background" cfg.OutlineColor2)
		ui.joinGuiAddTextBg:=ui.joinGui.addText("v" controlId "-" a_index  " section center x5 y" (cfg.friendsBungieIdArr.length*28)+28+24 " w627 h26 background" cfg.tabColor4)
		ui.joinGuiAdd:=ui.joinGui.addText("section center x5 y" (cfg.friendsBungieIdArr.length*28)+28+26 " w627 h26 backgroundTrans","Add New Friend")
		ui.joinGuiAdd.setFont("s14 bold q5 c" cfg.trimColor1,"move-x")
		ui.joinGuiAdd.onEvent("click",addFriend)
		ui.joinGuiAddDetail:=ui.joinGui.addPicture("section x5 y" (cfg.friendsBungieIdArr.length*28)+28+23 " w628 h26 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
		ui.joinGuiAddDetail2:=ui.joinGui.addPicture("section x3 y" (cfg.friendsBungieIdArr.length*28)+28+25 " w632 h26 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")

		doNothing(*) {
			return 0
		}
			
		moveUp(this_ctrl,*) {	
			loop cfg.friendsBungieIdArr.length {
				if cfg.friendsBungieIdArr[a_index]==strSplit(this_ctrl.name,"_")[2] {
					this_id:=cfg.friendsBungieIdArr[a_index]
					this_nick:=cfg.friendsNicknameArr[a_index]
					
					cfg.friendsBungieIdArr.removeAt(a_index)
					cfg.friendsNicknameArr.removeAt(a_index)
					cfg.friendsBungieIdArr.insertAt(a_index-1,this_id)
					cfg.friendsNicknameArr.insertAt(a_index-1,this_nick)
					break
				}
			}


			friendsBungieIdStr:=""
			friendsNicknameStr:=""
			loop cfg.friendsBungieIdArr.length {
				friendsBungieIdStr.=cfg.friendsBungieIdArr[a_index] ","
				friendsNicknameStr.=cfg.friendsNicknameArr[a_index] ","
			}
			iniWrite(rtrim(friendsBungieIdStr,","),cfg.file,"Game","FriendsBungieIDs")
			iniWrite(rtrim(friendsNicknameStr,","),cfg.file,"Game","FriendsNicknames")
			winGetPos(&ftX,&ftY,&ftW,&ftH,ui.joinGui)
			
			drawFriendsList()
			ui.joinGui.move(ftX,ftY,ftW,ftH)
		}
		
		
		moveDown(this_ctrl,*) {
			loop cfg.friendsBungieIdArr.length {
				if cfg.friendsBungieIdArr[a_index]==strSplit(this_ctrl.name,"_")[2] {
					this_id:=cfg.friendsBungieIdArr[a_index]
					this_nick:=cfg.friendsNicknameArr[a_index]
					
					cfg.friendsBungieIdArr.removeAt(a_index)
					cfg.friendsNicknameArr.removeAt(a_index)
					cfg.friendsBungieIdArr.insertAt(a_index+1,this_id)
					cfg.friendsNicknameArr.insertAt(a_index+1,this_nick)
					break
				}
			}

			friendsBungieIdStr:=""
			friendsNicknameStr:=""
			loop cfg.friendsBungieIdArr.length {
				friendsBungieIdStr.=cfg.friendsBungieIdArr[a_index] ","
				friendsNicknameStr.=cfg.friendsNicknameArr[a_index] ","
			}
			iniWrite(rtrim(friendsBungieIdStr,","),cfg.file,"Game","FriendsBungieIDs")
			iniWrite(rtrim(friendsNicknameStr,","),cfg.file,"Game","FriendsNicknames")
			winGetPos(&ftX,&ftY,&ftW,&ftH,ui.joinGui)
			
			drawFriendsList()
		}

		winGetPos(,,&joinW,&joinH,ui.joinGui)
		guiVis(ui.joinGui,false)
		ui.joinGui.show("h" (cfg.friendsBungieIdArr.length*28)+60+29)
		ui.joinGuiOutline.opt("h" joinH+30+29)
		ui.joinGuiOutline.redraw()
		ui.joinGuiBackground.opt("h" joinH+30+29)
		ui.joinGuiBackground.redraw()
		winGetPos(&gsX,&gsY,&gsW,&gsH,ui.gameSettingsGui)
		ui.joinGui.hide()
		winGetPos(&friendsX,&friendsY,&friendsW,&friendsH,ui.joinGui)
		winSetRegion("0-22 w638 h" (cfg.friendsBungieIdArr.length*28)+59,ui.joinGui)
		ui.friendsListHelp:=ui.joinGui.addPicture("hidden x5 y136 w16 h20 backgroundTrans","./img/icon_help.png")
		ui.friendsListHelp.onEvent("click",showFriendsHelp)
		ui.joinGui.show("x" (gsX+(gsW/2))-325 " y" (gsY+(gsH/2))-(friendsH*0.64) " w639 h" (cfg.friendsBungieIdArr.length*28)+64+29)
		guiVis(ui.joinGui,true)


		ui.friendHelpVisible:=false
		showFriendsHelp(*) {
			tooltip("Click on a Bungie ID to copy /join command to clipboard. Add, remove and reorder friends using the grid icons. Move the friends window by dragging the column headers.")
			setTimer(hideFriendsHelp,-2000)
		}
		
		hideFriendsHelp(*) {
			static mCtrl:=""
			while mCtrl==ui.friendsListHelp {
				mouseGetPos(,,,&mCtrl)
			}
			tooltip()
		}

	;addFriend()
	
	hotkey("ESC",closeJoinGui)
	hotKey("ESC","On")

	}
	

	addFriend(*) {
		ui.addFriendGui:=gui()
		ui.addFriendGui.opt("-caption toolWindow alwaysOnTop owner" ui.joinGui.hwnd)
		ui.addFriendGui.backColor:="010203"
		ui.addFriendGui.color:="010203"
		winSetTransColor("010203",ui.addFriendGui)
		ui.addFriendGuiSubmit:=ui.addFriendGui.addButton("hidden w0 h0 default")
		ui.addFriendGuiSubmit.onEvent("click",saveFriend)
		ui.addFriendGuiOutline:=ui.addFriendGui.addText("x0 y0 w637 h30 background" cfg.TrimColor2)
		ui.addFriendGuiBg:=ui.addFriendGui.addText("x2 y2 w633 h26 background" cfg.TabColor1)
	;	ui.addNicknameGuiBg:=ui.addFriendGui.addText("x407 y2 w140 h26 background" cfg.TabColor1)

		ui.addFriendGui.setFont("s14 q5 c" cfg.trimColor2,"Calibri")
		ui.addFriendGuiInput:=ui.addFriendGui.addEdit("x5 y2 w203 h26 -E0x200 background" cfg.TabColor2 " -wantReturn")
		ui.addNicknameGuiInput:=ui.addFriendGui.addEdit("x210 y2 w342 h26 -E0x200 background" cfg.tabColor2 " -wantReturn")

 		ui.addFriendGuiCancelButton:=ui.addFriendGui.addPicture("x558 y2 w26 h26 backgroundTrans","./img/button_dont.png")
		ui.addFriendGuiSaveButton:=ui.addFriendGui.addPicture("x588 y2 w26 h26 backgroundTrans","./img/button_save.png")
		ui.addFriendGuiSaveButton.opt("v" ui.addFriendGuiInput.text)
		ui.addFriendGuiSaveButton.onEvent("click",saveFriend)
		ui.addFriendGuiCancelButton.onEvent("click",addFriendClose)
		winGetPos(&joinX,&joinY,&joinW,&joinH,ui.joinGui)
		ui.addFriendGui.show("x" joinX " y" joinY+joinH-41 " w700 h32")
		ui.addFriendGui.addText("x5 y2 w203 h26 background" cfg.trimColor2)
		ui.addFriendGui.addtext("x210 y2 w344 h26 background" cfg.trimColor2)

		hotkey("ESC",addFriendClose)
		hotkey("ESC","On")
	}	

	saveFriend(*) {
		if ui.addFriendGuiInput.text=="" {
			notifyOSD("Bungie ID Cannot be blank.")
			Return
		}	
		loop cfg.friendsBungieIdArr.length {
			if cfg.friendsBungieIdArr[a_index] == ui.addFriendGuiInput.text {
				notifyOSD("Friend with name " ui.addFriendGuiInput.text " already exists.`nPlease try again with a unique name",4000)
				return
			}
		}	
		if ui.addNicknameGuiInput.text==""
			ui.addNicknameGuiInput.text:=ui.addFriendGuiInput.text
			
		cfg.friendsBungieIdArr.push(ui.addFriendGuiInput.text)
		cfg.friendsNicknameArr.push(ui.addNicknameGuiInput.text)
			
			friendsBungieIdStr:=""
			friendsNicknameStr:=""
			loop cfg.friendsBungieIdArr.length {
				friendsBungieIdStr.=cfg.friendsBungieIdArr[a_index] ","
				friendsNicknameStr.=cfg.friendsNicknameArr[a_index] ","
			}
			iniWrite(rtrim(friendsBungieIdStr,","),cfg.file,"Game","FriendsBungieIDs")
			iniWrite(rtrim(friendsNicknameStr,","),cfg.file,"Game","FriendsNicknames")
		ui.addFriendGui.destroy()
		drawFriendsList()
		;joinFireteam()

		hotkey("ESC","Off")
		exit
	}
	
		
	addFriendClose(*) {
		ui.addFriendGui.destroy()
		hotkey("ESC",closeJoinGui)
		exit
	}

	removeFriend(this_ctrl,*) {
	
		ui.confirmDeleteGui:=gui()
		ui.confirmDeleteGui.opt("-border -caption toolWindow alwaysOnTop owner" ui.joinGui.hwnd)
		ui.confirmDeleteGui.backColor:="010203"
		ui.confirmDeleteGui.color:="010203"
		winSetTransColor("010203",ui.confirmDeleteGui)
		ui.confirmDeleteGui.addText("x0 y0 w365 h55 background151515")
		ui.confirmDeleteGui.addText("x1 y1 w363 h53 backgroundb5b0b2")
		;ui.confirmDeleteGui.addText("x2 y2 w361 h51 background151515")
		ui.confirmDeleteGui.addText("x3 y3 w359 h49 background" cfg.tabColor1)
		ui.confirmDeleteText:=ui.confirmDeleteGui.addText("center x7 y7 w240 h45 backgroundTrans","Confirm deletion of:")
		ui.confirmDeleteText.setFont("s14 q5 c" cfg.fontColor1,"Qargeo")
		ui.confirmDeleteName:=ui.confirmDeleteGui.addText("center x5 y23 w240 h45 backgroundTrans",strSplit(this_ctrl.name,"_")[2])
		ui.confirmDeleteName.setFont("s16 q5 c" cfg.fontColor1,"Prototype")
		ui.confirmDeleteButton:=ui.confirmDeleteGui.addText("x242 w120 y4 h22 background" cfg.tabColor3)
		ui.confirmDeleteButtonDetail:=ui.confirmDeleteGui.addPicture("x242 w120 y15 h12 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
		ui.confirmDeleteButton.onEvent("click",confirmDelete)
		ui.confirmCancelButton:=ui.confirmDeleteGui.addText("x242 w120 y27 h24 background" cfg.tabColor3)
		ui.confirmCancelButtonDetail:=ui.confirmDeleteGui.addPicture("x242 w120 y39 h12 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
		ui.confirmCancelButton.onEvent("click",confirmCancel)
		ui.confirmDeleteLabel:=ui.confirmDeleteGui.addText("center x248 w110 y2 h22 backgroundTrans","DELETE")
		ui.confirmDeleteLabel.setFont("s14 q5 c943126","Prototype")
		ui.confirmCancelLabel:=ui.confirmDeleteGui.addText("center x248 w110 y25 h22 backgroundTrans","Cancel")
		ui.confirmCancelLabel.setFont("s14 q5 c" cfg.fontColor1,"Prototype")
		ui.confirmDeleteGui.addPicture("x0 y1 w365 h15 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
		ui.confirmDeleteGui.addPicture("x0 y40 w365 h14 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
		ui.confirmDeleteGui.addPicture("x356 y4 w6 h22 backgroundTrans","./img/custom/lightburst_right_bar_dark.png")
		ui.confirmDeleteGui.addPicture("x356 y27 w6 h22 backgroundTrans","./img/custom/lightburst_right_bar_dark.png")
		winGetPos(&jX,&jY,&jW,&jH,ui.joinGui.hwnd)
		ui.confirmDeleteGui.show("x" jX+30 " y" jY+(jH/2)-23)
		confirmDelete(*) {
		;	friend_idx:=strSplit(this_ctrl.text)[2]
			
			 
				;msgBox(strSplit(this_ctrl.name,"_")[2])
			loop cfg.friendsBungieIdArr.length {
				if cfg.friendsBungieIdArr[a_index] == strSplit(this_ctrl.name,"_")[2] {
					cfg.friendsBungieIdArr.removeAt(a_index)
					break
				}
					
			}

				friendsBungieIdStr:=""
			friendsNicknameStr:=""
			loop cfg.friendsBungieIdArr.length {
				friendsBungieIdStr.=cfg.friendsBungieIdArr[a_index] ","
				friendsNicknameStr.=cfg.friendsNicknameArr[a_index] ","
			}
			iniWrite(rtrim(friendsBungieIdStr,","),cfg.file,"Game","FriendsBungieIDs")
			iniWrite(rtrim(friendsNicknameStr,","),cfg.file,"Game","FriendsNicknames")

	
			try
				ui.addFriendGui.destroy()
			try
				ui.confirmDeleteGui.destroy()
				
			drawFriendsList()
		}
		
		confirmCancel(*) {
			try
				ui.addFriendGui.destroy()
			try
				ui.confirmDeleteGui.destroy()
			return
		}
		;joinFireteam()
		
		; ui.joinGui%friend_idx%:=""
		; ui.joinGui%friend_idx%moveUp:=""
		; ui.joinGui%friend_idx%MoveDown:=""
		; ui.joinGui%friend_idx%Delete:=""
		; ui.joinGuiAddOutline.move(,(ui.friendsList.count*30)+60)
		; ui.joinGuiAdd.move(,(ui.friendsList.count*30)+32)
		; ui.joinGuiAddDetail.move(,(ui.friendsList.count*30)+32)
		; ui.joinGui.show("h" (ui.friendsList.count*30)+60)
	
	}
}

closeJoinGui(*) {
	hotkey("ESC","Off")
	try
		ui.joinGui.destroy()
	try
		addFriendGui.destroy()
		
	ui.button_link_2.down.opt("hidden")
	exit
}
