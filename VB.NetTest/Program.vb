Imports System                          ' 基础类型
Imports System.Runtime.InteropServices  ' Declare、Marshal
Imports System.Text                     ' UTF-8 解码
Imports INFITF                          ' CATIA COM 接口

Module Program                          ' VB.NET 调用 CforCATIA_64.dll 示例

    ' 初始化 DLL（不带授权码，会触发未授权弹窗）
    Declare Function CforCATIA_Init Lib "CforCATIA_64.dll" () As Integer

    ' 带授权码初始化 DLL
    Declare Function CforCATIA_InitWithLicense Lib "CforCATIA_64.dll" (license() As Byte) As Integer

    ' 获取最前 CATIA 的 IDispatch* 指针
    Declare Function CforCATIA_GetFrontmostObject Lib "CforCATIA_64.dll" (ByRef ptr As IntPtr) As Integer

    ' 释放 DLL 返回的指针
    Declare Sub CforCATIA_ReleaseObject Lib "CforCATIA_64.dll" (ptr As IntPtr)

    ' 取 DLL 侧最后一次错误信息
    Declare Function CforCATIA_GetLastError Lib "CforCATIA_64.dll" (buffer() As Byte, bufferSize As Integer) As Integer

    ' 设置弹窗中显示的联系方式（传入 UTF-8 字节数组）
    Declare Function CforCATIA_SetContactEmail Lib "CforCATIA_64.dll" (email() As Byte) As Integer

    ' 释放 DLL 资源
    Declare Sub CforCATIA_Shutdown Lib "CforCATIA_64.dll" ()

    Function GetLastErrorText() As String            ' 读取错误信息
        Dim buf(1023) As Byte                        ' 错误缓冲区
        CforCATIA_GetLastError(buf, buf.Length)      ' 调用 DLL
        Return Encoding.UTF8.GetString(buf).TrimEnd(ChrW(0))  ' 解码为字符串
    End Function

    Function GetCATIA() As Application               ' 调用 DLL 并包装为 CATIA Application
        Dim ptr As IntPtr = IntPtr.Zero              ' 接收 IDispatch*
        Dim rc As Integer = CforCATIA_GetFrontmostObject(ptr)  ' 获取指针
        If rc <> 0 Then Return Nothing               ' 失败
        Dim obj As Object = Marshal.GetObjectForIUnknown(ptr)  ' 包装为 RCW
        CforCATIA_ReleaseObject(ptr)                 ' 释放 DLL 侧 AddRef
        Return TryCast(obj, Application)             ' 强转
    End Function

    ' 测试用授权码：姓名|电话|日期|天数|RSA签名
    ReadOnly TestLicense As String = "张三|13800138000|20260714|7|WcjxYIyBYdh7A8ajwcfDj1rb3Cadv2h3J1ILrTchhByEQWY38L3zLhmYncpN/SRuydSHkbX5WTbHjmXoZ4gUChs1FomDgx6ZiY+EW2Cu3cSPO1SJHi4p4hlyADJTQ5zfIm5nhjnRoQWNgUs/fAdMAf5Ov1qJspAxXwLNqND3nrTP1eEKKJc/qrFfvJxRgwK2Er35CgE/4oumTE4tBFpkG43WDUqXCFhFApJUwwIkqvdXvIjXRq8jAtD0CKjCbVBSD/9J5g5nkOZTRpxyU8vBvteThex820iG93sp4Bt6xemRS3mcLIsXXNB43MNxGDt3oo/Oy80GynuCJdf7TGGDDg=="

    Sub Main()
        ' 设置未授权/试用弹窗中显示的联系方式，发布时替换成你的邮箱
        CforCATIA_SetContactEmail(Encoding.UTF8.GetBytes("1027160374@qq.com"))

        Dim licenseBytes() As Byte = Encoding.UTF8.GetBytes(TestLicense)
        If CforCATIA_InitWithLicense(licenseBytes) <> 0 Then  ' 带授权码初始化 DLL
            Console.WriteLine("初始化失败" & vbCrLf & "Initialization failed: " & GetLastErrorText())
            Return
        End If

        Console.WriteLine(New String("="c, 40))
        Console.WriteLine("CATIA 多进程连接命令行 Demo" & vbCrLf & "CATIA Multi-Process Connection CLI Demo (VB.NET calling C DLL)")
        Console.WriteLine(New String("="c, 40))
        Console.WriteLine("  1 : 获取最近 CATIA 的程序路径" & vbCrLf & "      Get the most recent CATIA executable path")
        Console.WriteLine("  2 : 获取最近 CATIA 的当前文档名称" & vbCrLf & "      Get the most recent CATIA's current document name")
        Console.WriteLine("  q : 退出" & vbCrLf & "      Quit")
        Console.WriteLine(New String("-"c, 40))

        While True
            Console.Write("选择" & vbCrLf & "Select > ")
            Dim cmd As String = Console.ReadLine().Trim()  ' 读取输入
            If cmd = "q" Then Exit While                 ' 退出

            If cmd = "1" Then
                Dim catia = GetCATIA()                   ' 取 CATIA 对象
                If catia Is Nothing Then
                    Console.WriteLine("获取失败" & vbCrLf & "Acquisition failed: " & GetLastErrorText())
                    Continue While
                End If
                Try
                    Dim path As String = catia.SystemService.Environ("Path")
                    Console.WriteLine("路径 = " & path)
                    Console.WriteLine("Path=" & path)
                Catch ex As Exception
                    Console.WriteLine("读取 Path 失败" & vbCrLf & "Failed to read Path: " & ex.Message)
                End Try
            ElseIf cmd = "2" Then
                Dim catia = GetCATIA()                   ' 取 CATIA 对象
                If catia Is Nothing Then
                    Console.WriteLine("获取失败" & vbCrLf & "Acquisition failed: " & GetLastErrorText())
                    Continue While
                End If
                Try
                    Dim doc As String = catia.ActiveDocument.FullName
                    Console.WriteLine("文档 = " & doc)
                    Console.WriteLine("Doc=" & doc)
                Catch ex As Exception
                    Console.WriteLine("读取 Document 失败" & vbCrLf & "Failed to read Document: " & ex.Message)
                End Try
            Else
                Console.WriteLine("未知指令，请输入 1、2 或 q" & vbCrLf & "Unknown command, please enter 1, 2 or q")
            End If
        End While

        CforCATIA_Shutdown()                             ' 释放 DLL 资源
        Console.WriteLine("已释放 CforCATIA_64.dll 资源" & vbCrLf & "CforCATIA_64.dll resources released")
        Console.WriteLine("按回车键退出..." & vbCrLf & "Press Enter to exit...")
        Console.ReadLine()
    End Sub
End Module
