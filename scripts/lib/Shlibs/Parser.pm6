use v6;

# class Shlibs::Parser::ParseTree {{{

role Pkg
{
    has Str:D $.pkgname is required;
    has Str:D $.version is required;
    has Str:D $.revision is required;
}

role Mapping
{
    # causal text
    has Str:D $.source is required;
    has Str:D $.soname is required;
    has Pkg:D $.pkg is required;
    has Str $.metadata;
}

role Shlibs
{
    has Mapping:D @.mapping is required;
}

# end class Shlibs::Parser::ParseTree }}}
# class Shlibs::Parser::Actions {{{

class Shlibs::Parser::Actions
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

grammar Shlibs::Parser::Grammar
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

    regex pkg
    {
        <pkgname> <version-full>
    }

    regex pkgname
    {
        <pkgname-chars>
    }

    regex pkgname-chars
    {
        <pkgname-char>+
    }

    token pkgname-char
    {
        \S
    }

    regex version-full
    {
        '-' <version> <revision-full>
    }

    regex version
    {
        <alnum> <version-chars>?
    }

    regex version-chars
    {
        <version-char>+
    }

    token version-char
    {
        <+alnum +[\.] +[\_] +[\<] +[\+]>
    }

    regex revision-full
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

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
