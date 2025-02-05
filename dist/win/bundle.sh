#!/bin/bash
set -xeu

# This script will compile spek.exe under MSYS2 and make a ZIP archive.
# Check README.md in this directory for instructions.

# Adjust these variables if necessary.
MAKE=make
JOBS=3
ZIP=zip
STRIP=strip
WINDRES=windres
CYGPATH=cygpath
WX_CONFIG=wx-config
WX_PREFIX="$(wx-config --prefix)"

LANGUAGES="bs ca cs da de el eo es fi fr gl he hu id it ja ko lv nb nl pl pt_BR ru sk sr@latin sv th tr uk vi zh_CN zh_TW"

cd "$(dirname $0)"/../..
rm -fr dist/win/build && mkdir dist/win/build

# Test windres
"$WINDRES" dist/win/spek.rc -O coff -o dist/win/spek.res

# Run autogen.sh
CXXFLAGS="--static" \
LDFLAGS="-mwindows dist/win/spek.res" ./autogen.sh \
    --disable-shared \
    --enable-static \
    --disable-valgrind \
    --with-wx-config="$WX_CONFIG" \
    --prefix="$PWD/dist/win/build" && \
    "$MAKE" clean

# Compile PO files first
cd po && "$MAKE" && cd ..

# Compile the resource file
./dist/win/compile-rc.py "$WINDRES" "$(CYGPATH "$WX_PREFIX")" $LANGUAGES
mkdir -p src/dist/win && cp dist/win/spek.res src/dist/win/

# Compile spek.exe
"$MAKE" V=1 -j "$JOBS" && "$MAKE" install
"$STRIP" dist/win/build/bin/spek.exe

# Copy files to the bundle
cd dist/win
rm -fr Spek && mkdir Spek
cp build/bin/spek.exe Spek/
cp ../../LICENCE.md Spek/
cp ../../README.md Spek/
mkdir Spek/licenses
cp ../../lic/* Spek/licenses/
for lic in Spek/licenses/*; do
    mv "$lic" "$lic.txt"
done
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
