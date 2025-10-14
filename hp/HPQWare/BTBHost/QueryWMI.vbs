On Error Resume Next 
Set objFSO=CreateObject("Scripting.FileSystemObject")
Set objFile = objFSO.CreateTextFile("c:\hp\hpqware\btbhost\SetCustomVars.bat", True)

For Each objOS in GetObject("winmgmts:").InstancesOf ("Win32_OperatingSystem")  
	va = split(objOS.Version,".")
	objFile.WriteLine("set WinOSMajor=") & va(0)
	objFile.WriteLine("set WinOSMinor=") & va(1)
	objFile.WriteLine("set WinOSBuild=") & va(2)
	objFile.WriteLine("set WinOSProductType=") & objOS.OperatingSystemSKU
Next
objFile.WriteLine("")
For Each objItem in GetObject("winmgmts:").InstancesOf ("Win32_VideoController")
	objFile.WriteLine("set GPUBrandName=") & objItem.AdapterCompatibility
	objFile.WriteLine("set GPUFullName=") & objItem.Caption
Next
objFile.WriteLine("")
objFile.Close