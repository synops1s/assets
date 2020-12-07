New-Item -Path "C:\WVD" -ItemType Directory -Force
Start-Transcript -Path "C:\WVD\WVD.Apps.Aquarius.Unpack.log" -Force

Expand-Archive -Path ".\WVD.Apps.Aquarius.zip" -DestinationPath "C:\Packages\WVD.Apps.Aquarius" -Force -Verbose

Stop-Transcript
