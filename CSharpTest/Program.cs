using System;                       // 基础类型
using System.Runtime.InteropServices;           // DllImport、Marshal
using System.Text;                  // UTF-8 解码
using INFITF;                       // CATIA COM 接口

namespace CSharpTest                // CforCATIA_64.dll 的 C# 调用示例
{
    class Program
    {
        // 初始化 DLL（不带授权码，会触发未授权弹窗）
        [DllImport("CforCATIA_64.dll", CallingConvention = CallingConvention.Cdecl)]
        static extern int CforCATIA_Init();

        // 带授权码初始化 DLL
        [DllImport("CforCATIA_64.dll", CallingConvention = CallingConvention.Cdecl)]
        static extern int CforCATIA_InitWithLicense(byte[] license);

        // 获取最前 CATIA 的 IDispatch* 指针
        [DllImport("CforCATIA_64.dll", CallingConvention = CallingConvention.Cdecl)]
        static extern int CforCATIA_GetFrontmostObject(out IntPtr ptr);

        // 释放 DLL 返回的指针
        [DllImport("CforCATIA_64.dll", CallingConvention = CallingConvention.Cdecl)]
        static extern void CforCATIA_ReleaseObject(IntPtr ptr);

        // 取 DLL 侧最后一次错误信息
        [DllImport("CforCATIA_64.dll", CallingConvention = CallingConvention.Cdecl)]
        static extern int CforCATIA_GetLastError(byte[] buffer, int bufferSize);

        // 设置弹窗中显示的联系方式
        [DllImport("CforCATIA_64.dll", CallingConvention = CallingConvention.Cdecl)]
        static extern int CforCATIA_SetContactEmail(byte[] email);

        // 释放 DLL 资源
        [DllImport("CforCATIA_64.dll", CallingConvention = CallingConvention.Cdecl)]
        static extern void CforCATIA_Shutdown();

        static string GetLastError()                    // 读取错误信息
        {
            byte[] buf = new byte[1024];                // 错误缓冲区
            CforCATIA_GetLastError(buf, buf.Length);    // 调用 DLL
            return Encoding.UTF8.GetString(buf).TrimEnd('\0');  // 解码为字符串
        }

        static Application GetCATIA()                   // 调用 DLL 并包装为 CATIA Application
        {
            IntPtr ptr;                                 // 接收 IDispatch*
            int rc = CforCATIA_GetFrontmostObject(out ptr);  // 获取指针
            if (rc != 0) return null;                   // 失败
            object obj = Marshal.GetObjectForIUnknown(ptr);  // 包装为 RCW
            CforCATIA_ReleaseObject(ptr);               // 释放 DLL 侧 AddRef
            return obj as Application;                  // 强转
        }

        // 测试用授权码：姓名|电话|日期|天数|RSA签名
        static readonly string TestLicense = "张三|13800138000|20260714|7|WcjxYIyBYdh7A8ajwcfDj1rb3Cadv2h3J1ILrTchhByEQWY38L3zLhmYncpN/SRuydSHkbX5WTbHjmXoZ4gUChs1FomDgx6ZiY+EW2Cu3cSPO1SJHi4p4hlyADJTQ5zfIm5nhjnRoQWNgUs/fAdMAf5Ov1qJspAxXwLNqND3nrTP1eEKKJc/qrFfvJxRgwK2Er35CgE/4oumTE4tBFpkG43WDUqXCFhFApJUwwIkqvdXvIjXRq8jAtD0CKjCbVBSD/9J5g5nkOZTRpxyU8vBvteThex820iG93sp4Bt6xemRS3mcLIsXXNB43MNxGDt3oo/Oy80GynuCJdf7TGGDDg==";

        static void Main(string[] args)
        {
            // 设置未授权/试用弹窗中显示的联系方式，发布时替换成你的邮箱
            CforCATIA_SetContactEmail(Encoding.UTF8.GetBytes("1027160374@qq.com"));

            byte[] licenseBytes = Encoding.UTF8.GetBytes(TestLicense);
            if (CforCATIA_InitWithLicense(licenseBytes) != 0)  // 带授权码初始化 DLL
            {
                Console.WriteLine("初始化失败\nInitialization failed: " + GetLastError());
                return;
            }

            Console.WriteLine(new string('=', 40));
            Console.WriteLine("CATIA 多进程连接命令行 Demo\nCATIA Multi-Process Connection Command Line Demo (C# calling C DLL)");
            Console.WriteLine(new string('=', 40));
            Console.WriteLine("  1 : 获取最近 CATIA 的程序路径\n      Get the executable path of the most recent CATIA");
            Console.WriteLine("  2 : 获取最近 CATIA 的当前文档名称\n      Get the current document name of the most recent CATIA");
            Console.WriteLine("  q : 退出\n      Quit");
            Console.WriteLine(new string('-', 40));

            while (true)
            {
                Console.Write("选择\nSelect > ");
                string cmd = Console.ReadLine()?.Trim();  // 读取输入
                if (cmd == "q") break;                    // 退出

                if (cmd == "1")
                {
                    var catia = GetCATIA();               // 取 CATIA 对象
                    if (catia == null)
                    {
                        Console.WriteLine("获取失败\nFailed to get: " + GetLastError());
                        continue;
                    }
                    try
                    {
                        string path = catia.SystemService.Environ("Path");
                        Console.WriteLine("路径 = " + path);
                        Console.WriteLine("Path = " + path);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("读取 Path 失败\nFailed to read Path: " + ex.Message);
                    }
                }
                else if (cmd == "2")
                {
                    var catia = GetCATIA();               // 取 CATIA 对象
                    if (catia == null)
                    {
                        Console.WriteLine("获取失败\nFailed to get: " + GetLastError());
                        continue;
                    }
                    try
                    {
                        string doc = catia.ActiveDocument.FullName;
                        Console.WriteLine("文档 = " + doc);
                        Console.WriteLine("Document = " + doc);
                    }
                    catch (Exception ex)
                    {
                        Console.WriteLine("读取 Document 失败\nFailed to read Document: " + ex.Message);
                    }
                }
                else
                {
                    Console.WriteLine("未知指令，请输入 1、2 或 q\nUnknown command, please enter 1, 2 or q");
                }
            }

            CforCATIA_Shutdown();                         // 释放 DLL 资源
            Console.WriteLine("已释放 CforCATIA_64.dll 资源\nCforCATIA_64.dll resources released");
            Console.WriteLine("按回车键退出...\nPress Enter to exit...");
            Console.ReadLine();
        }
    }
}
