## 构建 Windows 版本的 Spek

[[英文 English]](./README.md)

现在，您可以通过 MSYS2 在 Windows 上直接构建 Spek 可执行程序，无需交叉编译。

构建步骤：
* 安装 [MSYS2](https://www.msys2.org)。
* 运行 `mingw64.exe`。如果您使用 Windows on ARM，请运行 `clangarm64.exe`。
* 进入项目目录。
* 安装依赖：`./dist/win/install_deps.sh`。此操作将耗费一定的时间。
* 编译并打包 Spek： `./dist/win/bundle.sh`。

可以根据需要修改 `install_deps.sh` 和 `bundle.sh`。