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
               'ISOEnts'
               'LuaJIT'
               'MoarVM'
               'NetAuth'
               'NetAuth-ldap'
               'NetAuth-localizer'
               'NetAuth-nsscache'
               'NetAuth-pam-helper'
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
               'bearssl'
               'benchmark'
               'bettercap'
               'bind'
               'binfmt-support'
               'binutils'
               'bison'
               'bitcoin'
               'black'
               'boost'
               'bootiso'
               'borg'
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
               'cargo-bootstrap'
               'catgirl'
               'ccache'
               'ccl'
               'ccrypt'
               'cdrtools'
               'cereal'
               'cgit'
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
               'coccinelle'
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
               'cppzmq'
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
               'czmq'
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
               'dvd+rw-tools'
               'e2fsprogs'
               'earlyoom'
               'easyrsa'
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
               'execline-man-pages'
               'exfat-utils'
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
               'findutils'
               'firejail'
               'fish-shell'
               'flac'
               'flake8'
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
               'getmail'
               'gettext'
               'gf2x'
               'ghc'
               'ghc-bin'
               'giflib'
               'git'
               'git-lfs'
               'git-team'
               'git-toolbelt'
               'glibc'
               'glide'
               'gmp'
               'gnu-efi-libs'
               'gnupg'
               'gnupg1'
               'gnutls'
               'go'
               'go-bindata'
               'go-md2man'
               'go1.12-bootstrap'
               'gocryptfs'
               'golangci-lint'
               'google-authenticator-libpam'
               'gopls'
               'goreleaser'
               'gperf'
               'gperftools'
               'gpgme'
               'gptfdisk'
               'grep'
               'groff'
               'grpc'
               'grub'
               'grub-btrfs'
               'gsasl'
               'gtest'
               'guile'
               'gummiboot'
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
               'iw'
               'janet'
               'jbigkit'
               'jansson'
               'jemalloc'
               'john'
               'jp'
               'jpm'
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
               'kopia'
               'kpartx'
               'kpcli'
               'kyua'
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
               'libcap'
               'libcap-ng'
               'libcbor'
               'libcli'
               'libconfig'
               'libcppunit'
               'libdaemon'
               'libde265'
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
               'libheif'
               'libiberty-devel'
               'libidn'
               'libidn2'
               'libiscsi'
               'libjpeg-turbo'
               'libksba'
               'libluv'
               'liblz4'
               'liblzma'
               'libmaxminddb'
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
               'libogg'
               'libpcap'
               'libpipeline'
               'libpng'
               'libpsl'
               'libpwquality'
               'libqb'
               'libreadline8'
               'librsync'
               'librtmp'
               'libsasl'
               'libseccomp'
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
               'libusb'
               'libusb-compat'
               'libutempter'
               'libuv'
               'libvorbis'
               'libvterm'
               'libwebp'
               'libxml2'
               'libxml2-python'
               'libxslt'
               'libyaml'
               'libzstd'
               'linux'
               'linux-base'
               'linux-firmware'
               'linux-lts'
               'linux5.10'
               'linux5.15'
               'llhttp'
               'llvm'
               'llvm12'
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
               'minizip'
               'mit-krb5'
               'mlocate'
               'mobile-broadband-provider-info'
               'moreutils'
               'mosh'
               'mpfr'
               'moby'
               'monero'
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
               'mytop'
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
               'nomad'
               'npth'
               'nqp'
               'nsd'
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
               'openntpd'
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
               'outils'
               'p0f'
               'p11-kit'
               'packer'
               'pahole'
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
               'perl-b-cow'
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
               'plocate'
               'popt'
               'postfix'
               'postgresql'
               'postgresql13'
               'postgresql14'
               'pounce'
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
               'pueue'
               'pulseaudio'
               'pv'
               'pwgen'
               'pwget'
               'pwnat'
               'py3c'
               'python'
               'python-Babel'
               'python-Cython'
               'python-Jinja2'
               'python-M2Crypto'
               'python-MarkupSafe'
               'python-Pygments'
               'python-atomicwrites'
               'python-attrs'
               'python-backports'
               'python-backports.configparser'
               'python-backports.functools_lru_cache'
               'python-cffi'
               'python-chardet'
               'python-contextlib2'
               'python-coverage'
               'python-cram'
               'python-cryptography'
               'python-cryptography_vectors'
               'python-dateutil'
               'python-enum34'
               'python-funcsigs'
               'python-hypothesis'
               'python-idna'
               'python-importlib_metadata'
               'python-ipaddress'
               'python-lxml'
               'python-more-itertools'
               'python-numpy'
               'python-openssl'
               'python-packaging'
               'python-parsing'
               'python-pathlib2'
               'python-pip'
               'python-pluggy'
               'python-ply'
               'python-pretend'
               'python-py'
               'python-pyasn1'
               'python-pyasn1-modules'
               'python-pycparser'
               'python-pytest'
               'python-pytz'
               'python-rfc6555'
               'python-scandir'
               'python-selectors2'
               'python-service_identity'
               'python-setuptools'
               'python-six'
               'python-typing'
               'python-urllib3'
               'python-wcwidth'
               'python-zipp'
               'python-zope.interface'
               'python3'
               'python3-BeautifulSoup4'
               'python3-Brotli'
               'python3-Flask'
               'python3-Jinja2'
               'python3-MarkupSafe'
               'python3-Pygments'
               'python3-Sphinx'
               'python3-Unidecode'
               'python3-Werkzeug'
               'python3-aiohttp'
               'python3-aiohttp-cors'
               'python3-alabaster'
               'python3-appdirs'
               'python3-argcomplete'
               'python3-async-timeout'
               'python3-bcrypt'
               'python3-blinker'
               'python3-charset-normalizer'
               'python3-click'
               'python3-cryptography'
               'python3-cryptography_vectors'
               'python3-cssselect'
               'python3-decorator'
               'python3-defusedxml'
               'python3-distlib'
               'python3-docopt'
               'python3-docutils'
               'python3-elementpath'
               'python3-filelock'
               'python3-flaky'
               'python3-flit_core'
               'python3-freezegun'
               'python3-greenlet'
               'python3-html5lib'
               'python3-httpbin'
               'python3-hypothesis'
               'python3-idna'
               'python3-imagesize'
               'python3-iniconfig'
               'python3-iso8601'
               'python3-itsdangerous'
               'python3-llfuse'
               'python3-mccabe'
               'python3-mock'
               'python3-more-itertools'
               'python3-msgpack'
               'python3-multidict'
               'python3-mypy'
               'python3-mypy_extensions'
               'python3-neovim'
               'python3-nose'
               'python3-numpy'
               'python3-packaging'
               'python3-parameterized'
               'python3-paramiko'
               'python3-pathspec'
               'python3-pexpect'
               'python3-pip'
               'python3-platformdirs'
               'python3-pluggy'
               'python3-psutil'
               'python3-ptyprocess'
               'python3-py'
               'python3-pycodestyle'
               'python3-pyelftools'
               'python3-pyflakes'
               'python3-pynacl'
               'python3-pysocks'
               'python3-pytest'
               'python3-pytest-asyncio'
               'python3-pytest-mock'
               'python3-pytest-subtests'
               'python3-raven'
               'python3-regex'
               'python3-requests'
               'python3-requests-toolbelt'
               'python3-resolvelib'
               'python3-semanticversion'
               'python3-setuptools'
               'python3-setuptools-rust'
               'python3-setuptools_scm'
               'python3-simplejson'
               'python3-snowballstemmer'
               'python3-sortedcontainers'
               'python3-soupsieve'
               'python3-sphinxcontrib'
               'python3-sphinxcontrib-applehelp'
               'python3-sphinxcontrib-devhelp'
               'python3-sphinxcontrib-htmlhelp'
               'python3-sphinxcontrib-jsmath'
               'python3-sphinxcontrib-qthelp'
               'python3-sphinxcontrib-serializinghtml'
               'python3-testpath'
               'python3-tokenize-rt'
               'python3-toml'
               'python3-tomli'
               'python3-trustme'
               'python3-typed-ast'
               'python3-typing_extensions'
               'python3-virtualenv'
               'python3-webencodings'
               'python3-wheel'
               'python3-xmlschema'
               'python3-yaml'
               'python3-yarl'
               'qrencode'
               'quickjs'
               'quixand'
               'radvd'
               'raft'
               'rakudo'
               'rbenv'
               'rclone'
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
               'rsync'
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
               'rust-bootstrap'
               'rustup'
               's-nail'
               's6'
               's6-dns'
               's6-linux-utils'
               's6-man-pages'
               's6-networking'
               's6-networking-man-pages'
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
               'spdlog'
               'spdx-licenses-list'
               'speex'
               'speexdsp'
               'spiped'
               'sqlite'
               'squashfs-tools'
               'squid'
               'sshguard'
               'sshuttle'
               'sslh'
               'sss-cli'
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
               'tiff'
               'tin'
               'tini'
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
               'tree-sitter'
               'trousers'
               'tuntox'
               'tzdata'
               'tzutils'
               'u-boot-menu'
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
               'util-linux-common'
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
               'wpa_actiond'
               'wpa_supplicant'
               'wvdial'
               'wvstreams'
               'x265'
               'xbps'
               'xbps-static'
               'xbps-triggers'
               'xdelta3'
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
               'yasm'
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
