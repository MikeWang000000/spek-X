#!/bin/bash

if [ "$1" != "i_am_ci" ]
then
    cat << EOF

!!! DO NOT RUN THIS SCRIPT ON YOUR COMPUTER !!!
-----------------------------------------------
This script is used to build Spek-X Apple Silicon packages on Intel macOS CI.
It will break your dependencies if not executed in a container.

EOF
    exit 1
fi

LANGUAGES="bs ca cs da de el eo es fi fr gl he hu id it ja ko lv nb nl pl pt_BR ru sk sr@latin sv th tr uk vi zh_CN zh_TW"
LOCALEDIR="/usr/local/share/locale/"
[ ! -d "$LOCALEDIR" ] && [ -d "$HOMEBREW_PREFIX/share/locale/" ] && LOCALEDIR="$HOMEBREW_PREFIX/share/locale/"

cd $(dirname $0)/../../..

rm -f src/spek

sed 's/ --host=.*"/"/' "$HOMEBREW_PREFIX"/share/wx/*/aclocal/wxwin.m4 > wxwin.m4
echo "m4_include([wxwin.m4])" > acinclude.m4

./autogen.sh CC='clang -arch arm64' CXX='clang++ -arch arm64' --host=arm64-apple-darwin && make -j2 || exit 1

cd dist/osx
rm -fr Spek.app
mkdir -p Spek.app/Contents/MacOS
mkdir -p Spek.app/Contents/Frameworks
mkdir -p Spek.app/Contents/Resources
mv ../../src/spek Spek.app/Contents/MacOS/Spek
cp Info.plist Spek.app/Contents/
cp Spek.icns Spek.app/Contents/Resources/
cp *.png Spek.app/Contents/Resources/
cp ../../LICENCE.md Spek.app/Contents/Resources/
cp ../../README.md Spek.app/Contents/Resources/
mkdir Spek.app/Contents/Resources/lic
cp ../../lic/* Spek.app/Contents/Resources/lic/

for lang in $LANGUAGES; do
    mkdir -p Spek.app/Contents/Resources/"$lang".lproj
    cp -v ../../po/"$lang".gmo Spek.app/Contents/Resources/"$lang".lproj/spek.mo
    cp -v "$LOCALEDIR""$lang"/LC_MESSAGES/wxstd*.mo Spek.app/Contents/Resources/"$lang".lproj/wxstd.mo
done
mkdir -p Spek.app/Contents/Resources/en.lproj

BINS="Spek.app/Contents/MacOS/Spek"
while [ ! -z "$BINS" ]; do
    NEWBINS=""
    for bin in $BINS; do
        echo "Updating dependendies for $bin."
        LIBS=$(otool -L $bin | grep -e /usr/local/ -e /opt/ | tr -d '\t' | awk '{print $1}')
        for lib in $LIBS; do
            reallib=$(realpath $lib)
            libname=$(basename $reallib)
            install_name_tool -change $lib @executable_path/../Frameworks/$libname $bin
            if [ ! -f Spek.app/Contents/Frameworks/$libname ]; then
                echo "\tBundling $reallib."
                cp $reallib Spek.app/Contents/Frameworks/
                chmod +w Spek.app/Contents/Frameworks/$libname
                install_name_tool -id @executable_path/../Frameworks/$libname Spek.app/Contents/Frameworks/$libname
                NEWBINS="$NEWBINS Spek.app/Contents/Frameworks/$libname"
            fi
        done
    done
    BINS="$NEWBINS"
done

# Sign the app
codesign -fs - ./Spek.app ./Spek.app/Contents/Frameworks/*

# Create a gzip tar archive
rm -f Spek.tgz
tar cvzf Spek.tgz ./Spek.app

# Clean up
cd ../..
rm wxwin.m4 acinclude.m4
