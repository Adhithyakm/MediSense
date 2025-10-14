On Error Resume Next 
dim Architecture, OSArchitecture

for each obj in GetObject("winmgmts:").InstancesOf ("Win32_Processor")  
	Architecture = obj.Architecture
next

for each obj in GetObject("winmgmts:").InstancesOf ("Win32_OperatingSystem")  
	OSArchitecture =  obj.OSArchitecture
next

if Architecture = 12 then 
	WScript.Echo "ARM"
elseif InStr(OSArchitecture, "64") then
	WScript.Echo "x64"
elseif InStr(OSArchitecture, "32") then
	WScript.Echo "x86"
else
	WScript.Echo "Unknown"
end if