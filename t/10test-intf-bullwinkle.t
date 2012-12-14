#!/usr/bin/env perl
use strict; use warnings; no warnings 'redefine';
use rlib '../lib';

use Test::More;
note( "Testing Devel::Trepan::Interface::Bullwinkle" );

BEGIN {
use_ok( 'Devel::Trepan::Interface::Bullwinkle' );
}

plan;

my $bw_intf = Devel::Trepan::Interface::Bullwinkle->new;
# FIXME: more thorough testing of other routines.
done_testing();
