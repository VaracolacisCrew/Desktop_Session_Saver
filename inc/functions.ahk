; Created by 		Cristófano Varacolaci
; For 			 	ObsessedDesigns Studios™, Inc.
; Version 			0.1.0.0
; Build 			16:30 2021.12.05
; ==================================================================================================================================
; Function:       variablesFromIni
; Description     read all variables in an ini and store in variables
; Usage:          variablesFromIni(_SourcePath, _VarPrefixDelim = "_")
; Parameters:
;  _SourcePath    	-  path to the ini file ["config/main.ini"]
;  _ValueDelim      -  This is the delimitator used for key 'delim' value function
;  _VarPrefixDelim 	-  This specifies the separator between section name and key name.
; 						All section names and key names are merged into single name.
; Return values:  
;     Variables from the ini, named after SECTION Delimiter KEY
; Change history:
;     1.1.00.00/2022.03.30
;     Added _ValueDelim
;     corrected an error, now it is working again
; Remarks:
variablesFromIni(_SourcePath, _ValueDelim = "=", _VarPrefixDelim = "_")
{
    Global
    if !FileExist(CONFIGURATION_FILE){
        MsgBox, 16, % "Error", % "The file " . CONFIGURATION_FILE . " does not esxist.`nWe are gonna create one with default values for you."
    } else {        
        Local FileContent, CurrentPrefix, CurrentVarName, CurrentVarContent, DelimPos
        FileRead, FileContent, %_SourcePath%
        If ErrorLevel = 0
        {
            Loop, Parse, FileContent, `n, `r%A_Tab%%A_Space%
            {
                If A_LoopField Is Not Space
                {
                    If (SubStr(A_LoopField, 1, 1) = "[")
                    {
                        StringTrimLeft, CurrentPrefix, A_LoopField, 1
                        StringTrimRight, CurrentPrefix, CurrentPrefix, 1
                    }
                    Else
                    {
                        ;MsgBox, , Title, % A_LoopField
                        DelimPos := InStr(A_LoopField, _ValueDelim)
                        StringLeft, CurrentVarName, A_LoopField, % DelimPos - 1
                        StringTrimLeft, CurrentVarContent, A_LoopField, %DelimPos%
                        %CurrentPrefix%%_VarPrefixDelim%%CurrentVarName% = %CurrentVarContent%
                    }
                    
                }
            }
        }
    }
}
; ==================================================================================================================================
; Function:       Ini_write
; Description     writes a value into an ini file
; Usage:          Ini_write(inifile, section, key)
; Parameters:
;  inifile        -  path to the ini file ["config/main.ini"]
;  section        -  section of the ini to read the key from
;  key            -  the key to delete from the ini file
;  value          -  the value to write on
; Return values:  
;     True on success, fail otherwise
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
;     oresult -> operation result
Ini_write(inifile, section, key, value="", ifblank=false) {
	;ifblank means if the key doesn't exist
	Iniread, v,% inifile,% section,% key

	if ifblank && (v == "ERROR")
		IniWrite,% value,% inifile,% section,% key
   oresult := ErrorLevel ? False : True
	if !ifblank
		IniWrite,% value,% inifile,% section,% key
   oresult := ErrorLevel ? False : True
   Return oresult
}
; ==================================================================================================================================
; Function:       Ini_read
; Description     Reads a value from an ini file
; Usage:          Ini_read(inifile, section, key)
; Parameters:
;  inifile        -  path to the ini file ["config/main.ini"]
;  section        -  section of the ini to read the key from
;  key            -  the key to delete from the ini file
; Return values:  
;     value of the searched key
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
Ini_read(inifile, section, key){
	Iniread, v, % inifile,% section,% key, %A_space%
	if v = %A_temp%
		v := ""
	return v
}
; ==================================================================================================================================
; Function:       Ini_delete
; Description     Deletes value in an ini file
; Usage:          Ini_delete(inifile, section, key)
; Parameters:
;  inifile        -  path to the ini file ["config/main.ini"]
;  section        -  section of the ini to read the key from
;  key            -  the key to delete from the ini file
; Return values:  
;     True on success, fail otherwise
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
;     oresult -> operation result
Ini_delete(inifile, section, key){
	IniDelete, % inifile, % section, % key
   oresult := ErrorLevel ? False : True
   Return oresult
}
; ==================================================================================================================================
; Function:       Change_Icon
; Description     Set the icon to the tray depending if it's compiled or not
; Usage:          changeIcon(file)
; Parameters:
;  file           -  path to the icon file ["icons/icon.ico"]
; Return values:  
;     nothing
; Change history:
;     1.0.00.00/2016-08-13
; Remarks:
;     Nothing
Change_Icon(file){
	if A_IsCompiled or H_Compiled 		; H_Compiled is a user var created if compiled with ahk_h
		Menu, tray, icon, % A_AhkPath
	else
		Menu, tray, icon, % file
}

; ==================================================================================================================================
; Function:       Enumerate_Windows
; Change history:
;     1.0.00.00/17:30 29.03.2022
; Remarks:
;     Nothing
Enumerate_Windows(){
    WinGet, IDs, List, , , Program Manager
    Loop, % IDs
    {
        StringTrimRight, id, IDs%a_index%, 0
        WinGetTitle, title, ahk_id %id%

        ; don't add windows with empty titles
        If title =
            Continue

        numwindows += 1

        ; store the index of the active window
        IfWinActive, ahk_id %id%
            active_window = %id%

        WinGet, IsMinMax, MinMax, ahk_id %id%
        If IsMinMax <> 0
        {
            WinRestore, ahk_id %id%
            Sleep, % MOVE_TIME
        }

        WinGetPos, x, y, wid, hgt, ahk_id %id%

        ; store window id, position & size as a formatted string:
        fields := % id . "#" . IsMinMax . "#" . x . "#" . y . "#" . wid . "#" . hgt

        fields := fields . Chr(13) . Chr(10)
        FileAppend, % fields, % DATA_FILE

        If (IsMinMax < 0)
        {
            WinMinimize, ahk_id %id%
            Sleep, % MOVE_TIME
        }
        Else If (IsMinMax > 0)
        {
            WinMaximize, ahk_id %id%
            Sleep, % MOVE_TIME
        }
    }
}

; ==================================================================================================================================
; Function:       gui_placement
; Change history:
;     1.0.00.00/11:00 30.03.2022
; Remarks:
;     Nothing
gui_placement(top_bottom, left_right, xOffset, yOffset, gui_height, gui_width){

    dpi_scale   := A_ScreenDPI
    dpi_scale   := (dpi_scale = 96) ? 1
                :  (dpi_scale = 120) ? 1.25
                :  (dpi_scale = 144 ) ? 1.50
                :  (dpi_scale = 168) ? 1.75
                :  (dpi_scale = 192) ? 2.00

    gui_height := gui_height * dpi_scale
    gui_width := gui_width * dpi_scale
    
    MonitorKeyCount := 1
    SysGet, MonitorName, MonitorName, MonitorKeyCount
    SysGet, MonitorArea, Monitor, MonitorKeyCount
    SysGet, MonitorWorkArea, MonitorWorkArea, MonitorKeyCount

    MainMonitor:= Object("Name", MonitorName, "ResTop", MonitorWorkAreaTop, "ResBott", MonitorWorkAreaBottom, "ResLeft", MonitorWorkAreaLeft, "ResRight", MonitorWorkAreaRight)

    if (top_bottom == "top") {
        yPos := MonitorAreaTop + yOffset
    } else if (top_bottom == "center") {
        yPos := (MonitorWorkAreaBottom / 2 ) - ( gui_height / 2 ) - 25
    } else {
        yPos := MonitorWorkAreaBottom - ( gui_height + yOffset) - 25
    }

    if (left_right == "left"){
        xPos := MonitorWorkAreaLeft + xOffset
    } else if ( left_right == "center" ) {
        xPos := (MonitorWorkAreaRight / 2) - (gui_width / 2)
    } else {
        xPos := MonitorWorkAreaRight - ( gui_width + xOffset )
    }

    GUIPos	        :=	Object()
    GUIPos.xPos	    :=	xPos
    GUIPos.yPos     :=  yPos

    return GUIPos
    
}
