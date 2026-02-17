REM assemble .asm into hex listing
..\tools\pasmo.exe --hex scroll_attr_down.asm scroll_attr_down.hex
..\tools\pasmo.exe --hex crash_sfx.asm crash_sfx.hex
..\tools\pasmo.exe --hex udgs.asm udgs.hex
REM convert hex listing into BASIC DATA statements
powershell -File ..\tools\hex2routines.ps1 scroll_attr_down.hex crash_sfx.hex > ..\routines.zxb
powershell -File ..\tools\hex2udgs.ps1 udgs.hex > ..\udgs.zxb

REM tidy up
del *.hex