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
		ui.friendsList:=map(iniRead(cfg.file,"Game","FriendsList",""),",")
		ui.friendsListNicknames:=strSplit(iniRead(cfg.file,"Game","FriendsListNicknames",""),",")
		
		try
			ui.joinGui.destroy()
		ui.joinGui:=gui()
		ui.joinGui.opt("-caption -border alwaysOnTop owner" ui.gameSettingsGui.hwnd)
		ui.joinGui.backColor:=cfg.TabColor1
		ui.joinGui.color:="010203"
		winSetTransColor("010203",ui.joinGui)
		ui.joinGuiOutline:=ui.joinGui.addText("x0 y0 w437 h" (ui.friendsList.count*30)+64 " background" cfg.TrimColor1)
		ui.joinGuiBackground:=ui.joinGui.addText("x2 y2 w433 h" (ui.friendsList.count*30)+60 " background" cfg.TabColor1)
		ui.joinGuiTitlebar:=ui.joinGui.addText("x2 y2 w433 h" 24 " background" cfg.tabColor2)
		ui.joinGuiTitlebar.onEvent("click",WM_LBUTTONDOWN_callback)
		ui.joinGuiCloseButton:=ui.joinGui.addText("x286 y2 w26 h24 background450836")
		ui.joinGuiCloseButton.onEvent("click",closejoinGui)
		ui.joinGuiCloseLetter:=ui.joinGui.addText("x287 y1 w26 h26 backgroundTrans cCCCCCC","r")
		ui.joinGuiCloseLetter.setFont("s18","webdings")
		ui.joinGuiAddTextOutline:=("x40 y5 w250 h10 background" cfg.TrimColor2)
		;ui.joinGuiAddFriendOutline:=ui.joinGui.addText("x4 y4 w18 h18 background" cfg.TrimColor1)
		;ui.joinGuiAddFriend:=ui.joinGui.addPicture("x5 y5 w16 h16 background" cfg.OnColor,"./img/button_plus.png")
		ui.joinGuiAddText:=ui.joinGui.addText("x8 y2 w246 h20 backgroundTrans","Click to Join a Friend")		
		ui.joinGuiAddText.setFont("s14 c" cfg.fontColor1,"Prototype")
		ui.joinGuiAddText.onEvent("click",addFriend)
			
		ui.joinGuiAnchor:=ui.joinGui.addText("x5 y20 backgroundTrans section")
		static controlId:=0
		controlId+=1
		for friend,nickname in ui.friendsList {			
			ui.joinGui%a_index%:=""
			ui.joinGui%a_index%Nickname:=""
			ui.joinGui%a_index%MoveDown:=""
			ui.joinGui%a_index%MoveUp:=""

			try
				ui.joinGui%a_index%:=""
			try
				Up%a_index%:=""
			try
				Down%a_index%:=""
			try
				Delete%a_index%:=""
			; try
			; ui.joinGui%a_index%.opt("vTmp")
			if ui.friendsListNicknames.length >= a_index {
				if ui.friendsListNicknames[a_index] {
					ui.joinGuiBg%a_index%:=ui.joinGui.addText("vJoinBg" controlId "-" a_index  " section x5 y" (a_index*30) " w203 h26 background" cfg.tileColor)
					ui.joinGuiText%a_index%:=ui.joinGui.addText("vJoinText" controlId "-" a_index  " section x10 y" (a_index*30)+1 " w200 h26 backgroundTrans",friend)
				} else {
					ui.joinGuiBg%a_index%:=ui.joinGui.addText("vJoinBg" controlId "-" a_index  " section x5 y" (a_index*30) " w203 h26 background" cfg.tileColor)
					ui.joinGuiText%a_index%:=ui.joinGui.addText("vJoinText" controlId "-" a_index  " section x10 y" (a_index*30)+1 " w200 h26 backgroundTrans",friend)
				}
			} else {
					ui.joinGuiBg%a_index%:=ui.joinGui.addText("vJoinBg" controlId "-" a_index  " section x5 y" (a_index*30) " w203 h26 background" cfg.tileColor)
					ui.joinGuiText%a_index%:=ui.joinGui.addText("vJoinText" controlId "-" a_index  " section x10 y" (a_index*30)+1 " w200 h26 backgroundTrans",friend)
			}
			ui.joinGuiText%a_index%.setFont("s13 q5 c" cfg.titleFontColor,"prototype")
			ui.joinGuiText%a_index%.onEvent("click",joinFriend)
			ui.joinGuiBg%a_index%.onEvent("click",joinFriend)
			
			
			ui.joinGui%a_index%Nickname:=ui.joinGui.addText("vNicknameBg" controlId "-" a_index " section x210 y" (a_index*30) " w140 h26 background" cfg.tileColor)
			ui.joinGuiText%a_index%:=ui.joinGui.addText("vNicknameText" controlId "-" a_index  " section x214 y" (a_index*30)+1 " w137 h26 backgroundTrans",nickname)
			ui.joinGui%a_index%Nickname.onEvent("click",addNickname)
			
			; try
			; ui.joinGui%a_index%MoveUp.opt("vTmp")
			ui.joinGui%a_index%MoveUp:=ui.joinGui.addPicture("vUp" controlId "-" a_index  " x352 y" (a_index*30) " w25 h26 background" ((a_index>1) ? cfg.OnColor : cfg.OffColor),"./img/button_up_arrow.png")
			ui.joinGui%a_index%MoveUp.onEvent("click",(a_index>1) ? moveUp : doNothing)

			; try
			; ui.joinGui%a_index%MoveDown.opt("vTmp")
			ui.joinGui%a_index%MoveDown:=ui.joinGui.addPicture("vDown" controlId "-" a_index  " x379 y" (a_index*30) " w25 h26 background" ((a_index<ui.friendsList.count) ? cfg.OnColor : cfg.offColor),"./img/button_down_arrow.png")
			;ui.joinGui%a_index%MoveDown.onEvent("click",moveDown)
			ui.joinGui%a_index%MoveDown.onEvent("click",(a_index==ui.friendsList.count) ? doNothing : moveDown)

			
			; try
			; ui.joinGui%a_index%Delete.opt("vTmp")
			ui.joinGui%a_index%delete:=ui.joinGui.addPicture("vDelete" controlId "-" a_index  " x406 y" (a_index*30) " w26 h26 background" cfg.OnColor,"./img/button_delete.png")
			ui.joinGui%a_index%delete.onEvent("click",removeFriend)

			ui.joinGui%a_index%Detail:=ui.joinGui.addPicture("x5 y" a_index*30 " w427 h26 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
		}
		
		addNickname(this_ctrl,*) {
			friend_idx:=strSplit(this_ctrl.name,"-")[2]
			ui.addNicknameGui:=gui()
			ui.addNicknameGui.opt("-caption toolWindow alwaysOnTop owner" ui.joinGui.hwnd)
			ui.addNicknameGui.backColor:="010203"
			ui.addNicknameGui.color:="010203"
			winSetTransColor("010203",ui.addNicknameGui)
			ui.addNicknameGuiSubmit:=ui.addNicknameGui.addButton("hidden w0 h0 default")
			ui.addNicknameGuiSubmit.onEvent("click",saveNickname)
			ui.addNicknameGuiOutline:=ui.addNicknameGui.addText("x0 y0 w320 h46 background" cfg.TrimColor2)
			ui.addNicknameGuiBg:=ui.addNicknameGui.addText("x2 y2 w310 h42 background" cfg.TabColor2)
			ui.addNicknameGuiText:=ui.addNicknameGui.addText("x5 w245 y1 h20 backgroundTrans","Nickname")
			ui.addNicknameGuiText.setFont("s14 q5 c" cfg.FontColor2,"move-x")
			ui.addNicknameGui.setFont("s10 q5 c" cfg.FontColor1,"calibri")
			ui.addNicknameGuiInput:=ui.addNicknameGui.addEdit("r1 x5 y20 w260 background" cfg.TabColor1 " -wantReturn")
			
			ui.addNicknameGuiSaveButton:=ui.addNicknameGui.addPicture("x270 y4 w40 h38 backgroundTrans","./img/button_save.png")
			ui.addNicknameGuiSaveButton.opt("v" ui.addNicknameGuiInput.text)
			ui.addNicknameGuiSaveButton.onEvent("click",saveNickname)
			winGetPos(&joinX,&joinY,&joinW,&joinH,ui.joinGui)
			ui.addNicknameGui.show("x" joinX " y" joinY+joinH-30 " w314 h54")
				
			hotkey("ESC",addNicknameClose)
			hotkey("ESC","On")
			saveNickname(*) {
				
				ui.friendsListNicknames[friend_idx]:=ui.addNicknameGuiInput.text
				friendsListNicknamesStr:=""
				for nickname in ui.friendsListNicknames {
					friendsListNicknamesStr.=nickname ","
				}
				iniWrite(rtrim(friendsListNicknamesStr,","),cfg.file,"Game","FriendsListNicknames")
				ui.addNicknameGui.destroy()
				drawFriendsList()
				;joinFireteam()

				hotkey("ESC",closeJoinGui)
				hotkey("ESC","On")
				exit
			}
			addNicknameClose(*) {
				ui.addNicknameGui.destroy()
				hotkey("ESC",closeJoinGui)
				exit
			}
		}	


		
		joinFriend(this_ctrl,*) {
			a_clipboard:= "/join " ui.friendsList[strSplit(this_ctrl.name,"-")[2]]
			static vertCenter:=(((ui.friendsList.count*30)+30)/2)-30
			winGetPos(&tmpX,&tmpY,&tmpW,&tmpH,ui.joinGui)
			confirmMsgBody:=ui.joinGui.addText("x2 y2 w" tmpW-4 " h" tmph-8 " background" cfg.tabColor1)		
			confirmMsgOutline:=ui.joinGui.addText("x0 y0 w314 h" tmpH " background" cfg.trimColor1)
	
		
			confirmMsgTitle:=ui.joinGui.addText("center x2 y" (tmpH/2)-30 " w310 h28 background" cfg.tabColor1,"Copied to Clipboard:")
			confirmMsgTitle.setFont("s14 q5 c" cfg.fontColor1,"move-x")
		
			confirmMsgText:=ui.joinGui.addText("center x6 y" (tmpH/2) " w304 h24 background" cfg.tabColor2)
			confirmMsgText.setFont("s12 q5 c" cfg.fontColor2,"Prototype")
			confirmMsgText.text:=a_clipboard
			setTimer(clearConfirm,-2000)
				clearConfirm(*) {
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
		
		ui.joinGuiAddOutline:=ui.joinGui.addText("section center x5 y" (ui.friendsList.count*30)+30 " w304 h26 background" cfg.OutlineColor1)
		ui.joinGuiAdd:=ui.joinGui.addText("v" controlId "-" a_index  " section center x7 y" (ui.friendsList.count*30)+32 " w300 h20 background" cfg.titleBgColor,"Add New Friend")
		ui.joinGuiAdd.setFont("s14 bold q5 c" cfg.titleFontColor,"move-x")
		ui.joinGuiAdd.onEvent("click",addFriend)
		ui.joinGuiAddDetail:=ui.joinGui.addPicture("section x5 y" (ui.friendsList.count*30)+30 " w304 h26 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")

		doNothing(*) {
			return 0
		}
			
		moveUp(this_ctrl,*) {	
			friend_idx:=strSplit(this_ctrl.name,"-")[2]
			tmpFriendUp:=ui.friendsList[friend_idx-1]
			ui.friendsList[friend_idx-1]:=ui.friendsList[friend_idx]
			ui.friendsList[friend_idx]:=tmpFriendUp
						friendsListStr:=""
			for friend in ui.friendsList {
				friendsListStr.=friend ","
			}
			iniWrite(rtrim(friendsListStr,","),cfg.file,"Game","FriendsList")
			drawFriendsList()
		}
		moveDown(this_ctrl,*) {
		;msgBox(strSplit(this_ctrl.name,"-")[2] "`n" ui.friendsList.count )
			friend_idx:=strSplit(this_ctrl.name,"-")[2]
			tmpFriendDown:=ui.friendsList[friend_idx+1]
			ui.friendsList[friend_idx+1]:=ui.friendsList[friend_idx]
			ui.friendsList[friend_idx]:=tmpFriendDown
		
			friendsListStr:=""
			for friend in ui.friendsList {
				friendsListStr.=friend ","
			}
			iniWrite(rtrim(friendsListStr,","),cfg.file,"Game","FriendsList")
			drawFriendsList()
		}

		winGetPos(,,&joinW,&joinH,ui.joinGui)
		guiVis(ui.joinGui,false)
		ui.joinGui.show("h" (ui.friendsList.count*30)+60)
		ui.joinGuiOutline.opt("h" joinH+30)
		ui.joinGuiOutline.redraw()
		ui.joinGuiBackground.opt("h" joinH+30)
		ui.joinGuiBackground.redraw()
		winGetPos(&gsX,&gsY,&gsW,&gsH,ui.gameSettingsGui)
		ui.joinGui.hide()
		winGetPos(&friendsX,&friendsY,&friendsW,&friendsH,ui.joinGui)
	
		ui.joinGui.show("x" (gsX+(gsW/2))-(friendsW/2) " y" (gsY+(gsH/2))-(friendsH/2) " w480 h" (ui.friendsList.count*30)+64)
		guiVis(ui.joinGui,true)
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
		ui.addFriendGuiOutline:=ui.addFriendGui.addText("x0 y0 w320 h46 background" cfg.TrimColor2)
		ui.addFriendGuiBg:=ui.addFriendGui.addText("x2 y2 w310 h42 background" cfg.TabColor2)
		ui.addFriendGuiText:=ui.addFriendGui.addText("x5 w245 y1 h20 backgroundTrans","FRIEND'S BUNGIE ID")
		ui.addFriendGuiText.setFont("s14 c" cfg.FontColor2,"move-x")
		ui.addFriendGui.setFont("s10 c" cfg.FontColor1,"calibri")
		ui.addFriendGuiInput:=ui.addFriendGui.addEdit("r1 x5 y20 w260 background" cfg.TabColor1 " -wantReturn")
		
		ui.addFriendGuiSaveButton:=ui.addFriendGui.addPicture("x270 y4 w40 h38 backgroundTrans","./img/button_save.png")
		ui.addFriendGuiSaveButton.opt("v" ui.addFriendGuiInput.text)
		ui.addFriendGuiSaveButton.onEvent("click",saveFriend)
		winGetPos(&joinX,&joinY,&joinW,&joinH,ui.joinGui)
		ui.addFriendGui.show("x" joinX " y" joinY+joinH-30 " w314 h54")
			
		hotkey("ESC",addFriendClose)
		hotkey("ESC","On")
		saveFriend(*) {
			
			ui.friendsList.push(ui.addFriendGuiInput.text)
			ui.friendsListNicknames.push(" ")
			friendsListStr:=""
			for friend in ui.friendsList {
				friendsListStr.=friend ","
			}
			iniWrite(rtrim(friendsListStr,","),cfg.file,"Game","FriendsList")
			friendsListNicknamesStr:=""
			for nickname in ui.friendsListNicknames {
				friendsListNicknamesStr.=nickname ","
			}
			iniWrite(rtrim(friendsListNicknamesStr,","),cfg.file,"Game","FriendsListNicknames")
			ui.addFriendGui.destroy()
			drawFriendsList()
			;joinFireteam()

			hotkey("ESC",closeJoinGui)
			hotkey("ESC","On")
			exit
		}
		addFriendClose(*) {
			ui.addFriendGui.destroy()
			hotkey("ESC",closeJoinGui)
			exit
		}
	}	

	removeFriend(this_ctrl,*) {
	
		ui.confirmDeleteGui:=gui()
		ui.confirmDeleteGui.opt("-border -caption toolWindow alwaysOnTop owner" ui.joinGui.hwnd)
		ui.confirmDeleteGui.backColor:="010203"
		ui.confirmDeleteGui.color:="010203"
		winSetTransColor("010203",ui.confirmDeleteGui)
		ui.confirmDeleteGui.addText("x0 y0 w365 h55 backgroundb5b0b2")
		ui.confirmDeleteGui.addText("x1 y1 w363 h53 background" cfg.tabColor2)
		ui.confirmDeleteGui.addText("x2 y2 w361 h51 background" cfg.tabColor1)
		ui.confirmDeleteText:=ui.confirmDeleteGui.addText("center x7 y7 w240 h45 backgroundTrans","Confirm deletion of:")
		ui.confirmDeleteText.setFont("s14 q5 c" cfg.fontColor1,"Qargeo")
		ui.confirmDeleteName:=ui.confirmDeleteGui.addText("center x5 y23 w240 h45 backgroundTrans",ui.friendsList[strSplit(this_ctrl.name,"-")[2]])
		ui.confirmDeleteName.setFont("s16 q5 c" cfg.fontColor1,"Prototype")
		ui.confirmDeleteButton:=ui.confirmDeleteGui.addText("x242 w120 y5 h22 background" cfg.tabColor3)
		ui.confirmDeleteButtonDetail:=ui.confirmDeleteGui.addPicture("x242 w120 y15 h12 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
		ui.confirmDeleteButton.onEvent("click",confirmDelete)
		ui.confirmCancelButton:=ui.confirmDeleteGui.addText("x242 w120 y29 h22 background" cfg.tabColor3)
		ui.confirmCancelButtonDetail:=ui.confirmDeleteGui.addPicture("x242 w120 y39 h12 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
		ui.confirmCancelButton.onEvent("click",confirmCancel)
		ui.confirmDeleteLabel:=ui.confirmDeleteGui.addText("center x248 w110 y3 h22 backgroundTrans","DELETE")
		ui.confirmDeleteLabel.setFont("s14 q5 c" cfg.fontColor1 " bold","Prototype")
		ui.confirmCancelLabel:=ui.confirmDeleteGui.addText("center x248 w110 y27 h22 backgroundTrans","Cancel")
		ui.confirmCancelLabel.setFont("s14 q5 c" cfg.fontColor1 " bold","Prototype")
		ui.confirmDeleteGui.addPicture("x0 y1 w365 h15 backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
		ui.confirmDeleteGui.addPicture("x0 y40 w365 h14 backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")
		winGetPos(&jX,&jY,&jW,&jH,ui.joinGui.hwnd)
		ui.confirmDeleteGui.show("x" jX-25 " y" jY+(jH/2)-23)
		confirmDelete(*) {
			friend_idx:=strSplit(this_ctrl.name,"-")[2]
			ui.friendsList.removeAt(friend_idx)
			try
				ui.friendsListNicknames.removeAt(friend_idx)
			friendsListStr:=""
			for friend in ui.friendsList {
				friendsListStr.=friend ","
			}
			iniWrite(rtrim(friendsListStr,","),cfg.file,"Game","FriendsList")

			friendsListNicknamesStr:=""
			for nickname in ui.friendsListNicknames {
				friendsListNicknamesStr.=nickname ","
			}
			iniWrite(rtrim(friendsListNicknamesStr,","),cfg.file,"Game","FriendsListNicknames")
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
