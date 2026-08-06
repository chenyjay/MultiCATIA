VERSION 5.00
Begin VB.Form FormTestMultiCATIA
   Caption         =   "VB6 调用 CforCATIA_32.dll 测试 / VB6 Test for CforCATIA_32.dll"
   ClientHeight    =   3735
   ClientLeft      =   120
   ClientTop       =   465
   ClientWidth     =   5895
   LinkTopic       =   "Form1"
   ScaleHeight     =   3735
   ScaleWidth      =   5895
   StartUpPosition =   3
   Begin VB.TextBox txtResult
      Height          =   1815
      Left            =   240
      MultiLine       =   -1
      ScrollBars      =   2
      TabIndex        =   3
      Text            =   "结果 / Result"
      Top             =   1680
      Width           =   5415
   End
   Begin VB.CommandButton cmdQuit
      Caption         =   "3: 退出 / Exit"
      Height          =   1095
      Left            =   4080
      TabIndex        =   2
      Top             =   240
      Width           =   1575
   End
   Begin VB.CommandButton cmdDoc
      Caption         =   "2: 获取Document / Get Doc"
      Height          =   1095
      Left            =   2160
      TabIndex        =   1
      Top             =   240
      Width           =   1575
   End
   Begin VB.CommandButton cmdPath
      Caption         =   "1: 获取Path / Get Path"
      Height          =   1095
      Left            =   240
      TabIndex        =   0
      Top             =   240
      Width           =   1575
   End
End
Attribute VB_Name = "FormTestMultiCATIA"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Declare Function CforCATIA_InitWithLicense Lib "CforCATIA_32.dll" (ByRef license As Byte) As Long
Private Declare Function CforCATIA_GetFrontmostObject Lib "CforCATIA_32.dll" (ByRef ptr As Long) As Long
Private Declare Function CforCATIA_GetLastError Lib "CforCATIA_32.dll" (ByRef buffer As Byte, ByVal bufferSize As Long) As Long
Private Declare Function CforCATIA_SetContactEmail Lib "CforCATIA_32.dll" (ByVal email As String) As Long
Private Declare Sub CforCATIA_ReleaseObject Lib "CforCATIA_32.dll" (ByVal ptr As Long)
Private Declare Sub CforCATIA_Shutdown Lib "CforCATIA_32.dll" ()

Private Declare Sub CopyMemory Lib "kernel32" Alias "RtlMoveMemory" (ByRef Destination As Any, ByRef Source As Any, ByVal Length As Long)
Private Declare Function WideCharToMultiByte Lib "kernel32" (ByVal CodePage As Long, ByVal dwFlags As Long, ByVal lpWideCharStr As Long, ByVal cchWideChar As Long, ByVal lpMultiByteStr As Long, ByVal cbMultiByte As Long, ByVal lpDefaultChar As Long, ByVal lpUsedDefaultChar As Long) As Long

Private Const CP_UTF8 As Long = 65001

' 测试用授权码：姓名|电话|日期|天数|RSA签名
Private Const TEST_LICENSE As String = "张三|13800138000|20260714|7|WcjxYIyBYdh7A8ajwcfDj1rb3Cadv2h3J1ILrTchhByEQWY38L3zLhmYncpN/SRuydSHkbX5WTbHjmXoZ4gUChs1FomDgx6ZiY+EW2Cu3cSPO1SJHi4p4hlyADJTQ5zfIm5nhjnRoQWNgUs/fAdMAf5Ov1qJspAxXwLNqND3nrTP1eEKKJc/qrFfvJxRgwK2Er35CgE/4oumTE4tBFpkG43WDUqXCFhFApJUwwIkqvdXvIjXRq8jAtD0CKjCbVBSD/9J5g5nkOZTRpxyU8vBvteThex820iG93sp4Bt6xemRS3mcLIsXXNB43MNxGDt3oo/Oy80GynuCJdf7TGGDDg=="

Private Function StringToUtf8(s As String) As Byte()
    Dim cb As Long
    Dim b() As Byte
    cb = WideCharToMultiByte(CP_UTF8, 0, StrPtr(s), Len(s), 0, 0, 0, 0)
    If cb = 0 Then
        ReDim b(0 To 0)
        b(0) = 0
        StringToUtf8 = b
        Exit Function
    End If
    ReDim b(0 To cb)
    cb = WideCharToMultiByte(CP_UTF8, 0, StrPtr(s), Len(s), VarPtr(b(0)), cb, 0, 0)
    b(UBound(b)) = 0
    StringToUtf8 = b
End Function

Private Function GetLastErrorText() As String
    Dim buf(0 To 1023) As Byte
    Dim n As Long
    Dim s As String
    Dim pos As Long
    n = CforCATIA_GetLastError(buf(0), 1024)
    If n <= 0 Then
        GetLastErrorText = ""
        Exit Function
    End If
    s = StrConv(buf, vbUnicode)
    pos = InStr(s, Chr$(0))
    If pos > 0 Then s = Left$(s, pos - 1)
    GetLastErrorText = s
End Function

Private Function GetCATIA() As Object
    Dim p As Long
    Dim rc As Long
    Dim obj As Object
    rc = CforCATIA_GetFrontmostObject(p)
    If rc <> 0 Then Exit Function
    CopyMemory obj, p, 4
    Set GetCATIA = obj
End Function

Private Sub Form_Load()
    Dim b() As Byte
    Dim rc As Long
    CforCATIA_SetContactEmail "1027160374@qq.com"
    b = StringToUtf8(TEST_LICENSE)
    rc = CforCATIA_InitWithLicense(b(0))
    If rc <> 0 Then
        MsgBox "初始化失败 / Initialization failed: " & GetLastErrorText(), vbExclamation, "错误 / Error"
    End If
End Sub

Private Sub Form_Unload(Cancel As Integer)
    CforCATIA_Shutdown
End Sub

Private Sub cmdPath_Click()
    Dim catia As Object
    Set catia = GetCATIA()
    If catia Is Nothing Then
        txtResult.Text = "获取失败 / Failed to get: " & GetLastErrorText()
        Exit Sub
    End If
    On Error Resume Next
    txtResult.Text = "Path 环境变量 / Path environment variable = " & catia.SystemService.Environ("Path")
    If Err.Number <> 0 Then txtResult.Text = "读取 Path 失败 / Failed to read Path: " & Err.Description
    On Error GoTo 0
End Sub

Private Sub cmdDoc_Click()
    Dim catia As Object
    Set catia = GetCATIA()
    If catia Is Nothing Then
        txtResult.Text = "获取失败 / Failed to get: " & GetLastErrorText()
        Exit Sub
    End If
    On Error Resume Next
    txtResult.Text = "当前文档 / Current document = " & catia.ActiveDocument.FullName
    If Err.Number <> 0 Then txtResult.Text = "读取 Document 失败 / Failed to read Document: " & Err.Description
    On Error GoTo 0
End Sub

Private Sub cmdQuit_Click()
    Unload Me
End Sub
