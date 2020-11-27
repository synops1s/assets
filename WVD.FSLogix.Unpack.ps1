New-Item -Path "C:\WVD" -ItemType Directory -ErrorAction SilentlyContinue -Force

Start-Transcript -Path "C:\WVD\WVD.FSLogix.Unpack.log"

Expand-Archive -Path ".\FSLogix.zip" -DestinationPath "C:\Packages\FSLogix" -Force -Verbose

Stop-Transcript
