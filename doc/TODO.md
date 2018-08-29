Todo
====

pick up where you left off:

```sh
comm -3 <(find . -type f -name 'template' | sed 's,./,,' | sort ) <(ag Weidenbaum -l | sort) | ag srcpkgs
```

- adhere to style guide
  - convert tabs to spaces
- trim non-`template` files
- s/voidlinux.eu/voidlinux.org
