REM convert machine code routines and UDGs into data statements
cd src
call routines.bat
cd ..

REM append data statements to BASIC and build
type .\src\main.zxb udgs.zxb routines.zxb > build.zxb
.\tools\zmakebas -l -a @begin -o calirun.tap build.zxb

REM convert the .tap file to .bas that can be optimised with zxbasicus
.\tools\zxbasicus\zxbasicus -a -i calirun.tap
del calirun_0.info
del calirun_0.lst
ren calirun_0.bas
REM create optimiuse .bas file
.\tools\zxbasicus\zxbasicus -t --alloptim -i calirun_0.bas -o calirun.zxb
del calirun_0.bas
REM create .tap file from .bas file
del calirun.tap
.\tools\zxbasicus\zxbasicus -s --line 10 --progname calirun -i calirun.zxb -o calirun.tap

REM tidy up
del udgs.zxb
del routines.zxb
del build.zxb