# Copyright (C) 2012 Rocky Bernstein <rocky@cpan.org>
# I/O related BW processor methods

use warnings;
no warnings 'redefine';
use strict;
use Exporter;


use rlib '../../..';
require Devel::Trepan::Util;
package Devel::Trepan::BWProcessor;

use vars qw(@EXPORT @ISA);
@ISA = qw(Exporter);

sub errmsg($$;$) 
{
    my($self, $message, $opts) = @_;
    $opts ||={};
    my $err_ary = $self->{response}{errmsg} ||= [];
    $self->{response}{name} = 'error' if $opts->{set_name};
    push @$err_ary, $message;
}

sub flush_msg($) 
{
    my($self) = @_;
    $self->{interface}->msg($self->{response});
}

sub msg($$;$) 
{
    my($self, $message, $opts) = @_;
    $opts ||={};
    my $msg_ary = $self->{response}{msg} ||= [];
    push @$msg_ary, $message;
}

sub msg_need_running($$;$) {
    my($self, $prefix, $opts) = @_;
    $self->errmsg("$prefix not available when terminated");
}

unless (caller) {
    require Devel::Trepan::BWProcessor;
    my $proc  = Devel::Trepan::BWProcessor->new;
}

1;
