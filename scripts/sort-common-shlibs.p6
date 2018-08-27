#!/usr/bin/env perl6

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

my Str:D $common-shlibs = 'common/shlibs';
my Str:D @shlib = $common-shlibs.IO.lines;
.say for @shlib.&sort-shlibs().List;
