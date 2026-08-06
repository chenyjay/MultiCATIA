#Requires AutoHotkey v2.0
#SingleInstance
#NoTrayIcon

; 直接模式：由 C# 通过 AutoHotkey 解释器调用，无需与 C# 进程通讯。
; 用法：AutoHotkey.exe RunMacroDirect.ahk <CATIA句柄> <宏库路径>

if (A_Args.Length < 2) {
    ExitApp 1
}

catiaHwnd := Integer(A_Args[1])
macroDir := A_Args[2]

; 关闭可能弹出的“未知命令”等干扰窗口
windowTitles := ["超级输入消息", "Power input message", "未知命令：", "Unknown Command:", "Unknown command:", "不可用命令:", "Unavailable command:", "* Syntax Error", "* 语法错误"]
for unKnownWin in windowTitles {
    GroupAdd "Unknown", unKnownWin
}
shapeTitles := ["Pad Definition", "ThickSurface Definition"]
for shapeTitle in shapeTitles {
    GroupAdd "shapeWin", shapeTitle
}
GroupAdd "弹窗", "警告"
GroupAdd "弹窗", "Warning"

; 宏相关窗口组，用于启动前清理和运行后监控
GroupAdd "宏标题", "宏"
GroupAdd "宏标题", "Macros"
GroupAdd "宏库标题", "宏库"
GroupAdd "宏库标题", "Macro libraries"
GroupAdd "创建目录标题", "创建新的宏目录"
GroupAdd "创建目录标题", "Create a new macro directory"

SetTimer 关闭弹框, 1500

; 主流程：带全局重试。若某次卡死或失败，关闭所有宏窗口后从头再来
maxAttempts := 3
success := false
lastError := ""
Loop maxAttempts {
    CloseExistingMacroWindows()
    result := RunMacroFlow(catiaHwnd, macroDir)
    if (result.success) {
        success := true
        break
    }
    lastError := result.error
    if (A_Index < maxAttempts) {
        Sleep 1000
    }
}

if (!success) {
    ExitApp 1
}

; 等待宏运行并生成 .dat，同时检测 CATIA 进程是否存活，最多等 30 秒
catiaPid := WinGetPID(catiaHwnd)
datFile := macroDir "\CATIA\" catiaPid ".dat"
prevTime := 0
if FileExist(datFile) {
    try prevTime := FileGetTime(datFile, "M")
}
startTime := A_TickCount
datUpdated := false
while (A_TickCount - startTime < 30000) {
    if (!ProcessExist(catiaPid)) {
        ExitApp 1
    }
    curTime := 0
    if FileExist(datFile) {
        try curTime := FileGetTime(datFile, "M")
    }
    if (curTime > prevTime) {
        datUpdated := true
        break
    }
    Sleep 500
}

Sleep 1000
ExitApp datUpdated ? 0 : 1

关闭弹框() {
    弹窗 := WinExist("ahk_group 弹窗")
    if 弹窗 = 0
        return
    try
        if ControlGetVisible(弹窗) = 1 {
            SendMessage(0x10, 0, 0, , 弹窗, , , , 60000)
        }
}

; ---------- 流程控制函数 ----------

RunMacroFlow(CATIA句柄, 宏库路径) {
    if (!EnsureCatiaWindow(CATIA句柄)) {
        return {success: false, error: "CATIA window not available"}
    }

    宏标题句柄 := OpenMacrosDialog(CATIA句柄, 3)
    if (!宏标题句柄) {
        return {success: false, error: "Failed to open macros dialog"}
    }

    ; 检查 MultiCATIA 库是否已加载
    listStrs := ""
    try {
        listStrs := ListViewGetContent("Col1", "SysListView321", 宏标题句柄)
    }
    if (InStr(listStrs, "MultiCATIA") = 0) {
        宏标题句柄 := LoadMacroLibrary(CATIA句柄, 宏标题句柄, 宏库路径)
        if (!宏标题句柄) {
            return {success: false, error: "Failed to load macro library"}
        }
        ; 重新读取列表，确认已加载
        try {
            listStrs := ListViewGetContent("Col1", "SysListView321", 宏标题句柄)
        }
        if (InStr(listStrs, "MultiCATIA") = 0) {
            return {success: false, error: "MultiCATIA not found after load"}
        }
    }

    ; 选择并运行脚本
    if (!RunMacroScript(宏标题句柄)) {
        return {success: false, error: "Failed to run macro script"}
    }

    return {success: true, error: ""}
}

EnsureCatiaWindow(hwnd) {
    if (!WinExist(hwnd)) {
        return false
    }
    if (WinGetMinMax(hwnd) = -1) {
        WinRestore hwnd
        Sleep 100
    }
    return true
}

CloseExistingMacroWindows() {
    CloseWindowGroup("宏标题")
    CloseWindowGroup("宏库标题")
    CloseWindowGroup("创建目录标题")
}

CloseWindowGroup(groupName) {
    loop 20 {
        hwnd := WinExist("ahk_group " groupName)
        if (!hwnd) {
            break
        }
        try WinClose(hwnd)
        Sleep 200
        if (WinExist(hwnd)) {
            try WinKill(hwnd)
        }
    }
}

OpenMacrosDialog(CATIA句柄, retries) {
    Loop retries {
        WinActivate CATIA句柄
        try WinWaitActive CATIA句柄,, 15
        Send "!{F8}"
        try {
            hwnd := WinWait("ahk_group 宏标题",, 15)
            if (hwnd) {
                return hwnd
            }
        }
        Sleep 1000
    }
    return 0
}

LoadMacroLibrary(CATIA句柄, 宏标题句柄, 宏库路径) {
    WinActivate(宏标题句柄)
    try WinWaitActive(宏标题句柄,, 15)

    ; 打开“宏库”对话框
    SendMessage(0xF5, 0, 0, "Button2", 宏标题句柄, , , , 60000)
    宏库标题句柄 := 0
    try {
        宏库标题句柄 := WinWait("ahk_group 宏库标题",, 15)
    }
    if (!宏库标题句柄) {
        return 0
    }
    WinActivate(宏库标题句柄)
    try WinWaitActive(宏库标题句柄,, 15)

    ControlChooseIndex(2, "ComboBox1", 宏库标题句柄)
    Sleep 500

    macroDirs := ""
    try {
        macroDirs := ControlGetItems("ListBox1", 宏库标题句柄)
    }
    loadMacro := true
    for macroDir in macroDirs {
        if (macroDir = 宏库路径) {
            loadMacro := false
            PostMessage(0x0185, 0, -1, "ListBox1", 宏库标题句柄)
            PostMessage(0x0185, 1, A_Index - 1, "ListBox1", 宏库标题句柄)
            Sleep 3000
            ControlChooseIndex A_Index, "ListBox1", 宏库标题句柄
            break
        }
    }

    if (loadMacro) {
        SendMessage 0xF5, 0, 0, "Button3", 宏库标题句柄, , , , 60000
        创建目录句柄 := 0
        try {
            创建目录句柄 := WinWait("ahk_group 创建目录标题",, 15)
        }
        if (创建目录句柄) {
            WinActivate(创建目录句柄)
            try WinWaitActive(创建目录句柄,, 15)
            ControlSetText 宏库路径, "Edit1", 创建目录句柄
            Sleep 100
            WinClose 创建目录句柄
            try {
                SendMessage 0xF5, 0, 0, "Button1", 创建目录句柄
            }
        }
    }

    try WinClose 宏库标题句柄
    try SendMessage 0xF5, 0, 0, "Button1", 宏库标题句柄
    Sleep 100

    ; 确认列表已刷新；若为空，由外层重试
    ScriptCount := 0
    try {
        ScriptCount := ListViewGetContent("Count", "SysListView321", 宏标题句柄)
    }
    if (ScriptCount = 0) {
        return 0
    }

    return 宏标题句柄
}

RunMacroScript(宏标题句柄) {
    ; 选中 MultiCATIA.catvbs
    选择列表视图指定项("MultiCATIA.catvbs", "SysListView321", 宏标题句柄)
    ControlFocus "Button3", 宏标题句柄
    Sleep 100

    ; 点击运行（先 Post WM_KEYDOWN 回车，再 SendMessage BM_CLICK 备用）
    PostMessage(0x0100, 0xD, 0, "Button3", 宏标题句柄)
    try SendMessage(0xF5, 0, 0, "Button3", 宏标题句柄)

    ; 监控宏对话框是否在 10 秒内关闭；若未关闭，强制关闭并视为失败
    start := A_TickCount
    while (A_TickCount - start < 10000) {
        if (!WinExist(宏标题句柄)) {
            return true
        }
        Sleep 200
    }

    ; 超时未关闭，尝试强制关闭，外层会重试
    try WinKill(宏标题句柄)
    return false
}

选择列表视图指定项(goalStr, listView, WinID) {
    selItem := ""
    goalIndex := 0
    selIndex := 0
    count := 0
    try {
        count := ListViewGetContent("Count", listView, WinID)
    }
    num := 0
    while (selItem != goalStr) {
        try selItem := ListViewGetContent("Focused Col1", listView, WinID)
        col1Items := ""
        try col1Items := ListViewGetContent("Col1", listView, WinID)
        itemIndex := Map()
        Loop Parse, col1Items, "`n" {
            itemIndex[A_LoopField] := A_Index
            if (A_LoopField = selItem) {
                selIndex := A_Index
            }
            if (A_LoopField = goalStr) {
                goalIndex := A_Index
            }
        }
        step := goalIndex - selIndex
        WinActivate WinID
        ControlFocus listView, WinID
        if (step > 0) {
            loop step {
                Send "{Down}"
            }
        }
        if (step < 0) {
            loop -step {
                Send "{Up}"
            }
        }
        try selItem := ListViewGetContent("Focused Col1", listView, WinID)
        Sleep 100
        num := num + 1
        if (num > count) {
            break
        }
    }
}
