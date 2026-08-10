#Requires AutoHotkey v2.0
#SingleInstance Force

; 根据当前 AutoHotkey 进程位数自动选择 DLL
; 64 位 AHK -> CforCATIA_64.dll，32 位 AHK -> CforCATIA_32.dll
global dllName := (A_PtrSize = 8) ? "CforCATIA_64.dll" : "CforCATIA_32.dll"
global dllPath := A_ScriptDir "\" dllName

if (!FileExist(dllPath)) {
    MsgBox("找不到 DLL: " dllPath "`n请确保 " dllName " 与本脚本在同一目录。`n`nDLL not found: " dllPath "`nPlease make sure " dllName " is in the same directory as this script.", "错误 / Error", "Icon!")
    ExitApp
}

if (!InitDll()) {
    ExitApp
}

; 创建 GUI
mainGui := Gui(, "AHK 调用 " dllName " 测试 / AHK Test for " dllName)
mainGui.SetFont("s10", "Microsoft YaHei")
mainGui.Add("Text", "xm", "请把目标 CATIA 窗口切到最前，然后按对应按钮或数字键。`nBring the target CATIA window to the front, then press the corresponding button or number key.")
mainGui.Add("Button", "xm w120 h40", "1: 获取 Path`nGet Path").OnEvent("Click", OnPathClick)
mainGui.Add("Button", "x+20 yp w120 h40", "2: 获取 Document`nGet Document").OnEvent("Click", OnDocClick)
mainGui.Add("Button", "x+20 yp w120 h40", "3: 退出`nExit").OnEvent("Click", OnQuitClick)
global resultEdit := mainGui.Add("Edit", "xm w500 h150 r6 ReadOnly vResult", "")

mainGui.OnEvent("Close", OnGuiClose)
mainGui.Show("Center")

; 快捷键
Hotkey("1", OnPathClick)
Hotkey("2", OnDocClick)
Hotkey("3", OnQuitClick)

OnPathClick(*) {
    resultEdit.Value := GetPath()
}

OnDocClick(*) {
    resultEdit.Value := GetDocument()
}

OnQuitClick(*) {
    ExitApp
}

OnGuiClose(*) {
    CforCATIA_Shutdown()
    ExitApp
}

GetPath() {
    catiaInfo := GetCATIA()
    if (catiaInfo = "") {
        return "获取失败: " GetLastErrorText() "`nFailed to get: " GetLastErrorText()
    }
    catia := catiaInfo.obj
    try {
        path := catia.SystemService.Environ("Path")
        result := "Path 环境变量: " path "`nPath environment variable: " path
    } catch Error as e {
        result := "读取 Path 失败`nFailed to read Path: " e.Message
    }
    return result
}

GetDocument() {
    catiaInfo := GetCATIA()
    if (catiaInfo = "") {
        return "获取失败: " GetLastErrorText() "`nFailed to get: " GetLastErrorText()
    }
    catia := catiaInfo.obj
    try {
        doc := catia.ActiveDocument.FullName
        result := "当前文档: " doc "`nCurrent document: " doc
    } catch Error as e {
        result := "读取 Document 失败`nFailed to read Document: " e.Message
    }
    return result
}

GetCATIA() {
    ptrBuf := Buffer(A_PtrSize, 0)
    rc := DllCall(dllPath "\CforCATIA_GetFrontmostObject", "Ptr", ptrBuf, "Cdecl Int")
    if (rc != 0) {
        return ""
    }
    ptr := NumGet(ptrBuf, 0, "Ptr")
    if (ptr = 0) {
        return ""
    }
    ; DLL 返回的指针已被 AddRef 并缓存在 DLL 内部；AHK 不再额外 Release，
    ; 避免重复释放导致后续调用拿到无效对象
    catia := ComValue(9, ptr)
    return { obj: catia, ptr: ptr }
}

GetLastErrorText() {
    buf := Buffer(1024, 0)
    DllCall(dllPath "\CforCATIA_GetLastError", "Ptr", buf, "Int", 1024, "Cdecl Int")
    return StrGet(buf, "UTF-8")
}

InitDll() {
    rc := DllCall(dllPath "\CforCATIA_Init", "Cdecl Int")
    if (rc != 0) {
        MsgBox("初始化失败: " GetLastErrorText() "`nInitialization failed: " GetLastErrorText(), "错误 / Error", "Icon!")
        return false
    }
    return true
}

CforCATIA_Shutdown() {
    DllCall(dllPath "\CforCATIA_Shutdown", "Cdecl")
}