Todo
====

pick up where you left off:

```sh
comm -3 <(find . -type f -name 'template' | sed 's,./,,' | sort ) <(ag Weidenbaum -l | sort) | ag srcpkgs
```
- create `build_style=perl6-module`
- adhere to style guide
  - convert tabs to spaces
  - put all `&&` conditional on separate line
- trim non-`template` files
- s/voidlinux.eu/voidlinux.org
