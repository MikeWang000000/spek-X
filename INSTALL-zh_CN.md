# 安装说明

[[英文 English]](./INSTALL.md)

## Windows 系统

有两种软件压缩包可供下载：一个用于 x64 处理器的 ZIP 压缩包，和一个用于 Arm64 处理器的 ZIP 压缩包。32 位的 Windows 系统不被支持。

下载 ZIP 压缩包，在磁盘上的某处解压它，然后运行 `spek.exe`。

## macOS 系统

有两种软件压缩包可供下载: 一个用于 Intel 处理器的 TGZ 压缩包，和一个用于 Apple Silicon 的 TGZ 压缩包。Spek 需要 macOS 10.5+。

下载并解压 ZIP 压缩包，然后将 Spek 图标拖拽至“应用程序 (Applications)”。

## Linux 和其他类 Unix 系统

### 二进制软件包

Spek-X
 * Debian (deb-multimedia): [spek-x](https://deb-multimedia.org/pool/main/s/spek-x-dmo/), 清华镜像: [spek-x](https://mirrors.tuna.tsinghua.edu.cn/debian-multimedia/pool/main/s/spek-x-dmo/)

原 Spek (已经过时)
 * Arch: [spek](https://aur.archlinux.org/packages/spek/) and
   [spek-git](https://aur.archlinux.org/packages/spek-git/)
 * Debian: [spek](https://packages.debian.org/search?keywords=spek)
 * Fedora: [RPMFusion package](https://bugzilla.rpmfusion.org/show_bug.cgi?id=1718)
 * FreeBSD: [audio/spek](https://www.freshports.org/audio/spek/)
 * Gentoo: [media-sound/spek](https://packages.gentoo.org/packages/media-sound/spek)
 * Ubuntu: [spek](http://packages.ubuntu.com/search?keywords=spek)

### 从 git 仓库构建

    git clone https://github.com/MikeWang000000/spek-X.git
    cd spek-X
    ./autogen.sh
    make

您需要 wxWidgets 和 FFmpeg 以完成构建。在 Debian/Ubuntu 上，您还需要以下开发用软件包：`libwxgtk3.0-dev`，`wx-common`，`libavcodec-dev` 和
`libavformat-dev`。

您可以使用以下命令启动 Spek：

    src/spek

或者安装它：

    sudo make install

