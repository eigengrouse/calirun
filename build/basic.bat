REM build .tap file from interim BASIC file
..\tools\zmakebas -l -a @begin -o calirun.tap build.zxb
del build.zxb
REM convert the .tap file to .bas that can be optimised with zxbasicus
..\tools\zxbasicus\zxbasicus -a -i calirun.tap
del calirun_0.info
del calirun_0.lst
REM create optimised .bas file
..\tools\zxbasicus\zxbasicus -t --alloptim -i calirun_0.bas -o ..\calirun.zxb
del calirun_0.bas
REM create output .tap file from .bas file
del calirun.tap
..\tools\zxbasicus\zxbasicus -s --line 10 --progname calirun -i ..\calirun.zxb -o ..\calirun.tap