use v6;

# class Binpkg::Parser::ParseTree {{{

role Binpkg
{
    # causal text
    has Str:D $.source is required;
    has Str:D $.pkgname is required;
    has Str:D $.version is required;
    has Str:D $.revision is required;
    has Str:D $.arch is required;
    has Str:D $.extension is required;
}

# end class Binpkg::Parser::ParseTree }}}
# class Binpkg::Parser::Actions {{{

class Binpkg::Parser::Actions
{
    method binpkg($/ --> Nil)
    {
        my Str:D $source = ~$/;
        my Str:D $pkgname = $<pkgname>.made;
        my %version-full = $<version-full>.made;
        my Str:D $revision = %version-full<revision>;
        my Str:D $version = %version-full<version>;
        my Str:D $arch = $<arch-full>.made;
        my Str:D $extension = $<extension>.made;
        make(
            Binpkg.new(
                :$arch,
                :$extension,
                :$pkgname,
                :$revision,
                :$source,
                :$version)
        );
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

    method arch-full($/ --> Nil)
    {
        make($<arch>.made);
    }

    method arch($/ --> Nil)
    {
        make(~$/);
    }

    method extension($/ --> Nil)
    {
        make('xbps');
    }
}

# end class Binpkg::Parser::Actions }}}
# grammar Binpkg::Parser::Grammar {{{

grammar Binpkg::Parser::Grammar
{
    regex binpkg
    {
        <pkgname> <version-full> <arch-full> <extension>
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

    regex revision
    {
        <revision-char>+
    }

    token revision-char
    {
        \d
    }

    regex arch-full
    {
        '.' <arch>
    }

    regex arch
    {
        <arch-char>+
    }

    token arch-char
    {
        \S
    }

    token extension
    {
        '.xbps'
    }
}

# end grammar Binpkg::Parser::Grammar }}}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
