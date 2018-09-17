#!/usr/bin/env perl6
use v6;
constant $LIB = sprintf(Q{%s/lib}, $*PROGRAM.dirname);
use lib $LIB;
use Binpkg::Parser;

# path to https://github.com/atweiden/voidpkgs
constant $DIR-ROOT = sprintf(Q{%s/..}, $*PROGRAM.dirname).IO.resolve;
# path to https://github.com/atweiden/voidpkgs/hostdir/binpkgs
constant $DIR-BINPKGS = sprintf(Q{%s/hostdir/binpkgs/}, $DIR-ROOT);

sub ls-binpkgs(--> Array[Str:D])
{
    my Str:D @xbps =
        dir($DIR-BINPKGS)
        .grep({ .extension eqv 'xbps' })
        .map({ .basename })
        .sort;
}

sub gen-binpkgs(Str:D @xbps --> Array[Binpkg:D])
{
    my Binpkg:D @binpkg =
        @xbps.map(-> Str:D $xbps {
            my Binpkg::Parser::Actions $actions .= new;
            my Str:D $rule = 'binpkg';
            my Binpkg:D $binpkg =
                Binpkg::Parser::Grammar.parse($xbps, :$rule, :$actions).made;
        });
}

multi sub output(%candidate --> Str:D)
{
    my Str:D @xbps =
        %candidate
        .kv
        .map(-> Str:D $arch, @source {
            output($arch, @source);
        })
        .flat;
    # adjust for C<arch>s with no dupes
    my Str:D @output = @xbps.grep({ .so }) // '';
    my Str:D $output = @output.sort.join("\n");
}

multi sub output(Str:D $arch, @source where .so --> Array[Str:D])
{
    my Str:D @output =
        @source
        .flat
        .map({ .Str });
}

multi sub output(Str:D $arch, @source --> Array[Str:D])
{
    my Str:D @output = '';
}

sub gen-candidates(--> Hash:D)
{
    # parse C<Binpkg>s from hostdir/binpkgs directory listing
    my Str:D @xbps = ls-binpkgs();
    my Binpkg:D @binpkg = gen-binpkgs(@xbps);

    # classify C<Binpkg>s by C<arch>, then by C<pkgname>
    my Array:D %binpkg-by-arch{Str:D} = @binpkg.classify({ .arch });
    my %binpkg-by-arch-by-pkgname =
        %binpkg-by-arch.kv.map(-> Str:D $arch, @binpkg-by-arch {
            $arch => @binpkg-by-arch.classify({ .pkgname })
        });

    # find C<Binpkg>s with dupe C<pkgname>s, adjusting for C<arch>
    my %candidate =
        %binpkg-by-arch-by-pkgname.kv.map(-> Str:D $arch, %classify {
            $arch =>
                %classify
                .grep({
                    .values.flat.first.elems > 1
                })
                .map({
                    .values.flat.first.map({ .source })
                });
        });
}

multi sub MAIN('ls', 'dupes')
{
    my %candidate = gen-candidates();
    output(%candidate).say;
}

# vim: set filetype=perl6 foldmethod=marker foldlevel=0:
