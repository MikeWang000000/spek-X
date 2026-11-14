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

## Right-click menu ("Analizar con Spek-X")

The ZIP produced by `bundle.sh` also contains three small helper files:

* `install-context-menu.bat` adds *Analizar con Spek-X* to the Explorer right-click menu of every file. Running it opens `spek.exe` with that file and starts the analysis immediately.
* `uninstall-context-menu.bat` removes the entry.
* `context-menu.ps1` does the real work. Use `-ExePath C:\path\to\spek.exe` if `spek.exe` is not in the same folder, `-Label "text"` to change the menu text, and `-Uninstall` to remove it.

The entry is written to `HKEY_CURRENT_USER`, so no administrator rights are needed. On Windows 11 the entry is listed under *Show more options* (Shift+F10). Keep `spek.exe` in a fixed folder: if you move it, run the installer again.

The MSI built from `spek.wxs.in` registers the same entry machine-wide (`HKEY_LOCAL_MACHINE`), so you do not need the scripts when you use the installer.
