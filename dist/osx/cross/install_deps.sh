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

FFMPEG_VER="7.0"
PREFIX="/usr/local"

# Check Homebrew
brew --version >/dev/null 2>&1 || {
    echo "Building spek.app requires Homebrew. Follow the instructions at [https://brew.sh] to install Homebrew."
    exit 1
}

brew install autoconf automake gettext intltool libtool pkg-config wxwidgets nasm wget coreutils || exit 1
# Force install arm64 libraries on x86_64 machines
for dep in jpeg-turbo libpng zstd libtiff pcre2 wxwidgets
do
    brew reinstall $(brew fetch --force --bottle-tag=arm64_ventura "${dep}" | egrep -om1 '/Users/.*\.gz') || exit 1
done

rm -rf $(dirname $0)/../deps
mkdir -p $(dirname $0)/../deps
cd $(dirname $0)/../deps

# === FFmpeg ===
echo "# Installing FFmpeg..."
brew unlink ffmpeg
wget "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VER}.tar.bz2" || exit 1
tar xjvf "ffmpeg-${FFMPEG_VER}.tar.bz2"
cd "ffmpeg-${FFMPEG_VER}"
./configure \
    --enable-cross-compile \
    --arch=arm64 \
    --cc='clang -arch arm64' \
    --prefix="$PREFIX" \
    --enable-version3 \
    --enable-gpl \
    --disable-programs \
    --disable-doc \
    --disable-debug \
    --enable-static \
    --disable-shared \
    --enable-pic \
    --disable-swscale \
    --disable-postproc \
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
    --enable-decoder=aac,aac_fixed,aac_latm,ac3,ac3_fixed,acelp_kelvin,alac,als,amrnb,amrwb,ape,aptx,aptx_hd,atrac1,atrac3,atrac3al,atrac3p,atrac3pal,atrac9,binkaudio_dct,binkaudio_rdft,bmv_audio,cook,dca,dfpwm,dolby_e,dsd_lsbf,dsd_msbf,dsd_lsbf_planar,dsd_msbf_planar,dsicinaudio,dss_sp,dst,eac3,evrc,fastaudio,ffwavesynth,flac,g723_1,g729,gsm,gsm_ms,hca,hcom,iac,ilbc,imc,interplay_acm,mace3,mace6,metasound,mlp,mp1,mp1float,mp2,mp2float,mp3float,mp3,mp3adufloat,mp3adu,mp3on4float,mp3on4,mpc7,mpc8,msnsiren,nellymoser,on2avc,opus,paf_audio,qcelp,qdm2,qdmc,ra_144,ra_288,ralf,sbc,shorten,sipr,siren,smackaud,sonic,tak,truehd,truespeech,tta,twinvq,vmdaudio,vorbis,wavpack,wmalossless,wmapro,wmav1,wmav2,wmavoice,ws_snd1,xma1,xma2,pcm_alaw,pcm_bluray,pcm_dvd,pcm_f16le,pcm_f24le,pcm_f32be,pcm_f32le,pcm_f64be,pcm_f64le,pcm_lxf,pcm_mulaw,pcm_s8,pcm_s8_planar,pcm_s16be,pcm_s16be_planar,pcm_s16le,pcm_s16le_planar,pcm_s24be,pcm_s24daud,pcm_s24le,pcm_s24le_planar,pcm_s32be,pcm_s32le,pcm_s32le_planar,pcm_s64be,pcm_s64le,pcm_sga,pcm_u8,pcm_u16be,pcm_u16le,pcm_u24be,pcm_u24le,pcm_u32be,pcm_u32le,pcm_vidc,derf_dpcm,gremlin_dpcm,interplay_dpcm,roq_dpcm,sdx2_dpcm,sol_dpcm,xan_dpcm,adpcm_4xm,adpcm_adx,adpcm_afc,adpcm_agm,adpcm_aica,adpcm_argo,adpcm_ct,adpcm_dtk,adpcm_ea,adpcm_ea_maxis_xa,adpcm_ea_r1,adpcm_ea_r2,adpcm_ea_r3,adpcm_ea_xas,adpcm_g722,adpcm_g726,adpcm_g726le,adpcm_ima_acorn,adpcm_ima_amv,adpcm_ima_alp,adpcm_ima_apc,adpcm_ima_apm,adpcm_ima_cunning,adpcm_ima_dat4,adpcm_ima_dk3,adpcm_ima_dk4,adpcm_ima_ea_eacs,adpcm_ima_ea_sead,adpcm_ima_iss,adpcm_ima_moflex,adpcm_ima_mtf,adpcm_ima_oki,adpcm_ima_qt,adpcm_ima_rad,adpcm_ima_ssi,adpcm_ima_smjpeg,adpcm_ima_wav,adpcm_ima_ws,adpcm_ms,adpcm_mtaf,adpcm_psx,adpcm_sbpro_2,adpcm_sbpro_3,adpcm_sbpro_4,adpcm_swf,adpcm_thp,adpcm_thp_le,adpcm_vima,adpcm_xa,adpcm_yamaha,adpcm_zork || exit 1
make -j3 || exit 1
echo "$ sudo make install # your password may be necessary"
sudo make install || exit 1

# Clean up
cd ../..
rm -rf ./deps
