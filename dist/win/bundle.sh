#!/bin/bash

# This script will compile spek.exe under MSYS2 and make a ZIP archive.
# Check README.md in this directory for instructions.

# Adjust these variables if necessary.
MAKE=make
JOBS=3
ZIP=zip
STRIP=strip
WINDRES=windres
CYGPATH=cygpath
WXCONFIG=wx-config
WX_PREFIX="$(wx-config --prefix)"

LANGUAGES="bs ca cs da de el eo es fi fr gl he hu id it ja ko lv nb nl pl pt_BR ru sk sr@latin sv th tr uk vi zh_CN zh_TW"

cd $(dirname $0)/../..
rm -fr dist/win/build && mkdir dist/win/build

# Test windres
"$WINDRES" dist/win/spek.rc -O coff -o dist/win/spek.res || exit 1

# Run autogen.sh
CXXFLAGS="--static" \
LDFLAGS="-mwindows dist/win/spek.res" ./autogen.sh \
    --disable-shared \
    --enable-static \
    --disable-valgrind \
    --with-wx-config="$WX_CONFIG" \
    --prefix=${PWD}/dist/win/build && \
    "$MAKE" clean || exit 1

# Compile PO files first
cd po && "$MAKE" && cd .. || exit 1

# Compile the resource file
./dist/win/compile-rc.py "$WINDRES" "$(CYGPATH "$WX_PREFIX")" $LANGUAGES || exit 1
mkdir -p src/dist/win && cp dist/win/spek.res src/dist/win/

# Compile spek.exe
"$MAKE" V=1 -j $JOBS && "$MAKE" install || exit 1
"$STRIP" dist/win/build/bin/spek.exe

# Copy files to the bundle
cd dist/win
rm -fr Spek && mkdir Spek
cp build/bin/spek.exe Spek/
cp ../../LICENCE.md Spek/
cp ../../README.md Spek/
mkdir Spek/lic
cp ../../lic/* Spek/lic/
rm -fr build
cd ../..

# Create a zip archive
cd dist/win/Spek
rm -f Spek.zip
"$ZIP" -mr Spek.zip *
cd ../../..

# Clean up
rm -fr src/dist
rm dist/win/spek.res
