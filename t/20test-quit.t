#!/usr/bin/env perl
use strict; use warnings;
use English qw( -no_match_vars );
use rlib '.';
use Helper;

use Test::More;
plan;

my $test_prog = File::Spec->catfile(dirname(__FILE__), 
				    qw(.. example gcd.pl));

Helper::run_debugger($test_prog, cmd_file());
my %opts = %$standard_opts;
$opts{exitcode} = 7;
Helper::run_debugger("$test_prog", 'quit-nonzero-exit.cmd', undef, \%opts);

done_testing;
