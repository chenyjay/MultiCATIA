# AhkTest 使用说明 / AhkTest Usage Instructions

## 仓库说明 / Repository Notice

本项目仅包含 AutoHotkey 测试代码，不包含 CforCATIA.dll 的 C/C++ 源码。

This repository only contains the AutoHotkey test code. The C/C++ source of CforCATIA.dll is not included.

## 中文说明

### 功能

用 AutoHotkey v2 调用 CforCATIA.dll，测试获取最前 CATIA 窗口的 Path 和 Document。

### 核心特点

理论上，即使 CATIA 的 COM 接口未注册，该方法仍能连接上 CATIA。

### 运行方式

1. 方式 1（推荐 64 位）：如果本机已安装 AutoHotkey v2，直接双击运行 `TestMultiCATIA.ahk`。64 位系统会自动使用 `CforCATIA_64.dll`。
2. 方式 2（强制 32 位）：把 `TestMultiCATIA.ahk` 拖到同目录的 `AutoHotkey32.exe` 上运行，此时脚本使用 `CforCATIA_32.dll`。
3. 方式 3（命令行）：`cd` 到本目录后执行 `AutoHotkey32.exe TestMultiCATIA.ahk`。

### 测试步骤

1. 先打开一个或多个 CATIA 窗口。
2. 把要测试的 CATIA 窗口切到最前。
3. 运行脚本，弹出窗口后：
   - 按按钮【1: 获取 Path】或按键盘 `1`，读取 CATIA 安装路径。
   - 按按钮【2: 获取 Document】或按键盘 `2`，读取当前文档完整路径。
   - 按按钮【3: 退出】或按键盘 `3` / 关闭窗口，结束测试。
4. 切换不同 CATIA 窗口后重新按 `1` 或 `2`，即可看到对应进程的结果。

### 文件说明

- `TestMultiCATIA.ahk` — 测试脚本（AutoHotkey v2 语法）
- `CforCATIA_64.dll` — 64 位 DLL
- `CforCATIA_32.dll` — 32 位 DLL
- `AutoHotkey32.exe` — 32 位 AHK 解释器
- `RunMacroDirect.ahk` — DLL 内部调用宏脚本
- `MultiCATIA.catvba` — DLL 内部调用宏库
- `MultiCATIA.catvbs` — DLL 内部调用宏脚本

### 免费使用

- 本 DLL 已免费开放无限期使用，无需授权码、注册或试用限制。
- 直接调用 `CforCATIA_Init()` 即可完成初始化。

### 常见问题

1. 提示“找不到 DLL”：请检查 `CforCATIA_64.dll` 或 `CforCATIA_32.dll` 是否与脚本在同一目录。
2. 想强制使用 64 位 DLL：必须确保运行脚本的 AHK 是 64 位版本。`AutoHotkey32.exe` 是 32 位，会加载 32 位 DLL。

## English Instructions

### Purpose

Use AutoHotkey v2 to call CforCATIA.dll and retrieve the Path and Document of the frontmost CATIA window.

### Key Feature

Theoretically, this method can connect to CATIA even when its COM interface is not registered.

### How to Run

1. Method 1 (64-bit recommended): If AutoHotkey v2 is installed, double-click `TestMultiCATIA.ahk`. On 64-bit systems, `CforCATIA_64.dll` will be loaded automatically.
2. Method 2 (force 32-bit): Drag `TestMultiCATIA.ahk` onto `AutoHotkey32.exe` in the same folder. This will load `CforCATIA_32.dll`.
3. Method 3 (command line): Open a command prompt in this folder and run `AutoHotkey32.exe TestMultiCATIA.ahk`.

### Test Steps

1. Open one or more CATIA windows.
2. Bring the target CATIA window to the front.
3. Run the script, then in the popup window:
   - Press [1: Get Path] or key `1` to read the CATIA installation path.
   - Press [2: Get Document] or key `2` to read the full path of the current document.
   - Press [3: Exit] or key `3` / close the window to exit.
4. Switch to another CATIA window and press `1` or `2` again to see the result for that process.

### File Description

- `TestMultiCATIA.ahk` — Test script (AutoHotkey v2)
- `CforCATIA_64.dll` — 64-bit DLL
- `CforCATIA_32.dll` — 32-bit DLL
- `AutoHotkey32.exe` — 32-bit AHK interpreter
- `RunMacroDirect.ahk` — Macro script used internally by the DLL
- `MultiCATIA.catvba` — Macro library used internally by the DLL
- `MultiCATIA.catvbs` — Macro script used internally by the DLL

### Free to Use

- The DLL is now free for unlimited use without license keys, registration, or trial limits.
- Simply call `CforCATIA_Init()` to initialize it.

### FAQ

1. "DLL not found": Please ensure `CforCATIA_64.dll` or `CforCATIA_32.dll` is in the same folder as the script.
2. Force 64-bit DLL: Make sure you run the script with a 64-bit AHK interpreter. `AutoHotkey32.exe` is 32-bit and will load the 32-bit DLL.
