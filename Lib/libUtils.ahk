;libUtil
#SingleInstance
#Requires AutoHotKey v2.0+
#Warn All, Off

ConfigFile := (!A_Compiled ? FilesIn("../" A_ScriptFullPath,"*.ini"))[1] 
if (ConfigFile := FilesIn("../" A_ScriptFullPath,"*.ini")[1]) {
	SplitPath(ConfigFile,&selectedFilename,&selectedPath,&selectedExt,&selectedName,&selectedDrive)
	AppName := SelectedName
} 

if (InStr(A_LineFile,A_ScriptFullPath))
{
	Run(A_ScriptDir selectedPath "/" selectedFileName ".ahk")
	ExitApp
	Return
}

HasVal(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

; objSearch(objArr:="",propName:="",filter:="",invert:=0) {
	; resultArr:=[]
	; if !objArr[1] {
		; msgBox('not array')
		; return
	; }
	; for obj in objArr {
		; if !isObject(obj) {
			; msgBox("object array contains a non-object value at index " a_index)
			; continue
		; }
		
		; if !obj.hasProp(propName) {
			; msgBox("object at index " a_index " has no property named " propName)
			; continue
		; }
		
		; if inStr(obj.%propName%,filter) {
			; resultArr.push(obj)
		; }
	; }
	; if resultArr.length > 0 {
		; return resultArr
	; }
; }

; demoValues(*) {
	
	; guid:=newGuid()
	; tmpObjArr:=array()

	; static count:=0

	; loop 5 {
		; o:=object()
		; o.name:="obj" a_index
		; o.prop1:="test " count
		; count+=1
		; o.prop2:="test " count
		; tmpObjArr.push(o.clone())
	; }
	; return tmpObjArr
; }

; testObjSearch(demoValues(),"name","obj",0)

; testObjSearch(objArr,prop,filter,inv) {	
	; resultArr:=[]
	; resultGui:=gui()
	; propArr:=array()
	; for prop in objArr[1].ownProps
		; propArr.push(prop)
		
	; resultLV:=resultGui.addListview(,[propArr])
	; resultGui.show()
	; for obj in objSearch(objArr,prop,filter,inv) {
		; tmpArr:=array()
		; for prop in obj.ownProps() {
			; tmpArr.push(obj.%prop%)
		; }
		; resultLV.add(,tmpArr)
	; }
; }

; FilesIn(Path,Mask := "*.*")
; {
	; FileList := Array()
	; Loop %Path%\%Mask%
	; {
		; FileList.Push(%A_LoopFileName% 
	; Return FileList
; }

