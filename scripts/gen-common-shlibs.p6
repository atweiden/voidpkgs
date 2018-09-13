use v6;

# p6doc {{{

=begin pod
=head BUGS

=for item
C<ntfs-3g> mapping from L<https://github.com/void-linux/void-packages>
is not being detected.

=for item
C<p11-kit> mapping from L<https://github.com/void-linux/void-packages>
is not being detected.

=for item
C<pkcs11-helper> mapping from
L<https://github.com/void-linux/void-packages> is not being detected.

=for item
C<sort-common-shlibs.p6> produces different sort order of mappings than
C<gen-common-shlibs.p6>.
=end pod

# end p6doc }}}

# class Shlibs::Parser::ParseTree {{{

my role Pkg
{
    has Str:D $.pkgname is required;
    has Str:D $.version is required;
    has Str:D $.revision is required;
}

my role Mapping
{
    # causal text
    has Str:D $.source is required;
    has Str:D $.soname is required;
    has Pkg:D $.pkg is required;
    has Str $.metadata;
}

my role Shlibs
{
    has Mapping:D @.mapping is required;
}

# end class Shlibs::Parser::ParseTree }}}
# class Shlibs::Parser::Actions {{{

my class Shlibs::Parser::Actions
{
    multi method mapping($/ where $<metadata>.so --> Nil)
    {
        my Str:D $source = ~$/;
        my Str:D $soname = $<soname>.made;
        my Pkg:D $pkg = $<pkg>.made;
        my Str:D $metadata = $<metadata>.made;
        make(Mapping.new(:$metadata, :$pkg, :$soname, :$source));
    }

    multi method mapping($/ --> Nil)
    {
        my Str:D $source = ~$/;
        my Str:D $soname = $<soname>.made;
        my Pkg:D $pkg = $<pkg>.made;
        make(Mapping.new(:$pkg, :$soname, :$source));
    }

    method soname($/ --> Nil)
    {
        make(~$/);
    }

    method pkg($/ --> Nil)
    {
        my Str:D $pkgname = $<pkgname>.made;
        my %version-full = $<version-full>.made;
        my Str:D $revision = %version-full<revision>;
        my Str:D $version = %version-full<version>;
        make(Pkg.new(:$pkgname, :$revision, :$version));
    }

    method pkgname($/ --> Nil)
    {
        make(~$/);
    }

    method version-full($/ --> Nil)
    {
        my Str:D $version = $<version>.made;
        my Str:D $revision = $<revision-full>.made;
        my %version-full = :$revision, :$version;
        make(%version-full);
    }

    method version($/ --> Nil)
    {
        make(~$/);
    }

    method revision-full($/ --> Nil)
    {
        make($<revision>.made);
    }

    method revision($/ --> Nil)
    {
        make(~$/);
    }

    method metadata($/ --> Nil)
    {
        make(~$/);
    }

    method mapping-line($/ --> Nil)
    {
        make($<mapping>.made);
    }

    method line:mapping ($/ --> Nil)
    {
        make($<mapping-line>.made);
    }

    method document($/ --> Nil)
    {
        my Mapping:D @mapping =
            @<line>
            .map({ .made })
            .grep({ .so });
        make(@mapping);
    }

    multi method TOP($/ where $<document>.so --> Nil)
    {
        my Mapping:D @mapping = $<document>.made;
        make(Shlibs.new(:@mapping));
    }

    multi method TOP($/ --> Nil)
    {
        make(Nil);
    }
}

# end class Shlibs::Parser::Actions }}}
# grammar Shlibs::Parser::Grammar {{{

my grammar Shlibs::Parser::Grammar
{
    token comment
    {
        '#'\N*
    }

    token mapping
    {
        <soname> \h+ <pkg> [ \h+ <metadata> ]?
    }

    token soname
    {
        \S+
    }

    token pkg
    {
        <pkgname> <version-full>
    }

    token pkgname
    {
        <pkgname-chars>
    }

    token pkgname-chars
    {
        <pkgname-char>+
    }

    token pkgname-char
    {
        <!before <version-full>> \S
    }

    token version-full
    {
        '-' <version> <revision-full>
    }

    token version
    {
        <alnum> <version-chars>?
    }

    token version-chars
    {
        <version-char>+
    }

    token version-char
    {
        <!before <revision-full>> <+alnum +[\.] +[\_] +[\<] +[\+]>
    }

    token revision-full
    {
        '_' <revision>
    }

    token revision
    {
        \S+
    }

    token metadata
    {
        \S+
    }

    token blank-line
    {
        ^^ \h* $$
    }

    token comment-line
    {
        ^^ <comment> $$
    }

    token mapping-line
    {
        ^^ <mapping> $$
    }

    proto token line {*}
    token line:blank { <blank-line> }
    token line:comment { <comment-line> }
    token line:mapping { <mapping-line> }

    token document
    {
        <line> [ \n <line> ]*
    }

    token TOP
    {
        <document>? \n?
    }
}

# end grammar Shlibs::Parser::Grammar }}}

# list pkgs in https://github.com/atweiden/voidpkgs/srcpkgs
my Str:D @pkg-atw =
    dir('srcpkgs').map(-> IO::Path:D $p { $p.basename }).sort;

# parse shlibs from https://github.com/void-linux/void-packages/common/shlibs
my Str:D $path-void = sprintf(Q{%s/Sandbox/void-linux/void-packages}, $*HOME);
my Str:D $path-void-common-shlibs = sprintf(Q{%s/common/shlibs}, $path-void);
my Shlibs::Parser::Actions $actions .= new;
my Shlibs:D $shlibs-void =
    Shlibs::Parser::Grammar.parsefile($path-void-common-shlibs, :$actions).made;

# list pkgs in https://github.com/void-linux/void-packages/common/shlibs
my Str:D @pkg-void =
    $shlibs-void.mapping.map(-> Mapping:D $m { $m.pkg.pkgname }).unique.sort;

# take intersection of atw and void pkgs
my Set:D $pkg-atw-void = @pkg-atw (&) @pkg-void;
my Str:D @pkg-atw-void = Array[Str:D].new($pkg-atw-void.keys.sort);

# parse shlibs from https://github.com/atweiden/voidpkgs/common/shlibs
my Str:D $path-atw = sprintf(Q{%s/Projects/voidpkgs}, $*HOME);
my Str:D $path-atw-common-shlibs = sprintf(Q{%s/common/shlibs}, $path-atw);
$actions .= new;
my Shlibs:D $shlibs-atw =
    Shlibs::Parser::Grammar.parsefile($path-atw-common-shlibs, :$actions).made;

# take union of atw shlibs and intersection of atw and void
my Mapping:D @mapping-atw = $shlibs-atw.mapping;
my Mapping:D @mapping-void =
    @pkg-atw-void.map(-> Str:D $pkgname {
        $shlibs-void.mapping.grep({ .pkg.pkgname eqv $pkgname })
    }).flat;
my Set:D $mapping-atw-void = @mapping-atw (|) @mapping-void;
my Mapping:D @mapping-atw-void = Array[Mapping:D].new($mapping-atw-void.keys);

# write sorted shlibs to stdout
@mapping-atw-void
    .unique(:as(-> Mapping:D $mapping { $mapping.soname }))
    .sort({ $^a.soname cmp $^b.soname })
    .sort({ $^a.pkg.pkgname cmp $^b.pkg.pkgname })
    .map({ .source })
    .join("\n")
    .say;

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
