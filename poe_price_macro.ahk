; POE Simple Price Check
; Version: 5.1 (2015/08/11)
;
; Written by Pete Waterman aka trackpete on reddit, pwx* in game
; http://exiletools.com (used to be http://poe.pwx.me)
;
; CONFIGURATION NOTE: You must configure the LeagueName properly. Otherwise it will default to
; "Standard" - press ^F and search for LeagueName and you will find where to set it.
;
; For a list of valid leagues, go here and scroll down to "Active Leagues:"
; http://api.exiletools.com/ladder
;
; USAGE NOTE: This requires your Path of Exile to be in Windowed (or Windowed Full Screen) 
; to work properly, otherwise the popup will just show in the background and you won't
; see it. Also, you *must* use the AHK from http://ahkscript.org NOT NOT autohotkey.com!
;
; WINDOWS 10 NOTE: You may need to run this .ahk file as an Administrator in order for the popups
; to show properly. 
;
; INDEXER NOTE: I do not use poe.trade in any way. I run my own indexer, which lets me
; provide far more in-depth and advanced statistics than I could get from using 
; poe.trade. The results will not always exactly match poe.trade. You can read more 
; about this here: http://exiletools.com/blog
;
; CURRENCY NOTE: The "Chaos" values you see in this data are "Chaos Equivalent Values."
; These values are *FIXED* and do not fluctuate with the actual rates you will get
; in trade/etc. They are for *reference* only, because people hated this macro when it
; returned prices in a bunch of different currency types. You can see the rates I
; use to create these reference values here: http://exiletools.com/rates
;
; AUTHOR'S NOTE: I'm not an AHK programmer, I learned everything on the fly. There is a
; good chance this code will look sloppy to experienced AHK programmers, if you have any
; advice or would like to re-write it, please feel free and let me know. 
;
; Wow, I clearly need to add some more NOTES. Maybe a NOTE on the weather? It's raining
; outside right now. 
;
; ===================================================
; Change Log
; v1 (2014/07/29): Initial Release
; v2 (2014/08/18): +Features
; v3 (2014/08/19): +Features
; v4 (2014/09/25): +Features
; v5 (2015/07/06): An all-new release!
; v5.1 (2015/08/11): Added proper encoding for item post data so my server sees + signs
;
;   Version 5 works in a completely different way from previous versions:
;   It now sends the raw item data to my service via POST and simply displays the results.
;
;   The big reason for this is that I can now do all item processing server-side. This allows
;   me to increment parsing options, such as adding Divination Card capability/etc., without
;   needing to push new versions to clients.
;
;

; == Startup Options ===========================================
#SingleInstance force
#NoEnv 
#Persistent ; Stay open in background
SendMode Input 
StringCaseSense, On ; Match strings with case.
Menu, tray, Tip, Exile Tools Price Check

If (A_AhkVersion <= "1.1.22")
{
    msgbox, You need AutoHotkey v1.1.22 or later to run this script. `n`nPlease go to http://ahkscript.org/download and download a recent version.
    exit
}

; == Variables and Options and Stuff ===========================

; *******************************************************************
; *******************************************************************
;                      SET LEAGUENAME BELOW!!
; *******************************************************************
; *******************************************************************
; Option for LeagueName - this must be specified.
; Remove the ; from in front of the line that has the leaguename you
; want, or just change the uncommented line to say what you want.
; Make sure all other LeagueName lines have a ; in front of them (commented)
; or are removed

global LeagueName := "warbands"
;global LeagueName := "tempest"
;global LeagueName := "standard"
;global LeagueName := "hardcore"

; showDays - This filters results to items that are in shops which have been updated
; without the last # of days. The default is 7. There is not really any need to change
; this unless you really want the freshest prices, then you can try setting this to 3 or 4.
; Any lower and it will start to return a much smaller result set.
global showDays := "7"

; runVersion - Sets the internal run version so that I can warn you if this macro
; is out of date.
global runVersion := "5.1"

; Decoder URL - DO NOT CHANGE THIS! This is a development option. 
; Instead of doing all the processing in AHK, this script simply sends basic
; item information to a decoder service which checks for price information against
; my own item index.
Global URL = "http://api.exiletools.com/item-report-text"

; How much the mouse needs to move before the hotkey goes away, not a big deal, change to whatever
MouseMoveThreshold := 40
CoordMode, Mouse, Screen
CoordMode, ToolTip, Screen

; There are multiple hotkeys to run this script now, defaults set as follows:
; ^p (CTRL-p) - Sends the item information to my server, where a price check is performed. Levels and quality will be automatically processed.
; ^i (CTRL-i) - Pulls up an interactive search box that goes away after 30s or when you hit enter/ok
;
; To modify these, you will need to modify the function call headers below
; see http://www.autohotkey.com/docs/Hotkeys.htm for hotkey options


; Price check w/ auto filters
^p::
IfWinActive, Path of Exile ahk_class Direct3DWindowClass 
{
  FunctionReadItemFromClipboard()
}
return

; Custom Input String Search
^i::
IfWinActive, Path of Exile ahk_class Direct3DWindowClass 
{
  ; This grabs a text message from my server so that I can add functionality
  ; to the interactive search and document it without users having to download
  ; a new macro.
  gettxt := ComObjCreate("WinHttp.WinHttpRequest.5.1")
  gettxt.Open("GET", "http://exiletools.com/price-macro-input.txt")
  gettxt.Send
  macroprompt := gettxt.ResponseText
    
  Prompt := macroprompt
  Global X
  Global Y
  MouseGetPos, X, Y	
  InputBox,ItemName,Interactive Price Search,%Prompt%,,500,300,X-160,Y - 250,,30,
  if ItemName {
	Global PostData = "v=" . runVersion . "&interactiveSearch=" . ItemName . "&league=" . LeagueName . "&showDays=" . showDays . ""
    FunctionPostItemData(URL, "null", "isInteractive")
  }
}
return


; == Function Stuff =======================================

FunctionPostItemData(URL, ItemData, InteractiveCheck)
{
  ; This is for debug purposes, it should be commented out in normal use
  ; MsgBox, %URL%
  ; MsgBox, %ItemData%
  
  ; URI Encode ItemData to avoid any problem
  ItemData := FunctionUriEncode(ItemData)
  
  if (InteractiveCheck = "isInteractive") {
    temporaryContent = Submitting interactive search to exiletools.com...
    FunctionShowToolTipPriceInfo(temporaryContent)	
  } else {
    temporaryContent = Submitting item information to exiletools.com...
    FunctionShowToolTipPriceInfo(temporaryContent)
    ; Create PostData
    Global PostData = "v=" . runVersion . "&itemData=" . ItemData . "&league=" . LeagueName . "&showDays=" . showDays . ""  
  }
  
  ; Send the PostData to my server and check the response!
  whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
  whr.Open("POST", URL)
  whr.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
  whr.Send(PostData)
  rawcontent := whr.ResponseText
  
  ; The return data has a special line that can be pasted into chat/etc., this
  ; separates that out and copies it to the clipboard.
  StringSplit, responsecontent, rawcontent,^ 
  clipboard = %responsecontent2%
  
  FunctionShowToolTipPriceInfo(responsecontent1)    
}

; This is for the tooltip, so it shows it and starts a timer that watches mouse movement.
; I imagine there's a better way of doing this. The crazy long name is to avoid
; overlap with other scripts in case people try to combine these into one big script.

FunctionShowToolTipPriceInfo(responsecontent)
{
    ; Get position of mouse cursor
    Sleep, 2
	Global X
    Global Y
    MouseGetPos, X, Y	
	gui, font, s15, Verdana 
    ToolTip, %responsecontent%, X - 135, Y + 30
    SetTimer, SubWatchCursorPrice, 100     

}

; == The Goods =====================================

; Watches the mouse cursor to get rid of the tooltip after too much movement
SubWatchCursorPrice:
  MouseGetPos, CurrX, CurrY
  MouseMoved := (CurrX - X)**2 + (CurrY - Y)**2 > MouseMoveThreshold**2
  If (MouseMoved)
  {
    SetTimer, SubWatchCursorPrice, Off
    ToolTip
  }
return


FunctionReadItemFromClipboard() {
  ; Only does anything if POE is the window with focus
  IfWinActive, Path of Exile ahk_class Direct3DWindowClass
  {
    ; Send a ^C to copy the item information to the clipboard
	; Note: This will trigger any Item Info/etc. script that monitors the clipboard
    Send ^c
    ; Wait 250ms - without this the item information doesn't get to the clipboard in time
    Sleep 250
	; Get what's on the clipboard
    ClipBoardData = %clipboard%
    ; Split the clipboard data into strings to make sure it looks like a properly
	; formatted item, looking for the Rarity: tag in the first line. Just in case
	; something weird got copied to the clipboard.
	StringSplit, data, ClipBoardData, `n, `r
		
	; Strip out extra CR chars so my unix side server doesn't do weird things
	StringReplace RawItemData, ClipBoardData, `r, , A

	; If the first line on the clipboard has Rarity: it is probably some item
	; information from POE, so we'll send it to my server to process. Otherwise
	; we just don't do anything at all.
    IfInString, data1, Rarity:
    {
	  ; Do POST / etc.	  
	  FunctionPostItemData(URL, RawItemData, "notInteractive")
	
	} 	
  }  
}



; Stole this from here: http://www.autohotkey.com/board/topic/75390-ahk-l-unicode-uri-encode-url-encode-function/
; Hopefully it works right!
FunctionUriEncode(Uri, Enc = "UTF-8")
{
	StrPutVar(Uri, Var, Enc)
	f := A_FormatInteger
	SetFormat, IntegerFast, H
	Loop
	{
		Code := NumGet(Var, A_Index - 1, "UChar")
		If (!Code)
			Break
		If (Code >= 0x30 && Code <= 0x39 ; 0-9
			|| Code >= 0x41 && Code <= 0x5A ; A-Z
			|| Code >= 0x61 && Code <= 0x7A) ; a-z
			Res .= Chr(Code)
		Else
			Res .= "%" . SubStr(Code + 0x100, -1)
	}
	SetFormat, IntegerFast, %f%
	Return, Res
}
StrPutVar(Str, ByRef Var, Enc = "")
{
	Len := StrPut(Str, Enc) * (Enc = "UTF-16" || Enc = "CP1200" ? 2 : 1)
	VarSetCapacity(Var, Len, 0)
	Return, StrPut(Str, &Var, Enc)
}
