#!/usr/bin/env raku
use v6;

# path to https://github.com/atweiden/voidpkgs
constant $ROOT = sprintf(Q{%s/..}, $*PROGRAM.dirname).IO.resolve;
# path to https://github.com/atweiden/voidpkgs/srcpkgs
constant $SRCPKGS = sprintf(Q{%s/srcpkgs/}, $ROOT);

my class GitDiffSection
{
    has Str:D $.pkgname is required;
    has Str:D $.content is required;

    method Str(::?CLASS:D: --> Str:D)
    {
        $.content;
    }
}

my class GitDiffActions
{
    method pkgname($/ --> Nil)
    {
        my Str:D $pkgname = ~$/;
        make($pkgname);
    }

    method distinguisher($/ --> Nil)
    {
        my Str:D $pkgname = $<pkgname>.made;
        make($pkgname);
    }

    method first($/ --> Nil)
    {
        my Str:D $pkgname = $<distinguisher>.made;
        make($pkgname);
    }

    method section($/ --> Nil)
    {
        my Str:D $pkgname = $<first>.made;
        my Str:D $content = ~$/;
        my GitDiffSection $section .= new(:$pkgname, :$content);
        make($section);
    }

    method TOP($/ --> Nil)
    {
        my GitDiffSection:D @git-diff-section = @<section>.map({ .made });
        make(@git-diff-section);
    }
}

my grammar GitDiffGrammar
{
    token pkgname { <+[\w] +[-] +[\.]>+ <?[/]> }
    token distinguisher { 'diff --git a/srcpkgs/' <pkgname> }
    token first { ^^ <distinguisher> \N+ $$ }
    token other { ^^ <!before <distinguisher>> \N* $$ }
    token section { <first> [ \n <.other> ]* }
    token TOP { <section> [ \n <section> ]* \n? }
}

sub trim-upstream-git-diff(Str:D $file --> Str:D)
{
    my Str:D @srcpkg = dir($SRCPKGS).grep(none *.IO.l).map({ .IO.basename });
    my GitDiffActions $actions .= new;
    my Str:D $trimmed = GitDiffGrammar.parsefile($file, :$actions).made.grep({
        my Str:D $pkgname = $^a.pkgname;
        @srcpkg.grep($pkgname).so;
    }).map({ .Str }).join("\n");
}

sub MAIN(Str:D $file --> Nil)
{
    say(trim-upstream-git-diff($file));
}
