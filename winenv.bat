if "%1"=="flash" (
	doskey b=del bin\flash\bin\openflShaders.swf ^& cls ^& openfl build flash -debug
	doskey r=bin\flash\bin\openflShaders.swf
	doskey bb=del bin\flash\bin\openflShaders.swf ^& cls ^& openfl build flash -debug ^& echo. ^& echo. ^& echo. ^& bin\flash\bin\openflShaders.swf
)

if "%1"=="c++" (
	doskey b=del bin\windows\cpp\bin\openflShaders.exe ^& cls ^& openfl build windows -debug
	doskey r=pushd . ^& cd bin\windows\cpp\bin ^& openflShaders.exe ^& popd
	doskey bb=del bin\windows\cpp\bin\openflShaders.exe ^& cls ^& openfl build windows -debug ^& echo. ^& echo. ^& echo. ^& pushd . ^& cd bin\windows\cpp\bin ^& openflShaders.exe ^& popd
)