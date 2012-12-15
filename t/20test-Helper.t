#!/usr/bin/env perl
use strict; use warnings;
use English qw( -no_match_vars );
use rlib '.';
use Helper;

use Test::More;
plan;

is(Helper::cmd_file, 'Helper.cmd');
done_testing;
