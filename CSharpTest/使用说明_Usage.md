# CforCATIA_64.dll C# 测试程序 / C# Test Program

## 仓库说明 / Repository Notice

本项目仅包含 C# 测试代码，不包含 CforCATIA.dll 的 C/C++ 源码。

This repository only contains the C# test code. The C/C++ source of CforCATIA.dll is not included.

## 中文说明

### 核心特点

理论上，即使 CATIA 的 COM 接口未注册，该方法仍能连接上 CATIA。

### 使用步骤

1. 确保 `CforCATIA_64.dll` 与本 exe 在同一目录。
2. 启动 CATIA，并打开一个文档。
3. 双击运行 `CSharpTest.exe`。
4. 按提示输入：
   - `1` → 输出 CATIA 安装路径
   - `2` → 输出当前文档全路径
   - `q` → 退出

### 免费使用

- 本 DLL 已免费开放无限期使用，无需授权码、注册或试用限制。
- 直接调用 `CforCATIA_Init()` 即可完成初始化。

## English Instructions

### Key Feature

Theoretically, this method can connect to CATIA even when its COM interface is not registered.

### Usage Steps

1. Make sure `CforCATIA_64.dll` is in the same folder as this exe.
2. Start CATIA and open a document.
3. Double-click `CSharpTest.exe` to run.
4. Enter the following when prompted:
   - `1` → Output the CATIA installation path
   - `2` → Output the full path of the current document
   - `q` → Quit

### Free to Use

- The DLL is now free for unlimited use without license keys, registration, or trial limits.
- Simply call `CforCATIA_Init()` to initialize it.
