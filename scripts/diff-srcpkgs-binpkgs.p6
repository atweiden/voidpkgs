use v6;
constant $LIB = sprintf(Q{%s/lib}, $*PROGRAM.dirname);
use lib $LIB;
use Binpkg::Parser;

=begin pod
=head NAME

diff-srcpkgs-binpkgs.p6

=head SYNOPSIS

    perl6 scripts/diff-srcpkgs-binpkgs.p6

=head DESCRIPTION

Show srcpkgs not yet built into binpkgs.
=end pod

# path to https://github.com/atweiden/voidpkgs
constant $ROOT = sprintf(Q{%s/..}, $*PROGRAM.dirname).IO.resolve;
# path to https://github.com/atweiden/voidpkgs/hostdir/binpkgs
constant $BINPKGS = sprintf(Q{%s/hostdir/binpkgs/}, $ROOT);
# path to https://github.com/atweiden/voidpkgs/srcpkgs
constant $SRCPKGS = sprintf(Q{%s/srcpkgs/}, $ROOT);

multi sub ls-binpkgs(
    $? where $BINPKGS.IO.e && $BINPKGS.IO.d
    --> Array[Str:D]
)
{
    my Str:D @binpkg =
        dir($BINPKGS)
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
        dir($SRCPKGS)
        .map({ .basename })
        .sort;
}

my Str:D @binpkg = ls-binpkgs();
my Str:D @srcpkg = ls-srcpkgs();

# take set difference of srcpkgs and binpkgs
my Set:D $diff = @srcpkg (-) @binpkg;
$diff.keys.sort.join("\n").say;

# vim: set filetype=raku foldmethod=marker foldlevel=0:
