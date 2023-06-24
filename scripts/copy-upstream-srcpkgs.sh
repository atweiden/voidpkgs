#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# copy-upstream-srcpkgs.sh: copy select srcpkgs from upstream
# -----------------------------------------------------------------------------

# ==============================================================================
# constants {{{

# path to this script
readonly DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# path to https://github.com/atweiden/voidpkgs
readonly ROOT_NOX="$(realpath "$DIR/..")"
# path to https://github.com/atweiden/voidpkgs/srcpkgs
readonly SRCPKGS_NOX="$ROOT_NOX/srcpkgs/"
# path to https://github.com/void-linux/void-packages
readonly ROOT_VOID="$HOME/Sandbox/void-linux/void-packages"
# path to https://github.com/void-linux/void-packages/srcpkgs
readonly SRCPKGS_VOID="$ROOT_VOID/srcpkgs/"
# select pkgs to copy
readonly PKGS=('3mux'
               '66'
               '66-tools'
               '7zip'
               'EternalTerminal'
               'ISOEnts'
               'LuaJIT'
               'MoarVM'
               'NetAuth'
               'NetAuth-ldap'
               'NetAuth-localizer'
               'NetAuth-nsscache'
               'NetAuth-pam-helper'
               'NetAuth-sftpgo-hook'
               'NetKeys'
               'StyLua'
               'abseil-cpp'
               'ack'
               'acl'
               'acpi'
               'acpid'
               'aerc'
               'age'
               'aircrack-ng'
               'alpine'
               'alsa-lib'
               'alsa-ucm-conf'
               'android-tools'
               'android-udev-rules'
               'ansible'
               'ansible-core'
               'apache'
               'apk-tools'
               'apparmor'
               'apr'
               'apr-util'
               'argon2'
               'argp-standalone'
               'aria2'
               'asciidoc'
               'atf'
               'atf-rk3399-bl31'
               'attr'
               'autoconf'
               'autoconf-archive'
               'automake'
               'b43-firmware'
               'b43-firmware-classic'
               'b43-fwcutter'
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
               'bats'
               'bats-assert'
               'bats-support'
               'bc'
               'bc-gh'
               'bcachefs-tools'
               'bcc'
               'bearssl'
               'benchmark'
               'bettercap'
               'bind'
               'binfmt-support'
               'binutils'
               'bison'
               'bitcoin'
               'black'
               'bmake'
               'boost'
               'bootiso'
               'borg'
               'boringtun'
               'botan'
               'bpfmon'
               'bpftrace'
               'broadcom-wl-dkms'
               'brotli'
               'btrfs-progs'
               'bubblewrap'
               'busybox'
               'byacc'
               'bzip2'
               'c-ares'
               'ca-certificates'
               'cabal-install'
               'calcurse'
               'capnproto'
               'cargo'
               'cargo-auditable'
               'cargo-auditable-bootstrap'
               'cargo-bootstrap'
               'cargo-crev'
               'cargo-deny'
               'cargo-edit'
               'cargo-geiger'
               'cargo-outdated'
               'cargo-update'
               'catgirl'
               'ccache'
               'ccl'
               'ccrypt'
               'cdrtools'
               'cereal'
               'cgit'
               'chathistorysync'
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
               'clisp'
               'clucene'
               'cmake'
               'cmocka'
               'cni-plugins'
               'coWPAtty'
               'coccinelle'
               'colordiff'
               'confuse'
               'conntrack-tools'
               'consul'
               'consul-template'
               'containerd'
               'coreboot-utils'
               'coreutils'
               'corkscrew'
               'cpanminus'
               'cpio'
               'cppzmq'
               'cracklib'
               'crda'
               'create_ap'
               'cronie'
               'cryfs'
               'crypto++'
               'cryptsetup'
               'ctags'
               'curl'
               'cvs'
               'cvsps2'
               'cyrus-sasl'
               'czmq'
               'daemontools'
               'dar'
               'darcs'
               'darkhttpd'
               'dash'
               'db'
               'ddclient'
               'debootstrap'
               'dejagnu'
               'delta'
               'delve'
               'dep'
               'dhcp'
               'dhcpcd'
               'di'
               'dialog'
               'diffr'
               'difftastic'
               'diffutils'
               'diskonaut'
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
               'docker-cli'
               'docker-compose'
               'dos2unix'
               'dosfstools'
               'dovecot'
               'dovecot-plugin-pigeonhole'
               'doxygen'
               'dqlite'
               'dracut'
               'dsvpn'
               'dtc'
               'duf'
               'dune'
               'dust'
               'dvd+rw-tools'
               'e2fsprogs'
               'earlyoom'
               'easyrsa'
               'ed'
               'edbrowse'
               'editline'
               'efibootmgr'
               'efitools'
               'efivar'
               'elfutils'
               'elixir'
               'elvish'
               'encfs'
               'endlessh'
               'erlang'
               'ethtool'
               'ettercap'
               'eudev'
               'exa'
               'execline'
               'execline-man-pages'
               'exfat-utils'
               'exfatprogs'
               'exiftool'
               'expat'
               'expect'
               'f2fs-tools'
               'fail2ban'
               'fake-hwclock'
               'faketime'
               'fcgi'
               'fd'
               'fdm'
               'ffcall'
               'fftw'
               'file'
               'filespooler'
               'findutils'
               'fio'
               'firejail'
               'fish-shell'
               'flac'
               'flake8'
               'flashrom'
               'flex'
               'flintlib'
               'fmt'
               'fontconfig'
               'fossil'
               'freetype'
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
               'gd'
               'gdb'
               'gdbm'
               'geoip'
               'gerbil'
               'getdns'
               'gettext'
               'gf2x'
               'gflags'
               'ghc'
               'ghc-bin'
               'giflib'
               'git'
               'git-lfs'
               'git-team'
               'git-toolbelt'
               'github-cli'
               'glibc'
               'glide'
               'glow'
               'gmp'
               'gnu-efi-libs'
               'gnulib'
               'gnupg'
               'gnupg1'
               'gnutls'
               'go'
               'go-bindata'
               'go-md2man'
               'go1.17-bootstrap'
               'gocryptfs'
               'godef'
               'golangci-lint'
               'google-authenticator-libpam'
               'gopls'
               'gops'
               'goreleaser'
               'gperf'
               'gperftools'
               'gpgme'
               'gptfdisk'
               'grep'
               'grml-rescueboot'
               'groff'
               'grpc'
               'grub'
               'grub-btrfs'
               'gsasl'
               'gtest'
               'gtk-doc'
               'guile'
               'gum'
               'gummiboot'
               'gzip'
               'h2o'
               'haproxy'
               'hashcat'
               'hashcat-utils'
               'hatch-vcs'
               'hatchling'
               'haveged'
               'hdparm'
               'help2man'
               'hitch'
               'hostapd'
               'http-parser'
               'httpie'
               'httpstat'
               'httrack'
               'hub'
               'hunspell'
               'hut'
               'hwids'
               'hwloc'
               'i2pd'
               'iana-etc'
               'icdiff'
               'icu'
               'iftop'
               'img'
               'inadyn'
               'inetutils'
               'inih'
               'intel-ucode'
               'intltool'
               'iproute2'
               'iptables'
               'iputils'
               'ipw2100-firmware'
               'ipw2200-firmware'
               'isl15'
               'isync'
               'itstool'
               'iw'
               'janet'
               'jansson'
               'jbigkit'
               'jemalloc'
               'jitterentropy'
               'jo'
               'john'
               'jp'
               'jpm'
               'jq'
               'json-c'
               'json-c++'
               'jsoncpp'
               'just'
               'kakoune'
               'kbd'
               'kcgi'
               'kernel-libc-headers'
               'keybase'
               'keyutils'
               'kmod'
               'kopia'
               'kpartx'
               'kpcli'
               'kubefwd'
               'kubernetes'
               'kubernetes-helm'
               'kyua'
               'lame'
               'lapack'
               'ldns'
               'less'
               'lfe'
               'lft'
               'libaio'
               'libaom'
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
               'libbpf'
               'libbsd'
               'libcap'
               'libcap-ng'
               'libcbor'
               'libcgroup'
               'libcli'
               'libconfig'
               'libcppunit'
               'libcpuid'
               'libdaemon'
               'libde265'
               'libdnet'
               'libedit'
               'libev'
               'libevent'
               'libexecinfo'
               'libffi'
               'libfido2'
               'libftdi1'
               'libgcc'
               'libgcrypt'
               'libgfshare'
               'libgit2'
               'libgpg-error'
               'libgssglue'
               'libheif'
               'libhugetlbfs'
               'libidn'
               'libidn2'
               'libiscsi'
               'libjpeg-turbo'
               'libkdumpfile'
               'libksba'
               'libluv'
               'liblz4'
               'liblzma'
               'libmaxminddb'
               'libmd'
               'libmicrohttpd'
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
               'libnvme'
               'libogg'
               'libpcap'
               'libpciaccess'
               'libpipeline'
               'libpng'
               'libpsl'
               'libpwquality'
               'libqb'
               'libreadline8'
               'librsync'
               'librtmp'
               'libsasl'
               'libscrypt'
               'libseccomp'
               'libselinux'
               'libsepol'
               'libsigc++'
               'libsigsegv'
               'libsmbios'
               'libsndfile'
               'libsodium'
               'libsoxr'
               'libssh'
               'libssh2'
               'libtasn1'
               'libtermkey'
               'libtirpc'
               'libtls'
               'libtommath'
               'libtool'
               'libtorrent'
               'libucontext'
               'libunistring'
               'libunwind'
               'liburcu'
               'liburing'
               'libusb'
               'libusb-compat'
               'libutempter'
               'libuv'
               'libvorbis'
               'libvterm'
               'libwebp'
               'libxml2'
               'libxslt'
               'libyaml'
               'libzip'
               'libzstd'
               'linux'
               'linux-base'
               'linux-firmware'
               'linux-lts'
               'linux-mainline'
               'linux5.15'
               'linux6.1'
               'linux6.3'
               'litterbox'
               'llhttp'
               'llvm'
               'llvm12'
               'llvm15'
               'lm_sensors'
               'logrotate'
               'logswan'
               'lowdown'
               'lsof'
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
               'lua54-zlib'
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
               'mandown'
               'mariadb'
               'maturin'
               'mbedtls'
               'mblaze'
               'mcelog'
               'mdBook'
               'mdadm'
               'mdocml'
               'memcached'
               'memtest86+'
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
               'mitmproxy'
               'mkinitcpio'
               'mlocate'
               'mobile-broadband-provider-info'
               'moby'
               'monero'
               'monit'
               'moreutils'
               'mosh'
               'mpfr'
               'mpg123'
               'mpop'
               'msgpack'
               'msmtp'
               'mtd-utils'
               'mtools'
               'musl'
               'musl-bootstrap'
               'musl-fts'
               'musl-legacy-compat'
               'musl-obstack'
               'mutt'
               'myrepos'
               'mytop'
               'nasm'
               'ncdu'
               'ncdu2'
               'ncspot'
               'ncurses'
               'ndpi'
               'neovim'
               'nerdctl'
               'net-snmp'
               'net-tools'
               'netcat'
               'nethogs'
               'netsniff-ng'
               'nettle'
               'newt'
               'nfs-utils'
               'nftables'
               'nghttp2'
               'nginx'
               'ngrep'
               'nilfs-utils'
               'nim'
               'ninja'
               'nix'
               'nkf'
               'nmap'
               'nncp'
               'nodejs'
               'nomad'
               'npth'
               'nqp'
               'nsd'
               'nsjail'
               'nspr'
               'nss'
               'nsss'
               'ntfs-3g'
               'ntl'
               'ntp'
               'nullmailer'
               'numactl'
               'nvi'
               'nvme-cli'
               'nwipe'
               'nyx'
               'nzbget'
               'oath-toolkit'
               'obfs4proxy'
               'oblibs'
               'ocaml'
               'ocaml-findlib'
               'ocaml-num'
               'ocaml-stdcompat'
               'ocamlbuild'
               'offlineimap'
               'oniguruma'
               'opam'
               'openblas'
               'opencl2-headers'
               'opendoas'
               'openjade'
               'openldap'
               'openmpi'
               'openntpd'
               'openpgp-ca'
               'openresolv'
               'opensmtpd'
               'opensmtpd-extras'
               'opensp'
               'openssh'
               'openssl'
               'opentmpfiles'
               'openvpn'
               'opmsg'
               'opus'
               'oragono'
               'orc'
               'orjail'
               'os-prober'
               'ouch'
               'outils'
               'p0f'
               'p11-kit'
               'packer'
               'pahole'
               'pam'
               'pam-base'
               'pam_netauth'
               'pandoc'
               'parallel'
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
               'perl-Business-ISBN'
               'perl-Business-ISBN-Data'
               'perl-CGI'
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
               'perl-Digest-HMAC'
               'perl-Encode-Locale'
               'perl-Exception-Class'
               'perl-ExtUtils-Config'
               'perl-ExtUtils-Helpers'
               'perl-ExtUtils-InstallPaths'
               'perl-ExtUtils-PkgConfig'
               'perl-FCGI'
               'perl-File-KeePass'
               'perl-File-Next'
               'perl-File-Slurp'
               'perl-GD'
               'perl-HTML-Parser'
               'perl-HTML-Tagset'
               'perl-HTTP-Daemon'
               'perl-HTTP-Date'
               'perl-HTTP-Headers-Fast'
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
               'perl-Path-Tiny'
               'perl-Pod-Coverage'
               'perl-Scope-Guard'
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
               'perl-Test-SharedFork'
               'perl-Test-TCP'
               'perl-Test-Warn'
               'perl-Test-Warnings'
               'perl-Text-Diff'
               'perl-Time-Duration'
               'perl-TimeDate'
               'perl-Try-Tiny'
               'perl-URI'
               'perl-XML-NamespaceSupport'
               'perl-XML-Parser'
               'perl-XML-SAX'
               'perl-XML-SAX-Base'
               'perl-b-cow'
               'perltidy'
               'peru'
               'picocom'
               'pijul'
               'pinebookpro-base'
               'pinebookpro-firmware'
               'pinebookpro-kernel'
               'pinebookpro-uboot'
               'pinentry'
               'pipectl'
               'pkcs11-helper'
               'pkg-config'
               'pkgconf'
               'plocate'
               'pmbootstrap'
               'popt'
               'postfix'
               'postgresql'
               'postgresql14'
               'postgresql15'
               'pounce'
               'ppp'
               'pppconfig'
               'pps-tools'
               'privoxy'
               'procmail'
               'procps-ng'
               'procs'
               'progress'
               'proot'
               'prose'
               'protobuf'
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
               'python3'
               'python3-Arpeggio'
               'python3-Babel'
               'python3-BeautifulSoup4'
               'python3-Brotli'
               'python3-Cython'
               'python3-Flask'
               'python3-Jinja2'
               'python3-M2Crypto'
               'python3-Mako'
               'python3-MarkupSafe'
               'python3-PyHamcrest'
               'python3-Pygments'
               'python3-SecretStorage'
               'python3-Sphinx'
               'python3-Twisted'
               'python3-Unidecode'
               'python3-Werkzeug'
               'python3-aiohttp'
               'python3-alabaster'
               'python3-anytree'
               'python3-appdirs'
               'python3-argcomplete'
               'python3-argon2'
               'python3-asgiref'
               'python3-async_generator'
               'python3-async-timeout'
               'python3-attrs'
               'python3-automat'
               'python3-bcrypt'
               'python3-betamax'
               'python3-blinker'
               'python3-bottle'
               'python3-build'
               'python3-calver'
               'python3-certifi'
               'python3-cffi'
               'python3-chardet'
               'python3-charset-normalizer'
               'python3-click'
               'python3-colorama'
               'python3-commonmark'
               'python3-constantly'
               'python3-cram'
               'python3-cryptography'
               'python3-cryptography_vectors'
               'python3-cssselect'
               'python3-curio'
               'python3-curl'
               'python3-dateutil'
               'python3-decorator'
               'python3-defusedxml'
               'python3-distlib'
               'python3-distro'
               'python3-docopt'
               'python3-docutils'
               'python3-drgn'
               'python3-editables'
               'python3-elementpath'
               'python3-execnet'
               'python3-fido2'
               'python3-fields'
               'python3-filelock'
               'python3-flaky'
               'python3-flit_core'
               'python3-freezegun'
               'python3-future'
               'python3-greenlet'
               'python3-h11'
               'python3-h2'
               'python3-hpack'
               'python3-html5lib'
               'python3-httpbin'
               'python3-httplib2'
               'python3-hyperframe'
               'python3-hyperlink'
               'python3-hypothesis'
               'python3-idna'
               'python3-imagesize'
               'python3-imaplib2'
               'python3-importlib_metadata'
               'python3-incremental'
               'python3-iniconfig'
               'python3-installer'
               'python3-iso8601'
               'python3-itsdangerous'
               'python3-jaraco.classes'
               'python3-jeepney'
               'python3-kaitaistruct'
               'python3-keyring'
               'python3-ldap3'
               'python3-makefun'
               'python3-markdown-it'
               'python3-mccabe'
               'python3-mdurl'
               'python3-mitmproxy_wireguard'
               'python3-mock'
               'python3-more-itertools'
               'python3-msgpack'
               'python3-multidict'
               'python3-mypy'
               'python3-mypy_extensions'
               'python3-neovim'
               'python3-nose'
               'python3-numpy'
               'python3-openssl'
               'python3-outcome'
               'python3-packaging'
               'python3-pandas'
               'python3-parameterized'
               'python3-paramiko'
               'python3-parsing'
               'python3-parver'
               'python3-passlib'
               'python3-pathlib2'
               'python3-pathspec'
               'python3-pexpect'
               'python3-pip'
               'python3-pkgconfig'
               'python3-platformdirs'
               'python3-pluggy'
               'python3-ply'
               'python3-poetry-core'
               'python3-pretend'
               'python3-priority'
               'python3-process-tests'
               'python3-protobuf'
               'python3-psutil'
               'python3-ptyprocess'
               'python3-publicsuffix2'
               'python3-py'
               'python3-py-cpuinfo'
               'python3-pyasn1'
               'python3-pyasn1-modules'
               'python3-pycares'
               'python3-pycodestyle'
               'python3-pycparser'
               'python3-pyelftools'
               'python3-pyflakes'
               'python3-pyfuse3'
               'python3-pynacl'
               'python3-pyperclip'
               'python3-pyproject-hooks'
               'python3-pyrsistent'
               'python3-pyscard'
               'python3-pysocks'
               'python3-pytest'
               'python3-pytest-asyncio'
               'python3-pytest-benchmark'
               'python3-pytest-cov'
               'python3-pytest-forked'
               'python3-pytest-httpbin'
               'python3-pytest-mock'
               'python3-pytest-subtests'
               'python3-pytest-timeout'
               'python3-pytest-trio'
               'python3-pytest-xdist'
               'python3-pytz'
               'python3-pyzmq'
               'python3-raven'
               'python3-recommonmark'
               'python3-requests'
               'python3-requests-toolbelt'
               'python3-resolvelib'
               'python3-rfc6555'
               'python3-rich'
               'python3-ruamel.yaml'
               'python3-ruamel.yaml.clib'
               'python3-semanticversion'
               'python3-service_identity'
               'python3-setuptools'
               'python3-setuptools-rust'
               'python3-setuptools_scm'
               'python3-simplejson'
               'python3-six'
               'python3-sniffio'
               'python3-snowballstemmer'
               'python3-sortedcontainers'
               'python3-soupsieve'
               'python3-sphinx-automodapi'
               'python3-sphinxcontrib'
               'python3-sphinxcontrib-applehelp'
               'python3-sphinxcontrib-devhelp'
               'python3-sphinxcontrib-htmlhelp'
               'python3-sphinxcontrib-jsmath'
               'python3-sphinxcontrib-qthelp'
               'python3-sphinxcontrib-serializinghtml'
               'python3-stem'
               'python3-straight.plugin'
               'python3-testpath'
               'python3-tokenize-rt'
               'python3-tomli'
               'python3-tornado'
               'python3-trio'
               'python3-trove-classifiers'
               'python3-trustme'
               'python3-typing_extensions'
               'python3-unittest-mixins'
               'python3-urllib3'
               'python3-urwid'
               'python3-uvloop'
               'python3-versioneer'
               'python3-virtualenv'
               'python3-wcwidth'
               'python3-webencodings'
               'python3-wheel'
               'python3-wsproto'
               'python3-xmlschema'
               'python3-yaml'
               'python3-yarl'
               'python3-zipp'
               'python3-zope.interface'
               'python3-zstandard'
               'qrcp'
               'qrencode'
               'quickjs'
               'quixand'
               'quota'
               'radvd'
               'raft'
               'rakudo'
               'rbenv'
               'rclone'
               'rdrview'
               're2'
               'readline'
               'rebar3'
               'redis'
               'reiserfsprogs'
               'removed-packages'
               'rhash'
               'ripgrep'
               'rlwrap'
               'rpcbind'
               'rpcsvc-proto'
               'rpm'
               'rpmextract'
               'rr'
               'rsync'
               'rtmpdump'
               'rtorrent'
               'ruby'
               'ruby-asciidoctor'
               'ruby-build'
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
               'rust-analyzer'
               'rust-audit-info'
               'rust-bindgen'
               'rust-bootstrap'
               'rust-cargo-audit'
               'rust-cargo-bloat'
               'rust-sccache'
               'rustup'
               'rusty-diceware'
               's-nail'
               's6'
               's6-dns'
               's6-linux-utils'
               's6-man-pages'
               's6-networking'
               's6-networking-man-pages'
               's6-portable-utils'
               's6-portable-utils-man-pages'
               's6-rc'
               'sandboxfs'
               'sbcl'
               'scapy'
               'scdoc'
               'schilytools'
               'scons'
               'scooper'
               'screen'
               'scrypt'
               'sed'
               'sedutil'
               'senpai'
               'serf'
               'sftpgo'
               'shadow'
               'shadowsocks-libev'
               'shellcheck'
               'sift'
               'signify'
               'sipcalc'
               'skalibs'
               'slang'
               'smake'
               'smartmontools'
               'snappy'
               'sniproxy'
               'snooze'
               'so'
               'socat'
               'socklog'
               'socklog-void'
               'softhsm'
               'soju'
               'sops'
               'spdlog'
               'spdx-licenses-list'
               'spectre-meltdown-checker'
               'speex'
               'speexdsp'
               'spiped'
               'sqlite'
               'squashfs-tools'
               'squid'
               'sshguard'
               'sshuttle'
               'sslh'
               'sslscan'
               'sss-cli'
               'ssss'
               'stack'
               'stegsnow'
               'step-certificates'
               'step-cli'
               'strace'
               'stubby'
               'stunnel'
               'subversion'
               'sudo'
               'superd'
               'swig'
               'syncthing'
               'sysdig'
               'sysfsutils'
               'syslinux'
               'sysstat'
               'systemtap'
               'talloc'
               'taplo'
               'tar'
               'tbb'
               'tc-play'
               'tcl'
               'tcpdump'
               'tcpflow'
               'tcpreplay'
               'tdb'
               'tealdeer'
               'terraform'
               'testssl.sh'
               'texinfo'
               'thc-hydra'
               'the_silver_searcher'
               'thin-provisioning-tools'
               'tiff'
               'tin'
               'tini'
               'tinyproxy'
               'tio'
               'tlp'
               'tmux'
               'toggle-ht'
               'tokei'
               'toot'
               'tor'
               'torsocks'
               'tox'
               'toxcore'
               'toxic'
               'traceroute'
               'transmission'
               'tre'
               'tree'
               'tree-sitter'
               'trousers'
               'tuntox'
               'typst'
               'tzutils'
               'u-boot-menu'
               'u-boot-tools'
               'uacme'
               'ucspi-tcp'
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
               'usbutils'
               'usql'
               'util-linux'
               'util-linux-common'
               'uwsgi'
               'vagrant'
               'valgrind'
               'varnish'
               'vault'
               'vde2'
               'vim'
               'vnstat'
               'void-artwork'
               'void-release-keys'
               'void-repo-bootstrap'
               'void-repo-multilib'
               'void-repo-nonfree'
               'void-updates'
               'vsv'
               'w3m'
               'watchexec'
               'websocat'
               'wendy'
               'wget'
               'which'
               'whois'
               'wifi-firmware'
               'wifish'
               'wimlib'
               'wireguard-dkms'
               'wireguard-tools'
               'wireless_tools'
               'wireproxy'
               'wpa_actiond'
               'wpa_supplicant'
               'wvdial'
               'wvstreams'
               'x265'
               'xbps'
               'xbps-static'
               'xbps-triggers'
               'xdelta3'
               'xfsdump'
               'xfsprogs'
               'xinetd'
               'xmandump'
               'xmlcatmgr'
               'xmlrpc-c'
               'xmlto'
               'xmltoman'
               'xorriso'
               'xmirror'
               'xtools'
               'xxHash'
               'xz'
               'yarn'
               'yarn-bin'
               'yascreen'
               'yasm'
               'yubikey-manager'
               'zd1211-firmware'
               'zellij'
               'zeromq'
               'zfs'
               'zig'
               'zip'
               'zlib'
               'zls'
               'zps'
               'zramen'
               'zsh'
               'zsh-completions'
               'zsh-syntax-highlighting'
               'zstd'
               'zulucrypt')

# end constants }}}
# ==============================================================================

main() {
  for _pkg in "${PKGS[@]}"; do
    _dir="$SRCPKGS_VOID/$_pkg"
    echo "Copying $_dir..."
    if [[ -d "$_dir" ]]; then
      cp -a "$_dir" "$SRCPKGS_NOX"
    else
      echo "not found"
      exit 1
    fi
  done
}

main

# vim: set filetype=sh foldmethod=marker foldlevel=0:
