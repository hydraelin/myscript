#Requires AutoHotkey v2.0-a
; 本脚本需搭配其他有hotkey或进程不退出的代码使用

;默认是open操作，要现将默认操作去掉
A_TrayMenu.Default := ""

winc_presses := 0

OnMessage 0x404, Received_AHK_NOTIFYICON	

Received_AHK_NOTIFYICON(wParam, lParam, nMsg, hwnd) {
	global winc_presses
	
	; user left-clicked tray icon
	if (lParam = 0x202) {
		if winc_presses > 0 ; SetTimer already started, so we log the keypress instead.	
		{
			winc_presses += 1
			return
		}
		
		; Otherwise, this is the first press of a new series. Set count to 1 and start 
		; the timer:
		winc_presses := 1	
		SetTimer After400, -500 ; Wait for more presses within a 500 millisecond window.
	}
	
	if (lParam = 0x203) {
	}	
}

After400() { ; This is a nested function. 
	global winc_presses
	if winc_presses = 1 ; 单击操作
	{
		WinMinimizeAll
	}
	else if winc_presses = 2 ; 双击操作
	{	
		
	}
	else if winc_presses > 2	
	{
		
	}

	; Regardless of which action above was triggered, reset the count to	
	; prepare for the next series of presses:	
	winc_presses := 0	 
}
