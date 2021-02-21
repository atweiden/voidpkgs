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
    'NetAuth' => ['NetAuth-server'],
    'acl' => qw<acl-devel
                acl-progs>,
    'alsa-lib' => ['alsa-lib-devel'],
    'apache' => qw<apache-devel
                   apache-htpasswd>,
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
    'atf' => qw<atf-devel
                atf-libs>,
    'attr' => qw<attr-devel
                 attr-progs>,
    'bash' => ['bash-devel'],
    'bcc' => qw<bcc-devel
                bcc-tools
                python3-bcc>,
    'bearssl' => ['bearssl-devel'],
    'bind' => qw<bind-devel
                 bind-libs
                 bind-utils>,
    'binutils' => qw<binutils-devel
                     binutils-doc >,
    'boost' => qw<boost-build
                  boost-devel
                  boost-jam
                  boost-python1.72
                  boost-python3-1.72
                  libboost_atomic1.72
                  libboost_chrono1.72
                  libboost_container1.72
                  libboost_context1.72
                  libboost_contract1.72
                  libboost_coroutine1.72
                  libboost_date_time1.72
                  libboost_fiber1.72
                  libboost_filesystem1.72
                  libboost_graph1.72
                  libboost_iostreams1.72
                  libboost_locale1.72
                  libboost_log1.72
                  libboost_log_setup1.72
                  libboost_math_c991.72
                  libboost_math_c99f1.72
                  libboost_math_c99l1.72
                  libboost_math_tr11.72
                  libboost_math_tr1f1.72
                  libboost_math_tr1l1.72
                  libboost_prg_exec_monitor1.72
                  libboost_program_options1.72
                  libboost_random1.72
                  libboost_regex1.72
                  libboost_serialization1.72
                  libboost_stacktrace_addr2line1.72
                  libboost_stacktrace_basic1.72
                  libboost_stacktrace_noop1.72
                  libboost_system1.72
                  libboost_thread1.72
                  libboost_timer1.72
                  libboost_type_erasure1.72
                  libboost_unit_test_framework1.72
                  libboost_wave1.72
                  libboost_wserialization1.72>,
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
    'dar' => qw<libdar
                libdar-devel>,
    'db' => qw<db-devel
               db-doc
               libdb
               libdb-cxx>,
    'dhcp' => ['dhclient'],
    'dmraid' => ['dmraid-devel'],
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
    'duktape' => ['duktape-devel'],
    'e2fsprogs' => qw<e2fsprogs-devel
                      e2fsprogs-libs>,
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
    'fftw' => qw<fftw-devel
                 libfftw>,
    'file' => qw<file-devel
                 libmagic>,
    'flac' => qw<libflac
                 libflac-devel>,
    'flex' => ['libfl-devel'],
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
    'h2o' => ['h2o-devel'],
    'haveged' => qw<libhaveged
                    libhaveged-devel>,
    'http-parser' => ['http-parser-devel'],
    'httrack' => ['httrack-devel'],
    'hunspell' => qw<hunspell-devel
                     libhunspell1.7>,
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
    'jemalloc' => ['jemalloc-devel'],
    'jq' => ['jq-devel'],
    'json-c' => ['json-c-devel'],
    'jsoncpp' => ['jsoncpp-devel'],
    'kbd' => ['kbd-data'],
    'keybase' => ['kbfs'],
    'keyutils' => qw<keyutils-devel
                     libkeyutils>,
    'kmod' => qw<libkmod
                 libkmod-devel>,
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
    'libcap' => qw<libcap-devel
                   libcap-progs>,
    'libcap-ng' => qw<libcap-ng-devel
                      libcap-ng-progs
                      libcap-ng-python
                      libcap-ng-python3>,
    'libcbor' => ['libcbor-devel'],
    'libcli' => ['libcli-devel'],
    'libco' => ['libco-devel'],
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
    'libffi' => ['libffi-devel'],
    'libfido2' => ['libfido2-devel'],
    'libgcrypt' => ['libgcrypt-devel'],
    'libgfshare' => qw<libgfshare-devel
                       libgfshare-tools>,
    'libgit2' => ['libgit2-devel'],
    'libgpg-error' => ['libgpg-error-devel'],
    'libgssglue' => ['libgssglue-devel'],
    'libidn' => ['libidn-devel'],
    'libidn2' => ['libidn2-devel'],
    'libiscsi' => qw<libiscsi-devel
                     libiscsi-tools>,
    'libksba' => ['libksba-devel'],
    'libluv' => ['libluv-devel'],
    'libmaxminddb' => ['libmaxminddb-devel'],
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
    'libogg' => ['libogg-devel'],
    'libomp' => ['libomp-devel'],
    'libpcap' => ['libpcap-devel'],
    'libpipeline' => ['libpipeline-devel'],
    'libpng' => qw<libpng-devel
                   libpng-progs>,
    'libpsl' => ['libpsl-devel'],
    'libpwquality' => qw<libpwquality-devel
                         libpwquality-python3>,
    'libqb' => ['libqb-devel'],
    'libreadline8' => qw<libhistory8
                         readline-devel>,
    'libressl' => qw<libcrypto46
                     libressl-devel
                     libressl-netcat
                     libssl48
                     libtls20>,
    'librsync' => ['librsync-devel'],
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
                           linux-firmware-broadcom
                           linux-firmware-intel
                           linux-firmware-network
                           linux-firmware-nvidia>,
    'linux-lts' => ['linux-lts-headers'],
    'linux' => ['linux-headers'],
    'linux4.14' => qw<linux4.14-dbg
                      linux4.14-headers>,
    'linux4.19' => qw<linux4.19-dbg
                      linux4.19-headers>,
    'linux5.10' => qw<linux5.10-dbg
                      linux5.10-headers>,
    'llhttp' => ['llhttp-devel'],
    'llvm11' => qw<clang
                   clang-analyzer
                   clang-tools-extra
                   libclang
                   libclang-cpp
                   libllvm11
                   lld
                   lld-devel
                   lldb
                   lldb-devel>,
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
    'mit-krb5' => qw<mit-krb5-client
                     mit-krb5-devel
                     mit-krb5-libs>,
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
    'nfs-utils' => qw<libnfsidmap
                      libnfsidmap-devel>,
    'nftables' => qw<libnftables
                     libnftables-devel>,
    'nghttp2' => ['nghttp2-devel'],
    'nilfs-utils' => qw<libnilfs
                        nilfs-utils-devel>,
    'nodejs' => ['nodejs-devel'],
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
    'openssh' => ['openssh-sk-helper'],
    'opus' => ['opus-devel'],
    'orc' => ['orc-devel'],
    'p11-kit' => ['p11-kit-devel'],
    'pahole' => ['pahole-devel'],
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
    'pinebookpro-kernel' => qw<pinebookpro-kernel-dbg
                               pinebookpro-kernel-headers>,
    'pinentry' => qw<pinentry-emacs
                     pinentry-tty>,
    'pkcs11-helper' => qw<pkcs11-helper-devel
                          pkcs11-helper-doc>,
    'popt' => ['popt-devel'],
    'postgresql' => qw<postgresql-client
                       postgresql-contrib
                       postgresql-doc
                       postgresql-plperl
                       postgresql-plpython
                       postgresql-pltcl
                       postgresql9.6-libs
                       postgresql9.6-libs-devel>,
    'postgresql12' => qw<postgresql12-client
                         postgresql12-contrib
                         postgresql12-doc
                         postgresql12-libs
                         postgresql12-libs-devel
                         postgresql12-plperl
                         postgresql12-plpython
                         postgresql12-pltcl>,
    'postgresql13' => qw<postgresql-libs
                         postgresql-libs-devel
                         postgresql13-client
                         postgresql13-contrib
                         postgresql13-doc
                         postgresql13-plperl
                         postgresql13-plpython
                         postgresql13-pltcl>,
    'ppp' => ['ppp-devel'],
    'pps-tools' => ['pps-tools-devel'],
    'procps-ng' => ['procps-ng-devel'],
    'protobuf24' => qw<libprotobuf24
                       libprotobuf24-lite
                       libprotoc-devel
                       libprotoc24
                       libprotoc24-devel
                       protobuf
                       protobuf-devel
                       protobuf-lite
                       protobuf24-devel>
    'pulseaudio' => qw<libpulseaudio
                       pulseaudio-devel>,
    'python' => ['python-devel'],
    'python-Babel' => ['python3-Babel'],
    'python-Cython' => ['python3-Cython'],
    'python-Jinja2' => ['python3-Jinja2'],
    'python-M2Crypto' => ['python3-M2Crypto'],
    'python-MarkupSafe' => ['python3-MarkupSafe'],
    'python-atomicwrites' => ['python3-atomicwrites'],
    'python-attrs' => ['python3-attrs'],
    'python-bcrypt' => ['python3-bcrypt'],
    'python-cffi' => ['python3-cffi'],
    'python-chardet' => ['python3-chardet'],
    'python-coverage' => ['python3-coverage'],
    'python-cram' => ['python3-cram'],
    'python-dateutil' => ['python3-dateutil'],
    'python-docutils' => ['python3-docutils'],
    'python-idna' => ['python3-idna'],
    'python-iso8601' => ['python3-iso8601'],
    'python-lxml' => ['python3-lxml'],
    'python-nose' => ['python3-nose'],
    'python-parsing' => ['python3-parsing'],
    'python-pathlib2' => ['python3-pathlib2'],
    'python-ply' => ['python3-ply'],
    'python-pretend' => ['python3-pretend'],
    'python-pyasn1' => ['python3-pyasn1'],
    'python-pycparser' => ['python3-pycparser'],
    'python-pytz' => ['python3-pytz'],
    'python-requests' => ['python3-requests'],
    'python-rfc6555' => ['python3-rfc6555'],
    'python-scandir' => ['python3-scandir'],
    'python-six' => ['python3-six'],
    'python-urllib3' => ['python3-urllib3'],
    'python-wcwidth' => ['python3-wcwidth'],
    'python-zope.interface' => ['python3-zope.interface'],
    'python3' => ['python3-devel'],
    'python3-greenlet' => ['python3-greenlet-devel'],
    'qrencode' => qw<libqrencode
                     qrencode-devel>,
    'raft' => ['raft-devel'],
    're2' => ['re2-devel'],
    'rhash' => ['rhash-devel'],
    'rpm' => qw<librpm
                librpm-devel
                librpmbuild
                librpmio
                librpmsign
                rpm-python3>,
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
    'tidy5' => qw<libtidy5
                  libtidy5-devel>,
    'toxcore' => ['toxcore-devel'],
    'trousers' => ['trousers-devel'],
    'u-boot-tools' => ['uboot-mkimage'],
    'udns' => ['udns-devel'],
    'unbound' => qw<libunbound
                    unbound-devel>,
    'unibilium' => ['unibilium-devel'],
    'unixodbc' => qw<libodbc
                     unixodbc-devel>,
    'usbguard' => ['usbguard-devel'],
    'usbredir' => ['usbredir-devel'],
    'util-linux-libs' => qw<libblkid
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
    'wimlib' => ['wimlib-devel'],
    'wireless_tools' => ['wireless_tools-devel'],
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
    'znc' => qw<znc-devel
                znc-perl
                znc-python3
                znc-tcl>,
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
