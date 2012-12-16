# -*- coding: utf-8 -*-
# Copyright (C) 2012 Rocky Bernstein <rocky@cpan.org>
use warnings; no warnings 'redefine';

use rlib '../../../..';

package Devel::Trepan::BWProcessor::Command::Continue;
=head1 Continue

Leave the debugger loop and continue execution. Subsequent entry to
the debugger however may occur via breakpoints or explicit calls, or
exceptions.

=head2 Input Fields

 { command     => 'continue',
 }

The program being debugged is exited via I<exit()> which runs the
Kernel I<at_exit()> finalizers. If a return code is given, that is the
return code passed to I<exit()> - presumably the return code that will
be passed back to the OS. If no exit code is given, 0 is used.

=head2 Output Fields

 { name      => 'continue',
   [errmsg   => <error-message-array>]
   [msg      => <message-text array>]
 }

=cut

use if !@ISA, Devel::Trepan::BWProcessor::Command ;

use strict;
use vars qw(@ISA);
@ISA = @CMD_ISA;
use vars @CMD_VARS;  # Value inherited from parent

our $NAME = set_name();

# This method runs the command
sub run($$) {
    my ($self, $args) = @_;
    # FIXME: Handle args later.
    # $self->{proc}->continue($args);
    $self->{proc}->continue([]);
}

unless (caller) {
  # require_relative '../mock'
  # dbgr, cmd = MockDebugger::setup
  # p cmd.run([cmd.name])
}

1;
