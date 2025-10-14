If WScript.Arguments.Count > 0 Then

Set fso=CreateObject("Scripting.FileSystemObject")
rem "C:\Users\Default\AppData\Local\Microsoft\Windows\Shell\LayoutModification.xml"
whichfile = WScript.Arguments(0)
oldstring = " xmlns="""""
newstring = ""
If (fso.FileExists(whichfile)) Then

Dim objStream, srcStr, dstStr
Set objStream = CreateObject("ADODB.Stream")
objStream.CharSet = "utf-8"
objStream.Open
objStream.LoadFromFile(whichfile)
srcStr = objStream.ReadText()
objStream.Close

dstStr = Replace(srcStr, oldstring, newstring)

Set objStream = CreateObject("ADODB.Stream")
objStream.CharSet = "utf-8"
objStream.Open
objStream.WriteText dstStr
objStream.SaveToFile whichfile, 2
objStream.Close

End If

End If