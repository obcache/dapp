#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off
;Description: Provides support for working in AutoHotkey GUI windows
;Use: newGuid(),line(),drawOutline(),drawPanel(),drawTabs(),toggleGroup()

a_scriptName:="dapp.ahk"
a_libVersion:=20250310

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir "/../" a_scriptName)
	ExitApp
	Return
}


newGuid(*) {
	;returns a Global Unique ID in standard GUID format.
	return strReplace(trim(gui().addEdit(,comObject("ScriptLet.TypeLib").GUID).text,"{}"),"-","")
}

drawPanel(targetGui,panelX,panelY,panelW,panelH,panelColor,outlineColor,OutlineColor2,outlineWidth := 1,outlineOffset := 1,labelPos := "none",labelW := 0,labelH := 20,labelText := "",labelFont := "calibri",labelFontColor := "white",onClickFunction:=0) {
	static panelId := 0
	panelId+=1
	if (labelPos != "none") {
		labelX := panelX+panelW*labelPos
		labelY := panelY
		ui.label%panelId% := targetGui.addText("x" labelX " y" labelY+1 " w" labelW " h" labelH " background" outlineColor,"")
		ui.label%panelId%.setFont("q5 s10")
		ui.labelTop%panelId% := targetGui.addText("x" labelX+1 " y" labelY " w" labelW-2 " h" labelH " background" cfg.tabColor4 " center c" labelFontColor) 
		ui.labelTop%panelId%.setFont("q5 s10")
		ui.labelBottom%panelId% := targetGui.addText("x" labelX+1 " y" labelY+2 " w" labelW-2 " h" labelH " backgroundTrans center c" labelFontColor, labelText) 
		ui.labelBottom%panelId%.setFont("q5 s10")		
	}
	ui.backPanel%panelId% := targetGui.addText("x" panelX " y" panelY " w" panelW " h" panelH " background" panelColor)		
	ui.panelOutline2%panelId% := targetGui.addText("x" panelX+outlineOffset " y" panelY+outlineOffset " w" panelW-outlineOffset*2 " h" panelH-outlineOffset*2 " background" OutlineColor2)		
	ui.panelOutline1%panelId% := targetGui.addText("x" panelX+outlineOffset " y" panelY+outlineOffset " w" panelW-outlineWidth-outlineOffset*2 " h" panelH-outlineWidth-outlineOffset*2 " background" outlineColor)	
	ui.panel%panelId% := targetGui.addText("x" panelX+outlineWidth+outlineOffset " y" panelY+outlineWidth+outlineOffset " w" panelW-outlineWidth*2-outlineOffset*2 " h" panelH-outlineWidth*2-outlineOffset*2 " background" panelColor)
	ui.%panelId%cosmeticTop:= targetGui.addPicture("x" panelX+1 " y" panelY+1 " w" panelW-2 " h" (panelH/2-((panelH/2)-cfg.curveAmount))-1 " backgroundTrans","./img/custom/lightburst_top_bar_dark.png")
	ui.%panelId%cosmeticBottom:= targetGui.addPicture("x" panelX+1 " y" (panelY+panelH)-cfg.curveAmount " w" panelW-2 " h" (panelH/2-((panelH/2)-cfg.curveAmount))-1 " backgroundTrans","./img/custom/lightburst_bottom_bar_dark.png")

if onClickFunction !=0 {
		ui.backPanel%panelId%.onEvent("click",%onClickFunction%)
		ui.panel%panelId%.onEvent("click",%onClickFunction%)
		ui.panelOutline2%panelId%.onEvent("click",%onClickFunction%)
		ui.panelOutline1%panelId%.onEvent("click",%onClickFunction%)
		ui.%panelId%cosmeticTop.onEvent("click",%onClickFunction%)
		ui.%panelId%cosmeticBottom.onEvent("click",%onClickFunction%)
		
	}

	return panelId
}

createShading(objGui,objX,objY,objW,objH) {
		objGui.addPicture("x" objX " y" objY " w" objW " h" min(cfg.curveAmount,(objH/2)))
		objGui.addPicture("x" objX " y" objH-(min(cfg.curveAmount,(objH/2))) " w" objW " h" min(cfg.curveAmount,(objH/2)))
	}