Style Guide
===========

Void `template` File
---------------------

### Layout

From top to bottom:

1. Package Maintainer
1. Package Name
1. Package Version
1. Package Release
1. Package Description
1. Architecture
1. Dependencies (`depends`, `makedepends`, `checkdepends`, `hostmakedepends`)
1. URL
1. License
1. Changelog
1. Source
1. Source Checksums
1. Build Style
1. Build Style Options
1. Provides
1. Conflicts
1. Actions (in order of execution)
1. Subpackages

### Other

#### Long Lines

In *Actions* section, split lines of over 80 characters with `\`.

#### `post_install()`

Install license, man page, documentation in that order.

#### Variables

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

#### Spaces Vs. Tabs

Tabs only.

#### Vim

End every `template` file with: `vim: set filetype=sh foldmethod=marker foldlevel=0 nowrap:`.
