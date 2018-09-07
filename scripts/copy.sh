#!/usr/bin/env bash

# use this script to copy pkgs over from inside void-packages dir
_pkgs=('ISOEnts'
       'LuaJIT'
       'MoarVM'
       'ack'
       'acl'
       'acpi'
       'acpid'
       'ansible'
       'argp-standalone'
       'aria2'
       'asciidoc'
       'atf'
       'attr'
       'autoconf'
       'automake'
       'avahi'
       'base-chroot'
       'base-chroot-musl'
       'base-devel'
       'base-files'
       'base-system'
       'base-voidstrap'
       'bash'
       'bash-completion'
       'bc'
       'bcc'
       'binutils'
       'bison'
       'boost'
       'btrfs-progs'
       'bzip2'
       'c-ares'
       'ca-certificates'
       'cargo'
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
       'cmake'
       'cmocka'
       'colordiff'
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
       'dhcp'
       'dhcpcd'
       'dialog'
       'diffutils'
       'distcc'
       'dkms'
       'dnscrypt-proxy'
       'dnssec-anchors'
       'docbook'
       'docbook-dsssl'
       'docbook-xml'
       'docbook-xsl'
       'docbook2x'
       'dosfstools'
       'doxygen'
       'dracut'
       'dtc'
       'dvd+rw-tools'
       'e2fsprogs'
       'ed'
       'efibootmgr'
       'efivar'
       'elfutils'
       'elixir'
       'encfs'
       'erlang'
       'ethtool'
       'eudev'
       'exfat-utils'
       'exiftool'
       'expat'
       'expect'
       'f2fs-tools'
       'fd'
       'file'
       'findutils'
       'fish-shell'
       'flex'
       'fuse'
       'fzf'
       'gawk'
       'gc'
       'gcc'
       'gcc-multilib'
       'gdb'
       'gdbm'
       'gettext'
       'git'
       'glib'
       'glibc'
       'glide'
       'gmp'
       'gnupg'
       'gnupg2'
       'gnutls'
       'go'
       'go1.4-bootstrap'
       'gperf'
       'gptfdisk'
       'grep'
       'groff'
       'grub'
       'gtest'
       'guile'
       'gzip'
       'haveged'
       'help2man'
       'http-parser'
       'hwids'
       'iana-etc'
       'icdiff'
       'icu'
       'inetutils'
       'intel-ucode'
       'intltool'
       'iproute2'
       'iptables'
       'iputils'
       'ipw2100-firmware'
       'ipw2200-firmware'
       'irssi'
       'isl15'
       'isl16'
       'iw'
       'jansson'
       'jq'
       'json-c'
       'just'
       'kbd'
       'kernel-libc-headers'
       'kmod'
       'kyua'
       'lapack'
       'ldns'
       'less'
       'libaio'
       'libarchive'
       'libassuan'
       'libatomic_ops'
       'libcacard'
       'libcap'
       'libcap-ng'
       'libcppunit'
       'libedit'
       'libevent'
       'libffi'
       'libgcc'
       'libgcrypt'
       'libgit2'
       'libgpg-error'
       'libidn'
       'libjpeg-turbo'
       'libksba'
       'liblz4'
       'liblzma'
       'libmnl'
       'libmpack'
       'libmpc'
       'libnfs'
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
       'libtermkey'
       'libtomcrypt'
       'libtommath'
       'libtool'
       'libunistring'
       'libunwind'
       'libusb'
       'libusb-compat'
       'libutempter'
       'libuv'
       'libvterm'
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
       'lua'
       'lua-lpeg'
       'lua51'
       'lua51-mpack'
       'lua52'
       'lua52-BitOp'
       'lutok'
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
       'mosh'
       'mpfr'
       'msgpack'
       'musl'
       'musl-devel'
       'musl-legacy-compat'
       'musl-obstack'
       'myrepos'
       'ncdu'
       'ncurses'
       'neovim'
       'net-tools'
       'nettle'
       'nftables'
       'nghttp2'
       'ninja'
       'nodejs'
       'nodejs-lts'
       'npth'
       'nqp'
       'nspr'
       'nss'
       'ntp'
       'numactl'
       'nvi'
       'odroid-c2-base'
       'odroid-c2-kernel'
       'odroid-c2-uboot'
       'oniguruma'
       'openldap'
       'openresolv'
       'openssh'
       'openvpn'
       'os-prober'
       'p11-kit'
       'pam'
       'pam-base'
       'patch'
       'pciutils'
       'pcre'
       'pcre2'
       'pcsclite'
       'perl'
       'perl-Algorithm-Diff'
       'perl-Authen-SASL'
       'perl-Class-Data-Inheritable'
       'perl-Convert-BinHex'
       'perl-Devel-StackTrace'
       'perl-Devel-Symdump'
       'perl-Exception-Class'
       'perl-File-Next'
       'perl-File-Slurp'
       'perl-IO-Socket-INET6'
       'perl-IO-Socket-SSL'
       'perl-IO-Tty'
       'perl-IO-stringy'
       'perl-IPC-Run'
       'perl-Locale-gettext'
       'perl-MIME-tools'
       'perl-MailTools'
       'perl-Net-SMTP-SSL'
       'perl-Net-SSLeay'
       'perl-Pod-Coverage'
       'perl-Socket6'
       'perl-Sub-Uplevel'
       'perl-Test-Deep'
       'perl-Test-Differences'
       'perl-Test-Exception'
       'perl-Test-Most'
       'perl-Test-Needs'
       'perl-Test-NoWarnings'
       'perl-Test-Pod'
       'perl-Test-Pod-Coverage'
       'perl-Test-Warn'
       'perl-Text-Diff'
       'perl-Time-Duration'
       'perl-TimeDate'
       'perl-URI'
       'perl-XML-NamespaceSupport'
       'perl-XML-Parser'
       'perl-XML-SAX'
       'perl-XML-SAX-Base'
       'pinentry'
       'pixman'
       'pkcs11-helper'
       'pkg-config'
       'pkgconf'
       'popt'
       'pps-tools'
       'procps-ng'
       'proot'
       'protobuf'
       'psmisc'
       'pwgen'
       'python'
       'python-Babel'
       'python-Cython'
       'python-Jinja2'
       'python-M2Crypto'
       'python-MarkupSafe'
       'python-Pygments'
       'python-Sphinx'
       'python-alabaster'
       'python-asn1crypto'
       'python-atomicwrites'
       'python-attrs'
       'python-bcrypt'
       'python-cffi'
       'python-chardet'
       'python-coverage'
       'python-cram'
       'python-cryptography'
       'python-docopt'
       'python-enum34'
       'python-flaky'
       'python-funcsigs'
       'python-futures'
       'python-greenlet'
       'python-hypothesis'
       'python-idna'
       'python-imagesize'
       'python-ipaddress'
       'python-more-itertools'
       'python-msgpack'
       'python-neovim'
       'python-numpy'
       'python-packaging'
       'python-paramiko'
       'python-parsing'
       'python-pathlib2'
       'python-pluggy'
       'python-ply'
       'python-py'
       'python-pyasn1'
       'python-pycparser'
       'python-pynacl'
       'python-pytest'
       'python-pytz'
       'python-requests'
       'python-scandir'
       'python-setuptools'
       'python-six'
       'python-snowballstemmer'
       'python-sphinxcontrib'
       'python-sphinxcontrib-websupport'
       'python-trollius'
       'python-typing'
       'python-urllib3'
       'python-yaml'
       'python3'
       'qemu'
       'qemu-user-static'
       'qrencode'
       'rakudo'
       'rclone'
       'readline'
       'rhash'
       'ripgrep'
       'rlwrap'
       'rsync'
       'run-parts'
       'runit'
       'runit-swap'
       'runit-void'
       'rust'
       'schilytools'
       'sed'
       'shadow'
       'shellcheck'
       'smake'
       'snappy'
       'socat'
       'socklog'
       'socklog-void'
       'spice'
       'spice-protocol'
       'sqlite'
       'squashfs-tools'
       'sshuttle'
       'sudo'
       'swig'
       'sysfsutils'
       'talloc'
       'tar'
       'tcl'
       'texinfo'
       'the_silver_searcher'
       'thin-provisioning-tools'
       'tmux'
       'tor'
       'torsocks'
       'traceroute'
       'tree'
       'tzdata'
       'tzutils'
       'uboot-mkimage'
       'unibilium'
       'unixodbc'
       'unzip'
       'usb-modeswitch'
       'usb-modeswitch-data'
       'usbredir'
       'usbutils'
       'util-linux'
       'valgrind'
       'vde2'
       'vim'
       'void-artwork'
       'void-repo-multilib'
       'void-repo-nonfree'
       'wget'
       'which'
       'wifi-firmware'
       'wifish'
       'wireguard'
       'wireguard-go'
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
       'xxHash'
       'xz'
       'zd1211-firmware'
       'zeromq'
       'zip'
       'zlib'
       'zsh'
       'zsh-completions'
       'zsh-syntax-highlighting'
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
