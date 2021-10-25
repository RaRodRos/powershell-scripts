# Deactivate mouse acceleration
# From https://social.technet.microsoft.com/Forums/ie/en-US/697e6441-eb8e-482e-96a0-2dd4f67c1015/disable-enhance-pointer-precision-with-powershell?forum=ITCG

$code=@'
[DllImport("user32.dll", EntryPoint = "SystemParametersInfo")]
 public static extern bool SystemParametersInfo(uint uiAction, uint uiParam, int[] pvParam, uint fWinIni);
'@
Add-Type $code -name Win32 -NameSpace System

[System.Win32]::SystemParametersInfo(4,0,0,2)