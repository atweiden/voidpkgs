Style Guide
===========

Void `template` File
---------------------

### Layout

From top to bottom:

1. Package Name
2. Package Version
3. Package Release
4. Package Description
5. Architecture
6. Dependencies (`depends`, `makedepends`, `checkdepends`, `hostmakedepends`)
7. URL
8. License
9. Source
10. Source Checksums
11. Build Style
12. Build Style Options
13. Provides
14. Conflicts
15. Actions (in order of execution)
16. Subpackages

### Other

- Tabs only
- End every `template` file with `vim: set filetype=sh foldmethod=marker foldlevel=0 nowrap:`
