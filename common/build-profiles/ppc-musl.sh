XBPS_ENDIAN=be
XBPS_LIBC=musl
XBPS_WORDSIZE=32
XBPS_TARGET_CFLAGS="-mcpu=powerpc -mno-altivec -mtune=G4 -mlong-double-64"
XBPS_TARGET_CXXFLAGS="$XBPS_TARGET_CFLAGS"
XBPS_TARGET_FFLAGS=""
XBPS_TRIPLET="powerpc-linux-musl"
XBPS_RUST_TARGET="powerpc-unknown-linux-musl"
