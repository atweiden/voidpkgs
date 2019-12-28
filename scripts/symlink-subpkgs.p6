use v6;

=begin pod
=head NAME

symlink-subpkgs.p6

=head SYNOPSIS

    scripts/symlink-subpkgs.p6

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
    'acl' => qw<acl-devel
                acl-progs>,
    'alsa-lib' => ['alsa-lib-devel'],
    'atf' => qw<atf-devel
                atf-libs>,
    'apparmor' => qw<apparmor-vim
                     libapparmor
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
    'attr' => qw<attr-devel
                 attr-progs>,
    'avahi' => qw<avahi-autoipd
                  avahi-compat-libs
                  avahi-compat-libs-devel
                  avahi-libs
                  avahi-libs-devel
                  avahi-utils>,
    'babeltrace' => ['babeltrace-devel'],
    'bcc' => qw<bcc-devel
                bcc-tools
                python3-bcc>,
    'bind' => qw<bind-devel
                 bind-libs
                 bind-utils>,
    'binutils' => qw<binutils-devel
                     binutils-doc >,
    'boost' => qw<boost-build
                  boost-devel
                  boost-jam
                  boost-python
                  boost-python3>,
    'btrfs-progs' => qw<libbtrfs
                        libbtrfs-devel
                        libbtrfsutil
                        libbtrfsutil-devel>,
    'busybox' => qw<busybox-core
                    busybox-huge
                    busybox-static>,
    'bzip2' => ['bzip2-devel'],
    'c-ares' => ['c-ares-devel'],
    'check' => ['check-devel'],
    'chicken' => qw<chicken-devel
                    libchicken>,
    'clucene' => ['clucene-devel'],
    'cmocka' => ['cmocka-devel'],
    'confuse' => ['confuse-devel'],
    'coreboot-utils' => ['coreboot-utils-me_cleaner'],
    'cracklib' => qw<cracklib-devel
                     cracklib-python
                     libcracklib>,
    'cross-aarch64-linux-gnu' => ['cross-aarch64-linux-gnu-libc'],
    'cross-aarch64-linux-musl' => ['cross-aarch64-linux-musl-libc'],
    'cross-arm-linux-gnueabi' => ['cross-arm-linux-gnueabi-libc'],
    'cross-arm-linux-gnueabihf' => ['cross-arm-linux-gnueabihf-libc'],
    'cross-arm-linux-musleabi' => ['cross-arm-linux-musleabi-libc'],
    'cross-arm-linux-musleabihf' => ['cross-arm-linux-musleabihf-libc'],
    'cross-armv7l-linux-gnueabihf' => ['cross-armv7l-linux-gnueabihf-libc'],
    'cross-armv7l-linux-musleabihf' => ['cross-armv7l-linux-musleabihf-libc'],
    'cross-i686-linux-musl' => ['cross-i686-linux-musl-libc'],
    'cross-i686-pc-linux-gnu' => ['cross-i686-pc-linux-gnu-libc'],
    'cross-mips-linux-musl' => ['cross-mips-linux-musl-libc'],
    'cross-mips-linux-muslhf' => ['cross-mips-linux-muslhf-libc'],
    'cross-mipsel-linux-musl' => ['cross-mipsel-linux-musl-libc'],
    'cross-mipsel-linux-muslhf' => ['cross-mipsel-linux-muslhf-libc'],
    'cross-powerpc-linux-gnu' => ['cross-powerpc-linux-gnu-libc'],
    'cross-powerpc-linux-musl' => ['cross-powerpc-linux-musl-libc'],
    'cross-powerpc64-linux-gnu' => ['cross-powerpc64-linux-gnu-libc'],
    'cross-powerpc64-linux-musl' => ['cross-powerpc64-linux-musl-libc'],
    'cross-powerpc64le-linux-gnu' => ['cross-powerpc64le-linux-gnu-libc'],
    'cross-powerpc64le-linux-musl' => ['cross-powerpc64le-linux-musl-libc'],
    'cross-x86_64-linux-musl' => ['cross-x86_64-linux-musl-libc'],
    'cross-x86_64-w64-mingw32' => qw<cross-i686-w64-mingw32
                                     cross-i686-w64-mingw32-crt
                                     cross-x86_64-w64-mingw32-crt>,
    'crypto++' => ['crypto++-devel'],
    'cryptsetup' => qw<cryptsetup-devel
                       cryptsetup-static
                       libcryptsetup>,
    'curl' => qw<libcurl
                 libcurl-devel>,
    'cyrus-sasl' => qw<cyrus-sasl-modules
                       cyrus-sasl-modules-gssapi
                       cyrus-sasl-modules-ldap
                       cyrus-sasl-modules-sql>,
    'db' => qw<db-devel
               db-doc
               libdb
               libdb-cxx>,
    'dbus' => qw<dbus-devel
                 dbus-libs>,
    'dhcp' => ['dhclient'],
    'distcc' => ['distcc-pump'],
    'dmraid' => ['dmraid-devel'],
    'dovecot' => qw<dovecot-devel
                    dovecot-plugin-ldap
                    dovecot-plugin-lucene
                    dovecot-plugin-mysql
                    dovecot-plugin-pgsql
                    dovecot-plugin-sqlite>,
    'dovecot-plugin-pigeonhole' => qw<dovecot-plugin-pigeonhole-devel
                                      dovecot-plugin-pigeonhole-ldap>,
    'dracut' => ['dracut-network'],
    'dtc' => ['dtc-devel'],
    'duktape' => ['duktape-devel'],
    'e2fsprogs' => qw<e2fsprogs-devel
                      e2fsprogs-libs>,
    'efivar' => qw<libefivar
                   libefivar-devel>,
    'elfutils' => qw<elfutils-devel
                     libelf>,
    'ell' => ['ell-devel'],
    'erlang' => ['erlang-doc'],
    'eudev' => qw<eudev-libudev
                  eudev-libudev-devel>,
    'execline' => qw<execline-devel
                     execline-doc>,
    'expat' => qw<expat-devel
                  xmlwf>,
    'expect' => ['expect-devel'],
    'fann' => ['fann-devel'],
    'fftw' => qw<fftw-devel
                 libfftw>,
    'file' => qw<file-devel
                 libmagic>,
    'flac' => qw<libflac
                 libflac-devel>,
    'flex' => ['libfl-devel'],
    'fuse' => ['fuse-devel'],
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
                libssp
                libssp-devel
                libstdc++
                libstdc++-devel
                libvtv
                libvtv-devel>,
    'gcc-multilib' => ['gcc-objc-multilib'],
    'gdbm' => ['gdbm-devel'],
    'geoip' => qw<geoip-devel
                  libgeoip>,
    'getdns' => ['getdns-devel'],
    'gettext' => qw<gettext-devel
                    gettext-devel-examples
                    gettext-libs>,
    'git' => qw<git-all
                git-cvs
                git-netrc
                git-svn>,
    'glib' => qw<glib-devel
                 libglib-devel>,
    'glibc' => qw<glibc-devel
                  glibc-locales
                  nscd>,
    'gmp' => qw<gmp-devel
                gmpxx
                gmpxx-devel>,
    'gnupg2' => ['gnupg2-scdaemon'],
    'gnutls' => qw<gnutls-devel
                   gnutls-tools>,
    'gperftools' => ['gperftools-devel'],
    'gpgme' => qw<gpgme-devel
                  gpgmepp
                  gpgmepp-devel>,
    'groff' => qw<groff-doc
                  libgroff>,
    'grpc' => ['grpc-devel'],
    'grub' => qw<grub-arm64-efi
                 grub-i386-efi
                 grub-powerpc-ieee1275
                 grub-utils
                 grub-x86_64-efi>,
    'gsasl' => qw<gsasl-devel
                  libgsasl>,
    'gtest' => ['gtest-devel'],
    'guile' => qw<guile-devel
                  libguile>,
    'h2o' => ['h2o-devel'],
    'haveged' => qw<libhaveged
                    libhaveged-devel>,
    'hiredis' => ['hiredis-devel'],
    'http-parser' => ['http-parser-devel'],
    'httrack' => ['httrack-devel'],
    'hunspell' => qw<hunspell-devel
                     libhunspell1.7>,
    'icdiff' => ['python3-icdiff'],
    'icu' => qw<icu-devel
                icu-libs>,
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
    'irssi' => qw<irssi-devel
                  irssi-otr
                  irssi-perl>,
    'isl15' => ['isl15-devel'],
    'jansson' => ['jansson-devel'],
    'jemalloc' => ['jemalloc-devel'],
    'jq' => ['jq-devel'],
    'json-c' => ['json-c-devel'],
    'jsoncpp' => ['jsoncpp-devel'],
    'kbd' => ['kbd-data'],
    'keybase' => ['kbfs'],
    'kmod' => qw<libkmod
                 libkmod-devel>,
    'kubernetes' => ['kubectl'],
    'kyua' => ['kyua-tests'],
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
    'libarchive' => qw<bsdtar
                       libarchive-devel>,
    'libasr' => ['libasr-devel'],
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
    'libcacard' => ['libcacard-devel'],
    'libcap' => qw<libcap-devel
                   libcap-progs>,
    'libcap-ng' => qw<libcap-ng-devel
                      libcap-ng-progs
                      libcap-ng-python
                      libcap-ng-python3>,
    'libcli' => ['libcli-devel'],
    'libconfig' => qw<libconfig++
                      libconfig++-devel
                      libconfig-devel>,
    'libcppunit' => qw<libcppunit-devel
                       libcppunit-examples>,
    'libdaemon' => ['libdaemon-devel'],
    'libdnet' => ['libdnet-devel'],
    'libedit' => ['libedit-devel'],
    'libev' => ['libev-devel'],
    'libevent' => ['libevent-devel'],
    'libexecinfo' => ['libexecinfo-devel'],
    'libfetch' => ['libfetch-devel'],
    'libffi' => ['libffi-devel'],
    'libgcrypt' => ['libgcrypt-devel'],
    'libgfshare' => qw<libgfshare-devel
                       libgfshare-tools>,
    'libgit2' => ['libgit2-devel'],
    'libgpg-error' => ['libgpg-error-devel'],
    'libgssglue' => ['libgssglue-devel'],
    'libgudev' => ['libgudev-devel'],
    'libidn' => ['libidn-devel'],
    'libidn2' => ['libidn2-devel'],
    'libimobiledevice' => ['libimobiledevice-devel'],
    'libjpeg-turbo' => qw<libjpeg-turbo-devel
                          libjpeg-turbo-tools>,
    'libksba' => ['libksba-devel'],
    'libluv' => ['libluv-devel'],
    'libmaxminddb' => ['libmaxminddb-devel'],
    'libmbim' => ['libmbim-devel'],
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
    'libogg' => ['libogg-devel'],
    'libomp' => ['libomp-devel'],
    'libotr' => qw<libotr-devel
                   libotr-progs>,
    'libpcap' => ['libpcap-devel'],
    'libpipeline' => ['libpipeline-devel'],
    'libplist' => qw<libplist++
                     libplist-devel
                     libplist-python>,
    'libpng' => qw<libpng-devel
                   libpng-progs>,
    'libpsl' => ['libpsl-devel'],
    'libpwquality' => qw<libpwquality-devel
                         libpwquality-python3>,
    'libqb' => ['libqb-devel'],
    'libreadline8' => qw<libhistory8
                         readline-devel>,
    'libressl' => qw<libcrypto45
                     libressl-devel
                     libressl-netcat
                     libssl47
                     libtls19>,
    'libsasl' => ['libsasl-devel'],
    'libseccomp' => ['libseccomp-devel'],
    'libsigc++' => ['libsigc++-devel'],
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
    'libtomcrypt' => ['libtomcrypt-devel'],
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
    'libusbmuxd' => ['libusbmuxd-devel'],
    'libutempter' => ['libutempter-devel'],
    'libuv' => ['libuv-devel'],
    'libvorbis' => ['libvorbis-devel'],
    'libvterm' => ['libvterm-devel'],
    'libxml2' => ['libxml2-devel'],
    'libxml2-python' => ['libxml2-python3'],
    'libxslt' => qw<libxslt-devel
                    libxslt-python>,
    'libyaml' => ['libyaml-devel'],
    'linux-firmware' => qw<linux-firmware-amd
                           linux-firmware-intel
                           linux-firmware-network
                           linux-firmware-nvidia>,
    'linux-lts' => ['linux-lts-headers'],
    'linux' => ['linux-headers'],
    'linux4.14' => qw<linux4.14-dbg
                      linux4.14-headers>,
    'linux4.19' => qw<linux4.19-dbg
                      linux4.19-headers>,
    'linux5.3' => qw<linux5.3-dbg
                     linux5.3-headers>,
    'llhttp' => ['llhttp-devel'],
    'llvm7' => ['libllvm7'],
    'llvm8' => ['libllvm8'],
    'llvm9' => qw<clang
                  clang-analyzer
                  clang-tools-extra
                  libllvm9
                  lld
                  lld-devel
                  lldb
                  lldb-devel>,
    'lm_sensors' => qw<libsensors
                       libsensors-devel>,
    'lttng-tools' => ['lttng-tools-devel'],
    'lttng-ust' => ['lttng-ust-devel'],
    'lua' => ['lua-devel'],
    'LuaJIT' => ['LuaJIT-devel'],
    'lua-lpeg' => qw<lua51-lpeg
                     lua52-lpeg>,
    'lua51' => ['lua51-devel'],
    'lua52' => ['lua52-devel'],
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
                    mariadb-client
                    mytop>,
    'mbedtls' => qw<mbedtls-devel
                    mbedtls-utils>,
    'miniupnpc' => ['miniupnpc-devel'],
    'minizip' => ['minizip-devel'],
    'mit-krb5' => qw<mit-krb5-client
                     mit-krb5-devel
                     mit-krb5-libs>,
    'mpfr' => ['mpfr-devel'],
    'msgpack' => ['msgpack-devel'],
    'musl' => ['musl-devel'],
    'musl-fts' => ['musl-fts-devel'],
    'mysql' => qw<libmysqlclient
                  libmysqlclient-devel
                  mysql-client>,
    'ncurses' => qw<ncurses-base
                    ncurses-devel
                    ncurses-libs
                    ncurses-term>,
    'ndpi' => ['ndpi-devel'],
    'net-snmp' => qw<libnet-snmp
                     net-snmp-devel>,
    'nettle' => qw<nettle-devel
                   nettle-tools>,
    'nftables' => qw<libnftables
                     libnftables-devel>,
    'nghttp2' => ['nghttp2-devel'],
    'nilfs-utils' => qw<libnilfs
                        nilfs-utils-devel>,
    'nodejs' => ['nodejs-devel'],
    'nodejs-lts' => ['nodejs-lts-devel'],
    'npth' => ['npth-devel'],
    'nspr' => ['nspr-devel'],
    'nss' => ['nss-devel'],
    'nsss' => qw<nsss-devel
                 nsss-doc>,
    'ntfs-3g' => ['ntfs-3g-devel'],
    'ntp' => ['ntp-perl'],
    'numactl' => qw<libnuma
                    libnuma-devel>,
    'oath-toolkit' => ['oath-toolkit-devel'],
    'oblibs' => ['oblibs-devel'],
    'oniguruma' => qw<oniguruma-devel
                      oniguruma-doc>,
    'openldap' => qw<libldap
                     libldap-devel
                     openldap-tools>,
    'opensp' => ['opensp-devel'],
    'orc' => ['orc-devel'],
    'p11-kit' => ['p11-kit-devel'],
    'pam' => qw<pam-devel
                pam-libs
                pam-userdb>,
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
    'pinentry' => qw<pinentry-emacs
                     pinentry-tty>,
    'pixman' => ['pixman-devel'],
    'pkcs11-helper' => qw<pkcs11-helper-devel
                          pkcs11-helper-doc>,
    'popt' => ['popt-devel'],
    'postgresql' => qw<postgresql-client
                       postgresql-contrib
                       postgresql-doc
                       postgresql-libs
                       postgresql-libs-devel
                       postgresql-plperl
                       postgresql-plpython
                       postgresql-pltcl>,
    'ppp' => ['ppp-devel'],
    'pps-tools' => ['pps-tools-devel'],
    'procps-ng' => ['procps-ng-devel'],
    'protobuf' => qw<libprotobuf-lite18
                     libprotobuf18
                     libprotoc-devel
                     libprotoc18
                     protobuf-devel
                     protobuf-lite>,
    'pulseaudio' => qw<libpulseaudio
                       pulseaudio-devel>,
    'python' => ['python-devel'],
    'python-Babel' => ['python3-Babel'],
    'python-Cython' => ['python3-Cython'],
    'python-Jinja2' => ['python3-Jinja2'],
    'python-M2Crypto' => ['python3-M2Crypto'],
    'python-MarkupSafe' => ['python3-MarkupSafe'],
    'python-Pygments' => ['python3-Pygments'],
    'python-Sphinx' => ['python3-Sphinx'],
    'python-Unidecode' => ['python3-Unidecode'],
    'python-alabaster' => ['python3-alabaster'],
    'python-atomicwrites' => ['python3-atomicwrites'],
    'python-asn1crypto' => ['python3-asn1crypto'],
    'python-attrs' => ['python3-attrs'],
    'python-bcrypt' => ['python3-bcrypt'],
    'python-cffi' => ['python3-cffi'],
    'python-chardet' => ['python3-chardet'],
    'python-coverage' => ['python3-coverage'],
    'python-cram' => ['python3-cram'],
    'python-cryptography' => ['python3-cryptography'],
    'python-cryptography_vectors' => ['python3-cryptography_vectors'],
    'python-docopt' => ['python3-docopt'],
    'python-docutils' => ['python3-docutils'],
    'python-flaky' => ['python3-flaky'],
    'python-greenlet' => qw<python-greenlet-devel
                            python3-greenlet
                            python3-greenlet-devel>,
    'python-hypothesis' => ['python3-hypothesis'],
    'python-idna' => ['python3-idna'],
    'python-imagesize' => ['python3-imagesize'],
    'python-iso-8601' => ['python3-iso-8601'],
    'python-msgpack' => ['python3-msgpack'],
    'python-nose' => ['python3-nose'],
    'python-packaging' => ['python3-packaging'],
    'python-paramiko' => ['python3-paramiko'],
    'python-parsing' => ['python3-parsing'],
    'python-pathlib2' => ['python3-pathlib2'],
    'python-ply' => ['python3-ply'],
    'python-pretend' => ['python3-pretend'],
    'python-py' => ['python3-py'],
    'python-pyasn1' => ['python3-pyasn1'],
    'python-pycparser' => ['python3-pycparser'],
    'python-pyelftools' => ['python3-pyelftools'],
    'python-pynacl' => ['python3-pynacl'],
    'python-pytz' => ['python3-pytz'],
    'python-requests' => ['python3-requests'],
    'python-rfc6555' => ['python3-rfc6555'],
    'python-scandir' => ['python3-scandir'],
    'python-setuptools' => ['python3-setuptools'],
    'python-six' => ['python3-six'],
    'python-snowballstemmer' => ['python3-snowballstemmer'],
    'python-sphinxcontrib' => ['python3-sphinxcontrib'],
    'python-sphinxcontrib-websupport' => ['python3-sphinxcontrib-websupport'],
    'python-toml' => ['python3-toml'],
    'python-urllib3' => ['python3-urllib3'],
    'python-virtualenv' => ['python3-virtualenv'],
    'python-wcwidth' => ['python3-wcwidth'],
    'python-yaml' => ['python3-yaml'],
    'python-zope.interface' => ['python3-zope.interface'],
    'python3' => ['python3-devel'],
    'python3-importlib_metadata' => ['python-importlib_metadata'],
    'python3-zipp' => ['python-zipp'],
    'qemu' => ['qemu-ga'],
    'qrencode' => qw<libqrencode
                     qrencode-devel>,
    'rhash' => ['rhash-devel'],
    'ruby' => qw<ruby-devel
                 ruby-devel-doc
                 ruby-ri>,
    'runit-void' => ['runit-void-apparmor'],
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
    'sbc' => ['sbc-devel'],
    'sbcl' => ['sbcl-source'],
    'schilytools' => qw<sccs
                        sdd
                        sfind
                        smake
                        star>,
    'serf' => ['serf-devel'],
    'shadowsocks-libev' => ['shadowsocks-libev-devel'],
    'skalibs' => qw<skalibs-devel
                    skalibs-doc>,
    'snappy' => ['snappy-devel'],
    'spandsp' => ['spandsp-devel'],
    'spdx-licenses-list' => qw<spdx-licenses-html
                               spdx-licenses-json
                               spdx-licenses-text>,
    'speex' => qw<libspeex
                  speex-devel>,
    'speexdsp' => ['speexdsp-devel'],
    'spice' => ['spice-devel'],
    'sqlite' => ['sqlite-devel'],
    'subversion' => qw<libsvn
                       subversion-devel
                       subversion-perl
                       subversion-python>,
    'sysfsutils' => qw<libsysfs
                       libsysfs-devel>,
    'systemtap' => ['systemtap-devel'],
    'talloc' => ['talloc-devel'],
    'tbb' => ['tbb-devel'],
    'tcl' => ['tcl-devel'],
    'tdb' => qw<libtdb
                tdb-devel>,
    'tidy5' => qw<libtidy5
                  libtidy5-devel>,
    'tiff' => ['tiff-devel'],
    'toxcore' => ['toxcore-devel'],
    'udns' => ['udns-devel'],
    'unbound' => ['unbound-devel'],
    'unibilium' => ['unibilium-devel'],
    'unixodbc' => qw<libodbc
                     unixodbc-devel>,
    'usbguard' => ['usbguard-devel'],
    'usbredir' => ['usbredir-devel'],
    'util-linux' => qw<libblkid
                       libblkid-devel
                       libfdisk
                       libfdisk-devel
                       libmount
                       libmount-devel
                       libsmartcols
                       libsmartcols-devel
                       libuuid
                       libuuid-devel>,
    'valgrind' => ['valgrind-devel'],
    'varnish' => qw<libvarnishapi
                    libvarnishapi-devel>,
    'vde2' => qw<libvde2
                 vde2-devel>,
    'vim' => qw<vim-common
                xxd>,
    'void-repo-multilib' => ['void-repo-multilib-nonfree'],
    'void-repo-nonfree' => ['void-repo-debug'],
    'whois' => ['mkpasswd'],
    'wireguard' => ['wireguard-tools'],
    'wimlib' => ['wimlib-devel'],
    'wireless_tools' => ['wireless_tools-devel'],
    'wireshark' => qw<libwireshark
                      libwireshark-devel>,
    'wvstreams' => ['wvstreams-devel'],
    'xbps' => qw<libxbps
                 libxbps-devel
                 xbps-tests>,
    'xfsprogs' => ['xfsprogs-devel'],
    'xmlrpc-c' => ['xmlrpc-c-devel'],
    'xz' => qw<liblzma
               liblzma-devel>,
    'zeromq' => ['zeromq-devel'],
    'zlib' => ['zlib-devel'],
    'zstd' => qw<libzstd
                 libzstd-devel>,
    'zulucrypt' => ['zulucrypt-devel'],
    'zuluplay' => ['zuluplay-devel']
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

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
