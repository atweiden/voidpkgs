voidpkgs
========

Package templates for Void

Usage
-----

### Building libbitcoin

```sh
xbps-install xtools
_dir_voidpkgs="$HOME/.src/voidpkgs"
git clone https://github.com/atweiden/voidpkgs "$_dir_voidpkgs"
git clone https://github.com/void-linux/void-packages --depth 100
cd void-packages
_pkgs=('libsecp256k1'
       'libbitcoin-system'
       'libbitcoin-consensus'
       'libbitcoin-protocol'
       'libbitcoin-client'
       'libbitcoin-network'
       'libbitcoin-explorer'
       'libbitcoin-database'
       'libbitcoin-blockchain'
       'libbitcoin-node'
       'libbitcoin-server')
for _pkg in "${_pkgs[@]}"; do
  cp -R "$_dir_voidpkgs/$_pkg" srcpkgs
  ln -sr "srcpkgs/$_pkg" "srcpkgs/$_pkg-devel"
done
./xbps-src pkg libbitcoin-explorer
./xbps-src pkg libbitcoin-server
xi libbitcoin-explorer libbitcoin-server
```


Licensing
---------

This is free and unencumbered public domain software. For more
information, see http://unlicense.org/ or the accompanying UNLICENSE file.
