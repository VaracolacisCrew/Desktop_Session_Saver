; Created by 		Cristófano Varacolaci
; For 			 	ObsessedDesigns Studios™, Inc.
; Version 			1.0.0.1
; Build             17:30 29.03.2022
;#####################################################################################
; INCLUDES
;#####################################################################################
#Include, inc\init.ahk

; creates the tray menu
Gosub, MENU

MAIN:
    GUIPos := gui_placement(ini_VERTICAL, ini_HORIZONTAL, ini_xOFFSET, ini_yOFFSET, 66, 305)
    Goto, CONSOLE
return

END:
GuiEscape:
GuiClose:
ExitApp