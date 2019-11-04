$path = (Get-Item -Path ".\ExternalSQLHelper.dll").FullName

[Reflection.Assembly]::LoadFile($path)

write-host('----------------------------------------')
write-host('Test 1: �������� �� ��������� IP')
$strIP = "10.0f.10.10"
$ExpectedResult=$false

$rc  = [SQLHelper]::IsIpAdpress($strIP )
if($rc -eq $ExpectedResult) {
write-host('Test  - ������')
}
else {
write-host('Test  - Fail')
write-host("������� ������� ",$rc)
}
 
write-host('----------------------------------------')
write-host('Test 2: �������� ��������� IP')
$strIP = "10.0.10.10"
$ExpectedResult=$true
$rc  = [SQLHelper]::IsIpAdpress($strIP )
if($rc -eq $ExpectedResult) {
write-host('Test - ������')
}
else {
write-host('Test - Fail')
write-host("������� ������� ",$rc)
}
 