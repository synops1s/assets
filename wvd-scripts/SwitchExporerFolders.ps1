Function Switch-ExporerFolders {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet("Show", "Hide")]
        [String]
        $Mode    
    )

    $Folders = @(
        "{F42EE2D3-909F-4907-8871-4C22FC0BF756}",   # Documents
        "{0DDD015D-B06C-45D5-8C4C-F59713854639}",   # Pictures
        "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}",   # Videos
        "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}",   # Downloads
        "{A0C69A99-21C8-4671-8703-7934162FCF1D}",   # Music
        "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}",   # Desktop
        "{31C0DD25-9439-4F12-BF41-7FF4EDA38722}"    # 3D Objects
    )

    $Folders | ForEach-Object {
        Set-ItemProperty -Path "REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\$($_)\PropertyBag" -Name ThisPCPolicy -Value $Mode -Verbose
    }
}
