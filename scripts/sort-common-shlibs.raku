use v6;

=begin pod
=head NAME

sort-common-shlibs.raku

=head SYNOPSIS

    scripts/sort-common-shlibs.raku > common/shlibs

=head DESCRIPTION

Order soname mappings in C<common/shlibs> alphabetically by pkgname then
by soname.
=end pod

# path to https://github.com/atweiden/voidpkgs
constant $ROOT = sprintf(Q{%s/..}, $*PROGRAM.dirname).IO.resolve;
# path to https://github.com/atweiden/voidpkgs/common/shlibs
constant $COMMON-SHLIBS = sprintf(Q{%s/common/shlibs}, $ROOT);

sub sort-shlibs(Str:D @shlib --> List:D)
{
    my List:D $sort-shlibs =
        @shlib
        .sort({
            # sort by soname
            $^a.split(/\h+/)[0] cmp $^b.split(/\h+/)[0]
        })
        .sort({
            # sort by pkgname
            $^a.split(/\h+/)[1] cmp $^b.split(/\h+/)[1]
        })
        .List;
}

my Str:D @shlib = $COMMON-SHLIBS.IO.lines;
@shlib.&sort-shlibs().join("\n").say;

# vim: set filetype=raku foldmethod=marker foldlevel=0:
