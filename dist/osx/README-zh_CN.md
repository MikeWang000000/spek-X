## 构建 macOS 版本的 Spek

[[英文 English]](./README.md)

构建步骤：
* 安装 [Homebrew](https://brew.sh).
* 进入项目目录。
* 安装依赖：`./dist/osx/install_deps.sh`。此操作将耗费一定的时间，可能需要您的 sudo 密码。
* 编译并打包 Spek： `./dist/osx/bundle.sh`。

可以根据需要修改 `install_deps.sh` 和 `bundle.sh`。