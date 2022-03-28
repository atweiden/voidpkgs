Todo
====

- package [jitterentropy-rngd][jitterentropy-rngd]
- [harden][harden kernels i] [kernels][harden kernels ii] (see also:
  [1][harden kernels iii][2][harden kernels iv])
- write script that monitors [upstream][upstream] for pertinent changes
  - *pkg* component
    - extract `pkgname`, `version`, `release` from `template`s and cmp to
      [upstream][upstream]
    - grep [upstream][upstream]'s `git log`
      - grep from commit id to commit id
        - `e04fcbefd2d31280935f243e402562c582ccd500 .. HEAD`
  - *xbps* component
    - monitors changes to core xbps utils and libs
- adhere to style guide
  - convert tabs to spaces
  - put all `&&` conditional on separate line
- trim non-`template` files
- s/voidlinux.eu/voidlinux.org
- replace `http://` links with `https://`

[jitterentropy-rngd]: https://github.com/smuellerDD/jitterentropy-rngd
[harden kernels i]: https://forums.whonix.org/t/kernel-recompilation-for-better-hardening/7598/98
[harden kernels ii]: https://github.com/a13xp0p0v/kconfig-hardened-check
[harden kernels iii]: https://github.com/Whonix/security-misc
[harden kernels iv]: https://github.com/smuellerDD/jitterentropy-rngd/issues/9
[upstream]: https://github.com/void-linux/void-packages
