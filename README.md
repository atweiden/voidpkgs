voidpkgs
========

Package templates for Void


Description
-----------

Console-only XBPS repository. No X.

A fork of [void-linux/void-packages][void-linux/void-packages].


Usage
-----

```sh
git clone https://github.com/atweiden/voidpkgs
cd voidpkgs
./xbps-src <binary-bootstrap|bootstrap>
./xbps-src pkg quixand
xbps-install xtools
xi quixand
```


Licensing
---------

This is free and unencumbered public domain software. For more
information, see http://unlicense.org/ or the accompanying UNLICENSE file.


[void-linux/void-packages]: https://github.com/void-linux/void-packages
