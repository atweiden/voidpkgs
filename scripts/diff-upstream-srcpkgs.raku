use v6;
use Config::TOML;

=begin pod
=head NAME

diff-upstream-srcpkgs.raku

=head SYNOPSIS

    raku scripts/diff-upstream-srcpkgs.raku

=head DESCRIPTION

Compare upstream srcpkgs to our srcpkgs downstream and show diff.

Much of the work is done in C<seed-diff-upstream-srcpkgs.sh>.
=end pod

my role Pkg
{
    has Str:D $.maintainer is required;
    has Str:D $.pkgname is required;
    has Str:D $.version is required;
    has Str:D $.revision is required;
    has Str:D $.short-desc is required;
    has Str:D $.license is required;
    method new(
        %opts (
            Str:D :$maintainer!,
            Str:D :$pkgname!,
            Str:D :$version!,
            Str:D :$revision!,
            Str:D :short_desc($short-desc)!,
            Str:D :$license!
        )
        --> Pkg:D
    )
    {
        self.bless(
            :$maintainer,
            :$pkgname,
            :$version,
            :$revision,
            :$short-desc,
            :$license
        );
    }
}

my role Diff
{
    has Pkg:D $.pkg1 is required;
    has Pkg:D $.pkg2 is required;
    has Order:D $.maintainer is required;
    has Order:D $.pkgname is required;
    has Order:D $.version is required;
    has Order:D $.revision is required;
    has Order:D $.short-desc is required;
    has Order:D $.license is required;
    method new(Pkg:D :$pkg1!, Pkg:D :$pkg2! --> Diff:D)
    {
        my Order:D $maintainer = $pkg1.maintainer cmp $pkg2.maintainer;
        my Order:D $pkgname = $pkg1.pkgname cmp $pkg2.pkgname;
        my Order:D $version = $pkg1.version cmp $pkg2.version;
        my Order:D $revision = $pkg1.revision cmp $pkg2.revision;
        my Order:D $short-desc = $pkg1.short-desc cmp $pkg2.short-desc;
        my Order:D $license = $pkg1.license cmp $pkg2.license;
        my Diff:D $diff = self.bless(
            :$license,
            :$maintainer,
            :$pkg1,
            :$pkg2,
            :$pkgname,
            :$revision,
            :$short-desc,
            :$version
        );
    }
}

multi sub infix:<diff>(Pkg:D $pkg1, Pkg:D $pkg2 --> Diff:D)
{
    my Diff $diff .= new(:$pkg1, :$pkg2);
}

multi sub infix:<diff>(%p1, %p2 --> Diff:D)
{
    my Pkg $pkg1 .= new(%p1);
    my Pkg $pkg2 .= new(%p2);
    my Diff:D $diff = $pkg1 diff $pkg2;
}

# slow 10s
my Str:D $toml = qx{./scripts/seed-diff-upstream-srcpkgs.sh}.trim;
# very slow 180s
my %toml = from-toml($toml);

# use void keys because nox has more pkgs
my Diff:D @diff =
    %toml<void>.keys.map(-> Str:D $pkgname {
        my Diff:D $diff = %toml<nox>{$pkgname} diff %toml<void>{$pkgname};
    });

@diff.perl.say;

# vim: set filetype=raku foldmethod=marker foldlevel=0:
