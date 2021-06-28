Start-Transcript -Path "C:\WVD\WVD.FSLogix.Unpack.log" -Force

Expand-Archive -Path ".\FSLogix.zip" -DestinationPath "C:\Packages\FSLogix" -Force -Verbose

Stop-Transcript
