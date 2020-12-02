New-Item -Path "C:\WVD" -ItemType Directory -ErrorAction SilentlyContinue -Force

Start-Transcript -Path "C:\WVD\WVD.Apps.Aquarius.Unpack.log"

Expand-Archive -Path ".\WVD.Apps.Aquarius.zip" -DestinationPath "C:\Packages\WVD.Apps.Aquarius" -Force -Verbose

Stop-Transcript
