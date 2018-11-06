#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# copy-upstream-srcpkgs.sh: copy select srcpkgs from upstream
# -----------------------------------------------------------------------------

# ==============================================================================
# constants {{{

# path to this script
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# path to https://github.com/atweiden/voidpkgs
readonly ROOT_ATW="$(realpath "$DIR/..")"
# path to https://github.com/atweiden/voidpkgs/srcpkgs
readonly SRCPKGS_ATW="$ROOT_ATW/srcpkgs/"
# path to https://github.com/void-linux/void-packages
readonly ROOT_VOID="$HOME/Sandbox/void-linux/void-packages"
# path to https://github.com/void-linux/void-packages/srcpkgs
readonly SRCPKGS_VOID="$ROOT_VOID/srcpkgs/"
# select pkgs to copy
readonly PKGS=('ISOEnts'
               'LuaJIT'
               'MoarVM'
               'ack'
               'acl'
               'acpi'
               'acpid'
               'android-tools'
               'ansible'
               'apache'
               'apparmor'
               'apr'
               'apr-util'
               'argon2'
               'argp-standalone'
               'aria2'
               'asciidoc'
               'atf'
               'attr'
               'autoconf'
               'automake'
               'avahi'
               'babeltrace'
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
               'bettercap'
               'bind'
               'binfmt-support'
               'binutils'
               'bison'
               'boost'
               'btrfs-progs'
               'busybox'
               'byacc'
               'bzip2'
               'c-ares'
               'ca-certificates'
               'cabal-install'
               'cargo'
               'ccache'
               'ccrypt'
               'cdrtools'
               'check'
               'chicken'
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
               'confuse'
               'conntrack-tools'
               'coreutils'
               'cpio'
               'cracklib'
               'crda'
               'create_ap'
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
               'darcs'
               'darkhttpd'
               'dash'
               'db'
               'dbus'
               'ddclient'
               'dejagnu'
               'dep'
               'desktop-file-utils'
               'dhcp'
               'dhcpcd'
               'dialog'
               'diffutils'
               'distcc'
               'dkms'
               'dmraid'
               'dnscrypt-proxy'
               'dnsmasq'
               'dnssec-anchors'
               'docbook'
               'docbook-dsssl'
               'docbook-xml'
               'docbook-xsl'
               'docbook2x'
               'docker'
               'dosfstools'
               'doxygen'
               'dracut'
               'dtc'
               'duktape'
               'dvd+rw-tools'
               'e2fsprogs'
               'ed'
               'edbrowse'
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
               'fail2ban'
               'faketime'
               'fd'
               'file'
               'findutils'
               'fish-shell'
               'flex'
               'fossil'
               'fuse'
               'fwup'
               'fzf'
               'gambit'
               'gawk'
               'gc'
               'gcc'
               'gcc-multilib'
               'gdb'
               'gdbm'
               'geoip'
               'geoip-data'
               'gettext'
               'ghc'
               'ghc-bin'
               'git'
               'git-lfs'
               'glib'
               'glibc'
               'glide'
               'gmp'
               'gnu-efi-libs'
               'gnupg'
               'gnupg2'
               'gnutls'
               'go'
               'go-bindata'
               'go1.4-bootstrap'
               'gperf'
               'gptfdisk'
               'grep'
               'groff'
               'grub'
               'gtest'
               'guile'
               'gzip'
               'h2o'
               'haproxy'
               'haveged'
               'help2man'
               'hostapd'
               'http-parser'
               'hwids'
               'i2pd'
               'iana-etc'
               'icdiff'
               'icu'
               'iftop'
               'inadyn'
               'inetutils'
               'intel-ucode'
               'intltool'
               'iproute2'
               'iptables'
               'iputils'
               'ipw2100-firmware'
               'ipw2200-firmware'
               'irqbalance'
               'irssi'
               'isl15'
               'isl16'
               'iw'
               'jansson'
               'jq'
               'json-c'
               'just'
               'kbd'
               'kbfs'
               'kernel-libc-headers'
               'keybase'
               'kmod'
               'kpcli'
               'kubernetes'
               'kubernetes-helm'
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
               'libconfig'
               'libcppunit'
               'libdaemon'
               'libedit'
               'libev'
               'libevent'
               'libffi'
               'libgcc'
               'libgcrypt'
               'libgfshare'
               'libgit2'
               'libgpg-error'
               'libgssglue'
               'libgudev'
               'libidn'
               'libimobiledevice'
               'libjpeg-turbo'
               'libksba'
               'liblz4'
               'liblzma'
               'libmbim'
               'libmnl'
               'libmpack'
               'libmpc'
               'libnetfilter_acct'
               'libnetfilter_conntrack'
               'libnetfilter_cthelper'
               'libnetfilter_cttimeout'
               'libnetfilter_log'
               'libnetfilter_queue'
               'libnfc'
               'libnfnetlink'
               'libnfs'
               'libnftnl'
               'libnl'
               'libnl3'
               'libotr'
               'libpcap'
               'libpipeline'
               'libplist'
               'libpng'
               'libpsl'
               'libpwquality'
               'libressl'
               'librtmp'
               'libsasl'
               'libseccomp'
               'libsmbios'
               'libsodium'
               'libssh'
               'libssh2'
               'libtasn1'
               'libtermkey'
               'libtirpc'
               'libtomcrypt'
               'libtommath'
               'libtool'
               'libunistring'
               'libunwind'
               'liburcu'
               'libusb'
               'libusb-compat'
               'libusbmuxd'
               'libutempter'
               'libuv'
               'libvterm'
               'libxml2'
               'libxslt'
               'libyaml'
               'libzstd'
               'linux'
               'linux-firmware'
               'linux4.18'
               'linux4.19'
               'llvm'
               'logrotate'
               'lttng-modules-dkms'
               'lttng-tools'
               'lttng-ust'
               'lua'
               'lua-lpeg'
               'lua51'
               'lua51-mpack'
               'lua52'
               'lua52-BitOp'
               'lutok'
               'lvm2'
               'lxc'
               'lynx'
               'lz4'
               'lzip'
               'lzo'
               'm4'
               'make'
               'man-db'
               'man-pages'
               'man-pages-posix'
               'mbedtls'
               'mdadm'
               'mdocml'
               'mercurial'
               'meson'
               'minicom'
               'minisign'
               'miniupnpc'
               'mit-krb5'
               'mlocate'
               'mobile-broadband-provider-info'
               'moreutils'
               'mosh'
               'mpfr'
               'msgpack'
               'mtools'
               'musl'
               'musl-bootstrap'
               'musl-fts'
               'musl-legacy-compat'
               'musl-obstack'
               'myrepos'
               'nasm'
               'ncdu'
               'ncurses'
               'neovim'
               'net-snmp'
               'net-tools'
               'nettle'
               'nftables'
               'nghttp2'
               'nginx'
               'nim'
               'ninja'
               'nmap'
               'nodejs'
               'nodejs-lts'
               'npth'
               'nqp'
               'nsd'
               'nspr'
               'nss'
               'ntfs-3g'
               'ntp'
               'numactl'
               'nvi'
               'ocaml'
               'ocaml-findlib'
               'ocamlbuild'
               'odroid-c2-base'
               'odroid-c2-kernel'
               'odroid-c2-uboot'
               'oniguruma'
               'opam'
               'openjade'
               'openldap'
               'openntpd'
               'openresolv'
               'opensp'
               'openssh'
               'openvpn'
               'os-prober'
               'p11-kit'
               'packer'
               'pam'
               'pam-base'
               'parted'
               'patch'
               'pciutils'
               'pcre'
               'pcre2'
               'pcsclite'
               'perl'
               'perl-Algorithm-Diff'
               'perl-Authen-SASL'
               'perl-Class-Data-Inheritable'
               'perl-Clone'
               'perl-Convert-BinHex'
               'perl-Crypt-Rijndael'
               'perl-Data-Validate-IP'
               'perl-Devel-StackTrace'
               'perl-Devel-Symdump'
               'perl-Exception-Class'
               'perl-File-KeePass'
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
               'perl-NetAddr-IP'
               'perl-Pod-Coverage'
               'perl-Socket6'
               'perl-Sort-Naturally'
               'perl-Sub-Uplevel'
               'perl-Term-ReadKey'
               'perl-Term-ReadLine-Gnu'
               'perl-Term-ShellUI'
               'perl-Test-Deep'
               'perl-Test-Differences'
               'perl-Test-Exception'
               'perl-Test-Most'
               'perl-Test-Needs'
               'perl-Test-NoWarnings'
               'perl-Test-Pod'
               'perl-Test-Pod-Coverage'
               'perl-Test-Requires'
               'perl-Test-Warn'
               'perl-Text-Diff'
               'perl-Time-Duration'
               'perl-TimeDate'
               'perl-URI'
               'perl-XML-NamespaceSupport'
               'perl-XML-Parser'
               'perl-XML-SAX'
               'perl-XML-SAX-Base'
               'picocom'
               'pijul'
               'pinentry'
               'pixman'
               'pkcs11-helper'
               'pkg-config'
               'pkgconf'
               'popt'
               'postgresql'
               'ppp'
               'pps-tools'
               'privoxy'
               'procps-ng'
               'proot'
               'protobuf'
               'proxychains-ng'
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
               'python-Unidecode'
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
               'python-docutils'
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
               'radvd'
               'rakudo'
               'rclone'
               'readline'
               'rebar3'
               'rhash'
               'ripgrep'
               'rlwrap'
               'rsync'
               'ruby'
               'run-parts'
               'runit'
               'runit-swap'
               'runit-void'
               'rust'
               'rustup'
               'schilytools'
               'scons'
               'screen'
               'scrypt'
               'sdcv'
               'sed'
               'serf'
               'shadow'
               'shadowsocks-libev'
               'shared-mime-info'
               'shellcheck'
               'sift'
               'sipcalc'
               'smake'
               'snappy'
               'sniproxy'
               'socat'
               'socklog'
               'socklog-void'
               'spice'
               'spice-protocol'
               'spiped'
               'sqlite'
               'squashfs-tools'
               'squid'
               'sshuttle'
               'stack'
               'stegsnow'
               'strace'
               'subversion'
               'sudo'
               'swig'
               'sysfsutils'
               'syslinux'
               'systemtap'
               'talloc'
               'tar'
               'tcl'
               'texinfo'
               'the_silver_searcher'
               'thin-provisioning-tools'
               'tidy5'
               'tinyproxy'
               'tmux'
               'tor'
               'torsocks'
               'toxcore'
               'toxic'
               'traceroute'
               'tree'
               'tuntox'
               'tzdata'
               'tzutils'
               'uboot-mkimage'
               'udns'
               'ulogd'
               'unbound'
               'unibilium'
               'units'
               'unixodbc'
               'unzip'
               'usb-modeswitch'
               'usb-modeswitch-data'
               'usbredir'
               'usbutils'
               'util-linux'
               'vagrant'
               'valgrind'
               'vde2'
               'vim'
               'vnstat'
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
               'wvdial'
               'wvstreams'
               'xbps'
               'xbps-static'
               'xbps-triggers'
               'xfsprogs'
               'xinetd'
               'xmlcatmgr'
               'xmlto'
               'xmltoman'
               'xtools'
               'xxHash'
               'xz'
               'yasm'
               'zd1211-firmware'
               'zeromq'
               'zig'
               'zip'
               'zlib'
               'zsh'
               'zsh-completions'
               'zsh-syntax-highlighting'
               'zstd')

# end constants }}}
# ==============================================================================

main() {
  for _pkg in "${PKGS[@]}"; do
    _dir="$SRCPKGS_VOID/$_pkg"
    echo "Copying $_dir..."
    if [[ -d "$_dir" ]]; then
      cp -a "$_dir" "$SRCPKGS_ATW"
    else
      echo "not found"
      exit 1
    fi
  done
}

main

# vim: set filetype=sh foldmethod=marker foldlevel=0:
