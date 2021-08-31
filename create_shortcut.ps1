$TargetPath = "C:\SMARTCOP.APP"
$IconPath = "C:\SMARTCOP.APP\Icons"

$Targets = @(Get-ChildItem "$TargetPath" -Filter *.rdp)
$Icons = @(Get-ChildItem "$IconPath" -Filter *)

$Targets | 
ForEach-Object{
    foreach($Icon in $Icons){
        if($_.BaseName -eq $Icon.BaseName){
            $ShortcutIcon = $Icon.FullName
        }
    }
    $Target = $_.FullName
    $TargetName = $_.BaseName
    $WScriptShell = New-Object -ComObject WScript.Shell 
    $Shortcut = $WscriptShell.CreateShortcut("$env:USERPROFILE\Desktop\$TargetName.lnk")
    $Shortcut.TargetPath = $Target
    $Shortcut.IconLocation = $ShortcutIcon
    $Shortcut.Save()
}