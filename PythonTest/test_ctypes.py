# -*- coding: utf-8 -*-
"""CforCATIA_64.dll Python 调用示例
Example: retrieve the COM object of the frontmost CATIA window and read common properties."""

import os
import sys
import ctypes
import pythoncom
import win32com.client


_DLL = None  # 全局 DLL 句柄

# 测试用授权码：姓名|电话|日期|天数|RSA签名
TEST_LICENSE = ""


def GetCATIA():
    """获取最前 CATIA 的 COM 对象（返回：对象, 原始指针）
    Get the frontmost CATIA COM object (returns: object, raw pointer)."""
    ptr = ctypes.c_void_p()                              # 接收 IDispatch* 的指针变量
    rc = _DLL.CforCATIA_GetFrontmostObject(ctypes.byref(ptr))  # 调用 DLL 获取对象
    if rc != 0 or not ptr.value:                         # 获取失败
        return None
    raw = pythoncom.ObjectFromAddress(ptr.value, pythoncom.IID_IDispatch)  # 原始指针转 PyIDispatch
    catia = win32com.client.Dispatch(raw)                # 包装为可属性访问的动态对象
    return catia, ptr.value                              # 返回对象和原始指针


def get_path():
    """读取最前 CATIA 的安装路径
    Read the installation path of the frontmost CATIA."""
    result = GetCATIA()                                  # 取 CATIA 对象
    if result is None:                                   # 失败则返回错误信息
        return f"获取失败\nFailed to get: {_get_last_error()}"
    catia, ptr = result                                  # 解包
    try:
        return catia.SystemService.Environ("Path")       # 通过 COM 读取 Path
    except Exception as e:
        return f"读取 Path 失败\nFailed to read Path: {str(e)}"  # 捕获异常
    finally:
        _DLL.CforCATIA_ReleaseObject(ptr)                # 释放 DLL 侧 AddRef 的指针


def get_document():
    """读取最前 CATIA 的当前文档完整路径
    Read the full path of the current document in the frontmost CATIA."""
    result = GetCATIA()                                  # 取 CATIA 对象
    if result is None:
        return f"获取失败\nFailed to get: {_get_last_error()}"
    catia, ptr = result
    try:
        return catia.ActiveDocument.FullName             # 通过 COM 读取文档名
    except Exception as e:
        return f"读取 Document 失败\nFailed to read Document: {str(e)}"
    finally:
        _DLL.CforCATIA_ReleaseObject(ptr)                # 释放 DLL 侧 AddRef 的指针


def verify_license():
    """授权码验证自测：把 license 变量改成你要验证的授权码即可
    License verification self-test: set the license variable to the license you want to verify."""
    license = TEST_LICENSE  # <-- 手动改成要验证的授权码
    print("授权码验证自测\nLicense verification self-test:")
    data = license.encode("utf-8") if license else None
    rc = _DLL.CforCATIA_InitWithLicense(data)
    err = _get_last_error()
    print(f"  rc={rc} err={err!r}")
    print()


def main():
    """命令行 Demo 入口
    Command-line demo entry point."""
    try:
        _load_dll()                                      # 加载并声明 DLL 函数
    except Exception as e:
        _wait_exit(f"加载 DLL 失败\nFailed to load DLL: {e}")  # 失败则暂停退出

    try:
        pythoncom.CoInitializeEx(0, pythoncom.COINIT_MULTITHREADED)  # 初始化 COM 为 MTA
    except Exception:
        pass                                             # 已初始化则忽略

    print("初始化 CforCATIA_64.dll ...\nInitializing CforCATIA_64.dll ...")
    # 设置未授权/试用弹窗中显示的联系方式，发布时替换成你的邮箱
    _DLL.CforCATIA_SetContactEmail("1027160374@qq.com".encode("utf-8"))
    verify_license()                                     # 授权码自测（可手动增删授权码）

    print("=" * 40)
    print("CATIA 多进程连接命令行 Demo\nCATIA Multi-Process Connection Command-Line Demo")
    print("=" * 40)
    print("  1 : 获取最近 CATIA 的程序路径\n      Get the executable path of the most recent CATIA")
    print("  2 : 获取最近 CATIA 的当前文档名称\n      Get the current document name of the most recent CATIA")
    print("  q : 退出\n      Quit")
    print("-" * 40)

    try:
        while True:
            try:
                cmd = input("> ").strip()                # 读取用户输入
            except EOFError:
                break                                      # 非交互环境结束
            if cmd == "q":
                break                                      # 退出循环
            elif cmd == "1":
                print(f"Path={get_path()}")                # 输出 Path
            elif cmd == "2":
                print(f"Doc={get_document()}")             # 输出文档名
            else:
                print("未知指令，请输入 1、2 或 q\nUnknown command, please enter 1, 2 or q")  # 提示错误
    except Exception as e:
        print(f"运行异常\nRuntime exception: {e}")        # 捕获未处理异常
    finally:
        _DLL.CforCATIA_Shutdown()                          # 释放 DLL 资源
        print("已释放 CforCATIA_64.dll 资源\nCforCATIA_64.dll resources released")

    _wait_exit()                                           # 暂停防止闪退


def _load_dll():
    """加载同目录 CforCATIA_64.dll 并声明函数原型
    Load CforCATIA_64.dll from the same directory and declare function prototypes."""
    global _DLL
    dll_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), "CforCATIA_64.dll")  # 同目录 DLL 路径
    if not os.path.exists(dll_path):                       # DLL 不存在
        raise FileNotFoundError(f"找不到 DLL\nDLL not found: {dll_path}")  # 抛出异常

    _DLL = ctypes.CDLL(dll_path)                           # 加载 DLL

    _DLL.CforCATIA_Init.restype = ctypes.c_int             # 声明返回值类型
    _DLL.CforCATIA_Init.argtypes = []                      # 声明参数类型

    _DLL.CforCATIA_InitWithLicense.restype = ctypes.c_int  # 带授权码初始化
    _DLL.CforCATIA_InitWithLicense.argtypes = [ctypes.c_char_p]

    _DLL.CforCATIA_GetFrontmostObject.restype = ctypes.c_int
    _DLL.CforCATIA_GetFrontmostObject.argtypes = [ctypes.POINTER(ctypes.c_void_p)]

    _DLL.CforCATIA_ReleaseObject.restype = None
    _DLL.CforCATIA_ReleaseObject.argtypes = [ctypes.c_void_p]

    _DLL.CforCATIA_GetLastError.restype = ctypes.c_int
    _DLL.CforCATIA_GetLastError.argtypes = [ctypes.c_char_p, ctypes.c_int]

    _DLL.CforCATIA_Shutdown.restype = None
    _DLL.CforCATIA_Shutdown.argtypes = []

    _DLL.CforCATIA_SetContactEmail.restype = ctypes.c_int
    _DLL.CforCATIA_SetContactEmail.argtypes = [ctypes.c_char_p]


def _get_last_error():
    """取 DLL 侧最后一次错误信息
    Get the last error message from the DLL side."""
    err = ctypes.create_string_buffer(1024)                # 分配 1024 字节错误缓冲区
    _DLL.CforCATIA_GetLastError(err, 1024)                 # 调用 DLL
    return err.value.decode("utf-8", errors="ignore")      # 解码为字符串


def _wait_exit(message=None):
    """出错或结束时暂停，防止控制台一闪而过
    Pause on error or exit to prevent the console from closing immediately."""
    if message:
        print(message)                                     # 打印错误信息
    try:
        input("按回车键退出...\nPress Enter to exit...")  # 等待用户按键
    except EOFError:
        pass
    sys.exit(1 if message else 0)                          # 错误码退出


if __name__ == "__main__":
    main()                                                 # 启动命令行 Demo
