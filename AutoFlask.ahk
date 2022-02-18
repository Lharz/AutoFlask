g_activeState := false

²::
if (g_activeState = false)
{
	ToolTip Auto flask enabled, 10, 10
	SetTimer, DoAction, 5000
	g_activeState := true
}
else
{
	ToolTip
	SetTimer, DoAction, Off
	g_activeState := false
}

DoAction:
if (GetKeyState("LCtrl") = 1 || GetKeyState("LShift") = 1 || GetKeyState("LAlt") = 1)
{
	return
}

if (g_activeState = true)
{
	SendInput 345
}
return
