# CforCATIA_64.dll Python 测试脚本 / Python Test Script

## 仓库说明 / Repository Notice

本项目仅包含 Python 测试代码，不包含 CforCATIA.dll 的 C/C++ 源码。

This repository only contains the Python test code. The C/C++ source of CforCATIA.dll is not included.

联系方式仅通过本测试项目传入，请在发布前将下面的 `1027160374@qq.com` 替换为你自己的邮箱。

The contact email is configured only through this test project. Replace `1027160374@qq.com` below with your own email before publishing.

## 中文说明

### 使用步骤

1. 确保 `CforCATIA_64.dll` 与 `test_ctypes.py` 在同一目录。
2. 启动 CATIA，并打开一个文档。
3. 运行：`python test_ctypes.py`
4. 按提示输入：
   - `1` → 输出 CATIA 安装路径
   - `2` → 输出当前文档全路径
   - `q` → 退出

### 联系方式配置

- 如需自定义未授权/试用弹窗中显示的联系方式，请在初始化 DLL 前调用 `CforCATIA_SetContactEmail`。
- `test_ctypes.py` 中已默认设置为 `1027160374@qq.com`，发布前请改成你的邮箱。

### 授权与试用

- 本 DLL 默认提供 7 天试用期，无需授权码即可使用。
- 如需正式授权，请联系你在测试项目中配置的邮箱。

若提示未授权或试用期结束，请检查系统时间，或修改脚本中的授权码。

## English Instructions

### Usage Steps

1. Make sure `CforCATIA_64.dll` is in the same folder as `test_ctypes.py`.
2. Start CATIA and open a document.
3. Run: `python test_ctypes.py`
4. Enter the following when prompted:
   - `1` → Output the CATIA installation path
   - `2` → Output the full path of the current document
   - `q` → Quit

### Contact Configuration

- To customize the contact info shown in unauthorized/trial dialogs, call `CforCATIA_SetContactEmail` before initializing the DLL.
- `test_ctypes.py` already defaults to `1027160374@qq.com`; change it to your own contact before publishing.

### License and Trial

- A 7-day trial is enabled by default; no license code is required.
- For a formal license, please contact the email configured in this test project.

If you see an unauthorized or trial-expired message, please check your system time or update the license code in the script.
