# ConnectMultiCATIA

## Project Introduction

ConnectMultiCATIA is a set of multi-language calling examples for the CforCATIA.dll library. It demonstrates how to attach to the foreground CATIA window from external processes written in C#, VB.NET, Python, AutoHotkey, and VB6, and how to read common properties such as the installation path and the active document. These examples are intended for developers who need to drive or inspect multiple CATIA sessions from outside the CATIA process. The runtime DLL itself is closed-source; this repository only publishes the test-project source code so that users can verify the integration in their preferred language before requesting a license.

## Included Projects

| Directory | Language | Description |
| --- | --- | --- |
| `CSharpTest/` | C# | Console example |
| `VB.NetTest/` | VB.NET | Console example |
| `PythonTest/` | Python | ctypes example |
| `AhkTest/` | AutoHotkey v2 | GUI example |
| `VB6.0Test/` | VB6 | GUI example |

## Licensing & Contact

These test projects are provided for evaluation and integration verification. A permanent license for the closed-source CforCATIA runtime DLL can be requested by contacting the author via email. Trial behavior and license enforcement are handled by the DLL itself; please replace the contact email in each test project with your own before distribution.

- Email: 1027160374@qq.com

## Pricing

A single commercial license is offered for the closed-source CforCATIA runtime DLL. The DLL provides a 7-day trial period before requiring activation. Please contact the author via email for a formal quotation or volume licensing.

| License | Scope | Estimated Price (USD) |
| --- | --- | --- |
| Commercial | Single developer | $150 |

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

ConnectMultiCATIA 是 CforCATIA.dll 的多语言调用示例集合，用于演示如何在 C#、VB.NET、Python、AutoHotkey 与 VB6 等外部进程中获取最前 CATIA 窗口的 COM 对象，并读取安装路径、当前文档等常用属性。本仓库面向需要在外部程序中驱动或检测多个 CATIA 会话的开发者，仅发布测试项目源码供用户在不同语言环境下验证集成效果；运行时所依赖的 DLL 为闭源组件。

## 包含项目

| 目录 | 语言 | 说明 |
| --- | --- | --- |
| `CSharpTest/` | C# | 控制台调用示例 |
| `VB.NetTest/` | VB.NET | 控制台调用示例 |
| `PythonTest/` | Python | ctypes 调用示例 |
| `AhkTest/` | AutoHotkey v2 | 窗体调用示例 |
| `VB6.0Test/` | VB6 | 窗体调用示例 |

## 授权与联系方式

本仓库中的测试项目仅用于评估与集成验证。闭源 CforCATIA 运行时 DLL 的永久授权请通过邮箱联系作者申请。试用与授权校验由 DLL 内部处理；发布前请将各测试项目中的联系方式替换为你自己的邮箱。

- 邮箱：1027160374@qq.com

## 定价

闭源 CforCATIA 运行时 DLL 采用统一商业授权，DLL 内置 7 天试用期，到期后需激活。如需正式报价或批量授权，请通过邮箱联系作者。

| 授权 | 适用范围 | 参考价格（人民币） |
| --- | --- | --- |
| 商业版 | 单个开发者 | ¥1050 |

## 鸣谢

感谢以下开发者的贡献与支持：

- Bob Reynolds
- 月落无声

## 参考文献

- [Getting a specific instance of COM object in VB.NET](https://stackoverflow.com/questions/17658425/getting-a-specific-instance-of-com-object-in-vb-net#)

## 第三方声明

本仓库在 `AhkTest/` 中转发了 `AutoHotkey32.exe`，AutoHotkey 按 GPL v2 授权，详见 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md)。其余组件由仓库作者以单独的闭源条款提供。
