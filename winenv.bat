if "$1"=="flash" do (
	doskey b=del bin\flash\bin\openflShaders.swf ^& cls ^& openfl build flash -debug
	doskey r=bin\flash\bin\openflShaders.swf
	doskey bb=del bin\flash\bin\openflShaders.swf ^& cls ^& openfl build flash -debug ^& echo. ^& echo. ^& echo. ^& bin\flash\bin\openflShaders.swf
)

if "$1"=="c++" do (
	doskey b=del bin\windows\cpp\bin\openflShaders.exe ^& cls ^& openfl build windows -debug -Dlegacy
	doskey r=bin\windows\cpp\bin\openflShaders.exe
	doskey bb=del bin\windows\cpp\bin\openflShaders.exe ^& cls ^& openfl build windows -debug -Dlegacy ^& echo. ^& echo. ^& echo. ^& bin\windows\cpp\bin\openflShaders.exe
)

cls