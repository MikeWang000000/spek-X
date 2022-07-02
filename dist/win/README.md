## Build Spek for Windows

[[简体中文 Simplified Chinese]](./README-zh_CN.md)

You can now build the Spek executable directly under MSYS2 on Windows without cross-compiling.

Build steps:
* Install [MSYS2](https://www.msys2.org).
* Run `mingw64.exe`. If you are using Windows on ARM, please run `clangarm64.exe`.
* Enter the project directory.
* Install the dependencies: `./dist/win/install_deps.sh`. This procedure will take some time.
* Compile and bundle Spek: `./dist/win/bundle.sh`.

You can modify `install_deps.sh` and `bundle.sh` as needed.
