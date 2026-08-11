# ConnectMultiCATIA

<p align="center"><b>English</b> · <a href="README.zh.md">中文</a></p>

Demo Video:

  [https://youtu.be/FjJP3E2kWTg?si=1ssw2wEPVUOujkov](https://youtu.be/UFgfFF4EnaE)

  【[免费]C#/VB.NET/Python/ VB6.0/Autohotkey 等外部com方式开发插件 同时支持多进程/多开/多版本CATIA V5】 https://www.bilibili.com/video/BV1xVuR6sEuZ/?share_source=copy_web&vd_source=ff408703398502819e8cb5740f417d38

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

##Free to Use & Contact

These test projects are provided as open-source examples under the MIT License; see [LICENSE](LICENSE) for details. The CforCATIA runtime DLL remains closed-source but is now free for unlimited use without registration, license keys, or trial limits. If you have questions, feature requests, or need custom integration support, feel free to contact the author via email.

- Email: 1027160374@qq.com

## Acknowledgments

Thanks to the following developers for their contributions and support:

- Bob Reynolds
- 月落无声

## References

- [Getting a specific instance of COM object in VB.NET](https://stackoverflow.com/questions/17658425/getting-a-specific-instance-of-com-object-in-vb-net#)

## Third-Party Notices

This repository includes a forwarded copy of `AutoHotkey32.exe` in `AhkTest/`. AutoHotkey is licensed under GPL v2; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) for details. All other components are provided by the repository author under separate closed-source terms.
