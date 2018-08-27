#!/usr/bin/env perl6

# %pkg {{{

# array of subpackages indexed by base pkg
my List:D %pkg{Str:D} =
    'acl' => qw<acl-devel
                acl-progs>,
    'atf' => qw<atf-devel
                atf-libs>,
    'attr' => qw<attr-devel
                 attr-progs>,
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
                 dbus-libs
                 dbus-x11>,
    'dracut' => ['dracut-network'],
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
    'gdbm' => ['gdbm-devel'],
    'gettext' => qw<gettext-devel
                    gettext-devel-examples
                    gettext-libs>,
    'git' => qw<git-all
                git-cvs
                git-gui
                git-svn
                gitk>,
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
    'haveged' => qw<libhaveged
                    libhaveged-devel>,
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
    'isl15' => ['isl15-devel'],
    'jansson' => ['jansson-devel'],
    'json-c' => ['json-c-devel'],
    'kbd' => ['kbd-data'],
    'kmod' => qw<libkmod
                 libkmod-devel>,
    'kyua' => ['kyua-tests'],
    'ldns' => qw<libldns
                 libldns-devel>,
    'libaio' => ['libaio-devel'],
    'libarchive' => qw<bsdtar
                       libarchive-devel>,
    'libassuan' => ['libassuan-devel'],
    'libatomic_ops' => ['libatomic_ops-devel'],
    'libcap' => qw<libcap-devel
                   libcap-progs>,
    'libcap-ng' => qw<libcap-ng-devel
                      libcap-ng-progs
                      libcap-ng-python
                      libcap-ng-python3>,
    'libedit' => ['libedit-devel'],
    'libevent' => ['libevent-devel'],
    'libffi' => ['libffi-devel'],
    'libgcrypt' => ['libgcrypt-devel'],
    'libgpg-error' => ['libgpg-error-devel'],
    'libidn' => ['libidn-devel'],
    'libksba' => ['libksba-devel'],
    'libmnl' => ['libmnl-devel'],
    'libmpc' => ['libmpc-devel'],
    'libnftnl' => ['libnftnl-devel'],
    'libnl' => ['libnl-devel'],
    'libnl3' => qw<libnl3-devel
                   libnl3-progs>,
    'libpcap' => ['libpcap-devel'],
    'libpipeline' => ['libpipeline-devel'],
    'libpng' => qw<libpng-devel
                   libpng-progs>,
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
    'libtomcrypt' => ['libtomcrypt-devel'],
    'libtommath' => ['libtommath-devel'],
    'libtool' => qw<libltdl
                    libltdl-devel>,
    'libtommath' => ['libtommath-devel'],
    'libunistring' => ['libunistring-devel'],
    'libusb' => ['libusb-devel'],
    'libusb-compat' => ['libusb-compat-devel'],
    'libuv' => ['libuv-devel'],
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
    'musl' => ['musl-devel'],
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
    'ntp' => ['ntp-perl'],
    'numactl' => qw<libnuma
                    libnuma-devel>,
    'openldap' => qw<libldap
                     libldap-devel
                     openldap-tools>,
    'p11-kit' => ['p11-kit-devel'],
    'pam' => qw<pam-devel
                pam-libs
                pam-userdb>,
    'pciutils' => ['pciutils-devel'],
    'pcre' => qw<libpcre
                 libpcrecpp
                 pcre-devel>,
    'pcre2' => qw<libpcre2
                  pcre2-devel>,
    'pinentry' => qw<pinentry-emacs
                     pinentry-gtk
                     pinentry-qt
                     pinentry-tty>,
    'pkgconf' => ['pkgconf-devel'],
    'popt' => ['popt-devel'],
    'pps-tools' => ['pps-tools-devel'],
    'procps-ng' => ['procps-ng-devel'],
    'protobuf' => qw<protobuf-devel
                     protobuf-lite>,
    'python' => ['python-devel'],
    'python-docopt' => ['python3-docopt'],
    'python-setuptools' => ['python3-setuptools'],
    'python-yaml' => ['python3-yaml'],
    'python3' => ['python3-devel'],
    'qrencode' => qw<libqrencode
                     qrencode-devel>,
    'readline' => ['readline-devel'],
    'rhash' => ['rhash-devel'],
    'runit-void' => ['runit-void-apparmor'],
    'sqlite' => ['sqlite-devel'],
    'sysfsutils' => qw<libsysfs
                       libsysfs-devel>,
    'tcl' => ['tcl-devel'],
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
    'vim' => qw<gvim
                gvim-huge
                vim-common
                vim-huge
                vim-huge-python3
                vim-x11
                xxd>,
    'wireless_tools' => ['wireless_tools-devel'],
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

sub mksymlinks(%p --> Nil)
{
    %p.kv.map(-> Str:D $pkg, @subpkg {
        for @subpkg -> $subpkg
        {
            my Str:D $ln-cmdline = "ln -rs srcpkgs/$pkg srcpkgs/$subpkg";
            say($ln-cmdline);
            my Proc:D $ln-cmdline-proc = shell($ln-cmdline);
            $ln-cmdline-proc.exitcode == 0
                or do {
                    my Str:D $message =
                        sprintf(
                            Q{Sorry, could not create symlink from `%s`},
                            $ln-cmdline.join(' ')
                        );
                    die($message);
                }
        }
    });
}

mksymlinks(%pkg);

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
