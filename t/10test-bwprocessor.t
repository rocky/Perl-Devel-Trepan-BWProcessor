#!/usr/bin/env perl
use strict; use warnings;
use English qw( -no_match_vars );
use rlib '../lib';
use Devel::Trepan::BWProcessor;
use Config;

use Test::More;
plan;

is(Devel::Trepan::BWProcessor::invalid_cmd_hash(1),
   'not a reference; need a hash reference');
is(Devel::Trepan::BWProcessor::invalid_cmd_hash([1,2,3]),
   'reference is not to a hash',);
is(Devel::Trepan::BWProcessor::invalid_cmd_hash({nocommand=>1}),
   'hash reference does not have a key called "command"',
);
is(Devel::Trepan::BWProcessor::invalid_cmd_hash({command => 'info_program'}),
   0);
   
done_testing;
