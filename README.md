# Spek-X
Spek-X (IPA: /spɛks/) is a fork of [Spek-alternative](https://github.com/MikeWang000000/spek-X), which is originally derived from [Spek](https://github.com/alexkay/spek).

Spek is an acoustic spectrum analyser written in C and C++. It uses FFmpeg
libraries for audio decoding and wxWidgets for the GUI.

Spek is available on *BSD, GNU/Linux, Windows and macOS.

Find out more about Spek on its website: <http://spek.cc/>

## Spek-X 0.9.0 - Coming soon

### New Features And Enhancements

Updates since 0.8.2:
 * Apple Silicon binary is available now.
 * Windows Arm64 binary is available now.
 * FFmpeg is updated to 5.0+
 * wxWidgets is updated to 3.0+
 * Add Command line support for saving spectrograms.
 * Add high-DPI support, fixing clipped text issues. 
 * Add Windows MSYS2 build methods.
 * Improved translations in Simplified Chinese, Traditional Chinese and French.
 * Suppress wxWidgets warning pop-ups.
 * Improve file associations on Linux.
 * Crash fixes.

### Sources / Packages

Spek-X 0.9.0 source tarball:

 * <https://github.com/MikeWang000000/spek-X/archive/v0.9.0.tar.gz>

Windows and Mac OS X binaries:

 * Windows (x64): \<Coming soon\>
 * Windows (Arm64): \<Coming soon\>
 * macOS (Intel): \<Coming soon\>
 * macOS (Apple Silicon): \<Coming soon\>

Debian packages:
 * <https://deb-multimedia.org/pool/main/s/spek-x-dmo/>

### Build Instructions
[Windows](./dist/win/README.md) | [macOS](./dist/osx/README.md) | [Linux and other Unix-like systems](./INSTALL.md#building-from-the-git-repository)

### Dependencies

 * wxWidgets >= 3.0
 * FFmpeg >= 5.0
