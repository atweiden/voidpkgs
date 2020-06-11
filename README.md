voidpkgs
========

Console-only XBPS source package collection for Void


Description
-----------

A fork of [void-linux/void-packages][void-linux/void-packages] with GUI
support removed from [srcpkgs][srcpkgs]. Also removes [glib][glib] and
cross-compilation support. Templates adhere to my [style guide][style
guide].


Usage
-----

Fetch voidpkgs:

```sh
git clone https://github.com/atweiden/voidpkgs
cd voidpkgs
```

Bootstrap native libc architecture without remote repositories:

```sh
./xbps-src -o gnatboot -N bootstrap
./xbps-src -N pkg base-system
```

Bootstrap cross-compiled musl architecture without remote repositories:

```sh
_arch=$(uname -m)
./xbps-src -N pkg cross-$_arch-linux-musl
./xbps-src -N -a $_arch-musl pkg base-chroot-musl
XBPS_TARGET_ARCH=$_arch-musl xbps-rindex -a hostdir/binpkgs/*
./xbps-src -N bootstrap -m masterdir-$_arch-musl $_arch-musl
```

Bootstrap 32-bit architecture without remote repositories:

```sh
./xbps-src -N -m masterdir-i686 bootstrap i686
```

Install pkg easily with xtools/xi:

```sh
./xbps-src -N pkg xtools
xbps-install --repository=hostdir/binpkgs xtools
xi xtools
```

Ignore upstream repo pkg updates:

```sh
xbps-pkgdb -m hold xtools
```

Fetch pkg sources:

```sh
./xbps-src -I fetch xtools
```


Licensing
---------

This is free and unencumbered public domain software. For more
information, see http://unlicense.org/ or the accompanying UNLICENSE file.

All unmodified works retained from [upstream][void-linux/void-packages]
are made available under the terms of the [original license][original
license].


[glib]: https://wiki.gnome.org/Projects/GLib
[original license]: doc/COPYING.xtraeme
[srcpkgs]: srcpkgs/
[style guide]: doc/STYLE.md
[void-linux/void-packages]: https://github.com/void-linux/void-packages
