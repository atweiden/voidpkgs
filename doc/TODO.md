Todo
====

- write script that monitors [upstream][upstream] for pertinent changes
  - *pkg* component
    - extract `pkgname`, `version`, `release` from `template`s and cmp to
      [upstream][upstream]
    - grep [upstream][upstream]'s `git log`
      - grep from commit id to commit id
        - `e04fcbefd2d31280935f243e402562c582ccd500 .. HEAD`
  - *xbps* component
    - monitors changes to core xbps utils and libs
- create `build_style=perl6-module`
- adhere to style guide
  - convert tabs to spaces
  - put all `&&` conditional on separate line
- trim non-`template` files
- s/voidlinux.eu/voidlinux.org
- replace `http://` links with `https://`

[upstream]: https://github.com/void-linux/void-packages
