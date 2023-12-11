;读取同名ini文件，注意au3只可以读取ansi格式的ini文件，编译后应在相同目录新建一个连接wlan.ini文件
$sFileName = StringRegExpReplace(@ScriptName, '\..*?$', "")
$sFilePath = @ScriptDir & "\" & $sFileName & ".ini"
$fnetfile = @ScriptDir & "\temp.txt"


$count = 1

Local $read = IniReadSection($sFilePath, "run")

;以cmd方式运行run配置项下项目
Run(@ComSpec & " /c " & $read[$count][1], "", @SW_HIDE) ;

$count = $count + 1
$successcount = 0

While 1
;$read[0][0]存储的是所有读取项数目
	If $count > $read[0][0] Then
		$count = 1
	EndIf
	
	Sleep(4111)
;将当前网络连接状态写入文件
	RunWait(@ComSpec & " /c netsh interface show interface > " & $fnetfile, "", @SW_HIDE)

	Local $hFileOpen = FileOpen($fnetfile, 0)
	Local $sFileRead = FileRead($hFileOpen)
	FileClose($hFileOpen)
	FileDelete($fnetfile)

	Local $aArray1 = StringRegExp($sFileRead, '(?i)(.*?)WLAN', 1)
	If @error <> 0 Then
		MsgBox(0, "", "获取网卡状态出错", 5)
		Exit
	EndIf

	Local $aArray2 = StringRegExp($aArray1[0], '(.*?已连接.*?)', 0)
	If $aArray2 = 0 Then
		$successcount = 0
		Run(@ComSpec & " /c " & $read[$count][1], "", @SW_HIDE) ;
		$count = $count + 1
	Else
		$successcount = $successcount + 1
		Sleep(111)
		If $successcount >= 2 Then
			MsgBox(0 + 48 + 0 + 262144, "", "成功连接wlan", 5)
			Exit
		EndIf
	EndIf
WEnd


#comments-start
;~ ini文件示例

[run]
cmd1=netsh wlan connect ssid=zMobile2 name=zMobile2
cmd2=netsh wlan connect ssid=zMobile1 name=zMobile1

#comments-end
