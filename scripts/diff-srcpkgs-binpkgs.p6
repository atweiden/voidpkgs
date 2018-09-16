use v6;

constant $DIR-BINPKGS = 'hostdir/binpkgs';
constant $DIR-SRCPKGS = 'srcpkgs';

# class Binpkg::Parser::ParseTree {{{

my role Binpkg
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

my class Binpkg::Parser::Actions
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

my grammar Binpkg::Parser::Grammar
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

multi sub ls-binpkgs(
    $? where $DIR-BINPKGS.IO.e && $DIR-BINPKGS.IO.d
    --> Array[Str:D]
)
{
    my Str:D @binpkg =
        dir($DIR-BINPKGS)
        .grep({ .extension eqv 'xbps' })
        .map({ .basename })
        .sort
        .map({
            my Binpkg::Parser::Actions $actions .= new;
            my Str:D $rule = 'binpkg';
            Binpkg::Parser::Grammar.parse($_, :$rule, :$actions).made.pkgname;
        });
}

multi sub ls-binpkgs(
    --> Array[Str:D]
)
{
    my Str:D @binpkg;
}

sub ls-srcpkgs(--> Array[Str:D])
{
    my Str:D @srcpkg =
        dir($DIR-SRCPKGS)
        .map({ .basename })
        .sort;
}

my Str:D @binpkg = ls-binpkgs();
my Str:D @srcpkg = ls-srcpkgs();

# take set difference of srcpkgs and binpkgs
my Set:D $diff = @srcpkg (-) @binpkg;
$diff.keys.sort.join("\n").say;

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
