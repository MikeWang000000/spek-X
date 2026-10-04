#!/bin/bash
set -xeu

# This script will compile and install the dependencies which are needed to build Spek.app.
# Check README.md in this directory for instructions.

# Adjust these variables if necessary.
WX_VER="3.3.3"
WX_URL="https://github.com/wxWidgets/wxWidgets/releases/download/v$WX_VER/wxWidgets-$WX_VER.tar.bz2"
WX_SHA="81b09d6dd9f1ed9301f8c55a968a488d0491f264dc2bab19a7e407ac67009482"

FFMPEG_VER="9.0.2"
FFMPEG_URL="https://ffmpeg.org/releases/ffmpeg-$FFMPEG_VER.tar.bz2"
FFMPEG_SHA="ee80a25a5621df84498cef46917be87eab3b4f01951e85c2c7cbe5c94914ee70"

[ -z "${ARCH-}" ] && ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    echo "Target architecture: $ARCH"
    MACOSX_DEPLOYMENT_TARGET=10.10
elif [ "$ARCH" = "arm64" ]; then
    echo "Target architecture: $ARCH"
    MACOSX_DEPLOYMENT_TARGET=12.0
else
    echo "Unsupported architecture: $ARCH" >&2
    exit 1
fi

DEPSSRC="$(realpath "$(dirname $0)")/deps.src"
DEPSDIR="$(realpath "$(dirname $0)")/deps.$ARCH"

export MACOSX_DEPLOYMENT_TARGET

install_homebrew_deps()
{
    brew --version >/dev/null 2>&1 || {
        echo "Building Spek.app requires Homebrew."
        echo "Follow the instructions at [https://brew.sh] to install Homebrew."
        exit 1
    }
    brew install -q autoconf automake gettext intltool libtool pkg-config nasm wget coreutils
}

build_wxwidgets()
{
    pushd .

    mkdir -p "$DEPSSRC"
    cd "$DEPSSRC"

    if [ ! -d "wxWidgets-$WX_VER" ]; then
        wget "$WX_URL"
        echo "$WX_SHA wxWidgets-$WX_VER.tar.bz2" | sha256sum -c -
        tar xf "wxWidgets-$WX_VER.tar.bz2"
    fi
    cd "wxWidgets-$WX_VER"

    mkdir "builddir.$ARCH"
    cd "builddir.$ARCH"
    cmake .. \
        -DCMAKE_INSTALL_PREFIX="$DEPSDIR" \
        -DCMAKE_OSX_ARCHITECTURES="$ARCH" \
        -DCMAKE_OSX_DEPLOYMENT_TARGET="$MACOSX_DEPLOYMENT_TARGET" \
        -DCMAKE_BUILD_TYPE=Release \
        -DwxUSE_LIBTIFF=OFF \
        -DwxUSE_LIBJPEG=OFF \
        -DwxUSE_LIBWEBP=OFF \
        -DwxUSE_NANOSVG=OFF \
        -DwxUSE_OPENGL=OFF \
        -DwxUSE_REGEX=OFF \
        -DwxUSE_STC=OFF \
        -DwxUSE_RICHTEXT=OFF \
        -DwxUSE_PROPGRID=OFF \
        -DwxUSE_AUI=OFF \
        -DwxUSE_RIBBON=OFF \
        -DwxUSE_WEBVIEW=OFF \
        -DwxUSE_SVG=OFF \
        -DwxUSE_MEDIACTRL=OFF \
        -DwxUSE_HTML=OFF \
        -DwxUSE_WXHTML_HELP=OFF \
        -DwxUSE_MS_HTML_HELP=OFF \
        -DwxUSE_XRC=OFF \
        -DwxUSE_PRINTING_ARCHITECTURE=OFF \
        -DwxUSE_WEBREQUEST=OFF \
        -DwxUSE_DISPLAY=OFF \
        -DwxUSE_IPC=OFF \
        -DwxUSE_DOC_VIEW_ARCHITECTURE=OFF \
        -DwxUSE_MDI=OFF \
        -DwxUSE_MDI_ARCHITECTURE=OFF \
        -DwxUSE_JOYSTICK=OFF \
        -DwxUSE_METAFILE=OFF \
        -DwxUSE_DRAGIMAGE=OFF \
        -DwxUSE_SOUND=OFF \
        -DwxUSE_NOTIFICATION_MESSAGE=OFF \
        -DwxUSE_GIF=OFF \
        -DwxUSE_PCX=OFF \
        -DwxUSE_TGA=OFF \
        -DwxUSE_IFF=OFF \
        -DwxUSE_PNM=OFF
    make install -j$(nproc)
    # Install wxwin.m4
    mkdir -p "$DEPSDIR/share/aclocal"
    # tempfix: wx-config --host=$host_alias not works
    sed 's/--host=$host_alias//g' ../wxwin.m4 > "$DEPSDIR/share/aclocal/wxwin.m4"
    # Install mo files
    mkdir -p "$DEPSDIR/share/locale"
    for mo in ../locale/*.mo; do
        lang=$(basename "$mo" | sed "s/\.mo$//")
        mkdir -p "$DEPSDIR/share/locale/$lang/LC_MESSAGES"
        cp -a "$mo" "$DEPSDIR/share/locale/$lang/LC_MESSAGES/wxstd.mo"
    done
    unset lang mo

    popd
}

build_ffmpeg()
{
    pushd .

    mkdir -p "$DEPSSRC"
    cd "$DEPSSRC"

    if [ ! -d "ffmpeg-${FFMPEG_VER}" ]; then
        wget "$FFMPEG_URL"
        # Pass "-" explicitly so that the checksum is read from stdin.
        # The BSD/Darwin sha256sum bundled with macOS requires a file
        # argument, unlike GNU coreutils which defaults to stdin.
        echo "$FFMPEG_SHA ffmpeg-${FFMPEG_VER}.tar.bz2" | sha256sum -c -
        tar xf "ffmpeg-${FFMPEG_VER}.tar.bz2"
    fi
    cd "ffmpeg-${FFMPEG_VER}"

    mkdir "builddir.$ARCH"
    cd "builddir.$ARCH"
    ../configure \
        --enable-cross-compile \
        --arch="$ARCH" \
        --cc="/usr/bin/clang -arch $ARCH" \
        --prefix="$DEPSDIR" \
        --install-name-dir="@rpath" \
        --enable-version3 \
        --enable-gpl \
        --disable-programs \
        --disable-doc \
        --disable-debug \
        --disable-static \
        --enable-shared \
        --enable-pic \
        --disable-swscale \
        --disable-avfilter \
        --disable-avdevice \
        --disable-network \
        --disable-xlib \
        --disable-encoders \
        --disable-hwaccels \
        --disable-muxers \
        --disable-bsfs \
        --disable-devices \
        --disable-filters \
        --disable-protocols \
        --enable-protocol=file,pipe \
        --disable-parsers \
        --enable-parser=aac,aac_latm,ac3,cook,dca,dirac,dolby_e,flac,g723_1,g729,gsm,mlp,mpegaudio,opus,sbc,sipr,tak,vorbis\
        --disable-decoders \
        --enable-decoder=aac,aac_fixed,aac_latm,ac3,ac3_fixed,acelp_kelvin,alac,als,amrnb,amrwb,ape,aptx,aptx_hd,atrac1,atrac3,atrac3al,atrac3p,atrac3pal,atrac9,binkaudio_dct,binkaudio_rdft,bmv_audio,cook,dca,dfpwm,dolby_e,dsd_lsbf,dsd_msbf,dsd_lsbf_planar,dsd_msbf_planar,dsicinaudio,dss_sp,dst,eac3,evrc,fastaudio,ffwavesynth,flac,g723_1,g729,gsm,gsm_ms,hca,hcom,iac,ilbc,imc,interplay_acm,mace3,mace6,metasound,mlp,mp1,mp1float,mp2,mp2float,mp3float,mp3,mp3adufloat,mp3adu,mp3on4float,mp3on4,mpc7,mpc8,msnsiren,nellymoser,on2avc,opus,paf_audio,qcelp,qdm2,qdmc,ra_144,ra_288,ralf,sbc,shorten,sipr,siren,smackaud,tak,truehd,truespeech,tta,twinvq,vmdaudio,vorbis,wavpack,wmalossless,wmapro,wmav1,wmav2,wmavoice,ws_snd1,xma1,xma2,pcm_alaw,pcm_bluray,pcm_dvd,pcm_f16le,pcm_f24le,pcm_f32be,pcm_f32le,pcm_f64be,pcm_f64le,pcm_lxf,pcm_mulaw,pcm_s8,pcm_s8_planar,pcm_s16be,pcm_s16be_planar,pcm_s16le,pcm_s16le_planar,pcm_s24be,pcm_s24daud,pcm_s24le,pcm_s24le_planar,pcm_s32be,pcm_s32le,pcm_s32le_planar,pcm_s64be,pcm_s64le,pcm_sga,pcm_u8,pcm_u16be,pcm_u16le,pcm_u24be,pcm_u24le,pcm_u32be,pcm_u32le,pcm_vidc,derf_dpcm,gremlin_dpcm,interplay_dpcm,roq_dpcm,sdx2_dpcm,sol_dpcm,xan_dpcm,adpcm_4xm,adpcm_adx,adpcm_afc,adpcm_agm,adpcm_aica,adpcm_argo,adpcm_ct,adpcm_dtk,adpcm_ea,adpcm_ea_maxis_xa,adpcm_ea_r1,adpcm_ea_r2,adpcm_ea_r3,adpcm_ea_xas,adpcm_g722,adpcm_g726,adpcm_g726le,adpcm_ima_acorn,adpcm_ima_amv,adpcm_ima_alp,adpcm_ima_apc,adpcm_ima_apm,adpcm_ima_cunning,adpcm_ima_dat4,adpcm_ima_dk3,adpcm_ima_dk4,adpcm_ima_ea_eacs,adpcm_ima_ea_sead,adpcm_ima_iss,adpcm_ima_moflex,adpcm_ima_mtf,adpcm_ima_oki,adpcm_ima_qt,adpcm_ima_rad,adpcm_ima_ssi,adpcm_ima_smjpeg,adpcm_ima_wav,adpcm_ima_ws,adpcm_ms,adpcm_mtaf,adpcm_psx,adpcm_sbpro_2,adpcm_sbpro_3,adpcm_sbpro_4,adpcm_swf,adpcm_thp,adpcm_thp_le,adpcm_vima,adpcm_xa,adpcm_yamaha,adpcm_zork
    make install -j$(nproc)

    popd
}

install_homebrew_deps
build_wxwidgets
build_ffmpeg
