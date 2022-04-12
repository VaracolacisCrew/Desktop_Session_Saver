/*
**************************
PROGRAM VARIABLES GLOBALS
**************************
*/
/*
**************************
PROGRAM VARIABLES GLOBALS
**************************
*/
global PROGNAME 			:= "Desktop Session Saver"
global VERSION 				:= "1.0.0.1"
global RELEASEDATE 			:= "March 30, 2022"
global AUTHOR 				:= "Cristófano Varacolaci"
global ODESIGNS 			:= "obsessedDesigns Studios™, Inc."
global AUTHOR_PAGE 			:= "http://obsesseddesigns.com"
global AUTHOR_MAIL 			:= "cristo@obsesseddesigns.com"

global DATA_FOLDER			:= "Data"
global CONFIGURATION_FILE	:= % DATA_FOLDER . "\__dss.ini"

global DATA_FILE            := % A_ScriptDir . "\session.ses"
global SPACES               := "                 "
global MOVE_TIME            := 100 ; time for a window to resize / minimize / maximize
global NumWindows           := 0
global active_window        := 0

global H_Compiled := RegexMatch(Substr(A_AhkPath, Instr(A_AhkPath, "\", 0, 0)+1), "iU)^(Desktop Session Saver).*(\.exe)$") && (!A_IsCompiled) ? 1 : 0
global mainIconPath := H_Compiled || A_IsCompiled ? A_AhkPath : "Data\icons\main.ico"

;read ini file for VARIABLES
variablesFromIni(CONFIGURATION_FILE)


VERSION := SYSTEM_version
VERSION := ((!VERSION) ? ("1.0.0.1") : (VERSION))

ini_LANG := SYSTEM_lang
ini_LANG := ((!ini_LANG) ? ("english") : (ini_LANG))

;---- [initial values]
ini_VERTICAL := POSITION_vertical
ini_VERTICAL := ((!ini_VERTICAL) ? ("bottom") : (ini_VERTICAL))

ini_HORIZONTAL := POSITION_horizontal
ini_HORIZONTAL := ((!ini_HORIZONTAL) ? ("center") : (ini_HORIZONTAL))

ini_xOFFSET := POSITION_xOffset
ini_xOFFSET := ((!ini_xOFFSET) ? (0) : (ini_xOFFSET))

ini_yOFFSET := POSITION_yOffset
ini_yOFFSET := ((!ini_yOFFSET) ? (50) : (ini_yOFFSET))

if !FileExist(CONFIGURATION_FILE) {
    FileCreateDir, % DATA_FOLDER
    FileAppend, % "[SYSTEM]`nversion=" . VERSION . "`nlang=" . ini_LANG . "`n`n[POSITION]`nvertical=" . ini_VERTICAL . "`nhorizontal=" . ini_HORIZONTAL . "`nxOffset=" . ini_xOFFSET . "`nyOffset=" . ini_yOFFSET, % CONFIGURATION_FILE
}

;---- [Initilization]
Change_Icon(mainIconPath)