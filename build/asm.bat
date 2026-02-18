REM assemble .asm into hex listing
..\tools\pasmo.exe --hex ..\src\scroll_attr_down.asm scroll_attr_down.hex
..\tools\pasmo.exe --hex ..\src\crash_sfx.asm crash_sfx.hex
..\tools\pasmo.exe --hex ..\src\udgs.asm udgs.hex
REM convert hex listing into BASIC DATA statements
powershell -File hex2routines.ps1 scroll_attr_down.hex crash_sfx.hex > routines.zxb
powershell -File hex2udgs.ps1 udgs.hex > udgs.zxb
REM create catenated BASIC file
type ..\src\main.zxb udgs.zxb routines.zxb > build.zxb
REM tidy up
del *.hex
del udgs.zxb
del routines.zxb