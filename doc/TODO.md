Todo
====

pick up where you left off:

```sh
comm -3 <(find . -type f -name 'template' | sed 's,./,,') <(ag Weidenbaum -l)
```

- adhere to style guide
  - convert tabs to spaces
- trim non-`template` files
- s/voidlinux.eu/voidlinux.org
