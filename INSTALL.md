# Installation instructions

## Windows

Download section offers two packages: a ZIP archive for x64 processors and a
ZIP archive for Arm64 processors. 32-bit Windows is not supported.

Download the ZIP archive, unpack it somewhere on your disk and run `spek.exe`.

## macOS

Download section offers two packages: a ZIP archive for Intel processors and a
ZIP archive for Apple Silicon. Spek requires macOS 10.5+.

Download and unpack the ZIP archive, then drag the Spek icon to Applications.

## Linux and other Unix-like systems

### Binary packages

Spek-X
 * Debian (deb-multimedia): [spek-x](https://deb-multimedia.org/pool/main/s/spek-x-dmo/), Tsinghua mirror: [spek-x](https://mirrors.tuna.tsinghua.edu.cn/debian-multimedia/pool/main/s/spek-x-dmo/)

Original Spek (Outdated)
 * Arch: [spek](https://aur.archlinux.org/packages/spek/) and
   [spek-git](https://aur.archlinux.org/packages/spek-git/)
 * Debian: [spek](https://packages.debian.org/search?keywords=spek)
 * Fedora: [RPMFusion package](https://bugzilla.rpmfusion.org/show_bug.cgi?id=1718)
 * FreeBSD: [audio/spek](https://www.freshports.org/audio/spek/)
 * Gentoo: [media-sound/spek](https://packages.gentoo.org/packages/media-sound/spek)
 * Ubuntu: [spek](http://packages.ubuntu.com/search?keywords=spek)

### Building from the git repository

    git clone https://github.com/MikeWang000000/spek-X.git
    cd spek-X
    ./autogen.sh
    make

To build you will need wxWidgets and FFmpeg packages. On Debian/Ubuntu you also
need development packages: `libwxgtk3.0-dev`, `wx-common`, `libavcodec-dev` and
`libavformat-dev`.

To start Spek, run:

    src/spek

Or install it with:

    sudo make install

