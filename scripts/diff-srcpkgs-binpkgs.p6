use v6;
constant $LIB = sprintf(Q{%s/lib}, $*PROGRAM.dirname);
use lib $LIB;
use Binpkg::Parser;

# path to https://github.com/atweiden/voidpkgs
constant $DIR-ROOT = sprintf(Q{%s/..}, $*PROGRAM.dirname).IO.resolve;
# path to https://github.com/atweiden/voidpkgs/hostdir/binpkgs
constant $DIR-BINPKGS = sprintf(Q{%s/hostdir/binpkgs/}, $DIR-ROOT);
# path to https://github.com/atweiden/voidpkgs/srcpkgs
constant $DIR-SRCPKGS = sprintf(Q{%s/srcpkgs/}, $DIR-ROOT);

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
