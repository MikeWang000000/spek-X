## Building the Windows installer

This is done in two steps:

 * Cross-compiling spek.exe using [MXE](http://mxe.cc/).
 * Building the MSI package under Windows.

For the first step you can use any Unix-y environment. Set up
[MXE](http://mxe.cc/#tutorial) to /opt/mxe-spek.

For this version [MXE #00da92a](https://github.com/mxe/mxe/tree/00da932fef31a046b4507fc3ceb98b17e5f1d682) was used.

Apply `mxe.diff` and build Spek dependencies:

    make pthreads ffmpeg wxwidgets -j1 JOBS=4

Build Spek, adjusting `bundle.sh` variables as necessary:

    ./dist/win/bundle.sh

For the second step, you will need a Windows box with
[WiX](http://wixtoolset.org/) installed. Copy over the entire `dist/win`
directory, cd into it, and run `bundle.bat`.
