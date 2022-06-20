#! /usr/bin/sh

export NDK=/home/lz/Android/Sdk/ndk/21.1.6352462

export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/linux-x86_64

API=21

build_android()
{
    echo "Compiling FFmpeg for $CPU"
    ./configure \
        --prefix=$PREFIX \
        --disable-neon \
        --disable-hwaccels \
        --disable-gpl \
        --disable-postproc \
        --enable-shared \
        --enable-jni \
        --disable-mediacodec \
        --disable-decoder=h264_mediacodec \
        --disable-static \
        --disable-doc \
        --disable-ffmpeg \
        --disable-ffplay \
        --disable-ffprobe \
        --disable-avdevice \
        --disable-doc \
        --disable-symver \
        --cross-prefix=$CROSS_PREFIX \
        --target-os=android \
        --arch=$ARCH \
        --cpu=$CPU \
        --cc=$CC \
        --cxx=$CXX \
        --enable-cross-compile \
        --sysroot=$SYSROOT \
        --extra-cflags="-Os -fpic $OPTIMIZE_CFLAGS"

    make clean
    make
    make install
    echo "The Compilation of FFmpeg for $CPU is completed"
}

#armv8-a
ARCH=arm64
CPU=armv8-a
ABI=arm64-v8a


CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++

AS=$CC
AR=$TOOLCHAIN/bin/llvm-ar
LD=$TOOLCHAIN/bin/ld
RANLIB=$TOOLCHAIN/bin/llvm-ranlib
STRIP=$TOOLCHAIN/bin/llvm-strip

SYSROOT=$TOOLCHAIN/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
# output path
PREFIX=$(pwd)/android/$ABI
OPTIMIZE_CFLAGS="-march=$CPU"
build_android


#armv7-a
ARCH=arm
CPU=armv7-a
ABI=armeabi-v7a

CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++

AS=$CC
AR=$TOOLCHAIN/bin/llvm-ar
LD=$TOOLCHAIN/bin/ld
RANLIB=$TOOLCHAIN/bin/llvm-ranlib
STRIP=$TOOLCHAIN/bin/llvm-strip

SYSROOT=$TOOLCHAIN/sysroot
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
PREFIX=$(pwd)/android/$ABI
OPTIMIZE_CFLAGS="-mfloat-abi=softfp -mfpu=vfp -marm -march=$CPU "
build_android
