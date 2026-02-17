# CaliRun

An OutRun inspired racing game written in Sinclair BASIC with a machine code scroll routine assembled from Z80 into BASIC data statements via a build pipeline.

Uses [pasmo](https://pasmo.speccy.org/pasmodoc.html) and [zmakebas](https://github.com/z00m128/zmakebas). Also now [ZX-Basicus](https://jafma.net/software/zxbasicus/) for final optimisations.

`make.bat` assembles the Z80 into Sinclair BASIC via pasmo and some powershell scripts and appends to `main.zxb` to create `build.zxp`, which is then built into a .tap file that can be used with a ZX Spectrum emulator. To build from powershell enter `& .\make.bat` from the root directory.