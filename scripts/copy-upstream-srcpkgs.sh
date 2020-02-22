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
readonly PKGS=('66'
               '66-tools'
               'ISOEnts'
               'LuaJIT'
               'MoarVM'
               'ack'
               'acl'
               'acpi'
               'acpid'
               'aerc'
               'age'
               'aircrack-ng'
               'alpine'
               'alsa-lib'
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
               'autoconf-archive'
               'automake'
               'avahi'
               'babeltrace'
               'bandwhich'
               'base-chroot'
               'base-devel'
               'base-files'
               'base-minimal'
               'base-system'
               'base-voidstrap'
               'bash'
               'bash-completion'
               'bc'
               'bc-gh'
               'bcc'
               'bettercap'
               'bind'
               'binfmt-support'
               'binutils'
               'bison'
               'boost'
               'bootiso'
               'boringtun'
               'bpftrace'
               'brotli'
               'btrfs-progs'
               'bubblewrap'
               'busybox'
               'byacc'
               'bzip2'
               'c-ares'
               'ca-certificates'
               'cabal-install'
               'cargo'
               'ccache'
               'ccl'
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
               'chroot-util-linux'
               'clang'
               'clucene'
               'cmake'
               'cmocka'
               'coWPAtty'
               'colordiff'
               'confuse'
               'conntrack-tools'
               'containerd'
               'coreboot-utils'
               'coreutils'
               'corkscrew'
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
               'cross-arm-none-eabi-binutils'
               'cross-arm-none-eabi-gcc'
               'cross-arm-none-eabi-gdb'
               'cross-arm-none-eabi-libstdc++'
               'cross-arm-none-eabi-newlib'
               'cross-armv7l-linux-gnueabihf'
               'cross-armv7l-linux-musleabihf'
               'cross-i686-linux-musl'
               'cross-i686-pc-linux-gnu'
               'cross-mips-linux-musl'
               'cross-mips-linux-muslhf'
               'cross-mipsel-linux-musl'
               'cross-mipsel-linux-muslhf'
               'cross-powerpc-linux-gnu'
               'cross-powerpc-linux-musl'
               'cross-powerpc64-linux-gnu'
               'cross-powerpc64-linux-musl'
               'cross-powerpc64le-linux-gnu'
               'cross-powerpc64le-linux-musl'
               'cross-vpkg-dummy'
               'cross-x86_64-linux-musl'
               'cross-x86_64-w64-mingw32'
               'cryfs'
               'crypto++'
               'cryptsetup'
               'curl'
               'cvs'
               'cvsps2'
               'cyrus-sasl'
               'darcs'
               'darkhttpd'
               'dash'
               'db'
               'dbus'
               'ddclient'
               'dejagnu'
               'delta'
               'delve'
               'dep'
               'desktop-file-utils'
               'dhcp'
               'dhcpcd'
               'di'
               'dialog'
               'diffr'
               'diffutils'
               'distcc'
               'dkms'
               'dma'
               'dmraid'
               'dnscrypt-proxy'
               'dnsmasq'
               'dnssec-anchors'
               'docbook'
               'docbook-dsssl'
               'docbook-xml'
               'docbook-xsl'
               'docbook-xsl-ns'
               'docbook2x'
               'docker'
               'dos2unix'
               'dosfstools'
               'dovecot'
               'dovecot-plugin-pigeonhole'
               'doxygen'
               'dracut'
               'dsvpn'
               'dtc'
               'duktape'
               'dvd+rw-tools'
               'e2fsprogs'
               'earlyoom'
               'easyrsa'
               'ecl'
               'ed'
               'edbrowse'
               'efibootmgr'
               'efivar'
               'elfutils'
               'elixir'
               'ell'
               'encfs'
               'endlessh'
               'erlang'
               'ethtool'
               'ettercap'
               'eudev'
               'execline'
               'exfat-utils'
               'exiftool'
               'expat'
               'expect'
               'f2fs-tools'
               'fail2ban'
               'fake-hwclock'
               'faketime'
               'fann'
               'fd'
               'fdm'
               'fftw'
               'file'
               'findutils'
               'firejail'
               'fish-shell'
               'flac'
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
               'gcompat'
               'gdb'
               'gdbm'
               'geoip'
               'geoip-data'
               'gerbil'
               'getdns'
               'getmail'
               'gettext'
               'ghc'
               'ghc-bin'
               'git'
               'git-lfs'
               'git-team'
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
               'go-md2man'
               'go1.12-bootstrap'
               'gocryptfs'
               'gperf'
               'gperftools'
               'gpgme'
               'gptfdisk'
               'grep'
               'groff'
               'grpc'
               'grub'
               'gsasl'
               'gtest'
               'guile'
               'gzip'
               'h2o'
               'haproxy'
               'hashcat'
               'hashcat-utils'
               'haveged'
               'hdparm'
               'help2man'
               'hiredis'
               'hostapd'
               'http-parser'
               'httpie'
               'httrack'
               'hunspell'
               'hwids'
               'i2pd'
               'iana-etc'
               'icdiff'
               'icu'
               'iftop'
               'img'
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
               'isync'
               'itstool'
               'iw'
               'iwd'
               'jansson'
               'jemalloc'
               'john'
               'jp'
               'jq'
               'json-c'
               'jsoncpp'
               'just'
               'kakoune'
               'kbd'
               'kernel-libc-headers'
               'keybase'
               'kmod'
               'kpartx'
               'kpcli'
               'kubefwd'
               'kubernetes'
               'kubernetes-helm'
               'kyua'
               'lapack'
               'ldns'
               'less'
               'lfe'
               'libaio'
               'libarchive'
               'libasr'
               'libassuan'
               'libatomic_ops'
               'libbitcoin-blockchain'
               'libbitcoin-client'
               'libbitcoin-consensus'
               'libbitcoin-database'
               'libbitcoin-explorer'
               'libbitcoin-network'
               'libbitcoin-node'
               'libbitcoin-protocol'
               'libbitcoin-secp256k1'
               'libbitcoin-server'
               'libbitcoin-system'
               'libcacard'
               'libcap'
               'libcap-ng'
               'libcbor'
               'libcli'
               'libconfig'
               'libcppunit'
               'libdaemon'
               'libdnet'
               'libedit'
               'libev'
               'libevent'
               'libexecinfo'
               'libfetch'
               'libffi'
               'libfido2'
               'libgcc'
               'libgcrypt'
               'libgfshare'
               'libgit2'
               'libglib-static'
               'libgpg-error'
               'libgssglue'
               'libgudev'
               'libidn'
               'libidn2'
               'libimobiledevice'
               'libjpeg-turbo'
               'libksba'
               'libluv'
               'liblz4'
               'liblzma'
               'libmaxminddb'
               'libmbim'
               'libmnl'
               'libmpack'
               'libmpc'
               'libnet'
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
               'libogg'
               'libomp'
               'libotr'
               'libpcap'
               'libpipeline'
               'libplist'
               'libpng'
               'libpsl'
               'libpwquality'
               'libqb'
               'libreadline8'
               'libressl'
               'librtmp'
               'libsasl'
               'libseccomp'
               'libsigc++'
               'libsmbios'
               'libsndfile'
               'libsodium'
               'libsoxr'
               'libssh'
               'libssh2'
               'libtasn1'
               'libtermkey'
               'libtirpc'
               'libtomcrypt'
               'libtommath'
               'libtool'
               'libtorrent'
               'libucontext'
               'libunistring'
               'libunwind'
               'liburcu'
               'libusb'
               'libusb-compat'
               'libusbmuxd'
               'libutempter'
               'libuv'
               'libvorbis'
               'libvterm'
               'libxml2'
               'libxml2-python'
               'libxslt'
               'libyaml'
               'libzstd'
               'linux'
               'linux-firmware'
               'linux-lts'
               'linux4.14'
               'linux4.19'
               'linux5.4'
               'llhttp'
               'llvm'
               'llvm7'
               'llvm8'
               'llvm9'
               'lm_sensors'
               'logrotate'
               'logswan'
               'ltrace'
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
               'mariadb'
               'mbedtls'
               'mblaze'
               'mcelog'
               'mdadm'
               'mdocml'
               'mercurial'
               'meson'
               'mime-types'
               'minicom'
               'minijail'
               'minimodem'
               'minisign'
               'miniupnpc'
               'minizip'
               'mit-krb5'
               'mlocate'
               'mobile-broadband-provider-info'
               'moreutils'
               'mosh'
               'mpfr'
               'msgpack'
               'msmtp'
               'mtools'
               'musl'
               'musl-bootstrap'
               'musl-fts'
               'musl-legacy-compat'
               'musl-obstack'
               'mutt'
               'myrepos'
               'mysql'
               'nasm'
               'ncdu'
               'ncurses'
               'ndpi'
               'neovim'
               'net-snmp'
               'net-tools'
               'nethogs'
               'netsniff-ng'
               'nettle'
               'nftables'
               'nghttp2'
               'nginx'
               'ngrep'
               'nilfs-utils'
               'nim'
               'ninja'
               'nmap'
               'nncp'
               'nodejs'
               'nodejs-lts'
               'npth'
               'nqp'
               'nsd'
               'nspr'
               'nss'
               'nsss'
               'ntfs-3g'
               'ntp'
               'nullmailer'
               'numactl'
               'nvi'
               'nwipe'
               'nzbget'
               'oath-toolkit'
               'obfs4proxy'
               'oblibs'
               'ocaml'
               'ocaml-findlib'
               'ocamlbuild'
               'offlineimap'
               'oniguruma'
               'opam'
               'opencl2-headers'
               'opendoas'
               'openjade'
               'openldap'
               'openntpd'
               'openresolv'
               'opensmtpd'
               'opensmtpd-extras'
               'opensp'
               'openssh'
               'opentmpfiles'
               'openvpn'
               'opmsg'
               'orc'
               'orjail'
               'os-prober'
               'p0f'
               'p11-kit'
               'packer'
               'pam'
               'pam-base'
               'pandoc'
               'parted'
               'pass'
               'passphrase2pgp'
               'patch'
               'patchelf'
               'pax-utils'
               'pciutils'
               'pcre'
               'pcre2'
               'pcsclite'
               'perl'
               'perl-Algorithm-Diff'
               'perl-AnyEvent'
               'perl-Authen-SASL'
               'perl-CPAN-Meta-Check'
               'perl-Capture-Tiny'
               'perl-Class-Data-Inheritable'
               'perl-Clone'
               'perl-Convert-BinHex'
               'perl-Crypt-Rijndael'
               'perl-DBD-SQLite'
               'perl-DBD-mysql'
               'perl-DBI'
               'perl-Data-Validate-IP'
               'perl-Devel-CheckLib'
               'perl-Devel-StackTrace'
               'perl-Devel-Symdump'
               'perl-Encode-Locale'
               'perl-Exception-Class'
               'perl-File-KeePass'
               'perl-File-Next'
               'perl-File-Slurp'
               'perl-HTML-Parser'
               'perl-HTML-Tagset'
               'perl-HTTP-Daemon'
               'perl-HTTP-Date'
               'perl-HTTP-Message'
               'perl-IO-CaptureOutput'
               'perl-IO-HTML'
               'perl-IO-Socket-INET6'
               'perl-IO-Socket-SSL'
               'perl-IO-Tty'
               'perl-IO-stringy'
               'perl-IPC-Run'
               'perl-LWP-MediaTypes'
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
               'perl-Test-Fatal'
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
               'perl-Try-Tiny'
               'perl-URI'
               'perl-XML-NamespaceSupport'
               'perl-XML-Parser'
               'perl-XML-SAX'
               'perl-XML-SAX-Base'
               'peru'
               'picocom'
               'pijul'
               'pinebookpro-base'
               'pinebookpro-firmware'
               'pinebookpro-kernel'
               'pinebookpro-uboot'
               'pinentry'
               'pixman'
               'pkcs11-helper'
               'pkg-config'
               'pkgconf'
               'popt'
               'postfix'
               'postgresql'
               'ppp'
               'pps-tools'
               'privoxy'
               'procmail'
               'procps-ng'
               'procs'
               'progress'
               'proot'
               'protobuf'
               'proxychains-ng'
               'psmisc'
               'pulseaudio'
               'pv'
               'pwgen'
               'pwget'
               'pwnat'
               'python'
               'python-Babel'
               'python-BeautifulSoup4'
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
               'python-backports'
               'python-backports.configparser'
               'python-backports.functools_lru_cache'
               'python-bcrypt'
               'python-cffi'
               'python-chardet'
               'python-contextlib2'
               'python-coverage'
               'python-cram'
               'python-cryptography'
               'python-cryptography_vectors'
               'python-cssselect'
               'python-docopt'
               'python-docutils'
               'python-enum34'
               'python-flaky'
               'python-funcsigs'
               'python-futures'
               'python-greenlet'
               'python-html5lib'
               'python-hypothesis'
               'python-idna'
               'python-imagesize'
               'python-importlib_metadata'
               'python-ipaddress'
               'python-iso-8601'
               'python-lxml'
               'python-more-itertools'
               'python-msgpack'
               'python-nose'
               'python-numpy'
               'python-packaging'
               'python-paramiko'
               'python-parsing'
               'python-pathlib2'
               'python-pluggy'
               'python-ply'
               'python-pretend'
               'python-py'
               'python-pyasn1'
               'python-pycparser'
               'python-pyelftools'
               'python-pynacl'
               'python-pytest'
               'python-pytz'
               'python-requests'
               'python-rfc6555'
               'python-scandir'
               'python-selectors2'
               'python-setuptools'
               'python-six'
               'python-snowballstemmer'
               'python-soupsieve'
               'python-sphinxcontrib'
               'python-sphinxcontrib-websupport'
               'python-toml'
               'python-typing'
               'python-urllib3'
               'python-virtualenv'
               'python-wcwidth'
               'python-webencodings'
               'python-yaml'
               'python-zipp'
               'python-zope.interface'
               'python3'
               'python3-Sphinx'
               'python3-argcomplete'
               'python3-filelock'
               'python3-mock'
               'python3-more-itertools'
               'python3-neovim'
               'python3-numpy'
               'python3-pluggy'
               'python3-pytest'
               'python3-sphinxcontrib-applehelp'
               'python3-sphinxcontrib-devhelp'
               'python3-sphinxcontrib-htmlhelp'
               'python3-sphinxcontrib-jsmath'
               'python3-sphinxcontrib-qthelp'
               'python3-sphinxcontrib-serializinghtml'
               'qemu'
               'qemu-user-static'
               'qrencode'
               'quixand'
               'radvd'
               'ragel'
               'rakudo'
               'rclone'
               'readline'
               'rebar3'
               'redis'
               'rhash'
               'ripgrep'
               'rlwrap'
               'rspamd'
               'rsync'
               'rtorrent'
               'ruby'
               'ruby-hpricot'
               'ruby-mustache'
               'ruby-rdiscount'
               'ruby-ronn'
               'run-parts'
               'runc'
               'runit'
               'runit-iptables'
               'runit-nftables'
               'runit-swap'
               'runit-void'
               'rust'
               'rustup'
               's-nail'
               's6'
               's6-dns'
               's6-linux-utils'
               's6-networking'
               's6-portable-utils'
               's6-rc'
               'sandboxfs'
               'sbc'
               'sbcl'
               'scapy'
               'scdoc'
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
               'skalibs'
               'smake'
               'snappy'
               'sniproxy'
               'snooze'
               'socat'
               'socklog'
               'socklog-void'
               'sops'
               'spandsp'
               'spdx-licenses-list'
               'speex'
               'speexdsp'
               'spice'
               'spice-protocol'
               'spiped'
               'sqlite'
               'squashfs-tools'
               'squid'
               'sshguard'
               'sshuttle'
               'sslh'
               'ssss'
               'stack'
               'stegsnow'
               'strace'
               'stubby'
               'stunnel'
               'subversion'
               'sudo'
               'swig'
               'sysdig'
               'sysfsutils'
               'syslinux'
               'sysstat'
               'systemtap'
               'talloc'
               'tar'
               'tbb'
               'tcl'
               'tcpdump'
               'tcpflow'
               'tcpreplay'
               'tdb'
               'tealdeer'
               'termshark'
               'texinfo'
               'thc-hydra'
               'the_silver_searcher'
               'thin-provisioning-tools'
               'tidy5'
               'tiff'
               'tin'
               'tinyproxy'
               'tmux'
               'toggle-ht'
               'tor'
               'torsocks'
               'tox'
               'toxcore'
               'toxic'
               'traceroute'
               'tree'
               'trousers'
               'tuntox'
               'tzdata'
               'tzutils'
               'u-boot-tools'
               'udns'
               'ulogd'
               'unbound'
               'unibilium'
               'units'
               'unixodbc'
               'unzip'
               'usb-modeswitch'
               'usb-modeswitch-data'
               'usbguard'
               'usbmuxd'
               'usbredir'
               'usbutils'
               'util-linux'
               'vagrant'
               'valgrind'
               'varnish'
               'vde2'
               'vim'
               'vnstat'
               'void-artwork'
               'void-release-keys'
               'void-repo-multilib'
               'void-repo-nonfree'
               'void-updates'
               'vsv'
               'wget'
               'which'
               'whois'
               'wifi-firmware'
               'wifish'
               'wimlib'
               'wireguard-dkms'
               'wireguard-tools'
               'wireless_tools'
               'wireshark'
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
               'xmlrpc-c'
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
               'zramen'
               'zsh'
               'zsh-completions'
               'zsh-syntax-highlighting'
               'zstd'
               'zulucrypt'
               'zuluplay')

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
