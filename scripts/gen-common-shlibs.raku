use v6;
constant $LIB = sprintf(Q{%s/lib}, $*PROGRAM.dirname);
use lib $LIB;
use Shlibs::Parser;

=begin pod
=head NAME

gen-common-shlibs.raku

=head SYNOPSIS

    raku scripts/gen-common-shlibs.raku > common/shlibs

=head DESCRIPTION

Generate C<common/shlibs> based on srcpkgs.

Derives list of our downstream srcpkgs from C<srcpkgs/> directory
listing. Parses upstream's C<common/shlibs> for associated soname
mappings, and adds them to our own C<common/shlibs>. Keeps entries to our
own C<common/shlibs> which we've added over and above that of upstream.
Orders soname mappings alphabetically by pkgname then by soname.

=head BUGS

=for item
C<sort-common-shlibs.raku> produces different sort order of mappings
than C<gen-common-shlibs.raku>.
=end pod

# path to https://github.com/atweiden/voidpkgs
constant $ROOT-NOX = sprintf(Q{%s/..}, $*PROGRAM.dirname).IO.resolve;
# path to https://github.com/atweiden/voidpkgs/common/shlibs
constant $COMMON-SHLIBS-NOX = sprintf(Q{%s/common/shlibs}, $ROOT-NOX);
# path to https://github.com/atweiden/voidpkgs/srcpkgs
constant $SRCPKGS-NOX = sprintf(Q{%s/srcpkgs/}, $ROOT-NOX);
# path to https://github.com/void-linux/void-packages
constant $ROOT-VOID = sprintf(Q{%s/Sandbox/void-linux/void-packages}, $*HOME);
# path to https://github.com/void-linux/void-packages/common/shlibs
constant $COMMON-SHLIBS-VOID = sprintf(Q{%s/common/shlibs}, $ROOT-VOID);

sub gen-shlibs(Str:D $path-common-shlibs --> Shlibs:D)
{
    my Shlibs::Parser::Actions $actions .= new;
    my Shlibs:D $shlibs =
        Shlibs::Parser::Grammar.parsefile($path-common-shlibs, :$actions).made;
}

# list pkgs in https://github.com/atweiden/voidpkgs/srcpkgs
my Str:D @pkg-nox =
    dir($SRCPKGS-NOX)
    .map(-> IO::Path:D $p { $p.basename })
    .sort;

# parse shlibs from https://github.com/void-linux/void-packages/common/shlibs
my Shlibs:D $shlibs-void = gen-shlibs($COMMON-SHLIBS-VOID);

# list pkgs in https://github.com/void-linux/void-packages/common/shlibs
my Str:D @pkg-void =
    $shlibs-void.mapping.map(-> Mapping:D $m { $m.pkg.pkgname }).unique.sort;

# take intersection of nox and void pkgs
my Set:D $pkg-nox-void = @pkg-nox (&) @pkg-void;
my Str:D @pkg-nox-void = Array[Str:D].new($pkg-nox-void.keys.sort);

# parse shlibs from https://github.com/atweiden/voidpkgs/common/shlibs
my Shlibs:D $shlibs-nox = gen-shlibs($COMMON-SHLIBS-NOX);

# take union of nox shlibs and intersection of nox and void
my Mapping:D @mapping-nox = $shlibs-nox.mapping;
my Mapping:D @mapping-void =
    @pkg-nox-void.map(-> Str:D $pkgname {
        $shlibs-void.mapping.grep({ .pkg.pkgname eqv $pkgname })
    }).flat;
my Set:D $mapping-nox-void = @mapping-nox (|) @mapping-void;
my Mapping:D @mapping-nox-void = Array[Mapping:D].new($mapping-nox-void.keys);

# needed where multiple pkgs provide same soname
my Str:D &as = sub (Mapping:D $mapping --> Str:D)
{
    my Str:D $s = sprintf(Q{%s|%s}, $mapping.soname, $mapping.pkg.pkgname);
}

# write sorted shlibs to stdout
@mapping-nox-void
    .unique(:&as)
    .sort({ $^a.soname cmp $^b.soname })
    .sort({ $^a.pkg.pkgname cmp $^b.pkg.pkgname })
    .map({ .source })
    .join("\n")
    .say;

# vim: set filetype=raku foldmethod=marker foldlevel=0:
