Style Guide for Void `template` Files
=====================================

Layout
------

From top to bottom:

1. Package Maintainer
1. Package Name
1. Package Version
1. Package Release
1. Auxiliary Version Metadata (e.g. `_gitrev`)
1. Package Description
1. Architecture
1. Dependencies (`depends`, `makedepends`, `checkdepends`, `hostmakedepends`)
1. URL
1. License
1. Changelog
1. Source
1. Source Checksums
1. Config Files
1. Build Style
1. Build Style Options
1. Other Options
1. Provides
1. Conflicts
1. Replaces
1. Actions (in order of execution)
1. Subpackages

Style
-----

### Comments

Always put comments on a line of their own, e.g.

```sh
# good comment
_var=3 # bad comment
```

### Dependencies

Group optional dependencies by `build_option` in a separate alphabetical
order, after mandatory dependencies, e.g.

```sh
# good
depends+=" python3-qrcode"
depends+=" python3-requests"
depends+=" $(vopt_if qt hicolor-icon-theme)"
depends+=" $(vopt_if qt xdg-utils)"
```

```sh
# not good
depends+=" $(vopt_if qt hicolor-icon-theme)"
depends+=" python3-qrcode"
depends+=" python3-requests"
depends+=" $(vopt_if qt xdg-utils)"
```

### Long Lines

In *Actions* section, split lines of over 80 characters with `\`.

### Order

Always sort items in alphabetical order when appropriate, e.g.

```sh
# good
configure_args+=" --with-bash-completiondir=/usr/share/bash-completion/completions"
configure_args+=" --with-gnu-ld"
```

```sh
# not good
configure_args+=" --with-gnu-ld"
configure_args+=" --with-bash-completiondir=/usr/share/bash-completion/completions"
```

It is not always appropriate to sort items in alphabetical order,
e.g. for dependencies listed in `build_style="meta"` templates.

### `post_install()`

Install license, man page, documentation in that order.

### Variables

Split string variables containing multiple entries across newlines, e.g.

```sh
# good
hostmakedepends+=" dep"
hostmakedepends+=" git"
```

```sh
# not good
hostmakedepends="dep git"
```

Always double-quote string variables, e.g.

```sh
# good
homepage="https://github.com/atweiden/voidpkgs"
```

```sh
# not good
homepage='https://github.com/atweiden/voidpkgs'
```

```sh
# not good
homepage=https://github.com/atweiden/voidpkgs
```

Never quote `version`, e.g.

```sh
# good
version=2018.08.14
```

```sh
# not good
version='2018.08.14'
```

```sh
# not good
version="2018.08.14"
```

### Vim

End every `template` file with: `vim: set filetype=sh foldmethod=marker foldlevel=0 nowrap:`.

### Whitespacing

Spaces only. Indent by two spaces.

```vim
set tabstop = 2
set shiftwidth = 2
set softtabstop = 2
set expandtab
```
