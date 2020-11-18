#!/usr/bin/perl -w

use strict;
use File::Copy;

# gensigs.pl - Generate API signatures for bac
# Copyright (C) 2020 Jean Zundel <jzu@free.fr>
# See https://github.com/jzu/bac
#
# Generates Avalanche API signatures as text in bac.sigs by
# scraping https://docs.avax.network/v1.0/en/api/
# Saves the current bac.sigs in /tmp with a unique suffix.
# No EVM stuff yet.

my $docs = "/tmp/sigs.tmp";
my $sigs = "bac.sigs";

my $scrape = 0;
my $line = "";


sub apis () { qw (admin auth exchange-chain-x-chain health info ipc keystore platform-chain-p-chain) };


-e "/usr/bin/w3m" or
  die "$0 needs w3m  (apt install w3m) ";

-e $docs and 
  unlink $docs; 
copy ("$sigs", "/tmp/$sigs.$$");

foreach my $api (apis()) {
  print "$api\n";
  `w3m -dump "https://docs.avax.network/build/avalanchego-apis/$api-api"/ >> $docs`
}

open (I, "<$docs") or die;
open (O, ">$sigs") or die;

while (<I>) {

  if (m/^Signature/) {
#$line =~ /_/ and print "$line\n";
    $line = "";
    $scrape = 1;
  }
  if ($scrape) {
    s/.*Signature//;
    chomp;
    $line = $line . $_;
  }
  if ((m/->/) and ($scrape)) {
    $line =~ s/: *string//g;
    $line =~ s/: \[\]string/\[\]/g;
    $line =~ s/: *int//g;
    $line =~ s/: *float//g;
    $line =~ s/: *number//g;
    $line =~ s/: *JSON//g;
    $line =~ s/[\(\)]/ /g;
    $line =~ s/ *\boptional\b/\(opt\)/;
    $line =~ s/, optional/\(opt\)/g;
    $line =~ s/, \(opt\)/\(opt\)/g;
    $line =~ s/{/ /;
    $line =~ s/},? *{//;
    $line =~ s/: *{ *optional/\(opt\){/;
    $line =~ s/: *\[\] *{/\[\]{/;
    $line =~ s/,//g;
    $line =~ s/->.*//;
    $line =~ s/} *$//;
    $line =~ s/  */ /g;
    $line =~ s/  *$//g;
    $line =~ s/^  *//g;
    $line =~ s/ / : /;
    print O "$line\n";
    $scrape = 0;
  }
}
close O;
close I;
unlink $docs;
