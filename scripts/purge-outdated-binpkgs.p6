#!/usr/bin/env perl6
use v6;
constant $LIB = sprintf(Q{%s/lib}, $*PROGRAM.dirname);
use lib $LIB;
use Binpkg::Parser;

=begin pod
=head NAME

purge-outdated-binpkgs.p6

=head SYNOPSIS

List all duplicate pkgs, all versions, including latest version:

    scripts/purge-outdated-binpkgs.p6 --all ls dupes

Dry run:

    scripts/purge-outdated-binpkgs.p6 ls dupes \
        | scripts/purge-outdated-binpkgs.p6 --dry-run rm

Purge:

    scripts/purge-outdated-binpkgs.p6 ls dupes \
        | scripts/purge-outdated-binpkgs.p6 rm

=head DESCRIPTION

Grep C<hostdir/binpkgs> for duplicate binpkgs and purge outdated.

Properly adjusts for binpkgs with duplicate C<pkgname>s but different
C<arch>s.

Features C<--dry-run> flag for safety, and C<--all ls dupes> cmd for
reviewability.

=head ALTERNATVES

    xbps-rindex -c "$PWD/hostdir/binpkgs"
    xbps-rindex -r "$PWD/hostdir/binpkgs"
=end pod

# path to https://github.com/atweiden/voidpkgs
constant $ROOT = sprintf(Q{%s/..}, $*PROGRAM.dirname).IO.resolve;
# path to https://github.com/atweiden/voidpkgs/hostdir/binpkgs
constant $BINPKGS = sprintf(Q{%s/hostdir/binpkgs/}, $ROOT);

sub ls-binpkgs(--> Array[Str:D])
{
    my Str:D @xbps =
        dir($BINPKGS)
        .grep({ .extension eqv 'xbps' })
        .map({ .basename });
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
                .grep({ .values.flat.first.elems > 1 })
                .map({ .values.flat.first });
        });
}

multi sub fmt(%candidate, Bool:D :all($)! where .so --> Str:D)
{
    my Str:D $fmt =
        %candidate
        .map({
            .values
            .flat
            .first
            .map({
                .classify({ .pkgname })
            })
            .values
            .flat
            .kv
            .map(-> $k, $v {
                $v.values.flat.first.map({ .source })
            })
            .flat
        })
        .values
        .flat
        .sort
        .join("\n");
}

multi sub fmt(%candidate --> Str:D)
{
    my Str:D $fmt =
        %candidate
        .map({
            .values
            .flat
            .first
            .map({
                .classify({ .pkgname })
            })
            .values
            .flat
            .kv
            .map(-> $k, $v {
                $v.values.flat.first[0..^*-1].map({ .source })
            })
            .flat
        })
        .values
        .flat
        .sort
        .join("\n");
}

multi sub MAIN('ls', 'dupes', Bool:D :all($)! where .so --> Nil)
{
    gen-candidates()
    ==> fmt(:all)
    ==> say();
}

multi sub MAIN('ls', 'dupes' --> Nil)
{
    gen-candidates()
    ==> fmt()
    ==> say();
}

multi sub MAIN('rm', Bool:D :dry-run($)! where .so --> Nil)
{
    my Str:D @xbps = $*IN.lines;
    my Str:D @path-str =
        @xbps
        .map(-> Str:D $xbps {
            sprintf(Q{%s%s}, $BINPKGS, $xbps)
        })
        .map(-> Str:D $xbps {
            # --dry-run
            sprintf(Q{rm -f %s}, $xbps)
        });
    @path-str.join("\n").say if @path-str.so;
}

multi sub MAIN('rm' --> Nil)
{
    my Str:D @xbps = $*IN.lines;
    @xbps
    .map(-> Str:D $xbps {
        sprintf(Q{%s%s}, $BINPKGS, $xbps)
    })
    .map(-> Str:D $xbps {
        $xbps.IO.unlink
    });
}

# vim: set filetype=raku foldmethod=marker foldlevel=0:
