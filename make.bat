REM convert machine code routines and UDGs into data statements
cd routines
call routines.bat
cd ..

REM append data statements to BASIC and build
type main.zxb udgs.zxb routines.zxb > build.zxb
.\tools\zmakebas -l -a @begin -o calirun.tap build.zxb

REM tidy up
del udgs.zxb
del routines.zxb
REM del build.zxb