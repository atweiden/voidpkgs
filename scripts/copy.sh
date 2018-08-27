#!/usr/bin/env bash

# use this script to copy pkgs over from inside void-packages dir
_pkgs=('MoarVM'
       'acl'
       'acpi'
       'acpid'
       'argp-standalone'
       'asciidoc'
       'atf'
       'attr'
       'autoconf'
       'automake'
       'base-chroot'
       'base-chroot-musl'
       'base-devel'
       'base-files'
       'base-system'
       'base-voidstrap'
       'bash'
       'bash-completion'
       'bc'
       'binutils'
       'bison'
       'boost'
       'btrfs-progs'
       'bzip2'
       'ca-certificates'
       'ccache'
       'ccrypt'
       'cdrtools'
       'chrony'
       'chroot-bash'
       'chroot-distcc'
       'chroot-gawk'
       'chroot-git'
       'chroot-grep'
       'chroot-texinfo'
       'chroot-util-linux'
       'clang'
       'coreutils'
       'cpio'
       'cracklib'
       'crda'
       'cronie'
       'cross-aarch64-linux-gnu'
       'cross-aarch64-linux-musl'
       'cross-arm-linux-gnueabi'
       'cross-arm-linux-gnueabihf'
       'cross-arm-linux-musleabi'
       'cross-arm-linux-musleabihf'
       'cross-arm-none-eabi'
       'cross-armv7l-linux-gnueabihf'
       'cross-armv7l-linux-musleabihf'
       'cross-i686-linux-musl'
       'cross-i686-pc-linux-gnu'
       'cross-mips-linux-musl'
       'cross-mips-linux-muslhf'
       'cross-mipsel-linux-musl'
       'cross-mipsel-linux-muslhf'
       'cross-vpkg-dummy'
       'cross-x86_64-linux-musl'
       'crypto++'
       'cryptsetup'
       'curl'
       'darkhttpd'
       'dash'
       'db'
       'dbus'
       'dejagnu'
       'dep'
       'dhclient'
       'dhcpcd'
       'dialog'
       'diffutils'
       'dnscrypt-proxy'
       'dnssec-anchors'
       'docbook-xsl'
       'dosfstools'
       'dracut'
       'dvd+rw-tools'
       'e2fsprogs'
       'ed'
       'efibootmgr'
       'efivar'
       'elfutils'
       'encfs'
       'ethtool'
       'eudev'
       'exfat-utils'
       'expat'
       'expect'
       'f2fs-tools'
       'file'
       'findutils'
       'flex'
       'fuse'
       'fzf'
       'gawk'
       'gcc'
       'gdb'
       'gdbm'
       'gettext'
       'git'
       'glibc'
       'glide'
       'gmp'
       'gnupg'
       'gnupg2'
       'gnutls'
       'go'
       'gptfdisk'
       'grep'
       'groff'
       'grub'
       'gzip'
       'haveged'
       'help2man'
       'hwids'
       'iana-etc'
       'icu'
       'inetutils'
       'intel-ucode'
       'iproute2'
       'iputils'
       'ipw2100-firmware'
       'ipw2200-firmware'
       'isl15'
       'iw'
       'jansson'
       'json-c'
       'kbd'
       'kernel-libc-headers'
       'kmod'
       'kyua'
       'ldns'
       'less'
       'libaio'
       'libarchive'
       'libassuan'
       'libatomic_ops'
       'libcap'
       'libcap-ng'
       'libedit'
       'libevent'
       'libffi'
       'libgcc'
       'libgcrypt'
       'libgpg-error'
       'libidn'
       'libksba'
       'liblz4'
       'liblzma'
       'libmnl'
       'libmpc'
       'libnftnl'
       'libnl'
       'libnl3'
       'libpcap'
       'libpipeline'
       'libpng'
       'libpwquality'
       'libressl'
       'librtmp'
       'libsasl'
       'libseccomp'
       'libsodium'
       'libssh2'
       'libtasn1'
       'libtomcrypt'
       'libtommath'
       'libtool'
       'libunistring'
       'libusb'
       'libusb-compat'
       'libuv'
       'libxml2'
       'libxslt'
       'libyaml'
       'libzstd'
       'linux'
       'linux-firmware'
       'linux4.17'
       'linux4.18'
       'llvm'
       'logrotate'
       'lvm2'
       'lz4'
       'lzo'
       'm4'
       'make'
       'man-db'
       'man-pages'
       'mdocml'
       'mercurial'
       'mit-krb5'
       'mlocate'
       'moreutils'
       'mpfr'
       'musl'
       'musl-devel'
       'musl-legacy-compat'
       'musl-obstack'
       'myrepos'
       'ncurses'
       'net-tools'
       'nettle'
       'nftables'
       'nghttp2'
       'ninja'
       'npth'
       'nqp'
       'numactl'
       'nvi'
       'openldap'
       'openresolv'
       'openssh'
       'os-prober'
       'p11-kit'
       'pam'
       'pam-base'
       'patch'
       'pciutils'
       'pcre'
       'pcre2'
       'perl'
       'perl-Authen-SASL'
       'perl-Convert-BinHex'
       'perl-IO-Socket-SSL'
       'perl-IO-stringy'
       'perl-IPC-Run'
       'perl-MIME-tools'
       'perl-MailTools'
       'perl-Net-SMTP-SSL'
       'perl-Net-SSLeay'
       'perl-Time-Duration'
       'perl-TimeDate'
       'perl-URI'
       'pinentry'
       'pkg-config'
       'pkgconf'
       'popt'
       'procps-ng'
       'protobuf'
       'psmisc'
       'python'
       'python3'
       'python3-docopt'
       'python3-yaml'
       'qemu'
       'qemu-user-static'
       'qrencode'
       'rakudo'
       'rclone'
       'readline'
       'ripgrep'
       'rsync'
       'run-parts'
       'runit'
       'runit-swap'
       'runit-void'
       'sed'
       'shadow'
       'shellcheck'
       'smake'
       'socat'
       'socklog'
       'socklog-void'
       'sqlite'
       'sudo'
       'sysfsutils'
       'tar'
       'tcl'
       'texinfo'
       'the_silver_searcher'
       'tmux'
       'tor'
       'torsocks'
       'traceroute'
       'tzdata'
       'uboot-mkimage'
       'unzip'
       'usb-modeswitch'
       'usb-modeswitch-data'
       'usbutils'
       'util-linux'
       'vim'
       'void-artwork'
       'wget'
       'which'
       'wifi-firmware'
       'wifish'
       'wireless_tools'
       'wpa_actiond'
       'wpa_supplicant'
       'xbps'
       'xbps-static'
       'xbps-triggers'
       'xfsprogs'
       'xmlcatmgr'
       'xmlto'
       'xtools'
       'xz'
       'zd1211-firmware'
       'zeromq'
       'zip'
       'zlib'
       'zstd')

for _pkg in "${_pkgs[@]}"; do
  _dir="srcpkgs/$_pkg"
  echo "Copying $_dir..."
  if [[ -d "$_dir" ]]; then
    cp -a "$PWD/srcpkgs/$_pkg" "$HOME/Projects/voidpkgs/srcpkgs"
  else
    echo "not found"
    exit 1
  fi
done
