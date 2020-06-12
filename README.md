voidpkgs
========

Console-only XBPS source package collection for Void


Description
-----------

A fork of [void-linux/void-packages][void-linux/void-packages] with GUI
support removed from [srcpkgs][srcpkgs]. Also removes [dbus][dbus],
[glib][glib] and cross-compilation support. Templates adhere to my
[style guide][style guide].


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

Ignore upstream repo pkg updates:

```sh
xbps-pkgdb -m hold fd
```

Fetch pkg sources:

```sh
./xbps-src -I fetch fd
```


Licensing
---------

This is free and unencumbered public domain software. For more
information, see http://unlicense.org/ or the accompanying UNLICENSE file.

All unmodified works retained from [upstream][void-linux/void-packages]
are made available under the terms of the [original license][original
license].


[dbus]: https://dbus.freedesktop.org/
[glib]: https://wiki.gnome.org/Projects/GLib
[original license]: doc/COPYING.xtraeme
[srcpkgs]: srcpkgs/
[style guide]: doc/STYLE.md
[void-linux/void-packages]: https://github.com/void-linux/void-packages
