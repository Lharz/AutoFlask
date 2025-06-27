; AutoHotkey Script - Pixel Color Monitor
; Presses keys 1-5 based on specific pixel colors
; Toggle ON/OFF with ² key
; Configuration loaded from config.ini

#NoEnv
#SingleInstance Force
SetBatchLines -1
SetKeyDelay -1, -1
SetMouseDelay -1
SetDefaultMouseSpeed 0
SetWinDelay -1
SetControlDelay -1
SendMode Input

; Global variables
ScriptActive := false
TimerRunning := false

; Variables to enable/disable each key individually
Key1_Enabled := true
Key2_Enabled := true
Key3_Enabled := true
Key4_Enabled := true
Key5_Enabled := true

; Configuration file
ConfigFile := A_ScriptDir . "\config.ini"

; Pixel coordinates to monitor (will be loaded from config file)
Pixel1_X := 422
Pixel1_Y := 1428
Pixel2_X := 483
Pixel2_Y := 1428
Pixel3_X := 543
Pixel3_Y := 1428
Pixel4_X := 607
Pixel4_Y := 1428
Pixel5_X := 667
Pixel5_Y := 1428

; Target colors (0xRRGGBB format - will be loaded from config file)
TargetColor1 := 0x030303
TargetColor2 := 0x030303
TargetColor3 := 0x030303
TargetColor4 := 0x030303
TargetColor5 := 0x030303

; Color tolerance (0 = exact color, higher = more tolerant)
ColorTolerance := 10

; Load configuration on startup
LoadConfig()

; Function to load configuration from INI file
LoadConfig() {
	global ConfigFile
	global Key1_Enabled
	global Key2_Enabled
	global Key3_Enabled
	global Key4_Enabled
	global Key5_Enabled
	global Pixel1_X
	global Pixel1_Y
	global Pixel2_X
	global Pixel2_Y
	global Pixel3_X
	global Pixel3_Y
	global Pixel4_X
	global Pixel4_Y
	global Pixel5_X
	global Pixel5_Y
	global Color1Hex
	global Color2Hex
	global Color3Hex
	global Color4Hex
	global Color5Hex
	global TargetColor1
	global TargetColor2
	global TargetColor3
	global TargetColor4
	global TargetColor5
	global ColorTolerance
	
    ; Create default config file if it doesn't exist
    if (!FileExist(ConfigFile)) {
        CreateDefaultConfig()
    }
    
    ; Load key states
    IniRead, Key1_Enabled, %ConfigFile%, Keys, Key1_Enabled, 1
    IniRead, Key2_Enabled, %ConfigFile%, Keys, Key2_Enabled, 1
    IniRead, Key3_Enabled, %ConfigFile%, Keys, Key3_Enabled, 1
    IniRead, Key4_Enabled, %ConfigFile%, Keys, Key4_Enabled, 1
    IniRead, Key5_Enabled, %ConfigFile%, Keys, Key5_Enabled, 1
	
    ; Load pixel coordinates
    IniRead, Pixel1_X, %ConfigFile%, Coordinates, Pixel1_X, 100
    IniRead, Pixel1_Y, %ConfigFile%, Coordinates, Pixel1_Y, 100
    IniRead, Pixel2_X, %ConfigFile%, Coordinates, Pixel2_X, 200
    IniRead, Pixel2_Y, %ConfigFile%, Coordinates, Pixel2_Y, 100
    IniRead, Pixel3_X, %ConfigFile%, Coordinates, Pixel3_X, 300
    IniRead, Pixel3_Y, %ConfigFile%, Coordinates, Pixel3_Y, 100
    IniRead, Pixel4_X, %ConfigFile%, Coordinates, Pixel4_X, 400
    IniRead, Pixel4_Y, %ConfigFile%, Coordinates, Pixel4_Y, 100
    IniRead, Pixel5_X, %ConfigFile%, Coordinates, Pixel5_X, 500
    IniRead, Pixel5_Y, %ConfigFile%, Coordinates, Pixel5_Y, 100
    
    ; Load target colors (in hexadecimal format without 0x)
    IniRead, Color1Hex, %ConfigFile%, Colors, TargetColor1, FF0000
    IniRead, Color2Hex, %ConfigFile%, Colors, TargetColor2, 00FF00
    IniRead, Color3Hex, %ConfigFile%, Colors, TargetColor3, 0000FF
    IniRead, Color4Hex, %ConfigFile%, Colors, TargetColor4, FFFF00
    IniRead, Color5Hex, %ConfigFile%, Colors, TargetColor5, FF00FF
    
    ; Convert hex colors to 0xRRGGBB format
    TargetColor1 := "0x" . Color1Hex
    TargetColor2 := "0x" . Color2Hex
    TargetColor3 := "0x" . Color3Hex
    TargetColor4 := "0x" . Color4Hex
    TargetColor5 := "0x" . Color5Hex
    
    ; Load color tolerance
    IniRead, ColorTolerance, %ConfigFile%, Settings, ColorTolerance, 10
    
    ; Convert strings to booleans for keys
    Key1_Enabled := (Key1_Enabled = "1" || Key1_Enabled = "true")
    Key2_Enabled := (Key2_Enabled = "1" || Key2_Enabled = "true")
    Key3_Enabled := (Key3_Enabled = "1" || Key3_Enabled = "true")
    Key4_Enabled := (Key4_Enabled = "1" || Key4_Enabled = "true")
    Key5_Enabled := (Key5_Enabled = "1" || Key5_Enabled = "true")
}

; Function to create default configuration file
CreateDefaultConfig() {
	global ConfigFile
	
    ConfigContent := "
(
[Keys]
; Enable or disable each key (1 = enabled, 0 = disabled)
Key1_Enabled=1
Key2_Enabled=1
Key3_Enabled=1
Key4_Enabled=1
Key5_Enabled=1

[Coordinates]
; Pixel coordinates to monitor (X, Y)
Pixel1_X=422
Pixel1_Y=1428
Pixel2_X=483
Pixel2_Y=1428
Pixel3_X=543
Pixel3_Y=1428
Pixel4_X=607
Pixel4_Y=1428
Pixel5_X=667
Pixel5_Y=1428

[Colors]
; Target colors in hexadecimal format (without 0x)
; Default: Red, Green, Blue, Yellow, Magenta
TargetColor1=030303
TargetColor2=030303
TargetColor3=030303
TargetColor4=030303
TargetColor5=030303

[Settings]
; Color tolerance (0 = exact color, higher = more tolerant)
ColorTolerance=10
)"
    
    FileAppend, %ConfigContent%, %ConfigFile%
    ToolTip, Configuration file created: %ConfigFile%, , , 2
    SetTimer, RemoveTempTooltip, 3000
}

; Function to save key states to config file
SaveKeyStates() {
    Key1Value := Key1_Enabled ? "1" : "0"
    Key2Value := Key2_Enabled ? "1" : "0"
    Key3Value := Key3_Enabled ? "1" : "0"
    Key4Value := Key4_Enabled ? "1" : "0"
    Key5Value := Key5_Enabled ? "1" : "0"
    
    IniWrite, %Key1Value%, %ConfigFile%, Keys, Key1_Enabled
    IniWrite, %Key2Value%, %ConfigFile%, Keys, Key2_Enabled
    IniWrite, %Key3Value%, %ConfigFile%, Keys, Key3_Enabled
    IniWrite, %Key4Value%, %ConfigFile%, Keys, Key4_Enabled
    IniWrite, %Key5Value%, %ConfigFile%, Keys, Key5_Enabled
}

; Hotkey for toggle ON/OFF (² key)
²::
	global ScriptActive
	global TimerRunning
	
    ScriptActive := !ScriptActive
    if (ScriptActive) {
        if (!TimerRunning) {
            ; Start with random delay between 200ms and 400ms (300ms ± 100ms)
            RandomDelay := GetRandomDelay()
            SetTimer, CheckPixels, %RandomDelay%
            TimerRunning := true
        }
        ShowPersistentTooltip()
    } else {
        SetTimer, CheckPixels, Off
        TimerRunning := false
        HidePersistentTooltip()
    }
return

; Function to check pixels
CheckPixels:
	global ConfigFile
	global Key1_Enabled
	global Key2_Enabled
	global Key3_Enabled
	global Key4_Enabled
	global Key5_Enabled
	global Pixel1_X
	global Pixel1_Y
	global Pixel2_X
	global Pixel2_Y
	global Pixel3_X
	global Pixel3_Y
	global Pixel4_X
	global Pixel4_Y
	global Pixel5_X
	global Pixel5_Y
	global Color1Hex
	global Color2Hex
	global Color3Hex
	global Color4Hex
	global Color5Hex
	global TargetColor1
	global TargetColor2
	global TargetColor3
	global TargetColor4
	global TargetColor5
	global ColorTolerance

    if (!ScriptActive)
        return
    
	DebugText := "Debug :"
	
    ; Check pixel 1
    if (Key1_Enabled) {
        PixelGetColor, CurrentColor1, %Pixel1_X%, %Pixel1_Y%
        if (ColorMatch(CurrentColor1, TargetColor1, ColorTolerance)) {
            Send, 1
			DebugText .= " 1"
        }
    }
    
    ; Check pixel 2
    if (Key2_Enabled) {
        PixelGetColor, CurrentColor2, %Pixel2_X%, %Pixel2_Y%
        if (ColorMatch(CurrentColor2, TargetColor2, ColorTolerance)) {
            Send, 2
			DebugText .= " 2"
        }
    }
    
    ; Check pixel 3
    if (Key3_Enabled) {
        PixelGetColor, CurrentColor3, %Pixel3_X%, %Pixel3_Y%
        if (ColorMatch(CurrentColor3, TargetColor3, ColorTolerance)) {
            Send, 3
			DebugText .= " 3"
        }
    }
    
    ; Check pixel 4
    if (Key4_Enabled) {
        PixelGetColor, CurrentColor4, %Pixel4_X%, %Pixel4_Y%
        if (ColorMatch(CurrentColor4, TargetColor4, ColorTolerance)) {
            Send, 4
			DebugText .= " 4"
        }
    }
    
    ; Check pixel 5
    if (Key5_Enabled) {
        PixelGetColor, CurrentColor5, %Pixel5_X%, %Pixel5_Y%
        if (ColorMatch(CurrentColor5, TargetColor5, ColorTolerance)) {
            Send, 5
			DebugText .= " 5"
        }
    }
    ;ToolTip, %DebugText%, 10, 50, 1
    ; Schedule next check with random delay
    RandomDelay := GetRandomDelay()
    SetTimer, CheckPixels, %RandomDelay%
return

; Function to compare colors with tolerance
ColorMatch(Color1, Color2, Tolerance) {
    if (Tolerance = 0)
        return (Color1 = Color2)
    
    R1 := (Color1 >> 16) & 0xFF
    G1 := (Color1 >> 8) & 0xFF
    B1 := Color1 & 0xFF
    
    R2 := (Color2 >> 16) & 0xFF
    G2 := (Color2 >> 8) & 0xFF
    B2 := Color2 & 0xFF
    
    return (Abs(R1 - R2) <= Tolerance && Abs(G1 - G2) <= Tolerance && Abs(B1 - B2) <= Tolerance)
}

; Function to generate random delay between 200ms and 400ms (300ms ± 100ms)
GetRandomDelay() {
    Random, RandomOffset, -100, 100
    return 500 + RandomOffset
}

; Function to show persistent tooltip at bottom left
ShowPersistentTooltip() {
	global Key1_Enabled
	global Key2_Enabled
	global Key3_Enabled
	global Key4_Enabled
	global Key5_Enabled
	
    StatusText := "Script ACTIVE - Keys: "
    StatusText .= (Key1_Enabled ? "1 " : "")
    StatusText .= (Key2_Enabled ? "2 " : "")
    StatusText .= (Key3_Enabled ? "3 " : "")
    StatusText .= (Key4_Enabled ? "4 " : "")
    StatusText .= (Key5_Enabled ? "5" : "")
    ToolTip, %StatusText%, 10, A_ScreenHeight-50, 1
}

; Function to hide persistent tooltip
HidePersistentTooltip() {
    ToolTip, , , , 1
}

; Function to update persistent tooltip
UpdatePersistentTooltip() {
	global ScriptActive
	
    if (ScriptActive) {
        ShowPersistentTooltip()
    }
}

; Hotkey to reload configuration (Ctrl+Alt+R)
^!r::
    LoadConfig()
    ToolTip, Configuration reloaded from %ConfigFile%, , , 2
    SetTimer, RemoveTempTooltip, 2000
    UpdatePersistentTooltip()
return

; Function to remove temporary tooltip
RemoveTempTooltip:
    ToolTip, , , , 2
    SetTimer, RemoveTempTooltip, Off
return

; Hotkey to get cursor coordinates (Ctrl+Alt+C)
;^!c::
;    MouseGetPos, MouseX, MouseY
;    PixelGetColor, MouseColor, %MouseX%, %MouseY%
;    ToolTip, Coordinates: %MouseX%`, %MouseY% - Color: %MouseColor%, , , 2
;    SetTimer, RemoveTempTooltip, 20000
;return

; Hotkey to close script (Ctrl+Alt+Q)
^!q::
    HidePersistentTooltip()
    ExitApp
return