use v6;

sub mksymlinks(%pkg --> Nil)
{
    %pkg.kv.map(-> Str:D $pkg, @subpkg {
        for @subpkg -> $subpkg
        {
            my Str:D $ln-cmdline = "ln -rs srcpkgs/$pkg srcpkgs/$subpkg";
            say($ln-cmdline);
            my Proc:D $ln-cmdline-proc = shell($ln-cmdline);
            $ln-cmdline-proc.exitcode == 0
                or die("Sorry, could not create symlink from `$ln-cmdline`");
        }
    });
}

# %pkg {{{

# array of subpackages indexed by base pkg
my List:D %pkg{Str:D} =
    'acl' => qw<acl-devel
                acl-progs>,
    'atf' => qw<atf-devel
                atf-libs>,
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
                python-bcc>,
    'binutils' => ['binutils-devel'],
    'boost' => qw<boost-build
                  boost-devel
                  boost-jam
                  boost-python>,
    'btrfs-progs' => qw<libbtrfs
                        libbtrfs-devel
                        libbtrfsutil
                        libbtrfsutil-devel>,
    'bzip2' => ['bzip2-devel'],
    'c-ares' => ['c-ares-devel'],
    'cmocka' => ['cmocka-devel'],
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
    'cross-x86_64-linux-musl' => ['cross-x86_64-linux-musl-libc'],
    'crypto++' => ['crypto++-devel'],
    'cryptsetup' => qw<cryptsetup-devel
                       cryptsetup-static
                       libcryptsetup>,
    'curl' => qw<libcurl
                 libcurl-devel>,
    'db' => qw<db-devel
               db-doc
               libdb
               libdb-cxx>,
    'dbus' => qw<dbus-devel
                 dbus-libs>,
    'dhcp' => ['dhclient'],
    'distcc' => ['distcc-pump'],
    'dracut' => ['dracut-network'],
    'dtc' => ['dtc-devel'],
    'e2fsprogs' => qw<e2fsprogs-devel
                      e2fsprogs-libs>,
    'efivar' => qw<libefivar
                   libefivar-devel>,
    'elfutils' => qw<elfutils-devel
                     libelf>,
    'eudev' => qw<eudev-libudev
                  eudev-libudev-devel>,
    'expat' => qw<expat-devel
                  xmlwf>,
    'expect' => ['expect-devel'],
    'file' => qw<file-devel
                 libmagic>,
    'flex' => ['libfl-devel'],
    'fuse' => ['fuse-devel'],
    'gc' => ['gc-devel'],
    'gcc' => qw<gcc-fortran
                gcc-go
                gcc-go-tools
                gcc-objc
                gcc-objc++
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
                libmpx
                libmpx-devel
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
    'gettext' => qw<gettext-devel
                    gettext-devel-examples
                    gettext-libs>,
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
    'groff' => ['groff-doc'],
    'grub' => qw<grub-i386-efi
                 grub-utils
                 grub-x86_64-efi>,
    'gtest' => ['gtest-devel'],
    'guile' => qw<guile-devel
                  libguile>,
    'haveged' => qw<libhaveged
                    libhaveged-devel>,
    'http-parser' => ['http-parser-devel'],
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
    'iptables' => ['iptables-devel'],
    'irssi' => qw<irssi-devel
                  irssi-perl>,
    'isl15' => ['isl15-devel'],
    'isl16' => ['isl16-devel'],
    'jansson' => ['jansson-devel'],
    'jq' => ['jq-devel'],
    'json-c' => ['json-c-devel'],
    'kbd' => ['kbd-data'],
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
    'libcacard' => ['libcacard-devel'],
    'libcap' => qw<libcap-devel
                   libcap-progs>,
    'libcap-ng' => qw<libcap-ng-devel
                      libcap-ng-progs
                      libcap-ng-python
                      libcap-ng-python3>,
    'libcppunit' => qw<libcppunit-devel
                       libcppunit-examples>,
    'libdaemon' => ['libdaemon-devel'],
    'libedit' => ['libedit-devel'],
    'libevent' => ['libevent-devel'],
    'libffi' => ['libffi-devel'],
    'libgcrypt' => ['libgcrypt-devel'],
    'libgit2' => ['libgit2-devel'],
    'libgpg-error' => ['libgpg-error-devel'],
    'libgudev' => ['libgudev-devel'],
    'libidn' => ['libidn-devel'],
    'libimobiledevice' => ['libimobiledevice-devel'],
    'libjpeg-turbo' => qw<libjpeg-turbo-devel
                          libjpeg-turbo-tools>,
    'libksba' => ['libksba-devel'],
    'libmbim' => ['libmbim-devel'],
    'libmnl' => ['libmnl-devel'],
    'libmpack' => ['libmpack-devel'],
    'libmpc' => ['libmpc-devel'],
    'libnetfilter_conntrack' => ['libnetfilter_conntrack-devel'],
    'libnfnetlink' => ['libnfnetlink-devel'],
    'libnfs' => ['libnfs-devel'],
    'libnftnl' => ['libnftnl-devel'],
    'libnl' => ['libnl-devel'],
    'libnl3' => qw<libnl3-devel
                   libnl3-progs>,
    'libpcap' => ['libpcap-devel'],
    'libpipeline' => ['libpipeline-devel'],
    'libplist' => qw<libplist++
                     libplist-devel
                     libplist-python>,
    'libpng' => qw<libpng-devel
                   libpng-progs>,
    'libpsl' => ['libpsl-devel'],
    'libpwquality' => ['libpwquality-devel'],
    'libressl' => qw<libcrypto43
                     libressl-devel
                     libressl-netcat
                     libssl45
                     libtls17>,
    'libsasl' => ['libsasl-devel'],
    'libseccomp' => ['libseccomp-devel'],
    'libsodium' => ['libsodium-devel'],
    'libssh2' => ['libssh2-devel'],
    'libtasn1' => qw<libtasn1-devel
                     libtasn1-tools>,
    'libtermkey' => ['libtermkey-devel'],
    'libtomcrypt' => ['libtomcrypt-devel'],
    'libtommath' => ['libtommath-devel'],
    'libtool' => qw<libltdl
                    libltdl-devel>,
    'libtommath' => ['libtommath-devel'],
    'libunistring' => ['libunistring-devel'],
    'libunwind' => ['libunwind-devel'],
    'libusb' => ['libusb-devel'],
    'libusb-compat' => ['libusb-compat-devel'],
    'libusbmuxd' => ['libusbmuxd-devel'],
    'libutempter' => ['libutempter-devel'],
    'libuv' => ['libuv-devel'],
    'libvterm' => ['libvterm-devel'],
    'libxml2' => qw<libxml2-devel
                    libxml2-python>,
    'libxslt' => qw<libxslt-devel
                    libxslt-python>,
    'libyaml' => ['libyaml-devel'],
    'linux-firmware' => qw<linux-firmware-amd
                           linux-firmware-intel
                           linux-firmware-network
                           linux-firmware-nvidia>,
    'linux' => ['linux-headers'],
    'linux4.17' => qw<linux4.17-dbg
                      linux4.17-headers>,
    'linux4.18' => qw<linux4.18-dbg
                      linux4.18-headers>,
    'llvm' => qw<clang
                 clang-analyzer
                 clang-tools-extra
                 libllvm6.0
                 lld
                 lld-devel
                 lldb
                 lldb-devel>,
    'lua' => qw<lua-devel>,
    'LuaJIT' => ['LuaJIT-devel'],
    'lua-lpeg' => qw<lua51-lpeg
                     lua52-lpeg>,
    'lua51' => ['lua51-devel'],
    'lua52' => ['lua52-devel'],
    'lutok' => qw<lutok-devel>,
    'lvm2' => qw<device-mapper
                 device-mapper-devel
                 liblvm2app
                 liblvm2app-devel>,
    'lz4' => qw<liblz4
                liblz4-devel
                lz4-devel>,
    'lzo' => ['lzo-devel'],
    'man-pages' => ['man-pages-devel'],
    'mit-krb5' => qw<mit-krb5-client
                     mit-krb5-devel
                     mit-krb5-libs>,
    'mpfr' => ['mpfr-devel'],
    'msgpack' => ['msgpack-devel'],
    'musl' => ['musl-devel'],
    'musl-fts' => ['musl-fts-devel'],
    'ncurses' => qw<ncurses-base
                    ncurses-devel
                    ncurses-libs
                    ncurses-term>,
    'nettle' => qw<nettle-devel
                   nettle-tools>,
    'nftables' => qw<libnftables
                     libnftables-devel>,
    'nghttp2' => ['nghttp2-devel'],
    'npth' => ['npth-devel'],
    'nspr' => ['nspr-devel'],
    'nss' => ['nss-devel'],
    'ntfs-3g' => ['ntfs-3g-devel'],
    'ntp' => ['ntp-perl'],
    'numactl' => qw<libnuma
                    libnuma-devel>,
    'odroid-c2-kernel' => ['odroid-c2-kernel-headers'],
    'oniguruma' => qw<oniguruma-devel
                      oniguruma-doc>,
    'openldap' => qw<libldap
                     libldap-devel
                     openldap-tools>,
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
    'pinentry' => ['pinentry-tty'],
    'pixman' => ['pixman-devel'],
    'pkcs11-helper' => qw<pkcs11-helper-devel
                          pkcs11-helper-doc>,
    'pkgconf' => ['pkgconf-devel'],
    'popt' => ['popt-devel'],
    'ppp' => ['ppp-devel'],
    'pps-tools' => ['pps-tools-devel'],
    'procps-ng' => ['procps-ng-devel'],
    'protobuf' => qw<protobuf-devel
                     protobuf-lite>,
    'python' => ['python-devel'],
    'python-Babel' => ['python3-Babel'],
    'python-Cython' => ['python3-Cython'],
    'python-Jinja2' => ['python3-Jinja2'],
    'python-M2Crypto' => ['python3-M2Crypto'],
    'python-MarkupSafe' => ['python3-MarkupSafe'],
    'python-Pygments' => ['python3-Pygments'],
    'python-Sphinx' => ['python3-Sphinx'],
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
    'python-docopt' => ['python3-docopt'],
    'python-docutils' => ['python3-docutils'],
    'python-flaky' => ['python3-flaky'],
    'python-greenlet' => qw<python-greenlet-devel
                            python3-greenlet
                            python3-greenlet-devel>,
    'python-hypothesis' => ['python3-hypothesis'],
    'python-idna' => ['python3-idna'],
    'python-imagesize' => ['python3-imagesize'],
    'python-msgpack' => ['python3-msgpack'],
    'python-more-itertools' => ['python3-more-itertools'],
    'python-neovim' => ['python3-neovim'],
    'python-numpy' => ['python3-numpy'],
    'python-packaging' => ['python3-packaging'],
    'python-paramiko' => ['python3-paramiko'],
    'python-parsing' => ['python3-parsing'],
    'python-pluggy' => ['python3-pluggy'],
    'python-ply' => ['python3-ply'],
    'python-py' => ['python3-py'],
    'python-pyasn1' => ['python3-pyasn1'],
    'python-pycparser' => ['python3-pycparser'],
    'python-pynacl' => ['python3-pynacl'],
    'python-pytest' => ['python3-pytest'],
    'python-pytz' => ['python3-pytz'],
    'python-requests' => ['python3-requests'],
    'python-setuptools' => ['python3-setuptools'],
    'python-six' => ['python3-six'],
    'python-snowballstemmer' => ['python3-snowballstemmer'],
    'python-sphinxcontrib' => ['python3-sphinxcontrib'],
    'python-sphinxcontrib-websupport' => ['python3-sphinxcontrib-websupport'],
    'python-urllib3' => ['python3-urllib3'],
    'python-yaml' => ['python3-yaml'],
    'python3' => ['python3-devel'],
    'qemu' => ['qemu-ga'],
    'qrencode' => qw<libqrencode
                     qrencode-devel>,
    'readline' => ['readline-devel'],
    'rhash' => ['rhash-devel'],
    'ruby' => qw<ruby-devel
                 ruby-devel-doc
                 ruby-ri>,
    'runit-void' => ['runit-void-apparmor'],
    'rust' => ['rust-doc'],
    'schilytools' => qw<sccs
                        sdd
                        sfind
                        smake
                        star>,
    'snappy' => ['snappy-devel'],
    'spice' => ['spice-devel'],
    'sqlite' => ['sqlite-devel'],
    'sysfsutils' => qw<libsysfs
                       libsysfs-devel>,
    'talloc' => ['talloc-devel'],
    'tcl' => ['tcl-devel'],
    'unibilium' => ['unibilium-devel'],
    'unixodbc' => qw<libodbc
                     unixodbc-devel>,
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
    'vde2' => qw<libvde2
                 vde2-devel>,
    'vim' => qw<vim-common
                xxd>,
    'void-repo-multilib' => ['void-repo-multilib-nonfree'],
    'void-repo-nonfree' => ['void-repo-debug'],
    'wireguard' => ['wireguard-tools'],
    'wireless_tools' => ['wireless_tools-devel'],
    'wvstreams' => ['wvstreams-devel'],
    'xbps' => qw<libxbps
                 libxbps-devel
                 xbps-tests>,
    'xfsprogs' => ['xfsprogs-devel'],
    'xz' => qw<liblzma
               liblzma-devel>,
    'zeromq' => ['zeromq-devel'],
    'zlib' => ['zlib-devel'],
    'zstd' => qw<libzstd
                 libzstd-devel
                 zstd-devel>;

# end %pkg }}}

mksymlinks(%pkg);

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
