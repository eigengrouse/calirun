REM delete previous build output files
del calirun.tap
del calirun.zxb

cd build

REM convert machine code routines and UDGs into data statements to create interim BASIC file
call asm.bat
REM create optimised BASIC file and output .tap file
call basic.bat

cd ..