voidpkgs
========

Console-only XBPS source package collection for Void


Description
-----------

Console-only package templates for Void. TUIs accepted.

A fork of [void-linux/void-packages][void-linux/void-packages] with GUI
support removed from [srcpkgs][srcpkgs]. Templates adhere to my [style
guide][style guide].


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


[srcpkgs]: srcpkgs/
[style guide]: doc/STYLE.md
[void-linux/void-packages]: https://github.com/void-linux/void-packages
