#!/usr/bin/perl -w
# Created by Ben Okopnik on Thu Jan 14 21:55:46 EST 2010
# Modified by Sam Bisbee <sbisbee@computervip.com>
#
# Takes an mbox and removes any e-mails from it that have all the provided
# key/value pairs in their header. All rules are matched, case sensitive, and
# accept Perl regular expressions.

use strict;
use Mail::MboxParser;

$|++;

die $0 =~ /([^\/]+)$/, " <mbox> <header name> <header value> [<header name> header value> [...]]\n" if @ARGV % 2 == 0 || @ARGV < 3;

my $mb = Mail::MboxParser->new($ARGV[0]);

while (my $msg = $mb->next_message) 
{
  my $matches = 0;

  for(my $i = 1; defined $ARGV[$i] && defined $ARGV[$i + 1]; $i += 2)
  {
    #Mail::MboxParser wants lower case heads only
    my $val = $msg->header->{lc $ARGV[$i]};
    $matches++ if defined $val && $val =~ $ARGV[$i + 1];
  }

  print "$msg\n\n" unless $matches == (@ARGV - 1) / 2;
}
