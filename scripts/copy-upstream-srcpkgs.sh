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
readonly PKGS=('3mux'
               '66'
               '66-tools'
               'ISOEnts'
               'LuaJIT'
               'MoarVM'
               'NetAuth'
               'NetAuth-localizer'
               'NetAuth-nsscache'
               'NetKeys'
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
               'android-udev-rules'
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
               'bandwhich'
               'base-chroot'
               'base-devel'
               'base-files'
               'base-minimal'
               'base-system'
               'base-voidstrap'
               'bash'
               'bash-completion'
               'bat'
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
               'borg'
               'boringtun'
               'bpftrace'
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
               'chez-scheme'
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
               'consul'
               'consul-template'
               'containerd'
               'coreboot-utils'
               'coreutils'
               'corkscrew'
               'cpio'
               'cracklib'
               'crda'
               'create_ap'
               'cronie'
               'cryfs'
               'crypto++'
               'cryptsetup'
               'curl'
               'cvs'
               'cvsps2'
               'cyrus-sasl'
               'dar'
               'darcs'
               'darkhttpd'
               'dash'
               'db'
               'ddclient'
               'dejagnu'
               'delta'
               'delve'
               'dep'
               'dhcp'
               'dhcpcd'
               'di'
               'dialog'
               'diffr'
               'diffutils'
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
               'dqlite'
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
               'efitools'
               'efivar'
               'elfutils'
               'elixir'
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
               'fscrypt'
               'fuse'
               'fuse3'
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
               'git-toolbelt'
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
               'google-authenticator-libpam'
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
               'hitch'
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
               'isl15'
               'isync'
               'iw'
               'janet'
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
               'keyutils'
               'kmod'
               'kpartx'
               'kpcli'
               'kyua'
               'lapack'
               'ldns'
               'less'
               'lfe'
               'lft'
               'libaio'
               'libarchive'
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
               'libcap'
               'libcap-ng'
               'libcbor'
               'libcli'
               'libco'
               'libconfig'
               'libcppunit'
               'libdaemon'
               'libdnet'
               'libedit'
               'libev'
               'libevent'
               'libexecinfo'
               'libffi'
               'libfido2'
               'libgcc'
               'libgcrypt'
               'libgfshare'
               'libgit2'
               'libgpg-error'
               'libgssglue'
               'libidn'
               'libidn2'
               'libiscsi'
               'libksba'
               'libluv'
               'liblz4'
               'liblzma'
               'libmaxminddb'
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
               'libpcap'
               'libpipeline'
               'libpng'
               'libpsl'
               'libpwquality'
               'libqb'
               'libreadline8'
               'libressl'
               'librsync'
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
               'llvm10'
               'lm_sensors'
               'logrotate'
               'logswan'
               'lowdown'
               'ltrace'
               'lttng-modules-dkms'
               'lttng-tools'
               'lttng-ust'
               'lua51'
               'lua51-mpack'
               'lua52'
               'lua52-BitOp'
               'lua53'
               'lua54'
               'lua54-lpeg'
               'luarocks-lua53'
               'lutok'
               'lvm2'
               'lxc'
               'lxd'
               'lynx'
               'lz4'
               'lzip'
               'lzo'
               'm4'
               'make'
               'make-ca'
               'man-db'
               'man-pages'
               'man-pages-posix'
               'mariadb'
               'mbedtls'
               'mblaze'
               'mcelog'
               'mdadm'
               'mdocml'
               'memcached'
               'mercurial'
               'meson'
               'mime-types'
               'minicom'
               'minijail'
               'minimodem'
               'minisign'
               'miniupnpc'
               'mit-krb5'
               'mlocate'
               'mobile-broadband-provider-info'
               'moreutils'
               'mosh'
               'mpfr'
               'mpop'
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
               'nasm-doc'
               'ncdu'
               'ncurses'
               'ndpi'
               'neovim'
               'net-snmp'
               'net-tools'
               'nethogs'
               'netsniff-ng'
               'nettle'
               'nfs-utils'
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
               'nomad'
               'npth'
               'nqp'
               'nsd'
               'nspr'
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
               'oragono'
               'orc'
               'orjail'
               'os-prober'
               'outils'
               'p0f'
               'p11-kit'
               'packer'
               'pam'
               'pam-base'
               'pam_netauth'
               'pandoc'
               'parted'
               'pass'
               'passphrase2pgp'
               'patch'
               'patchelf'
               'pax'
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
               'perl-ExtUtils-Config'
               'perl-ExtUtils-Helpers'
               'perl-ExtUtils-InstallPaths'
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
               'perl-Module-Build-Tiny'
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
               'pkcs11-helper'
               'pkg-config'
               'pkgconf'
               'popt'
               'postfix'
               'postgresql'
               'postgresql12'
               'ppp'
               'pps-tools'
               'privoxy'
               'procmail'
               'procps-ng'
               'procs'
               'progress'
               'proot'
               'protobuf'
               'protobuf23'
               'proxychains-ng'
               'psmisc'
               'pueue'
               'pulseaudio'
               'pv'
               'pwgen'
               'pwget'
               'pwnat'
               'py3c'
               'python'
               'python-Babel'
               'python-BeautifulSoup4'
               'python-Cython'
               'python-Jinja2'
               'python-M2Crypto'
               'python-MarkupSafe'
               'python-Pygments'
               'python-Unidecode'
               'python-alabaster'
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
               'python-llfuse'
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
               'python3-elementpath'
               'python3-filelock'
               'python3-mock'
               'python3-more-itertools'
               'python3-neovim'
               'python3-numpy'
               'python3-pluggy'
               'python3-pytest'
               'python3-setuptools'
               'python3-sphinxcontrib'
               'python3-sphinxcontrib-applehelp'
               'python3-sphinxcontrib-devhelp'
               'python3-sphinxcontrib-htmlhelp'
               'python3-sphinxcontrib-jsmath'
               'python3-sphinxcontrib-qthelp'
               'python3-sphinxcontrib-serializinghtml'
               'python3-sphinxcontrib-websupport'
               'python3-xmlschema'
               'qrencode'
               'quixand'
               'radvd'
               'raft'
               'rakudo'
               'rclone'
               'readline'
               'rebar3'
               'redis'
               'rhash'
               'ripgrep'
               'rlwrap'
               'rpcbind'
               'rpcsvc-proto'
               'rsync'
               'rtorrent'
               'ruby'
               'ruby-asciidoctor'
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
               'sbcl'
               'scapy'
               'scdoc'
               'schilytools'
               'scons'
               'screen'
               'scrypt'
               'sed'
               'serf'
               'shadow'
               'shadowsocks-libev'
               'shellcheck'
               'sift'
               'sipcalc'
               'skalibs'
               'smake'
               'snappy'
               'sniproxy'
               'snooze'
               'so'
               'socat'
               'socklog'
               'socklog-void'
               'sops'
               'spdx-licenses-list'
               'speex'
               'speexdsp'
               'spiped'
               'sqlite'
               'sqlite-replication'
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
               'tc-play'
               'tcl'
               'tcpdump'
               'tcpflow'
               'tcpreplay'
               'tdb'
               'tealdeer'
               'termshark'
               'terraform'
               'testssl.sh'
               'texinfo'
               'thc-hydra'
               'the_silver_searcher'
               'thin-provisioning-tools'
               'tidy5'
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
               'transmission'
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
               'usbredir'
               'usbutils'
               'util-linux'
               'util-linux-libs'
               'vagrant'
               'valgrind'
               'varnish'
               'vault'
               'vde2'
               'vim'
               'vnstat'
               'void-artwork'
               'void-release-keys'
               'void-repo-multilib'
               'void-repo-nonfree'
               'void-updates'
               'vsv'
               'websocat'
               'wget'
               'which'
               'whois'
               'wifi-firmware'
               'wifish'
               'wimlib'
               'wireguard-dkms'
               'wireguard-tools'
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
               'xmlrpc-c'
               'xmlto'
               'xmltoman'
               'xtools'
               'xxHash'
               'xz'
               'yarn'
               'yarn-bin'
               'zd1211-firmware'
               'zeromq'
               'zig'
               'zip'
               'zlib'
               'znc'
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
