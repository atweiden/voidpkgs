## [options.description][options.description]

[options.description][options.description] represents a map between
generic package build options and the description thereof.

## [shlibs][shlibs]

[shlibs][shlibs] represents a map between shared libraries and packages
in XBPS. Every shared library installed by a package must be listed here
and mapped to a binary package.

- The first field lists the exact SONAME embedded in binaries
- The second field lists the package/version tuple containing the SONAME
  - The version component is used as greater than or equal to that
    version in resulting binary package
- The third field (optional) specifies that shared library should not
  be used to perform checks of soname bumps

When multiple packages provide the same SONAME, the first one (order
top->bottom) is preferred over the next ones.

[shlibs][shlibs] is generated with
[scripts/gen-common-shlibs.raku][scripts/gen-common-shlibs.raku],
then sorted with
[scripts/sort-common-shlibs.raku][scripts/sort-common-shlibs.raku]:

```sh
raku scripts/gen-common-shlibs.raku > common/shlibs
raku scripts/sort-common-shlibs.raku > common/shlibs
```

[options.description]: options.description
[scripts/gen-common-shlibs.raku]: ../scripts/gen-common-shlibs.raku
[scripts/sort-common-shlibs.raku]: ../scripts/sort-common-shlibs.raku
[shlibs]: shlibs
