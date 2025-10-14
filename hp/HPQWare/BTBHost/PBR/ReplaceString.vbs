Set fso=CreateObject("Scripting.FileSystemObject")
whichfile = WScript.Arguments(0)
oldstring = WScript.Arguments(1)
newstring = WScript.Arguments(2)
If (fso.FileExists(whichfile)) Then

Dim objStream, srcStr, dstStr
Set objStream = CreateObject("ADODB.Stream")
objStream.CharSet = "Unicode"
objStream.Open
objStream.LoadFromFile(whichfile)
srcStr = objStream.ReadText()
objStream.Close

dstStr = Replace(srcStr, oldstring, newstring)

Set objStream = CreateObject("ADODB.Stream")
objStream.CharSet = "Unicode"
objStream.Open
objStream.WriteText dstStr
objStream.SaveToFile whichfile, 2
objStream.Close

End If
