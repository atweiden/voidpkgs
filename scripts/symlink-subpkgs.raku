use v6;

=begin pod
=head NAME

symlink-subpkgs.raku

=head SYNOPSIS

    scripts/symlink-subpkgs.raku

=head DESCRIPTION

Create relative symlinks in srcpkgs to handle subpkgs properly.

Symlinks take into consideration downstream changes, e.g. removal of
GUI support.
=end pod

# path to https://github.com/atweiden/voidpkgs
constant $ROOT = sprintf(Q{%s/..}, $*PROGRAM.dirname).IO.resolve;
# path to https://github.com/atweiden/voidpkgs/srcpkgs
constant $SRCPKGS = sprintf(Q{%s/srcpkgs}, $ROOT);
# array of subpackages indexed by base pkg
constant %PKG = Map.new(
    '66' => qw<66-devel
               66-doc>,
    '7zip' => qw<7zip-unrar
                 p7zip
                 p7zip-unrar>,
    'NetAuth' => ['NetAuth-server'],
    'abseil-cpp' => ['abseil-cpp-devel'],
    'acl' => qw<acl-devel
                acl-progs>,
    'alsa-lib' => ['alsa-lib-devel'],
    'ansible-core' => ['ansible-base'],
    'apache' => qw<apache-devel
                   apache-htpasswd>,
    'apparmor' => qw<libapparmor
                     libapparmor-devel>,
    'apr' => ['apr-devel'],
    'apr-util' => qw<apr-util-db
                     apr-util-devel
                     apr-util-gdbm
                     apr-util-ldap
                     apr-util-odbc
                     apr-util-pgsql
                     apr-util-sqlite>,
    'argon2' => qw<libargon2
                   libargon2-devel>,
    'aria2' => qw<libaria2
                  libaria2-devel>,
    'atf' => qw<atf-devel
                atf-libs>,
    'attr' => qw<attr-devel
                 attr-progs>,
    'bash' => ['bash-devel'],
    'bcc' => qw<bcc-devel
                bcc-tools
                python3-bcc>,
    'bearssl' => ['bearssl-devel'],
    'benchmark' => ['benchmark-devel'],
    'bind' => qw<bind-devel
                 bind-libs
                 bind-utils>,
    'binutils' => qw<binutils-devel
                     binutils-doc
                     libiberty-devel>,
    'bitcoin' => qw<bitcoin-devel
                    bitcoin-doc>,
    'boost' => qw<boost-build
                  boost-devel
                  boost-python3
                  libboost_atomic
                  libboost_chrono
                  libboost_container
                  libboost_context
                  libboost_contract
                  libboost_coroutine
                  libboost_date_time
                  libboost_fiber
                  libboost_filesystem
                  libboost_graph
                  libboost_graph_parallel
                  libboost_iostreams
                  libboost_json
                  libboost_locale
                  libboost_log
                  libboost_log_setup
                  libboost_math_c99
                  libboost_math_c99f
                  libboost_math_c99l
                  libboost_math_tr1
                  libboost_math_tr1f
                  libboost_math_tr1l
                  libboost_mpi
                  libboost_mpi-python3
                  libboost_nowide
                  libboost_prg_exec_monitor
                  libboost_program_options
                  libboost_random
                  libboost_regex
                  libboost_serialization
                  libboost_stacktrace_addr2line
                  libboost_stacktrace_basic
                  libboost_stacktrace_noop
                  libboost_sync
                  libboost_system
                  libboost_thread
                  libboost_timer
                  libboost_type_erasure
                  libboost_unit_test_framework
                  libboost_url
                  libboost_wave
                  libboost_wserialization>,
    'botan' => qw<botan-devel
                  botan-doc>,
    'brotli' => ['brotli-devel'],
    'btrfs-progs' => qw<libbtrfs
                        libbtrfs-devel
                        libbtrfsutil
                        libbtrfsutil-devel>,
    'busybox' => qw<busybox-core
                    busybox-huge
                    busybox-static>,
    'bzip2' => ['bzip2-devel'],
    'c-ares' => ['c-ares-devel'],
    'capnproto' => ['capnproto-devel'],
    'check' => ['check-devel'],
    'chicken' => qw<chicken-devel
                    libchicken>,
    'clucene' => ['clucene-devel'],
    'cmocka' => ['cmocka-devel'],
    'confuse' => ['confuse-devel'],
    'coreboot-utils' => ['coreboot-utils-me_cleaner'],
    'cracklib' => qw<cracklib-devel
                     libcracklib>,
    'crypto++' => ['crypto++-devel'],
    'cryptsetup' => qw<cryptsetup-devel
                       cryptsetup-static
                       libcryptsetup>,
    'curl' => qw<chroot-curl
                 libcurl
                 libcurl-devel>,
    'cyrus-sasl' => qw<cyrus-sasl-modules
                       cyrus-sasl-modules-gssapi
                       cyrus-sasl-modules-ldap
                       cyrus-sasl-modules-sql>,
    'czmq' => ['czmq-devel'],
    'dar' => qw<libdar
                libdar-devel>,
    'db' => qw<db-devel
               db-doc
               libdb
               libdb-cxx>,
    'dhcp' => ['dhclient'],
    'dmraid' => ['dmraid-devel'],
    'docker-cli' => ['docker'],
    'dovecot' => qw<dovecot-devel
                    dovecot-plugin-ldap
                    dovecot-plugin-lucene
                    dovecot-plugin-mysql
                    dovecot-plugin-pgsql
                    dovecot-plugin-sqlite>,
    'dovecot-plugin-pigeonhole' => qw<dovecot-plugin-pigeonhole-devel
                                      dovecot-plugin-pigeonhole-ldap>,
    'dqlite' => ['dqlite-devel'],
    'dracut' => <dracut-network
                 dracut-uefi>,
    'dtc' => ['dtc-devel'],
    'e2fsprogs' => qw<e2fsprogs-devel
                      e2fsprogs-libs
                      fuse2fs>,
    'efitools' => ['efitools-efi'],
    'efivar' => qw<libefivar
                   libefivar-devel>,
    'elfutils' => qw<debuginfod
                     elfutils-devel
                     libdebuginfod
                     libelf>,
    'erlang' => ['erlang-doc'],
    'eudev' => qw<eudev-libudev
                  eudev-libudev-devel>,
    'execline' => qw<execline-devel
                     execline-doc>,
    'expat' => qw<expat-devel
                  xmlwf>,
    'expect' => ['expect-devel'],
    'fcgi' => ['fcgi-devel'],
    'ffcall' => ['ffcall-devel'],
    'fftw' => qw<fftw-devel
                 libfftw>,
    'file' => qw<file-devel
                 libmagic>,
    'flake8' => ['python3-flake8'],
    'flac' => qw<libflac
                 libflac-devel>,
    'flex' => ['libfl-devel'],
    'flintlib' => ['flintlib-devel'],
    'fmt' => ['fmt-devel'],
    'fontconfig' => qw<fontconfig-devel
                       fontconfig-doc>,
    'freetype' => ['freetype-devel'],
    'fuse' => ['fuse-devel'],
    'fuse3' => ['fuse3-devel'],
    'gc' => ['gc-devel'],
    'gcc' => qw<gcc-ada
                gcc-fortran
                gcc-go
                gcc-go-tools
                gcc-objc
                gcc-objc++
                libada
                libada-devel
                libatomic
                libatomic-devel
                libgcc
                libgcc-devel
                libgfortran
                libgfortran-devel
                libgo
                libgo-devel
                libgomp
                libgomp-devel
                libitm
                libitm-devel
                libobjc
                libobjc-devel
                libquadmath
                libquadmath-devel
                libsanitizer
                libsanitizer-devel
                libstdc++
                libstdc++-devel
                libvtv
                libvtv-devel>,
    'gcc-multilib' => ['gcc-objc-multilib'],
    'gd' => qw<gd-devel
               gd-progs>,
    'gdb' => ['gdb-common'],
    'gdbm' => ['gdbm-devel'],
    'geoip' => qw<geoip-devel
                  libgeoip>,
    'getdns' => ['getdns-devel'],
    'gettext' => qw<gettext-devel
                    gettext-devel-examples
                    gettext-devel-tools
                    gettext-libs>,
    'gf2x' => ['gf2x-devel'],
    'gflags' => ['gflags-devel'],
    'giflib' => qw<giflib-devel
                   giflib-tools>,
    'git' => qw<git-all
                git-cvs
                git-netrc
                git-scalar
                git-svn>,
    'glibc' => qw<glibc-devel
                  glibc-locales
                  nscd>,
    'gmp' => qw<gmp-devel
                gmpxx
                gmpxx-devel>,
    'gnulib' => ['git-merge-changelog'],
    'gnupg' => qw<gnupg2
                  gnupg2-scdaemon>,
    'gnutls' => qw<gnutls-devel
                   gnutls-tools>,
    'gperftools' => ['gperftools-devel'],
    'gpgme' => qw<gpgme-devel
                  gpgmepp
                  gpgmepp-devel>,
    'groff' => qw<groff-doc
                  libgroff>,
    'grpc' => qw<grpc-devel
                 libgrpc>,
    'grub' => qw<grub-arm64-efi
                 grub-i386-coreboot
                 grub-i386-efi
                 grub-powerpc-ieee1275
                 grub-utils
                 grub-x86_64-efi
                 grub-xen>,
    'grub-btrfs' => ['grub-btrfs-runit'],
    'gsasl' => qw<gsasl-devel
                  libgsasl>,
    'gtest' => ['gtest-devel'],
    'guile' => qw<guile-devel
                  libguile>,
    'gummiboot' => ['gummiboot-efistub'],
    'h2o' => ['h2o-devel'],
    'haveged' => qw<libhaveged
                    libhaveged-devel>,
    'http-parser' => ['http-parser-devel'],
    'httrack' => ['httrack-devel'],
    'hunspell' => qw<hunspell-devel
                     libhunspell1.7>,
    'hwloc' => qw<libhwloc
                  libhwloc-devel>,
    'i2pd' => ['i2pd-devel'],
    'icdiff' => ['python3-icdiff'],
    'icu' => qw<icu-devel
                icu-libs>,
    'inih' => ['inih-devel'],
    'inetutils' => qw<inetutils-dnsdomainname
                      inetutils-ftp
                      inetutils-hostname
                      inetutils-ifconfig
                      inetutils-inetd
                      inetutils-ping
                      inetutils-rcp
                      inetutils-rexec
                      inetutils-rlogin
                      inetutils-rsh
                      inetutils-syslog
                      inetutils-talk
                      inetutils-telnet
                      inetutils-tftp
                      inetutils-traceroute
                      inetutils-uucpd
                      inetutils-whois>,
    'iproute2' => ['iproute2-tc-ipt'],
    'iptables' => qw<iptables-devel
                     iptables-nft>,
    'isl15' => ['isl15-devel'],
    'janet' => ['janet-devel'],
    'jansson' => ['jansson-devel'],
    'jbigkit' => qw<jbigkit-devel
                    jbigkit-libs>,
    'jemalloc' => ['jemalloc-devel'],
    'jitterentropy' => ['jitterentropy-devel'],
    'jq' => ['jq-devel'],
    'json-c' => ['json-c-devel'],
    'jsoncpp' => ['jsoncpp-devel'],
    'keybase' => ['kbfs'],
    'keyutils' => qw<keyutils-devel
                     libkeyutils>,
    'kmod' => qw<libkmod
                 libkmod-devel>,
    'kubernetes' => ['kubectl'],
    'kyua' => ['kyua-tests'],
    'lame' => ['lame-devel'],
    'lapack' => qw<blas
                   blas-devel
                   cblas
                   cblas-devel
                   lapack-devel
                   lapacke
                   lapacke-devel>,
    'ldns' => qw<libldns
                 libldns-devel>,
    'libaio' => ['libaio-devel'],
    'libaom' => qw<libaom-devel
                   libaom-tools>,
    'libarchive' => qw<bsdtar
                       libarchive-devel>,
    'libassuan' => ['libassuan-devel'],
    'libatomic_ops' => ['libatomic_ops-devel'],
    'libbitcoin-blockchain' => ['libbitcoin-blockchain-devel'],
    'libbitcoin-client' => ['libbitcoin-client-devel'],
    'libbitcoin-consensus' => ['libbitcoin-consensus-devel'],
    'libbitcoin-database' => ['libbitcoin-database-devel'],
    'libbitcoin-explorer' => ['libbitcoin-explorer-devel'],
    'libbitcoin-network' => ['libbitcoin-network-devel'],
    'libbitcoin-node' => ['libbitcoin-node-devel'],
    'libbitcoin-protocol' => ['libbitcoin-protocol-devel'],
    'libbitcoin-secp256k1' => ['libbitcoin-secp256k1-devel'],
    'libbitcoin-server' => ['libbitcoin-server-devel'],
    'libbitcoin-system' => ['libbitcoin-system-devel'],
    'libbpf' => ['libbpf-devel'],
    'libbsd' => ['libbsd-devel'],
    'libcap' => qw<libcap-devel
                   libcap-progs>,
    'libcap-ng' => qw<libcap-ng-devel
                      libcap-ng-progs
                      libcap-ng-python
                      libcap-ng-python3>,
    'libcbor' => ['libcbor-devel'],
    'libcgroup' => qw<libcgroup
                      libcgroup-devel
                      libcgroup-utils>,
    'libcli' => ['libcli-devel'],
    'libconfig' => qw<libconfig++
                      libconfig++-devel
                      libconfig-devel>,
    'libcppunit' => qw<libcppunit-devel
                       libcppunit-examples>,
    'libdaemon' => ['libdaemon-devel'],
    'libde265' => ['libde265-devel'],
    'libdnet' => ['libdnet-devel'],
    'libedit' => ['libedit-devel'],
    'libev' => ['libev-devel'],
    'libevent' => ['libevent-devel'],
    'libexecinfo' => ['libexecinfo-devel'],
    'libffi' => ['libffi-devel'],
    'libfido2' => ['libfido2-devel'],
    'libftdi1' => ['libftdi1-devel'],
    'libgcrypt' => ['libgcrypt-devel'],
    'libgfshare' => qw<libgfshare-devel
                       libgfshare-tools>,
    'libgit2' => ['libgit2-devel'],
    'libgpg-error' => ['libgpg-error-devel'],
    'libgssglue' => ['libgssglue-devel'],
    'libheif' => qw<libheif-devel
                    libheif-tools>,
    'libhugetlbfs' => qw<libhugetlbfs-devel
                         libhugetlbfs-tools>,
    'libidn' => ['libidn-devel'],
    'libidn2' => ['libidn2-devel'],
    'libiscsi' => qw<libiscsi-devel
                     libiscsi-tools>,
    'libjpeg-turbo' => qw<libjpeg-turbo-devel
                          libjpeg-turbo-tools>,
    'libkdumpfile' => ['libkdumpfile-devel'],
    'libksba' => ['libksba-devel'],
    'libluv' => ['libluv-devel'],
    'libmaxminddb' => ['libmaxminddb-devel'],
    'libmd' => ['libmd-devel'],
    'libmicrohttpd' => ['libmicrohttpd-devel'],
    'libmnl' => ['libmnl-devel'],
    'libmpack' => ['libmpack-devel'],
    'libmpc' => ['libmpc-devel'],
    'libnet' => ['libnet-devel'],
    'libnetfilter_acct' => ['libnetfilter_acct-devel'],
    'libnetfilter_conntrack' => ['libnetfilter_conntrack-devel'],
    'libnetfilter_cthelper' => ['libnetfilter_cthelper-devel'],
    'libnetfilter_cttimeout' => ['libnetfilter_cttimeout-devel'],
    'libnetfilter_log' => ['libnetfilter_log-devel'],
    'libnetfilter_queue' => ['libnetfilter_queue-devel'],
    'libnfc' => ['libnfc-devel'],
    'libnfnetlink' => ['libnfnetlink-devel'],
    'libnfs' => ['libnfs-devel'],
    'libnftnl' => ['libnftnl-devel'],
    'libnl' => ['libnl-devel'],
    'libnl3' => qw<libnl3-devel
                   libnl3-progs>,
    'libnvme' => qw<libnvme-devel
                    libnvme-doc
                    python3-libnvme>,
    'libogg' => ['libogg-devel'],
    'libpcap' => ['libpcap-devel'],
    'libpciaccess' => ['libpciaccess-devel'],
    'libpipeline' => ['libpipeline-devel'],
    'libpng' => qw<libpng-devel
                   libpng-progs>,
    'libpsl' => ['libpsl-devel'],
    'libpwquality' => qw<libpwquality-devel
                         libpwquality-python3>,
    'libqb' => ['libqb-devel'],
    'libreadline8' => qw<libhistory8
                         readline-devel>,
    'librsync' => ['librsync-devel'],
    'libsasl' => ['libsasl-devel'],
    'libscrypt' => ['libscrypt-devel'],
    'libseccomp' => ['libseccomp-devel'],
    'libselinux' => ['libselinux-devel'],
    'libsepol' => ['libsepol-devel'],
    'libsigc++' => ['libsigc++-devel'],
    'libsigsegv' => ['libsigsegv-devel'],
    'libsmbios' => qw<libsmbios-devel
                      libsmbios-utils
                      python3-libsmbios>,
    'libsndfile' => qw<libsndfile-devel
                       libsndfile-progs>,
    'libsodium' => ['libsodium-devel'],
    'libsoxr' => qw<libsoxr-devel
                    libsoxr-doc>,
    'libssh' => ['libssh-devel'],
    'libssh2' => ['libssh2-devel'],
    'libtasn1' => qw<libtasn1-devel
                     libtasn1-tools>,
    'libtermkey' => ['libtermkey-devel'],
    'libtirpc' => ['libtirpc-devel'],
    'libtls' => qw<libressl-netcat
                   libtls-devel>,
    'libtommath' => ['libtommath-devel'],
    'libtool' => qw<libltdl
                    libltdl-devel>,
    'libtommath' => ['libtommath-devel'],
    'libtorrent' => ['libtorrent-devel'],
    'libucontext' => ['libucontext-devel'],
    'libunistring' => ['libunistring-devel'],
    'libunwind' => ['libunwind-devel'],
    'liburcu' => ['liburcu-devel'],
    'libusb' => ['libusb-devel'],
    'libusb-compat' => ['libusb-compat-devel'],
    'libutempter' => ['libutempter-devel'],
    'libuv' => ['libuv-devel'],
    'libvorbis' => ['libvorbis-devel'],
    'libvterm' => ['libvterm-devel'],
    'libwebp' => qw<libsharpyuv
                    libsharpyuv-devel
                    libwebp-devel
                    libwebp-tools>,
    'libxml2' => qw<libxml2-devel
                    libxml2-python3>,
    'libxslt' => qw<libxslt-devel
                    libxslt-python3>,
    'libyaml' => ['libyaml-devel'],
    'libzip' => ['libzip-devel'],
    'linux-firmware' => qw<linux-firmware-amd
                           linux-firmware-broadcom
                           linux-firmware-intel
                           linux-firmware-network
                           linux-firmware-nvidia
                           linux-firmware-qualcomm>,
    'linux-lts' => ['linux-lts-headers'],
    'linux-mainline' => ['linux-mainline-headers'],
    'linux' => ['linux-headers'],
    'linux5.15' => qw<linux5.15-dbg
                      linux5.15-headers>,
    'linux6.1' => qw<linux6.1-dbg
                     linux6.1-headers>,
    'linux6.3' => qw<linux6.3-dbg
                     linux6.3-headers>,
    'llhttp' => ['llhttp-devel'],
    'llvm12' => ['libllvm12'],
    'llvm15' => qw<clang
                   clang-analyzer
                   clang-tools-extra
                   libclang
                   libclang-cpp
                   libcxx
                   libcxx-devel
                   libcxxabi
                   libcxxabi-devel
                   libllvm15
                   libomp
                   libomp-devel
                   lld
                   lld-devel
                   lldb
                   lldb-devel
                   llvm-unwind
                   llvm-unwind-devel>,
    'lm_sensors' => qw<libsensors
                       libsensors-devel>,
    'lowdown' => ['lowdown-devel'],
    'lttng-tools' => ['lttng-tools-devel'],
    'lttng-ust' => ['lttng-ust-devel'],
    'LuaJIT' => ['LuaJIT-devel'],
    'lua51' => ['lua51-devel'],
    'lua52' => ['lua52-devel'],
    'lua53' => qw<lua
                  lua-devel
                  lua53-devel>,
    'lua54' => ['lua54-devel'],
    'lua54-lpeg' => qw<lua-lpeg
                       lua51-lpeg
                       lua52-lpeg
                       lua53-lpeg>,
    'lua54-zlib' => qw<lua-zlib
                       lua51-zlib
                       lua52-zlib
                       lua53-zlib>,
    'luarocks-lua53' => qw<luarocks
                           luarocks-lua51
                           luarocks-lua52
                           luarocks-lua54>,
    'lutok' => ['lutok-devel'],
    'lvm2' => qw<device-mapper
                 device-mapper-devel
                 liblvm2app
                 liblvm2app-devel>,
    'lxc' => qw<liblxc
                lxc-devel>,
    'lz4' => qw<liblz4
                liblz4-devel>,
    'lzo' => ['lzo-devel'],
    'man-pages' => ['man-pages-devel'],
    'mariadb' => qw<libmariadbclient
                    libmariadbclient-devel
                    libmysqlclient
                    libmysqlclient-devel
                    mariadb-client
                    mysql
                    mysql-client>,
    'mbedtls' => qw<mbedtls-devel
                    mbedtls-utils>,
    'mdocml' => ['void-man-cgi'],
    'memcached' => ['memcached-devel'],
    'miniupnpc' => ['miniupnpc-devel'],
    'minizip' => ['minizip-devel'],
    'mit-krb5' => qw<mit-krb5-client
                     mit-krb5-devel
                     mit-krb5-libs>,
    'mkinitcpio' => qw<mkinitcpio-encrypt
                       mkinitcpio-lvm2
                       mkinitcpio-mdadm
                       mkinitcpio-xbps
                       mkinitcpio-zfs>,
    'monero' => ['monero-devel'],
    'mpg123' => qw<libmpg123
                   mpg123-devel>,
    'mpfr' => ['mpfr-devel'],
    'msgpack' => ['msgpack-devel'],
    'musl' => ['musl-devel'],
    'musl-fts' => ['musl-fts-devel'],
    'musl-obstack' => ['musl-obstack-devel'],
    'ncurses' => qw<ncurses-base
                    ncurses-devel
                    ncurses-libs
                    ncurses-libtinfo-devel
                    ncurses-libtinfo-libs
                    ncurses-term>,
    'ndpi' => ['ndpi-devel'],
    'net-snmp' => qw<libnet-snmp
                     net-snmp-devel>,
    'nettle' => qw<nettle-devel
                   nettle-tools>,
    'newt' => qw<newt-devel
                 newt-python3>,
    'nfs-utils' => qw<libnfsidmap
                      libnfsidmap-devel>,
    'nftables' => qw<libnftables
                     libnftables-devel>,
    'nghttp2' => ['nghttp2-devel'],
    'nginx' => qw<nginx-mod-http-geoip
                  nginx-mod-http-js
                  nginx-mod-http-perl
                  nginx-mod-http-xslt-filter
                  nginx-mod-stream
                  nginx-mod-stream-geoip
                  nginx-mod-stream-js>,
    'nilfs-utils' => qw<libnilfs
                        nilfs-utils-devel>,
    'nodejs' => qw<nodejs-devel
                   nodejs-lts
                   nodejs-lts-devel>,
    'npth' => ['npth-devel'],
    'nspr' => ['nspr-devel'],
    'nss' => ['nss-devel'],
    'nsss' => qw<nsss-devel
                 nsss-doc>,
    'ntfs-3g' => ['ntfs-3g-devel'],
    'ntl' => ['ntl-devel'],
    'ntp' => ['ntp-perl'],
    'numactl' => qw<libnuma
                    libnuma-devel>,
    'oath-toolkit' => ['oath-toolkit-devel'],
    'oblibs' => ['oblibs-devel'],
    'oniguruma' => qw<oniguruma-devel
                      oniguruma-doc>,
    'openblas' => ['openblas-devel'],
    'openldap' => qw<libldap
                     libldap-devel
                     openldap-tools>,
    'openmpi' => qw<libopenmpi
                    openmpi-devel>,
    'opensp' => ['opensp-devel'],
    'openssh' => ['openssh-sk-helper'],
    'openssl' => qw<libcrypto1.1
                    libssl1.1
                    openssl-c_rehash
                    openssl-devel>,
    'opus' => ['opus-devel'],
    'orc' => ['orc-devel'],
    'p11-kit' => ['p11-kit-devel'],
    'pahole' => ['pahole-devel'],
    'pam' => qw<pam-devel
                pam-libs
                pam-userdb>,
    'pandoc' => qw<pandoc-crossref
                   pandoc-sidenote>,
    'parted' => qw<libparted
                   libparted-devel>,
    'pciutils' => ['pciutils-devel'],
    'pcre' => qw<libpcre
                 libpcrecpp
                 pcre-devel>,
    'pcre2' => qw<libpcre2
                  pcre2-devel>,
    'pcsclite' => qw<libpcsclite
                     pcsclite-devel>,
    'pinebookpro-kernel' => qw<pinebookpro-kernel-dbg
                               pinebookpro-kernel-headers>,
    'pinentry' => qw<pinentry-emacs
                     pinentry-tty>,
    'pkcs11-helper' => qw<pkcs11-helper-devel
                          pkcs11-helper-doc>,
    'pkgconf' => qw<pkgconf-devel
                    libpkgconf>,
    'popt' => ['popt-devel'],
    'postgresql' => qw<postgresql-client
                       postgresql-contrib
                       postgresql-doc
                       postgresql-plperl
                       postgresql-plpython
                       postgresql-pltcl>,
    'postgresql14' => qw<postgresql14-client
                         postgresql14-contrib
                         postgresql14-doc
                         postgresql14-libs
                         postgresql14-libs-devel
                         postgresql14-plperl
                         postgresql14-plpython
                         postgresql14-pltcl>,
    'postgresql15' => qw<postgresql-libs
                         postgresql-libs-devel
                         postgresql15-client
                         postgresql15-contrib
                         postgresql15-doc
                         postgresql15-plperl
                         postgresql15-plpython
                         postgresql15-pltcl>,
    'ppp' => ['ppp-devel'],
    'pps-tools' => ['pps-tools-devel'],
    'procps-ng' => ['procps-ng-devel'],
    'protobuf' => qw<libprotobuf
                     libprotobuf-lite
                     libprotoc
                     libprotoc-devel
                     protobuf-devel>,
    'pulseaudio' => qw<libpulseaudio
                       pulseaudio-devel
                       pulseaudio-utils>,
    'python' => ['python-devel'],
    'python-Cython' => ['python3-Cython'],
    'python-cffi' => ['python3-cffi'],
    'python-coverage' => ['python3-coverage'],
    'python-dateutil' => ['python3-dateutil'],
    'python-ply' => ['python3-ply'],
    'python-pyasn1' => ['python3-pyasn1'],
    'python-pyasn1-modules' => ['python3-pyasn1-modules'],
    'python-pycparser' => ['python3-pycparser'],
    'python-service_identity' => ['python3-service_identity'],
    'python-six' => ['python3-six'],
    'python-zope.interface' => ['python3-zope.interface'],
    'python3' => ['python3-devel'],
    'python3-greenlet' => ['python3-greenlet-devel'],
    'python3-pycodestyle' => ['python-pycodestyle'],
    'python3-pyrsistent' => ['python3-rsistent'],
    'python3-pyscard' => ['python3-scard'],
    'qrencode' => qw<libqrencode
                     qrencode-devel>,
    'quickjs' => ['quickjs-devel'],
    'raft' => ['raft-devel'],
    're2' => ['re2-devel'],
    'rhash' => ['rhash-devel'],
    'rpm' => qw<librpm
                librpm-devel
                librpmbuild
                librpmio
                librpmsign
                rpm-python3>,
    'rtmpdump' => qw<librtmp
                     librtmp-devel>,
    'ruby' => qw<ruby-devel
                 ruby-devel-doc
                 ruby-ri>,
    'runit-void' => ['runit-void-apparmor'],
    'run-parts' => ['ischroot'],
    'rust' => qw<rust-doc
                 rust-std>,
    's6' => qw<s6-devel
               s6-doc>,
    's6-dns' => qw<s6-dns-devel
                   s6-dns-doc>,
    's6-linux-utils' => ['s6-linux-utils-doc'],
    's6-networking' => qw<s6-networking-devel
                          s6-networking-doc>,
    's6-portable-utils' => ['s6-portable-utils-doc'],
    's6-rc' => qw<s6-rc-devel
                  s6-rc-doc>,
    'sbcl' => ['sbcl-source'],
    'schilytools' => qw<sccs
                        sdd
                        sfind
                        smake
                        star
                        ved>,
    'serf' => ['serf-devel'],
    'shadowsocks-libev' => ['shadowsocks-libev-devel'],
    'skalibs' => qw<skalibs-devel
                    skalibs-doc>,
    'snappy' => ['snappy-devel'],
    'spdlog' => ['libspdlog'],
    'slang' => ['slang-devel'],
    'spdx-licenses-list' => qw<spdx-licenses-html
                               spdx-licenses-json
                               spdx-licenses-text>,
    'speex' => qw<libspeex
                  speex-devel>,
    'speexdsp' => ['speexdsp-devel'],
    'sqlite' => ['sqlite-devel'],
    'subversion' => qw<libsvn
                       subversion-devel
                       subversion-perl
                       subversion-python>,
    'syncthing' => qw<syncthing-discosrv
                      syncthing-inotify
                      syncthing-relaysrv>,
    'sysfsutils' => qw<libsysfs
                       libsysfs-devel>,
    'systemtap' => ['systemtap-devel'],
    'talloc' => ['talloc-devel'],
    'talloc' => qw<libpytalloc-util
                   talloc-devel
                   talloc-python3>,
    'tbb' => ['tbb-devel'],
    'tcl' => ['tcl-devel'],
    'tdb' => qw<libtdb
                tdb-devel
                tdb-python3>,
    'tiff' => ['tiff-devel'],
    'tlp' => ['tlp-rdw'],
    'toxcore' => ['toxcore-devel'],
    'tre' => ['tre-devel'],
    'tree-sitter' => ['tree-sitter-devel'],
    'trousers' => ['trousers-devel'],
    'tzutils' => ['tzdata'],
    'u-boot-tools' => ['uboot-mkimage'],
    'udns' => ['udns-devel'],
    'unbound' => qw<libunbound
                    unbound-devel>,
    'unibilium' => ['unibilium-devel'],
    'unixodbc' => qw<libodbc
                     unixodbc-devel>,
    'usbguard' => ['usbguard-devel'],
    'util-linux-common' => qw<libblkid
                              libblkid-devel
                              libfdisk
                              libfdisk-devel
                              libmount
                              libmount-devel
                              libsmartcols
                              libsmartcols-devel
                              libuuid
                              libuuid-devel>,
    'uwsgi' => qw<uwsgi-cgi
                  uwsgi-python3>,
    'valgrind' => ['valgrind-devel'],
    'varnish' => qw<libvarnishapi
                    libvarnishapi-devel>,
    'vde2' => qw<libvde2
                 vde2-devel>,
    'vim' => qw<vim-common
                xxd>,
    'void-repo-multilib' => ['void-repo-multilib-nonfree'],
    'void-repo-nonfree' => ['void-repo-debug'],
    'w3m' => ['w3m-img'],
    'whois' => ['mkpasswd'],
    'wimlib' => ['wimlib-devel'],
    'wireless_tools' => ['wireless_tools-devel'],
    'wvstreams' => ['wvstreams-devel'],
    'x265' => ['x265-devel'],
    'xbps' => qw<libxbps
                 libxbps-devel
                 xbps-tests>,
    'xfsprogs' => ['xfsprogs-devel'],
    'xmlrpc-c' => ['xmlrpc-c-devel'],
    'xtools' => ['xtools-minimal'],
    'xz' => qw<liblzma
               liblzma-devel>,
    'yascreen' => ['yascreen-devel'],
    'zeromq' => ['zeromq-devel'],
    'zfs' => qw<libzfs
                zfs-devel
                zfs-pam>,
    'zlib' => ['zlib-devel'],
    'zstd' => qw<libzstd
                 libzstd-devel>,
    'zulucrypt' => ['zulucrypt-devel']
);

sub mksymlinks(%pkg --> Nil)
{
    %pkg.kv.map(-> Str:D $pkg, @subpkg {
        for @subpkg -> $subpkg
        {
            my Str:D $ln-cmdline = "ln -rs $SRCPKGS/$pkg $SRCPKGS/$subpkg";
            say($ln-cmdline);
            my Proc:D $ln-cmdline-proc = shell($ln-cmdline);
            $ln-cmdline-proc.exitcode == 0
                or die("Sorry, could not create symlink from `$ln-cmdline`");
        }
    });
}

mksymlinks(%PKG);

# vim: set filetype=raku foldmethod=marker foldlevel=0:
