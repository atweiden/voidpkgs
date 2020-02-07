#!/usr/bin/env raku
use v6;

=begin pod
=head NAME

inc-revision.raku

=head SYNOPSIS

    raku scripts/inc-revision.raku srcpkgs/cross-x86_64-linux-musl/template

=head DESCRIPTION

Increment C<revision> variable in Void package template.
=end pod

multi sub output(
    Str:D $file where .IO.e.so && .IO.f.so,
    Bool:D :in-place($)! where .so
    --> Nil
)
{
    my Str:D @line = inc-revision($file);
    spurt($file, @line.join("\n") ~ "\n");
}

multi sub output(
    Str:D $file where .IO.e.so && .IO.f.so,
    Bool :in-place($)
    --> Nil
)
{
    my Str:D @line = inc-revision($file);
    @line.join("\n").say;
}

sub inc-revision(Str:D $file --> Array[Str:D])
{
    my Str:D @line = $file.IO.lines;
    my UInt:D $index = @line.first(/^'revision='/, :k);
    my UInt:D $revision = @line[$index].split('=').tail.Int;
    my UInt:D $inc-revision = $revision + 1;
    my Str:D $replace = sprintf('revision=%s', $inc-revision);
    @line[$index] = $replace;
    @line;
}

multi sub MAIN(
    *@file,
    Bool:D :in-place($)! where .so
    --> Nil
)
{
    @file.map(-> Str:D $file {
        output($file, :in-place);
    });
}

multi sub MAIN(
    *@file,
    Bool :in-place($)
    --> Nil
)
{
    @file.map(-> Str:D $file {
        output($file);
    });
}

multi sub USAGE($? --> Nil)
{
    constant $HELP = q:to/EOF/.trim;
    Usage:
      inc-revision.raku [-h] <file> [<file> <file>...]

    Options:
      --in-place
        modify file in place
    EOF
    say($HELP);
}
