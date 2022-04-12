MENU:
	Menu, Tray, DeleteAll
	Menu, Tray, NoStandard
	Menu, Tray, Add, % PROGNAME WinName, ABOUT
	Menu, Tray, Default, % PROGNAME WinName
	Menu, Tray, Add,
	Menu, Tray, Add, &About...,ABOUT
	Menu, Tray, Add, &Exit, END
	Menu, Tray, Tip, % PROGNAME VERSION
    Gosub, MAIN
Return

; [MENU ABOUT]
ABOUT:
    Gui,2:Destroy
	Gui 2:Font, s12 w600 c0x333333, Segoe UI
	Gui 2:Add, Text, x15 y3 w180 h23 +0x200, % PROGNAME
	Gui 2:Font
	Gui 2:Font, s8 c0x333333, Segoe UI
	Gui 2:Add, Text, x26 y22 w165 h23 +0x200, % ODESIGNS
	Gui 2:Font
	Gui 2:Font, s9 c0x333333
	Gui 2:Add, Text, x30 y50 w120 h23 +0x200, % "File Version:`t" VERSION
	Gui 2:Add, Text, x30 y70 w160 h23 +0x200, % "Release Date:`t" RELEASEDATE
	Gui 2:Font
	Gui 2:Font, s9 c0x808080, Segoe UI
	Gui 2:Add, Link, x46 y100 w171 h23, % "<a href=""" PROGNAME """>" AUTHOR "</a>"
	Gui 2:Font
	Gui 2:Add, Button, x83 y123 w44 h23 gGuiClose2, &OK
	Gui 2:Show, w210 h150, "About"
Return

CONSOLE:
	
	Gui, +LastFound
	Gui , -Resize +SysMenu +Caption +AlwaysOnTop
	Gui , Add, GroupBox,  x15 y5 w280 h55, % PROGNAME
	Gui , Add, Button,  x30 y30 w120 h20 gSAVE_SESSION, SAVE the session
	Gui , Add, Button,  x150 y30 w120 h20 gRESTORE_SESSION, LOAD a session
	xPos := GUIPos.xPos
	yPos := GUIPos.yPos
	GUI , Show, x%xPos% y%yPos% w305 h66, % PROGNAME

return

GUICLOSE2:
	Gui 2:Hide
Return



SAVE_SESSION:

    Gui +OwnDialogs  			; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
	FileSelectFile, session_file, 16, % DATA_FILE, SAVE your current window session to a file, *.ses
    if (session_file != "") {

        SplitPath , session_file, name, dir, ext, name_no_ext, drive	; To fetch all info:
        if ext<>ses
                DATA_FILE := % session_file . ".ses"
                Else
                DATA_FILE := % session_file

        If FileExist(DATA_FILE)
            FileDelete, % DATA_FILE
        
        msg := "# file for window session" . Chr(13) . Chr(10)
        FileAppend, % msg, % DATA_FILE
        
        Enumerate_Windows()

        If active_window <> 0
            WinActivate, ahk_id %active_window%
    }
Return

RESTORE_SESSION:
    ;Gui +OwnDialogs  			; Force the user to dismiss the FileSelectFile dialog before returning to the main window.
	FileSelectFile, session_file, 3, % DATA_FILE, SAVE your current window session to a file, *.ses
    if (session_file != "") {
        if ( InStr(session_file, ".ses", false) ){

             Loop, Read, % session_file
                {
                    StringLeft, c1, A_LoopReadLine, 1
                    If (c1 = "#")
                        Continue ;

                    StringSplit, windata, A_LoopReadLine,#

                    StringTrimLeft, id,     windata1, 0
                    StringTrimLeft, minmax, windata2, 0
                    StringTrimLeft, x,      windata3, 0
                    StringTrimLeft, y,      windata4, 0
                    StringTrimLeft, wid,    windata5, 0
                    StringTrimLeft, hgt,    windata6, 0

                    If ErrorLevel
                    {
                        MsgBox, % "Error reading" . DATA_FILE
                        Exit
                    }

                    WinGet, procID, PID, ahk_id %id%
                    If procID = 0
                    {
                        ; this window has been closed 
                        ; since running WinSave; ignore:
                        Continue ;
                    }

                    WinGet, IsMinMax, MinMax, ahk_id %id%
                    If IsMinMax <> 0
                    {
                        WinRestore, ahk_id %id%
                        Sleep, % MOVE_TIME
                    }

                    WinMove, ahk_id %id%, , %x%, %y%, %wid%, %hgt%
                    Sleep, % MOVE_TIME

                    If (minmax < 0)
                    {
                        WinMinimize, ahk_id %id%
                        Sleep, % MOVE_TIME
                    }
                    Else If (minmax > 0)
                    {
                        WinMaximize, ahk_id %id%
                        Sleep, % MOVE_TIME
                    }
                }

                If active_window <> 0
                    WinActivate, ahk_id %active_window%
        } else {
            SplitPath , session_file, name, dir, ext, name_no_ext, drive
            MsgBox, 16, % "Invalid File", % "The selected file (" . name . ") is not a valid session file."
        }

    }

return