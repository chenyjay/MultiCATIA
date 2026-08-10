# ConnectMultiCATIA
Demo Video: 
  https://youtu.be/FjJP3E2kWTg?si=1ssw2wEPVUOujkov

  
  https://www.bilibili.com/video/BV1xVuR6sEuZ/
## Project Introduction

ConnectMultiCATIA is a set of multi-language calling examples for the CforCATIA.dll library. It demonstrates how to attach to the foreground CATIA window from external processes written in C#, VB.NET, Python, AutoHotkey, and VB6, and how to read common properties such as the installation path and the active document. These examples are intended for developers who need to drive or inspect multiple CATIA sessions from outside the CATIA process. The runtime DLL itself is closed-source but free for unlimited use without registration or license keys; this repository only publishes the test-project source code so that users can verify the integration in their preferred language.

Theoretically, this method can connect to CATIA even when its COM interface is not registered.

## Included Projects

| Directory | Language | Description |
| --- | --- | --- |
| `CSharpTest/` | C# | Console example |
| `VB.NetTest/` | VB.NET | Console example |
| `PythonTest/` | Python | ctypes example |
| `AhkTest/` | AutoHotkey v2 | GUI example |
| `VB6.0Test/` | VB6 | GUI example |

## Licensing & Contact

These test projects are provided as open-source examples. The CforCATIA runtime DLL remains closed-source but is now free for unlimited use without registration, license keys, or trial limits. If you have questions, feature requests, or need custom integration support, feel free to contact the author via email.

- Email: 1027160374@qq.com

## Acknowledgments

Thanks to the following developers for their contributions and support:

- Bob Reynolds
- 月落无声

## References

- [Getting a specific instance of COM object in VB.NET](https://stackoverflow.com/questions/17658425/getting-a-specific-instance-of-com-object-in-vb-net#)

## Third-Party Notices

This repository includes a forwarded copy of `AutoHotkey32.exe` in `AhkTest/`. AutoHotkey is licensed under GPL v2; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for details. All other components are provided by the repository author under separate closed-source terms.

---

## 项目简介

ConnectMultiCATIA 是 CforCATIA.dll 的多语言调用示例集合，用于演示如何在 C#、VB.NET、Python、AutoHotkey 与 VB6 等外部进程中获取最前 CATIA 窗口的 COM 对象，并读取安装路径、当前文档等常用属性。本仓库面向需要在外部程序中驱动或检测多个 CATIA 会话的开发者，仅发布测试项目源码供用户在不同语言环境下验证集成效果。运行时所依赖的 DLL 为闭源组件，但已免费开放无限期使用，无需授权码或注册。

理论上，即使 CATIA 的 COM 接口未注册，该方法仍能连接上 CATIA。

## 包含项目

| 目录 | 语言 | 说明 |
| --- | --- | --- |
| `CSharpTest/` | C# | 控制台调用示例 |
| `VB.NetTest/` | VB.NET | 控制台调用示例 |
| `PythonTest/` | Python | ctypes 调用示例 |
| `AhkTest/` | AutoHotkey v2 | 窗体调用示例 |
| `VB6.0Test/` | VB6 | 窗体调用示例 |

## 授权与联系方式

本仓库中的测试项目作为开源示例提供。CforCATIA 运行时 DLL 仍为闭源组件，但现已免费开放无限期使用，无需授权码、注册或试用限制。如有问题、功能需求或需要定制集成支持，欢迎通过邮箱联系作者。

- 邮箱：1027160374@qq.com

## 鸣谢

感谢以下开发者的贡献与支持：

- Bob Reynolds
- 月落无声

## 参考文献

- [Getting a specific instance of COM object in VB.NET](https://stackoverflow.com/questions/17658425/getting-a-specific-instance-of-com-object-in-vb-net#)

## 第三方声明

本仓库在 `AhkTest/` 中转发了 `AutoHotkey32.exe`，AutoHotkey 按 GPL v2 授权，详见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。其余组件由仓库作者以单独的闭源条款提供。
