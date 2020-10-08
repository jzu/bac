#!/usr/bin/perl

# gensigs.pl - Generate API signatures for bac
# Copyright (C) 2020 Jean Zundel <jzu@free.fr>
# See https://github.com/jzu/bac
#
# Generates Avalanche API signatures as text in bac.sigs.
# They'll never be accurate I guess but, hey, better than nothing.
# Saves the current bac.sigs in /tmp with a unique suffix.
# Tempted by Brainfuck? Try Perl first.

use strict;
use warnings;
use Cwd qw (cwd);
use File::Copy;

my $cwd = cwd;
if (chdir "../avalanche-postman-collection") {
  system ("git pull");
  chdir $cwd;
}
else {
  die "No ../avalanche-postman-collection: please git clone " .
      "https://github.com/ava-labs/avalanche-postman-collection.git " .
      "in the same parent directory as this one.";
}
copy ("bac.sigs", "/tmp/bac.sigs.$$");

open (S, ">bac.sigs");
open (J, "<../avalanche-postman-collection/Avalanche.postman_collection.json") or die;

while (<J>) {
  if (m/raw":.*jsonrpc/) {
    if (!/avax\./) {
      s/\\n//g;
      s/\\//g;
      s/.*method" *: *"//;
      s/params//;
      s/"//g;
      s/: *\{\{[^\}]*\}\}/:/g;
      s/\{\{[^\}]*\}\}//g;
      s/: *[^ ,\[\]]*/:/g;
      s/, id *: *,//;
      s/\[[0-9A-Za-z \/,-]*\]/\[\]/g;
      s/\}\}?, *$//;
      s/://g;
      s/, / : /;
      s/  */ /g;
      s/ id$//;
      s/[:,] *$//g;
      s/(txI?D?) }/$1/;
      s/\] \} \}/\] /;
      s/\] \} \} \}/\] /;
      s/password goes here //g;
      s/ new timestamp//g;
      s/\[ /\[/g;
      s/ \]/\]/g;
      s/\{ /\{/g;
      s/ \}/\}/g;
      s/, *id *$//;
      s/: *$//;
      print S;
    }
  }
}
close S;
close J;
