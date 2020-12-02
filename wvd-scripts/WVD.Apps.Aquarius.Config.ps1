Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -Force -Verbose
New-Item -Path "C:\WVD" -ItemType Directory -ErrorAction SilentlyContinue -Force

Start-Transcript -Path "C:\WVD\WVD.Apps.Aquarius.Config.log" -Force

$BasePath = "C:\WVD.Apps\Aquarius"
New-Item -Path $BasePath -ItemType Directory -ErrorAction SilentlyContinue -Force

$CmdAquarius = @"
IF EXIST "C:\Program Files\Java\jdk-11.0.4\bin\java.exe" (
    set JAVA_HOME=C:\Program Files\Java\jdk-11.0.4
)

\\pnwnlota079\aquarius_519\sw_runtime\Aquarius.cmd

"@

$CmdAquarius | Set-Content -Path "$($BasePath)\Aquarius.cmd" -Force -Verbose

Stop-Transcript
