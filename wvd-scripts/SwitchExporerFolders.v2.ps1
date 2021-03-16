Function Set-ExplorerFolder {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [ValidateSet("Local Documents", "Local Pictures", "Local Videos", "Local Downloads", "Local Music", "Desktop", "3D Objects")]
        [String]
        $Folder,

        [Parameter(Mandatory)]
        [ValidateSet("Show", "Hide")]
        [String]
        $Mode      
    )

    $Folders = New-Object System.Collections.Generic.List[PSObject]
    
    $Folders.Add([PSCustomObject]@{
        Name = "Local Documents" 
        RelativePath = "Documents"
    })

    $Folders.Add([PSCustomObject]@{
        Name = "Local Pictures" 
        RelativePath = "Pictures"
    })

    $Folders.Add([PSCustomObject]@{
        Name = "Local Videos" 
        RelativePath = "Videos"
    })

    $Folders.Add([PSCustomObject]@{
        Name = "Local Downloads" 
        RelativePath = "Downloads"
    })

    $Folders.Add([PSCustomObject]@{
        Name = "Local Music" 
        RelativePath = "Music"
    })

    $Folders.Add([PSCustomObject]@{
        Name = "Desktop" 
        RelativePath = "Desktop"
    })

    $Folders.Add([PSCustomObject]@{
        Name = "3D Objects" 
        RelativePath = "3D Objects"
    })

    # $Folders = @(
    #     "{F42EE2D3-909F-4907-8871-4C22FC0BF756}",   # Documents
    #     "{0DDD015D-B06C-45D5-8C4C-F59713854639}",   # Pictures
    #     "{35286A68-3C57-41A1-BBB1-0EAE73D76C95}",   # Videos
    #     "{7D83EE9B-2244-4E70-B1F5-5393042AF1E4}",   # Downloads
    #     "{A0C69A99-21C8-4671-8703-7934162FCF1D}",   # Music
    #     "{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}",   # Desktop
    #     "{31C0DD25-9439-4F12-BF41-7FF4EDA38722}"    # 3D Objects
    # )

    $FolderDescription = $Folders | Where-Object { $_.Name -eq $Folder }
    
    if($null -ne $FolderDescription)
    {
        $FolderPSPath = Get-ChildItem -Path "REGISTRY::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions" | ForEach-Object { Get-ItemProperty $_.pspath } | Where-Object { $_.RelativePath -eq $FolderDescription.RelativePath -and $_.Name -eq $FolderDescription.Name }
        
        if($False -eq (Test-Path -Path "$($FolderPSPath.PSPath)\PropertyBag")) {

            New-Item -Path "$($FolderPSPath.PSPath)\PropertyBag" -Verbose
        }

        New-ItemProperty -Path "$($FolderPSPath.PSPath)\PropertyBag" -Name "ThisPCPolicy" -Value $Mode -Force -Verbose
    }
}

Set-ExplorerFolder -Folder 'Local Documents' -Mode Hide
Set-ExplorerFolder -Folder 'Local Pictures' -Mode Hide
Set-ExplorerFolder -Folder 'Local Videos' -Mode Hide
Set-ExplorerFolder -Folder 'Local Downloads' -Mode Hide
Set-ExplorerFolder -Folder 'Local Music' -Mode Hide
Set-ExplorerFolder -Folder Desktop -Mode Hide

# Set-ExplorerFolder -Folder '3D Objects' -Mode Hide


# Set-ExplorerFolder -Folder 'Local Documents' -Mode Show
# Set-ExplorerFolder -Folder 'Local Pictures' -Mode Show
# Set-ExplorerFolder -Folder 'Local Videos' -Mode Show
# Set-ExplorerFolder -Folder 'Local Downloads' -Mode Show
# Set-ExplorerFolder -Folder 'Local Music' -Mode Show
# Set-ExplorerFolder -Folder Desktop -Mode Show

