# Spek-X

[[简体中文 Simplified Chinese]](./README-zh_CN.md)

Spek-X (IPA: /spɛks/) is a fork of [Spek-alternative](https://github.com/withmorten/spek-alternative), which is originally derived from [Spek](https://github.com/alexkay/spek).

Spek is an acoustic spectrum analyser written in C and C++. It uses FFmpeg
libraries for audio decoding and wxWidgets for the GUI.

Spek is available on *BSD, GNU/Linux, Windows and macOS.

Find out more about Spek on its website: <http://spek.cc/>

<img src="./data/spek-screenshot.png" height="500">

## Spek-X 0.9.0 - 2020/7/10

### Sources / Packages

Category                             | Download link
-------------------------------------|----------------
Source tarball                       | [v0.9.0.tar.gz](https://github.com/MikeWang000000/spek-X/archive/v0.9.0.tar.gz)
Windows (x64)                        | [spek-x-0.9.0-windows-x86_64.zip](https://github.com/MikeWang000000/spek-X/releases/download/v0.9.0/spek-x-0.9.0-windows-x86_64.zip)
Windows (Arm64)                      | [spek-x-0.9.0-windows-aarch64.zip](https://github.com/MikeWang000000/spek-X/releases/download/v0.9.0/spek-x-0.9.0-windows-aarch64.zip)
macOS (Intel)                        | [spek-x-0.9.0-macos-x86_64.tgz](https://github.com/MikeWang000000/spek-X/releases/download/v0.9.0/spek-x-0.9.0-macos-x86_64.tgz)
macOS (Apple Silicon)                | [spek-x-0.9.0-macos-aarch64.tgz](https://github.com/MikeWang000000/spek-X/releases/download/v0.9.0/spek-x-0.9.0-macos-aarch64.tgz)
Debian packages (deb-multimedia.org) | [spek-x-dmo/](https://deb-multimedia.org/pool/main/s/spek-x-dmo/)

### New Features And Enhancements

Updates since 0.8.2:
 * Apple Silicon binary is available now.
 * Windows Arm64 binary is available now.
 * FFmpeg is updated to 5.0+
 * wxWidgets is updated to 3.0+
 * Add Command line support for saving spectrograms.
 * Add high-DPI support, fixing clipped text issues. 
 * Add Windows MSYS2 build methods.
 * Single exe file for Windows now.
 * Improved translations in Simplified Chinese, Traditional Chinese and French.
 * Suppress wxWidgets warning pop-ups.
 * Improve file associations on Linux.
 * Crash fixes.

### Build Instructions

[Windows](./dist/win/README.md) | [macOS](./dist/osx/README.md) | [Linux and other Unix-like systems](./INSTALL.md#building-from-the-git-repository)

### Dependencies

 * wxWidgets >= 3.0
 * FFmpeg >= 5.0
